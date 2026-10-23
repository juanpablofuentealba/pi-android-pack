# Debloat (quitar bloatware)

Objetivo: quitar apps preinstaladas inútiles **sin romper el sistema** y **de forma reversible**.

## Regla clave
`pm uninstall --user 0 <pkg>` desinstala solo para el usuario actual. El APK sigue en la partición de sistema. Se revierte con:
```
cmd package install-existing <pkg>
```
Nunca usar `--user all` ni `pm disable` en cascada sin necesidad.

## Categorías típicas (Xiaomi/MIUI, adaptar a otras marcas)

### Anuncios / telemetría (máxima prioridad, riesgo bajo)
- `com.miui.msa.global` (anuncios del sistema)
- `com.miui.analytics`
- `com.miui.misightservice`
- `com.miui.bugreport`

### Tiendas / apps MIUI prescindibles (riesgo bajo-medio)
- `com.xiaomi.mipicks`, `com.miui.player`, `com.miui.videoplayer`
- `com.miui.virtualsim`, `com.miui.vsimcore`, `com.miui.cleaner`
- `com.miui.yellowpage`, `com.mi.globalbrowser`, `com.mi.appfinder`
- `com.miui.fm`, `com.miui.fmservice`, `com.xiaomi.midrop`
- `com.xiaomi.discover`, `com.mi.globalminusscreen`

### Terceros preinstalados (riesgo bajo)
`com.facebook.*` (system, appmanager, services, katana si no la usas, orca, adsmanager, stella), `com.amazon.appmanager`, etc.

### Google prescindible (solo si usas alternativas)
`com.google.android.apps.bard`, `com.google.android.videos`, `com.google.android.apps.subscriptions.red`, `com.android.chrome` (⚠️ rompe WebView en algunos casos).

## ⛔ NO tocar (críticos)
- Launcher: `com.miui.home`, `com.android.launcher3`
- `com.android.systemui`, `com.android.settings`
- Telefonía: `com.android.phone`, `com.android.providers.telephony`, `com.android.mms` (⚠️ SMS; quitar solo si no los usas)
- `com.google.android.gms` (core) y `com.google.android.gsf`
- `com.android.vending` (Play Store)
- Cualquier cosa con "security", "keystore", "certinstaller", "sim", "bluetooth", "wifi"

## Pitfalls reales (aprendidos en un POCO C75 4G / HyperOS 3)

1. **`Failure [-1000]`** = paquete protegido; `pm uninstall --user 0` NO puede. Solución: **fallback a `pm disable-user --user 0`** (mismo efecto práctico: no corre, no aparece).
2. **Verificación falsa por timeout.** Hacer `rish -c "pm list packages" | grep <pkg>` dentro del bucle puede devolver vacío por timeout y reportar "quitado" cuando NO lo está. **Solución:** leer la lista completa **una sola vez** (`ALL=$(rish -c "pm list packages")`) y comparar en memoria. Verificar re-leyendo el estado al final.
3. **No abreviar la verificación.** `pm list packages` sigue mostrando el paquete si está deshabilitado; para distinguir usar `pm list packages -d`.
4. **Reiniciar Shizuku**: si `rish -c id` da "Request timeout", Shizuku está dormido. Quitar ahorro de batería de Termux y Shizuku.

## Script patrón robusto (Termux + rish)

```bash
#!/data/data/com.termux/files/usr/bin/bash
set -u
RISH="$HOME/rish"
LOG="$HOME/debloat/log_desinstalacion_$(date +%Y%m%d_%H%M%S).txt"
PKGS=( com.miui.daemon com.xiaomi.midrop com.xiaomi.glgm com.android.stk )

# rish operativo
timeout 20 "$RISH" -c id 2>&1 | grep -q "uid=2000" || { echo "Inicia Shizuku"; exit 1; }

# Estado en UNA llamada (evita timeouts por-paquete)
ALL=$(timeout 25 "$RISH" -c "pm list packages" | sed 's/^package://')
DIS=$(timeout 25 "$RISH" -c "pm list packages -d" | sed 's/^package://')
present(){ echo "$ALL" | grep -qx "$1"; }

{
 echo "# Debloat user 0 via rish, $(date)"
} > "$LOG"

for p in "${PKGS[@]}"; do
  present "$p" || { echo "AUSENTE $p"; echo "SKIP $p (ausente)" >>"$LOG"; continue; }

  out=$(timeout 30 "$RISH" -c "pm uninstall --user 0 $p" 2>&1)
  echo "$out" | grep -q Success && { echo "QUITADO $p"; echo "QUITADO $p" >>"$LOG"; continue; }

  # Fallback para Failure [-1000]
  out2=$(timeout 30 "$RISH" -c "pm disable-user --user 0 $p" 2>&1)
  echo "$out2" | grep -qi "new state: disabled" \
    && { echo "DESHABILITADO $p"; echo "DESHABILITADO $p" >>"$LOG"; continue; }

  echo "SKIP $p ($out | $out2)"; echo "SKIP $p" >>"$LOG"
done

# Verificacion final re-leyendo estado
echo "== Verificacion =="
for p in "${PKGS[@]}"; do
  if echo "$ALL" | grep -qx "$p"; then
    echo "$DIS" | grep -qx "$p" && echo "DESHABILITADO  $p" || echo "SIGUE ACTIVO   $p"
  else echo "QUITADO        $p"; fi
done
```

Implementación lista en `~/debloat/2b-desinstalar-pendientes-rish.sh`.

## Restaurar

El log distingue `QUITADO` (→ `install-existing`) de `DESHABILITADO` (→ `pm enable`):

```bash
#!/data/data/com.termux/files/usr/bin/bash
set -u
RISH="$HOME/rish"
LOG="${1:-$(ls -t ~/debloat/log_desinstalacion_*.txt 2>/dev/null | head -1)}"
r(){ timeout 30 "$RISH" -c "$1" 2>&1; }

while read -r state pkg _; do
  [ -n "${pkg:-}" ] || continue
  case "$state" in
    QUITADO|OK)     r "cmd package install-existing $pkg" | grep -qi installed \
                      && echo "RESTAURADO $pkg" || echo "FALLO $pkg" ;;
    DESHABILITADO)  r "pm enable $pkg" | grep -qi "new state: enabled" \
                      && echo "REACTIVADO $pkg" || echo "FALLO $pkg" ;;
  esac
done < <(grep -E '^(QUITADO|DESHABILITADO|OK) ' "$LOG")
```

Implementación lista en `~/debloat/3-restaurar.sh`.

## Casos especiales vistos

| Paquete | Comportamiento | Acción |
|---|---|---|
| `com.xiaomi.midrop` | `uninstall --user 0` → `Failure [-1000]` | `disable-user` ✅ |
| `com.miui.daemon`, `com.xiaomi.glgm`, `com.android.stk` | uninstall normal | `uninstall --user 0` ✅ |

## Alternativa no destructiva
`pm disable-user --user 0 <pkg>` deshabilita en vez de desinstalar. Igual de reversible con `pm enable <pkg>`. Útil cuando hay duda.

## Checklist antes de ejecutar
- [ ] Inventario hecho y lista revisada por el usuario.
- [ ] Ningún paquete de la lista "NO tocar".
- [ ] Log activado.
- [ ] Script de restauración probado/creado.
- [ ] Se explicó que es reversible.

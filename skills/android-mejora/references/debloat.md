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

## Script patrón (Termux + rish)

```bash
#!/data/data/com.termux/files/usr/bin/bash
set -u
RISH=~/rish
LOG=~/debloat/log_desinstalacion_$(date +%Y%m%d_%H%M%S).txt

PKGS=( com.miui.analytics com.miui.msa.global )   # <-- lista aprobada

echo "# Desinstalados user 0 via rish, $(date)" > "$LOG"
for p in "${PKGS[@]}"; do
  out=$(timeout 30 "$RISH" -c "pm uninstall --user 0 $p" 2>&1)
  case "$out" in
    *Success*)  echo "OK   $p"; echo "OK $p" >> "$LOG" ;;
    *Failure*|*Exception*|*"not installed"*) echo "SKIP $p ($out)"; echo "SKIP $p" >> "$LOG" ;;
    *)          echo "??   $p -> $out"; echo "SKIP $p" >> "$LOG" ;;
  esac
done
```

## Restaurar

```bash
#!/data/data/com.termux/files/usr/bin/bash
set -u
LOG="${1:-$(ls -t ~/debloat/log_desinstalacion_*.txt 2>/dev/null | head -1)}"
grep '^OK ' "$LOG" | awk '{print $2}' | while read -r p; do
  cmd package install-existing "$p" >/dev/null 2>&1 && echo "RESTAURADO $p" || echo "FALLO $p"
done
```

Con rish: anteponer `~/rish -c "..."`.

## Alternativa no destructiva
`pm disable-user --user 0 <pkg>` deshabilita en vez de desinstalar. Igual de reversible con `pm enable <pkg>`. Útil cuando hay duda.

## Checklist antes de ejecutar
- [ ] Inventario hecho y lista revisada por el usuario.
- [ ] Ningún paquete de la lista "NO tocar".
- [ ] Log activado.
- [ ] Script de restauración probado/creado.
- [ ] Se explicó que es reversible.

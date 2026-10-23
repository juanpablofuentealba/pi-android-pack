# Launcher: iconos, apps ocultas y backups

Aplica a Lawnchair, MIUI Home, Pixel Launcher (variantes de AOSP Launcher3).

## Concepto: dónde vive qué
| Dato | Dónde | Notas |
|---|---|---|
| Posición de iconos, carpetas, dock | `launcher.db` (SQLite, tabla `favorites`) | container `-100` = workspace, `-101` = hotseat/dock |
| **Apps ocultas** (Lawnchair) | `preferences.preferences_pb` (Protobuf, clave `hidden_apps`) | NO está en la db |
| Ajustes del launcher (filas/columnas, temas) | prefs XML / datastore | `com.android.launcher3.prefs.xml` |

## Ubicación típica sin root
`/data/data/<launcher_pkg>/` — inaccesible directo. Vías:
- **Shizuku/rish**: `~/rish -c "cat /data/data/com.android.launcher3/databases/launcher.db" > backup.db`
- **Backup de la app**: Lawnchair → Ajustes → Backup local/exportar. Sale un `.zip`.
- **Restauración**: importar ese zip.

## Leer `launcher.db` sin sqlite3
Termux suele no traer `sqlite3`; usar Python:
```bash
python3 - <<'EOF'
import sqlite3
con=sqlite3.connect('launcher.db'); cur=con.cursor()
cur.execute("PRAGMA table_info(favorites)"); cols=[r[1] for r in cur.fetchall()]
print(cols)
for r in cur.execute("SELECT * FROM favorites"):
    d=dict(zip(cols,r))
    print(d['_id'], d['itemType'], d['container'], d['screen'], d['title'], d['intent'])
EOF
```
`itemType`: 0=app, 1=widget, 2=shortcut, 4=folder. `container`: -100 workspace, -101 hotseat.

## Extraer apps ocultas del `.pb`
Los strings van como `paquete/Actividad#0` (Protobuf: longitud + bytes). Regex:
```bash
python3 - <<'EOF'
import re
s=open('preferences.preferences_pb','rb').read().decode('latin1')
seen=[]
for c in re.findall(r'[A-Za-z0-9_.]*?(com\.[a-zA-Z0-9_.]+/[a-zA-Z0-9_.$]+)', s):
    if c not in seen: seen.append(c)
for i,c in enumerate(seen,1): print(i,c)
EOF
```
`#0` = user profile 0.

## Modificar apps ocultas
- **Vía UI (recomendado):** Lawnchair → Ajustes → Aplicaciones ocultas → desmarcar. Sin riesgo.
- **Vía archivo:** editar el `.pb` es frágil (cambian longitudes del protobuf). Evitar salvo que se sepa re-serializar exacto. Preferir UI.

## Reglas al recomendar qué ocultar
1. Ocultar en el launcher **no es privacidad**: el cajón oculto se abre fácil. Decirlo.
2. Para privacidad real: carpeta con PIN, bloqueo de apps del sistema, o perfil de trabajo.
3. Nunca ocultar el **único acceso** a Ajustes, Play Store o launcher.
4. Apps de uso diario (mensajería, bancos, 2FA) ocultarlas solo genera fricción.
5. Ajustes de sistema/Xiaomi que se abren desde otros lados: ocultar del **cajón** está bien, no borrar.

## Backup recomendado (script)
```bash
#!/data/data/com.termux/files/usr/bin/bash
set -u
DEST=~/lcbk_$(date +%Y%m%d_%H%M%S); mkdir -p "$DEST"
PKG=com.android.launcher3
for f in databases/launcher.db shared_prefs/com.android.launcher3.prefs.xml files/preferences files/preferences.preferences_pb; do
  ~/rish -c "cat /data/data/$PKG/$f" > "$DEST/$(basename $f)" 2>/dev/null && echo "OK $f"
done
ls -la "$DEST"
```
(Con root: `su -c "cp ..."`.)

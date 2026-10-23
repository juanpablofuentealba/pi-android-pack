# Comandos: pm, cmd, am, dumpsys (cheatsheet)

Sin privilegios funciona un subconjunto. Con Shizuku/rish se comportan como ADB.
Patrón rish: `~/rish -c "<comando>"`.

## pm (package manager)
```bash
pm list packages                 # todos
pm list packages -3              # terceros
pm list packages -s              # sistema
pm list packages -d              # deshabilitados
pm list packages -e              # habilitados
pm list packages -u              # incluye desinstalados (user)
pm list packages -f              # con ruta apk
pm path <pkg>                    # ruta del apk
pm uninstall --user 0 <pkg>      # desinstalar para el usuario (reversible)
pm disable-user --user 0 <pkg>   # deshabilitar
pm enable <pkg>                  # rehabilitar
cmd package install-existing <pkg>   # restaurar desinstalado de user 0
pm clear <pkg>                   # borrar datos (⚠️ irreversible)
pm dump <pkg>                    # info completa (igual que dumpsys package)
pm grant <pkg> <permiso>
pm revoke <pkg> <permiso>
```

## cmd
```bash
cmd appops get <pkg>
cmd appops set <pkg> <OP> <allow|deny|ignore>
cmd package list packages
cmd package resolve-activity --brief <pkg>
cmd activity ...
cmd notification ...
cmd connectivity ...
cmd deviceidle ...
```

## am (activity manager)
```bash
am start -n <pkg>/<actividad>            # abrir app
am start -a android.intent.action.VIEW -d "https://x.cl"
am force-stop <pkg>                      # matar app
am kill <pkg>
am broadcast -a <accion>
am stack list
```

## dumpsys (info)
```bash
dumpsys package <pkg>
dumpsys battery
dumpsys power | grep -i wake
dumpsys alarm
dumpsys deviceidle
dumpsys activity processes | grep <pkg>
dumpsys usagestats
dumpsys sensorservice
dumpsys wifi | head -40
dumpsys meminfo | head -40
```

## settings (con Shizuku/root)
```bash
settings get global window_animation_scale
settings put global window_animation_scale 0.5   # revertir a 1.0
settings list global | head
```

## Helpers
```bash
# Abrir app por paquete (descubre la activity de launcher)
cmd package resolve-activity --brief <pkg> | tail -1
# Con eso: am start -n <resultado>
```

## Seguridad
- `pm clear` y `--user all` son **destructivos**. Pedir confirmación.
- `am force-stop` puede perder estado no guardado.
- Todo lo de esta hoja, si se hace con `disable-user`/`uninstall --user 0`, es reversible.

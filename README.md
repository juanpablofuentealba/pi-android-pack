# pi-android-pack

Pack de skills de **pi** para mejorar, limpiar y controlar un Android desde **Termux**, con o sin **Shizuku/rish**.

## Contenido

### Skill
- `android-mejora`: guía completa de diagnóstico, debloat, apps ocultas del launcher, permisos, batería y comandos `pm`/`cmd`/`am`/`dumpsys`.

### Referencias
| Archivo | Tema |
|---|---|
| `references/inventario.md` | Diagnóstico inicial: privilegios, paquetes, uso |
| `references/debloat.md` | Quitar bloatware de forma reversible |
| `references/launcher.md` | Iconos, apps ocultas y backups (Lawnchair/MIUI) |
| `references/energia.md` | Batería, wakelocks, autostart |
| `references/permisos.md` | Permisos, AppOps, privacidad real |
| `references/comandos.md` | Cheatsheet de `pm`/`cmd`/`am`/`dumpsys` |

## Instalación

```bash
# Desde esta carpeta
pi install ./pi-android-pack

# O desde git (recomendado para varios dispositivos)
pi install git:github.com/TU-USUARIO/pi-android-pack
```

Actualizar: `pi update --extensions`. Ver paquetes: `pi list`.

## Requisitos
- Termux con `bash` y `python3` (viene con sqlite3).
- Opcional pero recomendado: **Shizuku** + `rish` en `~/rish` + `rish_shizuku.dex`.
- Root opcional.

## Principios
- Diagnóstico antes de tocar nada.
- Todo reversible (`uninstall --user 0` ↔ `install-existing`).
- Logs y advertencia de riesgos para paquetes críticos.
- Sin promesas de mejora sin medir antes/después.

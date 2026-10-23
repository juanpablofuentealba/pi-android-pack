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
| `references/dispositivo-poco-c75-4g.md` | Caso concreto: POCO C75 4G (Helio G81 Ultra, eMMC, HyperOS 3) |
| `references/sin-root-no-tecnicos.md` | Optimizar el teléfono de otra persona sin Termux/scripts |

### Scripts (`skills/android-mejora/scripts/`)
| Script | Uso |
|---|---|
| `1-inventario.sh` | Solo lectura: estado de paquetes (no modifica nada) |
| `2-desinstalar-rish.sh` | Debloat reversible via rish (con fallback y verificación fiable) |
| `3-restaurar-rish.sh` | Restaura lo desinstalado/deshabilitado |

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
- Todo reversible (`uninstall --user 0` ↔ `install-existing`; `disable-user` ↔ `enable`).
- Logs y advertencia de riesgos para paquetes críticos.
- Sin promesas de mejora sin medir antes/después.
- Fallback `disable-user` cuando `uninstall` da `Failure [-1000]`.
- Verificación fiable: leer la lista de paquetes una sola vez, no un grep por paquete.

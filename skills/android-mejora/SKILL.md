---
name: android-mejora
description: Optimiza, limpia y controla un Android desde Termux (con o sin Shizuku/rish). Úsala para debloat, apps ocultas del launcher, permisos, batería, backups de launcher, ajustes por ADB/pm y automatización con scripts.
---

# Mejora de Android desde Termux

Guía de trabajo para diagnosticar, limpiar y optimizar un teléfono Android desde Termux, con o sin privilegios de Shizuku.

## Cuándo usarla
Cuando pidan debloat, ocultar/quitar bloatware, revisar apps del launcher, permisos, batería/autostart, backups del launcher, o automatizar tareas con `pm`/`cmd`/`am`.

## Reglas de oro (seguridad primero)
1. **Diagnóstico antes de tocar nada.** Siempre correr el inventario primero y mostrar qué se va a hacer.
2. **Nada irreversible sin avisar.** `pm uninstall --user 0` es reversible; `--user all` y root NO lo son tan fácil.
3. **Un cambio por vez**, con log. Nunca borrar en lote sin lista revisada.
4. **Backup antes de modificar** (launcher, listas de paquetes).
5. Si el paquete es de sistema crítico (launcher, settings, telefonía, GMS), **advertir y pedir confirmación explícita**.
6. Explicar el **trade-off** de cada app que se oculte/desinstale.

## Entorno de trabajo
- **Termux**: shell principal. `pm`, `cmd`, `am`, `dumpsys` funcionan pero con permisos limitados.
- **Shizuku + rish** (`~/rish` + `rish_shizuku.dex`): da permisos tipo ADB sin root. Es la vía recomendada.
  - Requiere que Shizuku esté corriendo y el proceso autorizado.
  - Probar: `~/rish -c "pm list packages | head"`.
- **root** (si existe): `su -c` directo. No asumir que hay root.
- Herramientas útiles: `python3` (viene con sqlite3), `sqlite3` puede no estar → usar Python.

## Flujo recomendado
1. **Inventario**: ver `references/inventario.md`.
2. **Diagnóstico**: identificar categoría del problema (ver tabla abajo).
3. **Plan**: proponer lista concreta + explicar riesgos + pedir OK.
4. **Ejecución**: script idempotente con log en `~/debloat/`.
5. **Verificación y rollback**: dejar siempre la vía de restauración.

| Problema | Categoría | Referencia |
|---|---|---|
| Bloatware / apps que no puedo quitar | debloat | `references/debloat.md` |
| Iconos desordenados / apps "desaparecidas" | launcher | `references/launcher.md` |
| Batería, autostart, wakelocks | energía | `references/energia.md` |
| Permisos, privacidad, sensores | permisos | `references/permisos.md` |
| Warp / comandos pm, cmd, am | comandos | `references/comandos.md` |
| Dispositivo concreto (POCO C75 4G) | equipo | `references/dispositivo-poco-c75-4g.md` |

## Convenciones de scripts (Termux)
- Shebang: `#!/data/data/com.termux/files/usr/bin/bash`.
- Guardar en `~/debloat/` con nombre numerado: `1-...`, `2-...`, `3-restaurar.sh`.
- Logs con fecha: `log_<accion>_$(date +%Y%m%d_%H%M%S).txt`.
- `set -u`; capturar salida de `rish` con `timeout 30`.
- Clasificar resultado: `Success` / `Failure` / `not installed` / otro.

## Límites
- **No** desinstalar paquetes críticos (launcher, `com.android.systemui`, settings, telefonía, GMS core) sin advertencia fuerte.
- **No** prometer "más batería" o "más velocidad" sin medir antes/después.
- Ocultar apps del launcher **no es privacidad real**; decirlo. Para privacidad usar bloqueo de apps/carpeta con PIN.
- Cambios con Shizuku se pierden si se reinicia Shizuku en algunos casos; reportar.
- Respetar garantía: `pm uninstall --user 0` no toca la partición de sistema, pero anotar que es reversible con `install-existing`.

## Fallos frecuentes (evitarlos)
- **`Failure [-1000]`** al desinstalar → paquete protegido; usar `pm disable-user --user 0` como fallback.
- **Falsos "OK"** al verificar: leer `pm list packages` **una sola vez** (no un grep por paquete vía rish, que da timeout).
- **Confundir modelos por nombre comercial**: verificar con `ro.board.platform`/`ro.soc.model` (el POCO C75 4G es MediaTek, el 5G es Qualcomm).
- **Swap sobre eMMC**: en equipos con eMMC 5.1 la RAM virtual rinde peor que en UFS; recomendar +2 GB o desactivar.

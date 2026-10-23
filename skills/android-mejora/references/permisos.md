# Permisos, privacidad y sensores

## Ver permisos de una app
```bash
pkg=com.ejemplo.app
dumpsys package "$pkg" | sed -n '/requested permissions/,/install permissions/p'
dumpsys package "$pkg" | sed -n '/runtime permissions/,/^\s*$/p'
```

## Ver qué apps tienen un permiso peligroso
```bash
# Requiere rish/root, salida larga
pm list permissions -g -d
dumpsys package | grep -B5 "android.permission.CAMERA" | head -40
```

## Revocar / conceder (rish o root)
```bash
pm revoke <pkg> android.permission.CAMERA
pm grant  <pkg> android.permission.ACCESS_FINE_LOCATION
pm reset-permissions            # reset global (⚠️ afecta a todas)
```

## AppOps (permisos ocultos: cámara en background, ubicación, etc.)
```bash
cmd appops get <pkg>                     # todo
cmd appops set <pkg> CAMERA deny
cmd appops set <pkg> RUN_IN_BACKGROUND ignore
```
AppOps útiles: `CAMERA`, `RECORD_AUDIO`, `FINE_LOCATION`, `COARSE_LOCATION`, `READ_CONTACTS`, `READ_SMS`, `RUN_IN_BACKGROUND`, `RUN_ANY_IN_BACKGROUND`.

## Privacidad real (lo que SÍ sirve)
| Medida | Efecto |
|---|---|
| Bloqueo de apps del sistema (MIUI: Apps → Bloquear apps) | Pide huella/PIN al abrir |
| Carpeta con PIN / espacio privado | Oculta contenido, no solo el icono |
| Perfil de trabajo (Shelter/Island) | Aísla apps y congela |
| Revocar permisos en AppOps | Limita cámara/mic/ubicación en background |
| Deshabilitar telemetría | Menos envío de datos |
| DNS privado (NextDNS/AdGuard) | Bloquea trackers a nivel red |

## Lo que NO es privacidad
- Ocultar apps del launcher → cosmético.
- "Modo incógnito" de apps individuales → limitado.
- Nombres de carpeta "Privado" → cosmético.

## Sensores / hardware
```bash
dumpsys sensorservice | head -60
cmd sensor_privacy ...          # en Android recientes
dumpsys media.camera | head -40
```

## Checklist
- [ ] Revisar apps con `CAMERA`/`RECORD_AUDIO`/ubicación en background.
- [ ] Revocar lo innecesario con `appops` (reversible).
- [ ] Activar bloqueo de apps para banca/crypto/2FA.
- [ ] Considerar DNS privado.
- [ ] Explicar que ocultar iconos ≠ privacidad.

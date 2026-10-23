# Energía, batería y autostart

## Medir ANTES (nunca prometer sin datos)
```bash
# Resumen de consumo
dumpsys batterystats --charged > ~/bat_antes.txt

# Wakelocks que despiertan el equipo
dumpsys power | grep -i wake

# Alarmas programadas
dumpsys alarm | head -80

# Doze / ahorro
dumpsys deviceidle
```

## Ver consumo por app
```bash
dumpsys batterystats --charged | grep -iE "Estimated power|uid " | head -60
# Más simple:
dumpsys batterystats -c | head
```

## Apps que suelen drenar (revisar, no asumir)
- Redes sociales con push agresivo (Facebook, IG, TikTok).
- Gestores de reloj/bandas (GloryFit, Mi Fitness).
- Launchers con widgets/animaciones.
- Apps Xiaomi de telemetría (`com.miui.analytics`, `misightservice`).
- Espejos de pantalla / cast.

## Autostart (MIUI/HyperOS)
MIUI suele matar apps de fondo por su cuenta. Lo relevante:
- **Ajustes → Apps → Administrar apps → Autostart**: permitir solo lo necesario (WhatsApp, bancos con 2FA, reloj).
- **Ahorro de batería → Sin restricciones** para las mismas.
- `pm list packages` no expone autostart; es ajuste de UI o `dumpsys appops`.

## Comandos útiles
```bash
# Poner app en modo "sin restricciones" (si el OEM lo permite)
cmd appops set <pkg> RUN_IN_BACKGROUND allow
cmd appops get <pkg> RUN_IN_BACKGROUND

# Historial de uso (pantalla)
dumpsys usagestats | head -60

# Doze forzar
dumpsys deviceidle force-idle
dumpsys deviceidle unforce
```

## Optimizaciones seguras
1. Quitar telemetría (`analytics`, `misight`) → menos despertadores.
2. Reducir animaciones: `settings put global window_animation_scale 0.5` (con rish). Reversible con `1.0`.
3. Desactivar apps que no uses en vez de tenerlas empujando push.
4. Revisar si un widget o fondo animado come batería.

## Optimizaciones de riesgo (advertir)
- `pm disable-user` de services de sistema.
- Congelar apps con listas de terceros: puede impedir notificaciones.
- Forzar Doze: puede cortar alarmas/recordatorios.

## Reporte
| App | Consumo antes | Acción | Consumo después |
|---|---|---|---|
| X | 8% | deshabilitada | 2% |

Sin el "antes" no hay afirmación de mejora.

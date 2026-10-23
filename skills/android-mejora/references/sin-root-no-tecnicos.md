# Optimización sin root para usuarios no técnicos

Cuando el teléfono es de otra persona **poco técnica**, no se usa Termux/Shizuku/scripts.
Riesgo alto, diagnóstico difícil y sin margen de error. Se aplican solo ajustes de UI seguros.

## Regla
- **No** instalar Termux/Shizuku ni correr scripts en un teléfono ajeno o de un usuario no técnico.
- **No** desinstalar paquetes del sistema.
- **Sí** aplicar los ajustes nativos de abajo (reversibles, cero riesgo).

## Los 5 ajustes que dan el 80% del beneficio (0% riesgo)

1. **Quitar anuncios / telemetría del sistema**
   `Ajustes → Huellas/PIN → Autorización y revocación` → desactivar **MSA**, **System Daemon**, **GetApps**.
   Puede fallar la 1ª vez: insistir 2-3 veces. Reiniciar después.
2. **Recomendaciones off**
   `Ajustes → Aplicaciones → ⋮ → Otros ajustes → Recomendaciones` → off.
3. **Animación rápida**
   `Ajustes → Pantalla de inicio → Velocidad de animación → Rápida`.
4. **Actualizar todo**
   Play Store → Gestionar apps → Actualizar todo; `Ajustes → Sobre el teléfono → Actualizar HyperOS`.
5. **Batería**
   `Ajustes → Batería → Protección de carga nocturna` ON; y programar reinicio nocturno
   (`Batería → Funciones adicionales → Programar encendido/apagado`).

## Ajustes con el usuario delante
- **Desinstalar solo lo que el usuario confirma que no usa** (`Ajustes → Aplicaciones`).
- **Ordenar el escritorio** en carpetas. Cosmético, cero riesgo.

## Nunca tocar en un teléfono ajeno
WhatsApp/mensajería, bancos, cámara, galería, teléfono, contactos, reloj, Ajustes, Play Store, Google/GMS.

## Qué NO hacer
- Termux, Shizuku, scripts, `pm uninstall` del sistema.
- Desactivar autostart de mensajería/bancos.
- Cambiar swap o ajustes de desarrollador.
- Apps "limpiadoras/aceleradoras".

## Contexto: por qué no debloat "de verdad" aquí
En un POCO C75 4G (Helio G81 Ultra, performance 21/100) el beneficio de debloat es real pero
el riesgo de romper la experiencia diaria del usuario es mayor que la ganancia si no puede revertir.
Para uso básico, los 5 ajustes nativos + actualizar + ordenar es suficiente.

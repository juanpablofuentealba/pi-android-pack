# Caso: POCO C75 4G (Helio G81 Ultra / HyperOS 3)

Notas específicas de este dispositivo. Sirven de plantilla para gamas de entrada Xiaomi.

## Identificación (no confundir con el C75 5G)
Verificar SIEMPRE con props, no con el nombre comercial:

```bash
getprop ro.product.model          # 2410FPCC5G
getprop ro.product.name           # lake_p_global
getprop ro.board.platform         # mt6768   <-- MediaTek
getprop ro.soc.model              # MT6769
getprop ro.miui.ui.version.name   # V816
getprop ro.build.version.incremental  # OS3.0.307.0.WGTMIXM (HyperOS 3)
```

**C75 4G**: MediaTek Helio G81 Ultra (MT6769), 12 nm, 2× A75 + 6× A55, Mali-G52 MC2.
**C75 5G**: Snapdragon 4s Gen 2 (SM4450), 4 nm, Adreno 611. Son equipos distintos.

## Hardware relevante para optimizar
| Componente | Valor | Implicación |
|---|---|---|
| SoC | Helio G81 Ultra, **12 nm** | Calienta; el modo alto rendimiento sostenido hace throttling |
| RAM | 6 GB LPDDR4X | Suficiente; NO es el cuello de botella |
| Storage | **eMMC 5.1** | Swap/RAM virtual lento y con más desgaste que en UFS |
| Batería | 5160 mAh, 18 W | Su punto fuerte (NanoReview 66/100) |

NanoReview: Performance 21/100, Gaming 10/100. Es un equipo de **uso básico**; el cuello de botella es CPU/GPU, no la RAM.

## RAM virtual (Memory Extension) en este equipo
- Con **eMMC 5.1** el swap rinde peor que en UFS: lag en multitarea pesada, +batería, +calor, desgaste.
- Recomendación: **+2 GB o desactivar**. Evitar el máximo. Probar 2-3 días y comparar.
- Desactivar si el storage está >80% lleno.

## Bloat ya eliminado en este equipo
msa, analytics, mipicks, player, videoplayer, globalbrowser, globalminusscreen,
yellowpage, cleanmaster, systemAdSolution, hybrid, mircs, **daemon, glgm, stk**,
y **midrop** (deshabilitado, no permitía uninstall).

## Acciones de mayor impacto (sin root)
1. **Autostart selectivo**: `Ajustes → Apps → Autoencendido en segundo plano` (activar "mostrar apps del sistema").
2. **MSA + System Daemon + GetApps off**: `Ajustes → Huellas/PIN → Autorización y revocación`.
3. **Velocidad de animación → Rápida**: `Ajustes → Pantalla de inicio`.
4. **Recomendaciones off**: `Ajustes → Apps → ⋮ → Otros ajustes`.
5. **Protección de carga nocturna**: `Ajustes → Batería` (cuidar el punto fuerte).

## No hacer en este equipo
- Root/KernelSU "optimizers" (riesgo bootloop, anula garantía).
- Apps limpiadoras tipo Clean Master.
- Forzar alto rendimiento permanente (12 nm → throttling).
- Tocar `powerkeeper`, `gms`, `securitycenter`, `home`.

## Herramientas en este equipo
- `~/rish` + `rish_shizuku.dex` (Shizuku). Si da timeout: quitar ahorro de batería a Termux y Shizuku.
- Debloat: `~/debloat/` (1-lista, 2b-desinstalar-rish, 3-restaurar).
- Skill `android-mejora` con referencias.

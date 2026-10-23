# Inventario y diagnóstico

Primer paso **siempre**. No modificar nada hasta tener este panorama.

## 1. ¿Hay privilegios?

```bash
# Shizuku / rish
if [ -x ~/rish ]; then
  ~/rish -c "id" 2>&1 | head -1
fi

# root
command -v su >/dev/null && su -c id 2>&1 | head -1
```

- `uid=2000(shell)` → rish OK (permisos ADB).
- `uid=0(root)` → root.
- Error/timeout → sin privilegios: solo `pm list` / `dumpsys` limitado.

## 2. Info del dispositivo

```bash
getprop ro.product.brand
getprop ro.product.model
getprop ro.build.version.release
getprop ro.build.version.sdk
getprop ro.miui.ui.version.name   # si es Xiaomi
getprop ro.build.characteristics  # phone/tablet
```

## 3. Inventario de paquetes

```bash
# Todos
pm list packages | sed 's/package://' | sort > ~/all_pkgs_$(date +%F).txt

# Deshabilitados (= ya debloateados)
pm list packages -d | sed 's/package://' | sort

# Desinstalados para el usuario 0 pero presentes en el sistema
pm list packages -u | sed 's/package://' | sort

# Solo de terceros (= instaladas por el usuario)
pm list packages -3 | sed 's/package://' | sort

# Con ruta del APK
pm list packages -f
```

## 4. Estado de un objetivo puntual

```bash
pkg=com.ejemplo.app
pm list packages | grep -q "package:$pkg$" && echo instalado || echo no-existe
pm list packages -d | grep -q "package:$pkg$" && echo deshabilitado
pm path "$pkg"
dumpsys package "$pkg" | head -40
```

## 5. Uso / datos (para decidir si vale la pena)

```bash
# Tamaño y datos
du -sh /data/data/"$pkg" 2>/dev/null

# ¿Está corriendo?
dumpsys activity processes | grep -i "$pkg"

# Batería: consumo por app
dumpsys batterystats --charged | grep -A5 "$pkg"
```

## 6. Serializar diagnóstico

Antes de proponer cambios, entregar una tabla:

| Paquete | Existe | Estado | Categoría | Riesgo | Recomendación |
|---|---|---|---|---|---|
| com.x | sí | habilitado | bloat | bajo | desinstalar user 0 |

Solo después de que el usuario apruebe, se pasa a la referencia correspondiente.

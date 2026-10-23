#!/data/data/com.termux/files/usr/bin/bash
# Inventario de solo lectura: NO modifica nada.
# Muestra el estado de una lista de paquetes objetivo.
# Ejecutar:  bash 1-inventario.sh

set -u
PKGS=(
  com.miui.msa.global
  com.miui.analytics
  com.miui.misightservice
  com.miui.bugreport
  com.xiaomi.mipicks
  com.miui.player
  com.miui.videoplayer
  com.miui.cleaner
  com.miui.yellowpage
  com.mi.globalbrowser
  com.mi.appfinder
  com.miui.miservice
  com.xiaomi.midrop
  com.xiaomi.discover
  com.mi.globalminusscreen
  com.miui.daemon
  com.xiaomi.glgm
  com.android.stk
)

ALL=$(pm list packages 2>/dev/null | sed 's/^package://')
DIS=$(pm list packages -d 2>/dev/null | sed 's/^package://')
UNI=$(pm list packages -u 2>/dev/null | sed 's/^package://')

echo "=== ESTADO DE OBJETIVOS ==="
for p in "${PKGS[@]}"; do
  if echo "$ALL" | grep -qx "$p"; then
    if echo "$DIS" | grep -qx "$p"; then echo "[DESHABILITADO] $p"
    else echo "[instalado]    $p"; fi
  elif echo "$UNI" | grep -qx "$p"; then
    echo "[QUITADO u0]   $p"
  else
    echo "[no en ROM]    $p"
  fi
done

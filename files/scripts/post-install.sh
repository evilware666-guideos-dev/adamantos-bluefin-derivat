#!/usr/bin/env bash
set -oue pipefail

echo ">>> AdamantOS Post-Install beginnt ..."

# ─── ImageMagick 'display' ausblenden ───
echo ">>> Blende ImageMagick 'display' aus ..."
IM_DESKTOPS=$(find /usr/share/applications -maxdepth 1 -type f \
    \( -name "display-im6*.desktop" -o -name "display-im*.desktop" \) \
    2>/dev/null || true)

if [[ -n "$IM_DESKTOPS" ]]; then
    while IFS= read -r IM_DESKTOP; do
        [[ -z "$IM_DESKTOP" ]] && continue
        if ! grep -q "^NoDisplay=true" "$IM_DESKTOP"; then
            sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$IM_DESKTOP"
        fi
    done <<< "$IM_DESKTOPS"
fi

# ─── Deutsche Sprache ───
echo ">>> Konfiguriere deutsche Sprache ..."
echo "LANG=de_DE.UTF-8" > /etc/locale.conf

# ─── UFW aktivieren ───
echo ">>> Aktiviere UFW ..."
ufw --force enable || true
ufw default deny incoming || true
ufw default allow outgoing || true

echo ">>> AdamantOS Post-Install abgeschlossen."

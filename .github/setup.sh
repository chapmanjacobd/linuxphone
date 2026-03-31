#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

sudo visudo

sudo sed -i 's/#Storage=.*/Storage=volatile/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald

sudo rsync -r --chmod=644 .github/etc/ /etc/
sudo rsync -r --chmod=644 .github/lib/ /lib/
sudo systemctl daemon-reload

sudo systemctl enable --now sshd
fish -c "key-refresh-ssh linuxphone"

sudo apk add $(cat .github/apk_installed)

sudo systemctl enable --now earlyoom
sudo systemctl enable --now plocate-updatedb.timer

sudo systemctl enable --now tlp.service
cat <<EOF | sudo tee -a /etc/tlp.conf
CPU_SCALING_GOVERNOR_ON_BAT=schedutil
CPU_SCALING_GOVERNOR_ON_SAV=powersave
PCIE_ASPM_ON_BAT=powersupersave

CPU_ENERGY_PERF_POLICY_ON_BAT=power
TLP_DEFAULT_MODE=BAT
TLP_PERSISTENT_DEFAULT=1
EOF

sudo iw dev wlan0 set power_save on

pip install --upgrade requests pip wheel
pip install $(cat .github/pip_installed)

if command -v cargo &> /dev/null; then
    cargo install $(cat .github/cargo_installed)
fi

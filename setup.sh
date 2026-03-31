#!/bin/bash

sudo visudo

cat ~/.github/etc/ssh/sshd_config.d/10-xk.conf | sudo tee /etc/ssh/sshd_config.d/10-xk.conf
sudo systemctl enable --now sshd

# Install packages from apk_installed list
sudo apk add $(cat ~/.github/apk_installed)

# Upgrade Python packages
pip install --upgrade requests pip wheel
pip install $(cat ~/.github/pip_installed)

# Fix shebangs for task scripts
for f in ./.shortcuts/tasks/*.sh
do
  chmod +x "$f"
done

# Enable systemd user timers
mkdir -p ~/.config/systemd/user
systemctl --user daemon-reload

# Setup SSH keys if needed
if command -v key-refresh-ssh &> /dev/null; then
  key-refresh-ssh phone
fi

# Create xclip symlink if wl-clipboard is available
if command -v wl-copy &> /dev/null; then
  ln -sf /usr/bin/wl-copy ~/.local/bin/xclip 2>/dev/null || true
fi

sudo sed -i 's/#Storage=.*/Storage=volatile/' /etc/systemd/journald.conf
sudo systemctl enable --now tlp.service

# TLP power management settings
cat <<EOF | sudo tee -a /etc/tlp.conf
CPU_SCALING_GOVERNOR_ON_BAT=schedutil
CPU_SCALING_GOVERNOR_ON_SAV=powersave
PCIE_ASPM_ON_BAT=powersupersave

CPU_ENERGY_PERF_POLICY_ON_BAT=power
TLP_DEFAULT_MODE=BAT
TLP_PERSISTENT_DEFAULT=1
EOF

sudo iw dev wlan0 set power_save on

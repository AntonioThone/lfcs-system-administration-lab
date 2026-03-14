#!/bin/bash
# Systemd Timers

echo "=== SYSTEMD TIMERS ==="

# Criar serviço
sudo tee /etc/systemd/system/clean-logs.service << 'EOF' > /dev/null
[Unit]
Description=Clean old journal logs

[Service]
Type=oneshot
ExecStart=/usr/bin/journalctl --vacuum-time=14d
EOF

# Criar timer
sudo tee /etc/systemd/system/clean-logs.timer << 'EOF' > /dev/null
[Unit]
Description=Run clean-logs daily at 03:15

[Timer]
OnCalendar=*-*-* 03:15:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Ativar
sudo systemctl daemon-reload
sudo systemctl enable --now clean-logs.timer

echo "Timer criado:"
systemctl list-timers clean-logs.timer --no-pager

echo ""
echo "Serviço:"
systemctl cat clean-logs.service

echo "=== FIM ==="

## 3.1 Kernel Tuning


# Aumentar limite inotify
echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.d/99-custom.conf
sudo sysctl -p /etc/sysctl.d/99-custom.conf

# Verificar
sysctl fs.inotify.max_user_watches

## 3.2 Apache Web Server

# Instalar Apache
sudo dnf install -y httpd
sudo systemctl enable --now httpd
echo "<h1>Node1 - LFCS Lab</h1>" | sudo tee /var/www/html/index.html

# Nota: Apache foi desativado para liberar porta 80 para HAProxy
sudo systemctl stop httpd
sudo systemctl disable httpd
## 3.3 Systemd Timers

# Criar serviço para limpar logs
sudo tee /etc/systemd/system/clean-logs.service << 'EOF'
[Unit]
Description=Clean old journal logs

[Service]
Type=oneshot
ExecStart=/usr/bin/journalctl --vacuum-time=14d
EOF

# Criar timer
sudo tee /etc/systemd/system/clean-logs.timer << 'EOF'
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

## 3.4 SELinux Context

# Mover web root para /data/www (exercício)
sudo mkdir -p /data/www
echo "<h1>SELinux Test</h1>" | sudo tee /data/www/index.html

# Ajustar contexto
sudo semanage fcontext -a -t httpd_sys_content_t "/data/www(/.*)?"
sudo restorecon -Rv /data/www

# Configurar Apache
sudo sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/data/www"|' /etc/httpd/conf/httpd.conf

#!/bin/bash
# Apache SELinux Context

echo "=== APACHE SELINUX CONTEXT ==="

# Criar novo diretório
sudo mkdir -p /data/www
echo "<h1>SELinux Test - $(date)</h1>" | sudo tee /data/www/index.html

# Ver contexto original
echo "Contexto original:"
ls -Z /data/www

# Ajustar contexto
sudo semanage fcontext -a -t httpd_sys_content_t "/data/www(/.*)?"
sudo restorecon -Rv /data/www

# Ver novo contexto
echo ""
echo "Contexto após ajuste:"
ls -Z /data/www

# Backup da configuração original
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak

# Configurar Apache (opcional)
echo ""
echo "Para usar este diretório no Apache, edite:"
echo "sudo sed -i 's|DocumentRoot \"/var/www/html\"|DocumentRoot \"/data/www\"|' /etc/httpd/conf/httpd.conf"
echo "sudo systemctl restart httpd"

echo "=== FIM ==="

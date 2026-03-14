#!/bin/bash
# ACL Permissions

echo "=== ACL PERMISSIONS ==="

# Preparar ambiente
sudo mkdir -p /srv/app
echo "database_password: secret123" | sudo tee /srv/app/config.yml

# Definir ACL
sudo setfacl -m u:qa:r /srv/app/config.yml

echo "Permissões ACL:"
getfacl /srv/app/config.yml

echo ""
echo "Testando acesso do qa:"
sudo -u qa cat /srv/app/config.yml && echo " Leitura OK" || echo " Falha leitura"

echo ""
echo "Testando escrita do qa:"
if sudo -u qa echo "teste" >> /srv/app/config.yml 2>/dev/null; then
    echo " Escrita permitida (erro!)"
else
    echo "Escrita bloqueada (correto!)"
fi

echo "=== FIM ==="

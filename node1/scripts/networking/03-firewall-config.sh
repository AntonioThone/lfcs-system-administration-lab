#!/bin/bash
# Firewall Configuration

echo "=== FIREWALL CONFIGURATION ==="

echo "Estado atual:"
sudo firewall-cmd --list-all

echo ""
echo "1. Adicionando serviços..."
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http

echo "2. Adicionando portas específicas..."
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --permanent --add-port=8082/tcp

echo "3. Recarregando firewall..."
sudo firewall-cmd --reload

echo ""
echo "Configuração final:"
sudo firewall-cmd --list-all

echo ""
echo "Portas abertas:"
sudo ss -tlnp | grep -E ":80|:8081|:8082"

echo "=== FIM ==="

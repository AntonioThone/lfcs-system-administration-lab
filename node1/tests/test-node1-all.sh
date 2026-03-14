#!/bin/bash
# Teste completo do Node 1

echo "========================================="
echo "   TESTE COMPLETO - NODE 1"
echo "========================================="
echo ""

# Executar todos os testes
./test-node1-services.sh

echo ""
echo "========================================="
echo "   VERIFICAÇÕES ADICIONAIS"
echo "========================================="

echo "1. SELinux: $(getenforce)"
sudo ausearch -m avc -ts recent | tail -3

echo ""
echo "2. Firewall rules:"
sudo firewall-cmd --list-all | grep -E "services:|ports:"

echo ""
echo "3. Network bonding:"
cat /proc/net/bonding/bond0 2>/dev/null | grep -E "Bonding Mode|Currently Active Slave" || echo "Bond não configurado"

echo ""
echo "4. Git config:"
git config --list | grep user

echo ""
echo "========================================="

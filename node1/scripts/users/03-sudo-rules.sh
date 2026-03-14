#!/bin/bash
# Sudo Rules

echo "=== SUDO RULES ==="

# Criar regra para deployer
echo "deployer ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart httpd" | \
  sudo tee /etc/sudoers.d/deployer-httpd

# Verificar
echo ""
echo "Regras sudo para deployer:"
sudo -l -U deployer

echo ""
echo "Testando (simulado):"
echo "sudo -u deployer sudo systemctl restart httpd"
echo " Configurado - deve funcionar sem pedir senha"

echo "=== FIM ==="

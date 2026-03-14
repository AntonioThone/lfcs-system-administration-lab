#!/bin/bash
# Criação de Utilizadores

echo "=== CRIAÇÃO DE UTILIZADORES ==="

# Criar utilizadores
sudo useradd -m -s /bin/bash analyst
sudo useradd -m qa
sudo useradd -m -G wheel deployer

# Definir senhas
echo "analyst:TempPass123" | sudo chpasswd
sudo passwd -e analyst
echo "qa:QaPass123" | sudo chpasswd
echo "deployer:Deploy123" | sudo chpasswd

# Verificar
echo ""
echo "Utilizadores criados:"
getent passwd analyst qa deployer | cut -d: -f1

echo ""
echo "Status da password do analyst:"
sudo chage -l analyst | head -2

echo "=== FIM ==="

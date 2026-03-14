#!/bin/bash
# Network Bonding

echo "=== NETWORK BONDING ==="

# Verificar interfaces disponíveis
echo "Interfaces disponíveis:"
ip link show | grep -E "^[0-9]" | cut -d: -f2 | grep -v lo

# Criar bond
sudo nmcli connection add type bond con-name bond0 ifname bond0 bond.options "mode=active-backup,miimon=100"

# Configurar DHCP
sudo nmcli connection mod bond0 ipv4.method auto

# Adicionar escrava (ens160)
sudo nmcli connection add type ethernet slave-type bond con-name bond0-slave1 ifname ens160 master bond0

# Ativar bond
sudo nmcli connection up bond0
sudo nmcli connection down ens160 2>/dev/null

echo ""
echo "Status do bond:"
cat /proc/net/bonding/bond0 | grep -E "Bonding Mode|Currently Active Slave|MII Status"

echo ""
echo "IP do bond:"
ip addr show bond0 | grep inet || echo "Aguardando DHCP..."

echo "=== FIM ==="

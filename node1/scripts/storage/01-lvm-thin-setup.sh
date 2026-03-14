#!/bin/bash
# LVM Thin Provisioning Setup

echo "=== LVM THIN PROVISIONING ==="

# Verificar discos disponíveis
echo "Discos disponíveis:"
lsblk | grep -E "sda|sdb|sdc|nvme"

# Assumindo /dev/sdb como disco adicional
DISK="/dev/sdb"

if [ ! -b "$DISK" ]; then
    echo "�ERRO: Disco $DISK não encontrado!"
    echo "Por favor, adicione um disco virtual no VMware primeiro."
    exit 1
fi

echo ""
echo "1. Criando Physical Volume..."
sudo pvcreate $DISK

echo "2. Criando Volume Group..."
sudo vgcreate vg_data $DISK

echo "3. Criando Thin Pool..."
sudo lvcreate -L 3G -T vg_data/thin_pool

echo "4. Criando volumes thin..."
sudo lvcreate -V 1G -T vg_data/thin_pool -n web_data
sudo lvcreate -V 1G -T vg_data/thin_pool -n db_data

echo "5. Formatando e montando..."
sudo mkfs.xfs /dev/vg_data/web_data
sudo mkdir -p /mnt/web
sudo mount /dev/vg_data/web_data /mnt/web

echo ""
echo "Status LVM:"
sudo lvs

echo ""
echo "Montagens:"
df -h | grep web_data

echo "=== FIM ==="

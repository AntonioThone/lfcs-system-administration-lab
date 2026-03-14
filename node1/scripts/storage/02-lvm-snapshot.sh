#!/bin/bash
# LVM Snapshot Exercise

echo "=== LVM SNAPSHOT EXERCISE ==="

# Verificar se o volume existe
if ! sudo lvs | grep -q web_data; then
    echo "Volume web_data não encontrado!"
    echo "Execute primeiro: 01-lvm-thin-setup.sh"
    exit 1
fi

# 1. Criar dados
echo "1. Criando dados importantes..."
echo "DADO CRÍTICO - $(date)" | sudo tee /mnt/web/critico.txt
sudo ls -la /mnt/web/ | grep critico

# 2. Criar snapshot
echo ""
echo "2. Criando snapshot..."
sudo lvcreate -s -n web_data_snap -L 500M /dev/vg_data/web_data
sudo lvs | grep snap

# 3. Simular corrupção
echo ""
echo "3. Simulando perda de dados..."
sudo rm -f /mnt/web/critico.txt
sudo ls -la /mnt/web/ | grep critico || echo "Arquivo removido"

# 4. Desmontar
echo ""
echo "4. Desmontando volume..."
sudo umount /mnt/web

# 5. Restaurar snapshot
echo "5. Restaurando snapshot..."
sudo lvconvert --merge /dev/vg_data/web_data_snap
sleep 2

# 6. Montar e verificar
echo "6. Montando volume restaurado..."
sudo mount /dev/vg_data/web_data /mnt/web

echo "7. Verificando dados restaurados:"
sudo ls -la /mnt/web/
echo ""
echo "Conteúdo do arquivo:"
sudo cat /mnt/web/critico.txt

echo ""
echo "=== EXERCÍCIO CONCLUÍDO ==="

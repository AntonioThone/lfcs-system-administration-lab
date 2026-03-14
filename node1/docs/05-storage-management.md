## 5.1 LVM Thin Provisioning


# Verificar discos disponíveis
lsblk
# /dev/sdb deve estar disponível (adicionado no VMware)

# Criar PV, VG
sudo pvcreate /dev/sdb
sudo vgcreate vg_data /dev/sdb

# Criar thin pool
sudo lvcreate -L 3G -T vg_data/thin_pool

# Criar volumes thin
sudo lvcreate -V 1G -T vg_data/thin_pool -n web_data

# Formatar e montar
sudo mkfs.xfs /dev/vg_data/web_data
sudo mkdir /mnt/web
sudo mount /dev/vg_data/web_data /mnt/web

# Verificar
sudo lvs
df -h | grep web_data

##5.2 Snapshots e Restore

# Criar dados
echo "Dados importantes - $(date)" | sudo tee /mnt/web/dados.txt

# Criar snapshot
sudo lvcreate -s -n web_data_snap -L 500M /dev/vg_data/web_data

# Simular corrupção
sudo rm -f /mnt/web/dados.txt

# Desmontar e restaurar
sudo umount /mnt/web
sudo lvconvert --merge /dev/vg_data/web_data_snap

# Montar e verificar dados restaurados
sudo mount /dev/vg_data/web_data /mnt/web
ls -la /mnt/web/  # dados.txt deve estar de volta!

## 5.3 Comandos Úteis LVM

# Listar volumes
sudo lvs
sudo vgs
sudo pvs

# Estender volume
sudo lvextend -L +500M /dev/vg_data/web_data
sudo xfs_growfs /mnt/web

# Reduzir volume (xfs não permite, mas ext4 sim)
# Apenas para referência

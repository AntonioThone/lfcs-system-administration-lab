#!/bin/bash
# Kernel Tuning

echo "=== KERNEL TUNING ==="

# Valor atual
CURRENT=$(sysctl -n fs.inotify.max_user_watches)
echo "Valor atual: $CURRENT"

# Aumentar limite
echo "fs.inotify.max_user_watches = 524288" | sudo tee /etc/sysctl.d/99-custom.conf
sudo sysctl -p /etc/sysctl.d/99-custom.conf

# Novo valor
NEW=$(sysctl -n fs.inotify.max_user_watches)
echo "Novo valor: $NEW"

if [ "$NEW" -gt "$CURRENT" ]; then
    echo " Kernel tuning aplicado com sucesso!"
else
    echo " Falha ao aplicar kernel tuning"
fi

echo "=== FIM ==="

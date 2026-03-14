#!/bin/bash
# Find com exec

echo "=== FIND COM EXEC ==="
echo "Procurando e copiando ficheiros .conf..."

mkdir -p ~/lfcs-lab/backup

find /etc -name "*.conf" -type f 2>/dev/null -exec cp {} ~/lfcs-lab/backup/ \;

COUNT=$(ls ~/lfcs-lab/backup/ | wc -l)
echo "Foram copiados $COUNT ficheiros .conf para ~/lfcs-lab/backup/"

echo ""
echo "Primeiros 5 ficheiros:"
ls ~/lfcs-lab/backup/ | head -5

echo "=== FIM ==="

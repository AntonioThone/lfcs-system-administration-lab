#!/bin/bash
# Exercício de Wildcards

echo "=== SHELL WILDCARDS ==="
echo "Criando ficheiros de teste..."

mkdir -p ~/lfcs-lab/wildcard
cd ~/lfcs-lab/wildcard

touch a.conf ab.conf abc.conf abcd.conf b.conf bc.conf c.conf
touch 1.txt 12.txt 123.txt 1234.txt
touch file1.log file2.log file10.log file100.log

echo ""
echo "1. Ficheiros que começam com a ou b, têm pelo menos 2 chars e extensão .conf:"
ls [a-b]??*.conf

echo ""
echo "2. Ficheiros com exatamente 3 dígitos e extensão .txt:"
ls [0-9][0-9][0-9].txt

echo ""
echo "3. Ficheiros file10.log até file99.log:"
ls file[1-9][0-9].log

echo ""
echo "=== FIM ==="

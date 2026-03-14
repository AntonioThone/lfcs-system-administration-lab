#!/bin/bash
# Process Monitoring

echo "=== PROCESS MONITORING ==="
echo ""

echo "Top 5 processos por CPU:"
ps aux --sort=-%cpu | head -6

echo ""
echo "Top 5 processos por MEMÓRIA:"
ps aux --sort=-%mem | head -6

echo ""
echo "Processos do utilizador $USER:"
ps aux -U $USER | head -10

echo "=== FIM ==="

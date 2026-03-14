#!/bin/bash
# Teste de serviços do Node 1

echo "========================================="
echo "   TESTE DE SERVIÇOS - NODE 1"
echo "========================================="
echo ""

PASSED=0
FAILED=0

test_service() {
    echo -n "Testando $1... "
    if systemctl is-active --quiet $2; then
        echo " ATIVO"
        PASSED=$((PASSED+1))
    else
        echo " INATIVO"
        FAILED=$((FAILED+1))
    fi
}

# 1. Testar serviços
echo "1. SERVIÇOS:"
test_service "HAProxy" "haproxy"
test_service "Firewall" "firewalld"
test_service "Podman" "podman"
echo ""

# 2. Testar containers
echo "2. CONTAINERS:"
if podman ps | grep -q web1; then
    echo "   web1:  ATIVO"
    PASSED=$((PASSED+1))
else
    echo "   web1:  INATIVO"
    FAILED=$((FAILED+1))
fi

if podman ps | grep -q web2; then
    echo "   web2:  ATIVO"
    PASSED=$((PASSED+1))
else
    echo "   web2:  INATIVO"
    FAILED=$((FAILED+1))
fi
echo ""

# 3. Testar portas
echo "3. PORTAS:"
if ss -tlnp | grep -q :80; then
    echo "   Porta 80 (HAProxy):  OK"
    PASSED=$((PASSED+1))
else
    echo "   Porta 80 (HAProxy):  FECHADA"
    FAILED=$((FAILED+1))
fi

if ss -tlnp | grep -q :8081; then
    echo "   Porta 8081 (web1):  OK"
    PASSED=$((PASSED+1))
else
    echo "   Porta 8081 (web1):  FECHADA"
    FAILED=$((FAILED+1))
fi

if ss -tlnp | grep -q :8082; then
    echo "   Porta 8082 (web2):  OK"
    PASSED=$((PASSED+1))
else
    echo "   Porta 8082 (web2):  FECHADA"
    FAILED=$((FAILED+1))
fi
echo ""

# 4. Testar LVM
echo "4. LVM:"
if sudo lvs | grep -q web_data; then
    echo "   Volume web_data:  OK"
    PASSED=$((PASSED+1))
else
    echo "   Volume web_data:  AUSENTE"
    FAILED=$((FAILED+1))
fi

if mount | grep -q /mnt/web; then
    echo "   Montagem /mnt/web:  OK"
    PASSED=$((PASSED+1))
else
    echo "   Montagem /mnt/web:  NÃO MONTADO"
    FAILED=$((FAILED+1))
fi
echo ""

# 5. Testar utilizadores
echo "5. UTILIZADORES:"
for user in analyst qa deployer; do
    if id $user &>/dev/null; then
        echo "   $user: OK"
        PASSED=$((PASSED+1))
    else
        echo "   $user: AUSENTE"
        FAILED=$((FAILED+1))
    fi
done
echo ""

# 6. Testar load balancer
echo "6. LOAD BALANCER:"
echo "   Requisições:"
SERVER1_COUNT=0
SERVER2_COUNT=0

for i in {1..6}; do
    RESULT=$(curl -s http://localhost)
    echo "     Req $i: $RESULT"
    if [ "$RESULT" = "Server 1" ]; then
        SERVER1_COUNT=$((SERVER1_COUNT+1))
    elif [ "$RESULT" = "Server 2" ]; then
        SERVER2_COUNT=$((SERVER2_COUNT+1))
    fi
done

if [ $SERVER1_COUNT -gt 0 ] && [ $SERVER2_COUNT -gt 0 ]; then
    echo "   Round-robin funcionando (S1:$SERVER1_COUNT, S2:$SERVER2_COUNT)"
    PASSED=$((PASSED+1))
else
    echo "    Round-robin não funcionou (S1:$SERVER1_COUNT, S2:$SERVER2_COUNT)"
    FAILED=$((FAILED+1))
fi
echo ""

# Resumo
echo "========================================="
echo "RESUMO: $PASSED testes passados, $FAILED falharam"
echo "========================================="

if [ $FAILED -eq 0 ]; then
    echo " NODE 1 PRONTO PARA SEGUIR!"
else
    echo "Reveja os testes falhados antes de prosseguir."
fi

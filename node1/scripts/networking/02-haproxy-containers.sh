#!/bin/bash
# HAProxy + Containers

echo "=== HAPROXY + CONTAINERS ==="

# Parar Apache se estiver a correr
sudo systemctl stop httpd 2>/dev/null
sudo systemctl disable httpd 2>/dev/null

# Remover containers antigos
podman rm -f web1 web2 2>/dev/null

# Criar containers
echo "1. Criando containers Nginx..."
podman run -d --name web1 -p 8081:80 docker.io/nginx
podman run -d --name web2 -p 8082:80 docker.io/nginx

# Personalizar
podman exec web1 sh -c 'echo "Server 1" > /usr/share/nginx/html/index.html'
podman exec web2 sh -c 'echo "Server 2" > /usr/share/nginx/html/index.html'

echo ""
echo "2. Containers:"
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Configurar HAProxy
echo ""
echo "3. Configurando HAProxy..."
sudo tee /etc/haproxy/haproxy.cfg > /dev/null << 'EOF'
global
    log /dev/log local0
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode http
    timeout connect 5000
    timeout client 50000
    timeout server 50000

frontend web_front
    bind *:80
    default_backend web_servers

backend web_servers
    balance roundrobin
    server web1 127.0.0.1:8081 check
    server web2 127.0.0.1:8082 check
EOF

# Iniciar HAProxy
sudo systemctl enable --now haproxy 2>/dev/null || sudo systemctl restart haproxy

# Firewall
sudo firewall-cmd --permanent --add-port=80/tcp 2>/dev/null
sudo firewall-cmd --permanent --add-port=8081/tcp 2>/dev/null
sudo firewall-cmd --permanent --add-port=8082/tcp 2>/dev/null
sudo firewall-cmd --reload 2>/dev/null

# SELinux (permitir HAProxy conectar às portas)
sudo setsebool -P haproxy_connect_any 1 2>/dev/null
sudo semanage port -a -t http_port_t -p tcp 8081 2>/dev/null
sudo semanage port -a -t http_port_t -p tcp 8082 2>/dev/null

echo ""
echo "4. Testando containers diretamente:"
curl -s http://localhost:8081 | head -1
curl -s http://localhost:8082 | head -1

echo ""
echo "5. Testando HAProxy (load balancer):"
for i in {1..4}; do
    echo "   Req $i: $(curl -s http://localhost)"
done

echo "=== FIM ==="

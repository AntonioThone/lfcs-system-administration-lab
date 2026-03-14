## 4.1 Network Bonding

# Criar bond mode active-backup
sudo nmcli connection add type bond con-name bond0 ifname bond0 bond.options "mode=active-backup,miimon=100"

# Configurar DHCP
sudo nmcli connection mod bond0 ipv4.method auto

# Adicionar interface escrava
sudo nmcli connection add type ethernet slave-type bond con-name bond0-slave1 ifname ens160 master bond0

# Ativar bond
sudo nmcli connection up bond0
sudo nmcli connection down ens160

# Verificar
cat /proc/net/bonding/bond0

## 4.2 HAProxy Load Balancer

# Instalar HAProxy
sudo dnf install -y haproxy

# Configurar HAProxy
sudo tee /etc/haproxy/haproxy.cfg << 'EOF'
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
sudo systemctl enable --now haproxy

## 4.3 Containers Nginx

# Instalar Podman
sudo dnf install -y podman

# Criar containers
podman run -d --name web1 -p 8081:80 docker.io/nginx
podman run -d --name web2 -p 8082:80 docker.io/nginx

# Personalizar páginas
podman exec web1 sh -c 'echo "Server 1" > /usr/share/nginx/html/index.html'
podman exec web2 sh -c 'echo "Server 2" > /usr/share/nginx/html/index.html'

# Testar
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost  # Deve alternar entre Server 1 e Server 2

## 4.4 Firewall

# Liberar portas
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --permanent --add-port=8082/tcp
sudo firewall-cmd --reload

# Verificar
sudo firewall-cmd --list-all

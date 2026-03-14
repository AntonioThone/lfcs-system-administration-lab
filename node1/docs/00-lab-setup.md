# Configuração do Ambiente - Node 1 (RHEL 9)

## 1. Criar VM no VMware

| Configuração | Valor |
|--------------|-------|
| **Nome** | node1 |
| **SO** | RHEL 9 |
| **RAM** | 2 GB |
| **CPU** | 2 vCPUs |
| **Disco** | 20 GB |
| **Rede** | NAT + Host-only |

## 2. Instalação do RHEL 9

- Escolher "Minimal Install"
- Criar utilizador: `admin` com senha
- Configurar hostname: `node1.lfcs.lab`

## 3. Configurações Pós-Instalação

```bash
# Atualizar sistema
sudo dnf update -y

# Instalar ferramentas essenciais
sudo dnf install -y vim wget curl git net-tools bind-utils \
  bash-completion tree htop

# Configurar rede estática ou DHCP (opcional)
sudo nmcli connection mod ens160 ipv4.addresses 192.168.57.10/24
sudo nmcli connection mod ens160 ipv4.gateway 192.168.57.1
sudo nmcli connection mod ens160 ipv4.dns "8.8.8.8 1.1.1.1"
sudo nmcli connection mod ens160 ipv4.method manual
sudo nmcli connection up ens160

# Configurar hostname
sudo hostnamectl set-hostname node1.lfcs.lab
echo "192.168.57.10 node1.lfcs.lab node1" | sudo tee -a /etc/hosts

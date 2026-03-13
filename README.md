# 🏢 LFCS Complete System Administration Lab

![RHEL](https://img.shields.io/badge/RHEL-9-red?style=flat-square&logo=red-hat)
![Rocky](https://img.shields.io/badge/Rocky-9-blue?style=flat-square)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?style=flat-square&logo=ubuntu)
![AlmaLinux](https://img.shields.io/badge/AlmaLinux-9-green?style=flat-square)
![LFCS](https://img.shields.io/badge/Certification-LFCS-orange?style=flat-square)

## 📌 Sobre o Projeto

Este laboratório implementa uma **infraestrutura corporativa completa** com 4 máquinas virtuais, cobrindo **100% dos 5 domínios da certificação LFCS** (Linux Foundation Certified System Administrator).

### 🖥️ Arquitetura do Ambiente
┌─────────────────────────────────────────────────────────────────┐
│ VMware Workstation 17 Pro │
├─────────────────────────────────────────────────────────────────┤
│ │
│ ┌──────────────────────┐ ┌──────────────────────┐ │
│ │ NODE 1 (RHEL 9) │ │ NODE 2 (Rocky 9) │ │
│ │ Servidor Principal │ │ Servidor Secundário│ │
│ ├──────────────────────┤ ├──────────────────────┤ │
│ │ • Essential Commands │ │ • NFS Server │ │
│ │ • Users & Groups │ │ • MySQL Replica │ │
│ │ • Apache │ │ • DNS (BIND) │ │
│ │ • HAProxy + Containers│ │ • FTP (vsftpd) │ │
│ │ • LVM + Snapshots │ │ • SMTP (Postfix) │ │
│ └──────────────────────┘ └──────────────────────┘ │
│ ▲ ▲ │
│ │ │ │
│ └───────────┬───────────────┘ │
│ │ │
│ ┌──────────▼──────────┐ │
│ │ NODE 3 (Ubuntu) │ │
│ │ Container Host │ │
│ ├──────────────────────┤ │
│ │ • Podman/Docker │ │
│ │ • Systemd containers │ │
│ │ • KVM Virtualization │ │
│ └──────────────────────┘ │
│ │ │
│ ┌──────────▼──────────┐ │
│ │ CLIENT (AlmaLinux) │ │
│ │ Testes Integração │ │
│ └──────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘

text

## 📊 Domínios LFCS Cobertos

| Domínio | Peso | Implementação |
|---------|------|---------------|
| **Essential Commands** | 20% | Node 1 - Wildcards, find, git, SSL |
| **Users & Groups** | 10% | Node 1 - ACLs, sudo, LDAP client |
| **Operations & Deployment** | 25% | Node 1 - Kernel tuning, systemd, SELinux |
| **Networking** | 25% | Node 1 - Bonding, HAProxy, firewall |
| **Storage** | 20% | Node 1 - LVM thin, snapshots |

## 📁 Estrutura do Repositório
lfcs-complete-lab/
├── README.md # Visão geral
├── docs/ # Documentação por módulo
├── node1/ # Scripts/configs do RHEL 9
├── node2/ # Scripts/configs do Rocky 9
├── node3/ # Scripts/configs do Ubuntu
├── client/ # Scripts da VM cliente
├── container-exercises/ # Exercícios com containers
└── tests/ # Testes de validação

text

## 🚀 Progresso Atual

- [x] **Node 1 (RHEL 9)** - Completo (Domínios 1-5)
- [ ] **Node 2 (Rocky 9)** - Em desenvolvimento
- [ ] **Node 3 (Ubuntu 24.04)** - Pendente
- [ ] **Client (AlmaLinux 9)** - Pendente
- [ ] **Testes de Integração** - Pendente

## 👨‍💻 Autor

**António Thone**  
LFCS Certified | CCNA | Linux SysAdmin

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin)](https://linkedin.com/in/antónio-thone-6a761a255)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat-square&logo=github)](https://github.com/AntonioThone)

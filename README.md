#  LFCS Complete System Administration Lab

![RHEL](https://img.shields.io/badge/RHEL-9-red?style=flat-square&logo=red-hat)
![Rocky](https://img.shields.io/badge/Rocky-9-blue?style=flat-square)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?style=flat-square&logo=ubuntu)
![AlmaLinux](https://img.shields.io/badge/AlmaLinux-9-green?style=flat-square)
![LFCS](https://img.shields.io/badge/Certification-LFCS-orange?style=flat-square)

##  Sobre o Projeto

Este laboratório implementa uma **infraestrutura corporativa completa** com 4 máquinas virtuais, cobrindo **100% dos 5 domínios da certificação LFCS** (Linux Foundation Certified System Administrator).

###  Arquitetura do Ambiente


![[diagrama.png]]

## Domínios LFCS Cobertos

| Domínio | Peso | Implementação |
|---------|------|---------------|
| **Essential Commands** | 20% | Node 1 - Wildcards, find, git, SSL |
| **Users & Groups** | 10% | Node 1 - ACLs, sudo, LDAP client |
| **Operations & Deployment** | 25% | Node 1 - Kernel tuning, systemd, SELinux |
| **Networking** | 25% | Node 1 - Bonding, HAProxy, firewall |
| **Storage** | 20% | Node 1 - LVM thin, snapshots |

##  Estrutura do Repositório
lfcs-complete-lab/
├── README.md # Visão geral
├── docs/ # Documentação por módulo
├── node1/ # Scripts/configs do RHEL 9
├── node2/ # Scripts/configs do Rocky 9
├── node3/ # Scripts/configs do Ubuntu
├── client/ # Scripts da VM cliente
├── container-exercises/ # Exercícios com containers
└── tests/ # Testes de validação


## Progresso Atual

- [x] **Node 1 (RHEL 9)** - Completo (Domínios 1-5)
- [ ] **Node 2 (Rocky 9)** - Em desenvolvimento
- [ ] **Node 3 (Ubuntu 24.04)** - Pendente
- [ ] **Client (AlmaLinux 9)** - Pendente
- [ ] **Testes de Integração** - Pendente

## Autor

**António Thone** 
LFCS Certified Specialization (Pearson) | CCNA | Linux SysAdmin

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin)](https://linkedin.com/in/antónio-thone-6a761a255)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat-square&logo=github)](https://github.com/AntonioThone)
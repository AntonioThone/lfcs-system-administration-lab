# Node 1 — LFCS Lab como Ansible (v2)

**Estado: ✅ Provisionado e validado em hardware real** (RHEL 9.8, VMware Workstation 17 Pro, Ubuntu 24.04 como nó de controlo).

Reconstrução do Node 1 do `lfcs-system-administration-lab` como automação
idempotente, substituindo a sequência de comandos manuais documentados
no README original.

## O que muda da v1 (bash manual) para esta v2 (Ansible)

| Problema na v1 | Correção na v2 |
|---|---|
| Utilizador criado como `analista`, testado como `analyst` (bug real — o teste falhava) | Um único nome (`analyst`) usado em `group_vars/node1.yml`, propagado a todo o role |
| Webroot inconsistente: `/data/www` numa secção, `/var/www/company` noutra | Uma única variável `web_docroot`, usada em todas as tasks que tocam o webroot |
| Passwords em texto simples (`echo "deployer:Deploy123" \| chpasswd`) | Passwords vêm de `group_vars/node1_vault.yml` (cifrado com `ansible-vault`), aplicadas já em hash |
| Scripts bash corridos manualmente, sem garantia de poderem repetir sem erro | Tasks Ansible idempotentes — correr `ansible-playbook playbook.yml` 1x ou 10x dá o mesmo resultado |
| Testes ad-hoc em bash (`grep`, `ss`, `curl` em loop) | `tests/validate_node1.yml` — testes declarativos com `assert` |
| Bonding com 1 escravo (não demonstra failover) | `bond_slaves` com 2 NICs reais (`ens160` + `ens192`), failover testável |

## Bugs de código encontrados durante o primeiro deployment real

Nenhum destes apareceu no `--syntax-check` nem no `ansible-lint` (perfil
`production`, 0 falhas) — só se manifestaram a correr contra hardware real.
Documentados aqui de propósito: é a prova de que sintaxe válida não é o
mesmo que comportamento correto.

| Bug | Sintoma | Causa raiz | Correção |
|---|---|---|---|
| Vault nunca carregado | `No variable named 'vault_analyst_password' was found` | `group_vars/node1_vault.yml` não é carregado automaticamente só por estar ao lado de `node1.yml` — o auto-load do Ansible só funciona com ficheiro/pasta exatamente igual ao nome do grupo | `vars_files` explícito em `playbook.yml`: `- group_vars/node1_vault.yml` |
| `copy` falha no role `networking` | `Destination directory /srv/web1 does not exist` | O módulo `copy` não cria diretórios pai | Task extra com `ansible.builtin.file` (`state: directory`) antes do `copy` |
| Teste destrutivo corre sem ser pedido | As tasks `[Teste opcional]` do `storage` corriam mesmo só com `--tags storage` | Tags ao nível do *role* (`tags: [storage, domain5]`) propagam-se a **todas** as tasks dentro dele, mesmo às marcadas com `never` — a tag `storage` herdada anulava a proteção | Teste movido para `roles/storage/tasks/restore_test.yml`, importado fora do `roles:` via `import_tasks` na secção `tasks:` do playbook — só aí a tag `never` isola mesmo |
| `validate_node1.yml` falha a verificar o timer | `object of type 'dict' has no attribute 'clean-logs.timer'` | `ansible.builtin.service_facts` só regista unidades `.service`, nunca `.timer` | Verificação trocada para `systemctl is-active clean-logs.timer` via `command` (com `# noqa` justificado) |

## Problemas de ambiente resolvidos (fora do código Ansible)

Histórico real do que foi preciso corrigir na máquina anfitriã e na VM antes
do projeto conseguir correr — vale como diário de troubleshooting de
sysadmin, não só footnote:

| Problema | Diagnóstico | Correção |
|---|---|---|
| `vmware.service` falhava a arrancar | `vmnet0` (Bridged→Automatic) tentava bridge a uma interface Wi-Fi (não suporta); depois `vmnet1` com subnet em conflito | Removidas as redes virtuais não usadas (`vmnet0`, `vmnet1`) em `vmware-netcfg`, mantendo só `vmnet8` (NAT) |
| VM sem internet apesar do NAT activo | Faltava a regra `MASQUERADE` para `192.168.100.0/24` — o `vmnet-natd` não a criou automaticamente nesta combinação de versões | `iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o wlp2s0 -j MASQUERADE`, persistido com `iptables-persistent` |
| DNS não resolvia mesmo com internet a funcionar | A rede Wi-Fi bloqueia consultas DNS diretas a `8.8.8.8`/`1.1.1.1` | DNS apontado para o router real (`192.168.1.1`), propagado também ao `bond0` via `dns4` |
| `dnf install git` falhava | VM não registada na Red Hat (`subscription-manager`) | `subscription-manager register --auto-attach` (conta Developer, Simple Content Access) |
| `dnf install htop` falhava sempre | `htop` não existe em BaseOS/AppStream, só em EPEL | Task de instalação do `epel-release` adicionada ao role `essential_commands` |
| `password_hash` falhava no nó de controlo | `passlib` não instalado no Ubuntu (onde o Ansible corre, não na VM) | `sudo apt install python3-passlib` |
| `ansible-playbook` falhava a arrancar (callback) | `community.general.yaml` callback removido na v12+ da collection | `ansible.cfg`: `stdout_callback = default` + `result_format = yaml` |
| `/dev/sdb` não existia | Boot em NVMe (`nvme0n1`) → o único disco SATA fica `sda`, não `sdb` | `lvm_disk: /dev/sda` |
| Timezone errado (`America/New_York`, resíduo do instalador) | `timedatectl status` mostrava fuso dos EUA em vez de Angola | Inicialmente corrigido manualmente com `timedatectl set-timezone` — depois codificado como task (`ansible.builtin.timezone`, variável `node1_timezone`) para sobreviver a um rebuild |

## Estrutura

```
node1-ansible/
├── ansible.cfg
├── inventory.ini
├── playbook.yml
├── group_vars/
│   ├── node1.yml                  # variáveis não-sensíveis
│   └── node1_vault.yml.example    # estrutura do vault (NÃO usar tal como está)
├── roles/
│   ├── essential_commands/        # Domínio 1 — 20%
│   ├── users_groups/              # Domínio 2 — 10%
│   ├── operations_deployment/     # Domínio 3 — 25%
│   ├── networking/                # Domínio 4 — 25%
│   └── storage/                   # Domínio 5 — 20% (+ tasks/restore_test.yml, ver Passo 5)
└── tests/
    └── validate_node1.yml         # validação pós-provisionamento
```

## Pré-requisitos

Na máquina de controlo (Ubuntu 24.04 ou equivalente, não no Node 1):

```bash
sudo apt install -y ansible sshpass python3-passlib
ansible-galaxy collection install community.general ansible.posix containers.podman
```

No Node 1 (RHEL 9.8), antes de correr o playbook:
- Instalação mínima feita, registada na Red Hat (`subscription-manager register`)
- IP estático configurado, DNS funcional (confirma com `dig`/`nslookup` antes de avançar)
- Utilizador `admin` com acesso SSH por chave e sudo
- **Um segundo disco SATA de 5GB+** adicionado no VMware — fica `/dev/sda` se o boot for NVMe, `/dev/sdb` se o boot for também SATA. Confirma com `lsblk` e ajusta `lvm_disk` em `group_vars/node1.yml` em conformidade.
- **Uma segunda NIC** na mesma rede virtual da primeira (não em redes virtuais diferentes — bonding entre redes diferentes não dá failover real), para o bonding ter failover testável.

## Passo 1 — Criar o vault de passwords

```bash
cd node1-ansible
ansible-vault create group_vars/node1_vault.yml
```

Cola o conteúdo de `group_vars/node1_vault.yml.example`, substitui pelas tuas
passwords reais, grava.

## Passo 2 — Ajustar inventário e variáveis de rede

Edita `inventory.ini` (`ansible_host`) e, em `group_vars/node1.yml`:
`node1_ip`, `node1_gateway`, `node1_dns`, `bond_slaves`, `lvm_disk` — todos
têm de corresponder à tua VM real, confirmados via `ip a` / `ip route` /
`lsblk` dentro da VM antes de correr.

## Passo 3 — Provisionar

```bash
ansible-playbook playbook.yml --ask-vault-pass --ask-become-pass
```

Por domínio (útil durante desenvolvimento/debug):
```bash
ansible-playbook playbook.yml --ask-vault-pass --ask-become-pass --tags networking
```

## Passo 4 — Validar

```bash
ansible-playbook tests/validate_node1.yml --ask-vault-pass --ask-become-pass
```

Confirma: serviços ativos (incluindo o timer), utilizadores existem, HAProxy
alterna entre os dois containers (testado com 6 pedidos HTTP reais), volume
LVM montado, SELinux em modo Enforcing.

## Passo 5 (opcional, destrutivo) — Testar o restauro de snapshot

```bash
ansible-playbook playbook.yml --ask-vault-pass --ask-become-pass --tags storage_restore_test
```

Apaga `dados.txt` de propósito, depois reverte via `lvconvert --merge`. Só
corre com esta tag explícita — confirma com `--list-tasks --tags storage`
que isto **não** aparece nessa lista (é exatamente essa a proteção).

## Notas para o relatório/portfolio

- Este projeto demonstra a transição clássica sysadmin → DevOps: o mesmo
  trabalho técnico (LFCS), mas expresso como infraestrutura-como-código,
  com gestão de segredos e testes automatizados em vez de checklist manual.
- A tabela de "problemas de ambiente" acima é, por si só, material de
  entrevista: cada linha é uma história de diagnóstico real (logs lidos,
  hipóteses eliminadas por ordem, causa raiz isolada antes de corrigir) —
  não "copiei um comando do Stack Overflow e funcionou".
- `tests/validate_node1.yml` é o artefacto mais forte para mostrar a um
  recrutador: não é "correu sem erro", é "afirmo explicitamente o que tem
  de ser verdade, e o Ansible confirma ou falha com mensagem clara".
- Próximo passo: o mesmo padrão aplicado ao Node 2 (NFS, MySQL réplica,
  BIND, vsftpd, Postfix), com o Node 1 a ganhar o papel de MySQL *source*
  para a réplica deixar de estar pendurada.

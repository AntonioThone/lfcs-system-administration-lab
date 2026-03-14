## 1.1 Shell Wildcards Avançados


# Criar ficheiros de teste
cd ~
mkdir -p lfcs-lab/wildcard && cd lfcs-lab/wildcard
touch a.conf ab.conf abc.conf abcd.conf b.conf bc.conf c.conf
touch 1.txt 12.txt 123.txt 1234.txt
touch file1.log file2.log file10.log file100.log

# Wildcard: [a-b]??*.conf
ls [a-b]??*.conf
# Deve mostrar: abcd.conf

# Wildcard: [0-9][0-9][0-9].txt
ls [0-9][0-9][0-9].txt
# Deve mostrar: 123.txt

# Wildcard: file[1-9][0-9].log
ls file[1-9][0-9].log
# Deve mostrar: file10.log file100.log

1.2 Find com Exec

cd ~/lfcs-lab
mkdir -p backup

# Copiar todos os ficheiros .conf do /etc para backup
find /etc -name "*.conf" -type f 2>/dev/null -exec cp {} ~/lfcs-lab/backup/ \;

# Verificar
ls ~/lfcs-lab/backup/ | wc -l

1.3 Process Monitoring

# Top 5 processos por CPU
ps aux --sort=-%cpu | head -6

# Top 5 por memória
ps aux --sort=-%mem | head -6

# Monitorar processo específico
pgrep -l httpd

1.4 Git Workflow

cd ~/lfcs-lab
git config --global user.name "António Thone"
git config --global user.email "antoniothone6@gmail.com"

mkdir myproject && cd myproject
git init
echo "# Meu Projeto" > README.md
git add README.md
git commit -m "Initial commit"

git checkout -b feature/logrotate
echo "Configuração do logrotate" > logrotate.conf
git add logrotate.conf
git commit -m "Add logrotate config"

git checkout main
git merge --ff-only feature/logrotate

1.5 SSL Certificates

# Gerar chave e CSR
openssl req -new -newkey rsa:2048 -nodes \
  -keyout server.key -out server.csr \
  -subj "/C=AO/ST=Luanda/L=Luanda/O=LFCS Lab/CN=node1.lfcs.lab"

# Auto-assinar
openssl x509 -req -days 365 -in server.csr \
  -signkey server.key -out server.crt

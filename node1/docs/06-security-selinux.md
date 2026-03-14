## 6.1 Verificar SELinux


# Verificar modo atual
getenforce
# Deve mostrar: Enforcing

# Verificar contexto de ficheiros
ls -Z /etc/passwd

## 6.2 Ajustar Contextos

# Ver contexto do diretório web
ls -Z /var/www/company

# Ajustar contexto para novo diretório
sudo semanage fcontext -a -t httpd_sys_content_t "/data/www(/.*)?"
sudo restorecon -Rv /data/www

# Verificar
ls -Z /data/www

## 6.3 Analisar Bloqueios SELinux

# Verificar denies recentes
sudo ausearch -m avc -ts recent

# Para HAProxy e containers
sudo ausearch -m avc -ts recent | grep haproxy

# Criar política personalizada (se necessário)
sudo ausearch -m avc -ts recent | audit2allow -M mypol
sudo semodule -i mypol.pp

## 6.4 Configurar Booleanos

# Ver booleanos relacionados ao HTTP
sudo getsebool -a | grep http

# Permitir HAProxy conectar a qualquer porta
sudo setsebool -P haproxy_connect_any 1

## 6.5 Registar Portas no SELinux

# Registrar portas dos containers
sudo semanage port -a -t http_port_t -p tcp 8081
sudo semanage port -a -t http_port_t -p tcp 8082

# Listar portas registadas
sudo semanage port -l | grep http_port_t

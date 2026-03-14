## 2.1 Criar Utilizadores


# Criar utilizadores
sudo useradd -m -s /bin/bash analista
sudo useradd -m qa
sudo useradd -m -G wheel deployer

# Definir senhas
echo "analyst:TempPass123" | sudo chpasswd
sudo passwd -e analyst  # Expirar password
echo "qa:QaPass123" | sudo chpasswd
echo "deployer:Deploy123" | sudo chpasswd

## 2.2 Password Policies

# Editar /etc/login.defs
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs

# Verificar
sudo chage -l analyst

## 2.3 ACLs (Access Control Lists)

# Preparar ambiente
sudo mkdir -p /srv/app
echo "database_password: secret" | sudo tee /srv/app/config.yml

# Dar acesso read-only ao utilizador qa
sudo setfacl -m u:qa:r /srv/app/config.yml

# Verificar
getfacl /srv/app/config.yml

# Testar
sudo -u qa cat /srv/app/config.yml  # deve funcionar
sudo -u qa echo "teste" >> /srv/app/config.yml  #  deve falhar

## 2.4 Sudo Rules

# Permitir que deployer reinicie httpd sem password
echo "deployer ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart httpd" | \
  sudo tee /etc/sudoers.d/deployer-httpd

# Verificar
sudo -l -U deployer

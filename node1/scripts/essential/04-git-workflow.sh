#!/bin/bash
# Git Workflow

echo "=== GIT WORKFLOW ==="

cd ~/lfcs-lab
mkdir -p git-project
cd git-project

echo "1. Inicializando repositório..."
git init

echo "2. Configurando identidade..."
git config user.name "António Thone"
git config user.email "antoniothone6@gmail.com"

echo "3. Criando primeiro commit..."
echo "# Git Project" > README.md
git add README.md
git commit -m "Initial commit"

echo "4. Criando branch feature..."
git checkout -b feature/script

echo "5. Adicionando script..."
echo "#!/bin/bash" > script.sh
echo 'echo "Hello from feature branch"' >> script.sh
chmod +x script.sh
git add script.sh
git commit -m "Add script.sh"

echo "6. Voltando à main..."
git checkout main

echo "7. Fazendo merge..."
git merge --ff-only feature/script

echo "8. Histórico:"
git log --oneline --graph

echo "=== FIM ==="

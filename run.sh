#!/bin/bash

# Script de execução segura do playbook Ansible
set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== WordPress + MySQL Ansible Provisioning ===${NC}\n"

# 1. Verificar dependências
echo -e "${YELLOW}[1/5] Validando dependências...${NC}"
if ! command -v ansible &> /dev/null; then
    echo -e "${RED}❌ Ansible não está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Ansible encontrado$(ansible --version | head -n1)${NC}\n"

# 2. Validar sintaxe do playbook
echo -e "${YELLOW}[2/5] Validando sintaxe do playbook...${NC}"
if ! ansible-playbook --syntax-check provisioning.yml &> /dev/null; then
    echo -e "${RED}❌ Erro de sintaxe no playbook${NC}"
    ansible-playbook --syntax-check provisioning.yml
    exit 1
fi
echo -e "${GREEN}✓ Sintaxe do playbook válida${NC}\n"

# 3. Validar arquivos requeridos
echo -e "${YELLOW}[3/5] Verificando arquivos requeridos...${NC}"
REQUIRED_FILES=("hosts" "provisioning.yml" "vars.yml" "templates/wordpress.conf.j2" "requirements.yml" "ansible.cfg")
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Arquivo não encontrado: $file${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✓ Todos os arquivos necessários encontrados${NC}\n"

# 4. Validar conectividade
echo -e "${YELLOW}[4/5] Testando conectividade com hosts...${NC}"
if ansible all -i hosts -m ping 2>&1 | grep -q "FAILED\|unreachable"; then
    echo -e "${YELLOW}⚠ Aviso: Alguns hosts podem estar inacessíveis${NC}"
    echo -e "${YELLOW}Deseja continuar? (s/n)${NC}"
    read -r response
    if [ "$response" != "s" ]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ Conectividade validada${NC}\n"
fi

# 5. Instalar dependências Galaxy
echo -e "${YELLOW}[5/5] Instalando dependências do Galaxy...${NC}"
if ! ansible-galaxy install -r requirements.yml --quiet 2>/dev/null; then
    echo -e "${YELLOW}⚠ Aviso: Falha ao instalar dependências Galaxy${NC}"
fi
echo -e "${GREEN}✓ Dependências processadas${NC}\n"

# Executar playbook
echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Iniciando provisioning...${NC}"
echo -e "${YELLOW}========================================${NC}\n"

ansible-playbook -i hosts provisioning.yml -v

echo -e "\n${GREEN}✓ Provisioning completado com sucesso!${NC}"

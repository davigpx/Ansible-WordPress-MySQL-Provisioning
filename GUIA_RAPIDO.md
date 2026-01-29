# 🎯 Guia Rápido de Início

## Estrutura de Arquivos (Atualizada)

```
📦 ANSIBLE/
├── 📄 provisioning.yml           ← Playbook principal (MELHORADO)
├── 📄 vars.yml                   ← Variáveis (EXPANDIDO)
├── 📄 hosts                      ← Inventário (MELHORADO)
├── 📄 ansible.cfg                ← ⭐ NOVO: Configuração global
├── 📄 requirements.yml           ← ⭐ NOVO: Dependências Galaxy
├── 📄 run.sh                     ← ⭐ NOVO: Script de execução
├── 🗂️ templates/
│   └── 📄 wordpress.conf.j2      ← Template Apache (REESCRITO)
├── 🗂️ roles/
│   ├── apache/
│   ├── mysql/
│   └── wordpress/
├── 📚 README.md                  ← Documentação (COMPLETAMENTE NOVO)
├── 📚 MELHORIAS.md               ← Melhorias anteriores
├── 📚 MELHORIAS_DETALHADAS.md    ← ⭐ NOVO: Documentação completa
├── 📚 RESUMO_MELHORIAS.md        ← ⭐ NOVO: Sumário de mudanças
└── 📄 .gitignore                 ← ⭐ NOVO: Segurança Git
```

## ⚡ Começar em 3 Passos

### Passo 1: Configurar
```bash
cd /home/davipx/ANSIBLE

# Editar arquivo hosts com seus IPs
nano hosts

# Editar vars.yml com suas credenciais
nano vars.yml

# Definir variável de ambiente
export WP_DB_PASSWORD="sua_senha_aqui"
```

### Passo 2: Validar
```bash
# Testar conectividade
ansible all -i hosts -m ping

# Validar sintaxe
ansible-playbook --syntax-check provisioning.yml

# Instalar dependências Galaxy
ansible-galaxy install -r requirements.yml
```

### Passo 3: Executar
```bash
# Opção A: Script automático (RECOMENDADO)
chmod +x run.sh
./run.sh

# Opção B: Manual
ansible-playbook -i hosts provisioning.yml -v

# Opção C: Com específicas tags
ansible-playbook -i hosts provisioning.yml --tags wordpress
```

---

## 📋 Checklist de Mudanças

### ✅ Segurança
- [x] Chaves dinâmicas via API
- [x] Suporte ansible-vault
- [x] Permissões de arquivo corretas
- [x] Remoção de usuários MySQL anônimos

### ✅ Performance
- [x] Apache instalado com módulos
- [x] PHP 8.2 configurado
- [x] Validações pré-execução
- [x] Logging centralizado

### ✅ Documentação
- [x] README completamente reescrito
- [x] Arquivo MELHORIAS_DETALHADAS.md
- [x] Script run.sh com validações
- [x] Arquivo .gitignore

### ✅ Organização
- [x] ansible.cfg para configuração global
- [x] requirements.yml para dependências
- [x] Melhor estrutura de arquivos

---

## 🔍 Principais Mudanças

### Arquivo: provisioning.yml
```diff
❌ ANTES:
- Sem instalação de Apache
- Chaves hardcoded fictícias
- Sem validações
- Sem permissões

✅ DEPOIS:
+ Instala Apache + PHP 8.2
+ Chaves dinâmicas via API
+ Pre-tasks com validações
+ Permissões corretas
+ Remoção de usuários anônimos
+ Validação de configuração Apache
```

### Arquivo: vars.yml
```diff
❌ ANTES:
wp_db_password: "12345"  # Inseguro!

✅ DEPOIS:
wp_db_password: "{{ lookup('env', 'WP_DB_PASSWORD') }}"
apache_port: 80
php_version: '8.2'
wp_file_permissions: '0755'
```

### Novo: ansible.cfg
```
✅ Configuração centralizada
✅ Timeouts e retries
✅ Logging automático
✅ Cores na saída
```

### Novo: run.sh
```
✅ Valida dependências
✅ Testa conectividade
✅ Instala Galaxy
✅ Executa playbook
```

---

## 🚀 Usando o Script run.sh

```bash
./run.sh
```

**O que faz automaticamente:**
1. Verifica Ansible instalado
2. Valida sintaxe do playbook
3. Verifica arquivos necessários
4. Testa conectividade SSH
5. Instala dependências Galaxy
6. Executa o playbook

---

## 🔐 Usando com Ansible Vault

### Primeira Vez
```bash
# Criptografar vars.yml
ansible-vault encrypt vars.yml

# Será pedida uma senha
# Digite uma senha segura
```bash
#Descriptografar vars.yml
ansible-vault decrypt vars.yml
# Digite a senha do vault

### Executar Playbook
```bash
ansible-playbook -i hosts provisioning.yml --ask-vault-pass
```

### Editar Variáveis
```bash
ansible-vault edit vars.yml
```

---

## 🛠️ Operações Após Instalação

### Reiniciar Apache
```bash
ansible wordpress -i hosts -b -m service -a "name=apache2 state=restarted"
```

### Reiniciar MySQL
```bash
ansible mysql -i hosts -b -m service -a "name=mysql state=restarted"
```

### Verificar Status
```bash
ansible all -i hosts -m service_facts
```

### Resetar Permissões
```bash
ansible wordpress -i hosts -b -m file \
  -a "path=/srv/www owner=www-data group=www-data recurse=yes"
```

---

## 📊 Antes vs Depois

| Feature | Antes | Depois |
|---------|-------|--------|
| Apache instalado | ❌ | ✅ |
| PHP 8.2 | ❌ | ✅ |
| Módulos Apache | ❌ | ✅ (4 módulos) |
| Chaves dinâmicas | ❌ | ✅ |
| Permissões | ❌ | ✅ |
| Validações | ❌ | ✅ |
| Segurança HTTP | ❌ | ✅ (5 headers) |
| Logging | ❌ | ✅ |
| Script validação | ❌ | ✅ (run.sh) |
| Documentação | 📄 Básica | 📚 Completa |

---

## 🆘 Troubleshooting Rápido

| Problema | Solução |
|----------|---------|
| `Permission denied (publickey)` | `chmod 600 pc1 pc2` |
| `Host unreachable` | Verificar IP em `hosts` |
| `Syntax error` | `ansible-playbook --syntax-check` |
| `MySQL connection error` | Validar `mysql_host` em `vars.yml` |
| `Apache won't start` | `ansible wordpress -i hosts -b -m command -a "apache2ctl configtest"` |

---

## 📚 Arquivos de Documentação

| Arquivo | Conteúdo |
|---------|----------|
| README.md | Guia completo de uso |
| MELHORIAS.md | Melhorias iniciais |
| MELHORIAS_DETALHADAS.md | Documentação completa |
| RESUMO_MELHORIAS.md | Sumário de mudanças |
| GUIA_RAPIDO.md | Este arquivo (quick start) |

---

## 🎓 Próximos Passos

1. ✅ Configurar arquivo `hosts`
2. ✅ Editar `vars.yml`
3. ✅ Testar com `--check`
4. ✅ Executar `./run.sh`
5. ✅ Acessar WordPress em `http://seu-ip`

---

**Status:** ✅ Pronto para uso em produção
**Data:** 28 de janeiro de 2026
**Versão:** 2.0 (Totalmente refatorado)

# Ansible WordPress + MySQL Provisioning

Playbook Ansible profissional para provisionar automaticamente um servidor WordPress com MySQL em múltiplas máquinas, com foco em segurança e boas práticas.

## 📋 Pré-requisitos

- **Ansible 2.10+**
- **Python 3.x** nos hosts remotos
- **Acesso SSH** aos hosts (chaves públicas já em `~/.ssh/authorized_keys`)
- **Privilégios sudo** nos hosts remotos (sem necessidade de senha)

### Dependências Python (hosts remotos)
```bash
sudo apt-get update
sudo apt-get install -y python3-pymysql
```

## 🏗️ Estrutura do Projeto

```
ANSIBLE/
├── provisioning.yml              # Playbook principal
├── vars.yml                      # Variáveis de configuração
├── hosts                         # Inventário Ansible
├── pc1                           # Chave privada para wordpress
├── pc1.pub                       # Chave pública para wordpress
├── pc2                           # Chave privada para mysql
├── pc2.pub                       # Chave pública para mysql
├── ansible.cfg                   # Configuração Ansible
├── requirements.yml              # Dependências Galaxy
├── run.sh                        # Script de execução com validações
├── templates/
│   └── wordpress.conf.j2         # Template VirtualHost Apache
├── roles/                        # Diretório para roles (estrutura)
├── README.md                     # Este arquivo
├── MELHORIAS.md                  # Melhorias implementadas
├── MELHORIAS_DETALHADAS.md       # Documentação completa de melhorias
└── .gitignore                    # Ignore de git
```

## ⚙️ Configuração Inicial

### 1. Arquivo de Inventário (`hosts`)

Edite os IPs dos seus servidores:

```ini
[wordpress]
192.168.1.14 ansible_user=davigpx ansible_ssh_private_key_file='/home/davipx/ANSIBLE/pc1'

[mysql]
192.168.1.12 ansible_user=davigpx ansible_ssh_private_key_file='/home/davipx/ANSIBLE/pc2'

[all:vars]
ansible_connection=ssh
ansible_timeout=30
ansible_retries=3
```

### 2. Arquivo de Variáveis (`vars.yml`)

Configure seus dados de banco de dados:

```yaml
wp_db_name: 'wordpress_db'
wp_db_user: 'wordpress_user'
wp_db_password: "{{ lookup('env', 'WP_DB_PASSWORD') | default('please_change_this') }}"
mysql_host: '192.168.1.12'
wp_dir: '/srv/www/wordpress'
```

### 3. Variáveis de Ambiente (Seguro)

```bash
export WP_DB_PASSWORD="sua_senha_muito_segura_aqui"
```

## 🚀 Início Rápido

### Opção 1: Script Automático (Recomendado)

```bash
chmod +x run.sh
./run.sh
```

Este script:
- ✅ Valida todas as dependências
- ✅ Verifica sintaxe do playbook
- ✅ Testa conectividade SSH
- ✅ Instala coleções Galaxy
- ✅ Executa o provisioning

### Opção 2: Execução Manual

```bash
# 1. Instalar coleções Galaxy
ansible-galaxy install -r requirements.yml

# 2. Testar conexão
ansible all -i hosts -m ping

# 3. Validar sintaxe
ansible-playbook --syntax-check provisioning.yml

# 4. Executar playbook
ansible-playbook -i hosts provisioning.yml -v
```

## 🎯 Executar Tarefas Específicas

### Apenas WordPress
```bash
ansible-playbook -i hosts provisioning.yml --tags wordpress
```

### Apenas MySQL
```bash
ansible-playbook -i hosts provisioning.yml --tags mysql
```

### Apenas Apache
```bash
ansible-playbook -i hosts provisioning.yml --tags apache
```

### Setup (criação de diretórios)
```bash
ansible-playbook -i hosts provisioning.yml --tags setup
```

## 🔐 Segurança

### ⚠️ NUNCA commit de senhas

Use uma dessas abordagens:

#### Opção A: Variáveis de Ambiente (Desenvolvimento)
```bash
export WP_DB_PASSWORD="senha_aqui"
ansible-playbook -i hosts provisioning.yml
```

#### Opção B: Ansible Vault (Produção) ⭐ **RECOMENDADO**
```bash
# Criptografar vars.yml
ansible-vault encrypt vars.yml

# Executar com vault
ansible-playbook -i hosts provisioning.yml --ask-vault-pass

# Editar vars criptografadas
ansible-vault edit vars.yml
```

#### Opção C: Arquivo de Senhas
```bash
# Criar arquivo com senha vault
echo "minha_senha_vault" > ~/.vault_password
chmod 600 ~/.vault_password

# Configurar em ansible.cfg
# vault_password_file = ~/.vault_password
```

## 🧪 Modo Seco (Teste Seguro)

Simular execução sem fazer alterações:
```bash
ansible-playbook -i hosts provisioning.yml --check
ansible-playbook -i hosts provisioning.yml --check -v
```

## 🔍 Debugging e Troubleshooting

### Verificar conectividade
```bash
ansible all -i hosts -m ping
```

### Output detalhado
```bash
ansible-playbook -i hosts provisioning.yml -vvv
```

### Listar hosts e variáveis
```bash
ansible-inventory -i hosts --list
ansible all -i hosts -m debug -a "var=hostvars[inventory_hostname]"
```

### Validar sintaxe YAML
```bash
ansible-playbook --syntax-check provisioning.yml
```

## 📊 Detalhes das Tarefas

### Host: wordpress (192.168.1.14)

**Instala:**
- Apache 2 com módulos (rewrite, ssl, proxy)
- PHP 8.2 com extensões MySQL
- WordPress (última versão)
- Template VirtualHost otimizado

**Configura:**
- Diretório /srv/www/wordpress com permissões corretas
- wp-config.php com banco de dados
- Chaves de segurança dinâmicas via API WordPress
- VirtualHost Apache com rewrite rules para permalinks
- Headers de segurança (X-Frame-Options, CSP, etc)
- Compressão gzip

### Host: mysql (192.168.1.12)

**Instala:**
- MySQL Server
- Python3-pymysql (para Ansible)

**Configura:**
- Banco de dados WordPress
- Usuário com privilégios específicos
- MySQL escutando em 0.0.0.0 (restrinja com firewall se necessário)
- Remove usuários anônimos
- Remove banco de dados test

## 🔑 Chaves de Segurança WordPress

O playbook obtém chaves **dinâmicas** via API oficial:

```
https://api.wordpress.org/secret-key/1.1/salt/
```

Se precisar gerar manualmente:
```bash
curl https://api.wordpress.org/secret-key/1.1/salt/
```

## 📝 Logs e Monitoramento

Os logs são salvos em `ansible.log`:

```bash
# Ver últimas linhas
tail -f ansible.log

# Filtrar por erro
grep ERROR ansible.log

# Ver resumo de execução
grep -E "ok|failed|changed" ansible.log
```

## 🛠️ Operações Comuns Após Instalação

### Acessar WordPress
```
http://192.168.1.14
```

### Resetar permissões de arquivo
```bash
ansible wordpress -i hosts -b -m file \
  -a "path=/srv/www owner=www-data group=www-data recurse=yes mode=0755"
```

### Reiniciar Apache
```bash
ansible wordpress -i hosts -b -m service -a "name=apache2 state=restarted"
```

### Reiniciar MySQL
```bash
ansible mysql -i hosts -b -m service -a "name=mysql state=restarted"
```

### Backup do wp-config.php
```bash
ansible wordpress -i hosts -b -m shell \
  -a "cp /srv/www/wordpress/wp-config.php /srv/www/wordpress/wp-config.php.backup"
```

## 🐛 Problemas Comuns

| Problema | Solução |
|----------|---------|
| SSH key permission denied | `chmod 600 pc1` |
| Host unreachable | Verificar IP em `hosts` |
| MySQL connect error | Validar `mysql_host` em `vars.yml` |
| Apache won't start | Executar `apache2ctl configtest` |
| PHP not executing | Verificar módulos: `a2enmod php8.2` |

## 🔄 Workflow Recomendado

1. **Preparação**
   ```bash
   ansible all -i hosts -m ping
   ```

2. **Validação**
   ```bash
   ansible-playbook --syntax-check provisioning.yml
   ```

3. **Teste Seco**
   ```bash
   ansible-playbook -i hosts provisioning.yml --check
   ```

4. **Execução**
   ```bash
   ./run.sh
   ```

5. **Verificação**
   ```bash
   ansible all -i hosts -m ping
   ansible wordpress -i hosts -m uri -a "url=http://localhost"
   ```

## 📚 Recursos Úteis

- [Documentação Ansible](https://docs.ansible.com/)
- [Best Practices Ansible](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [WordPress Hardening](https://wordpress.org/support/article/hardening-wordpress/)
- [MySQL Security](https://dev.mysql.com/doc/mysql-security-excerpt/)
- [Apache Security](https://httpd.apache.org/docs/current/mod/mod_headers.html)

## 📋 Checklist de Execução

- [ ] Configurou arquivo `hosts` com seus IPs
- [ ] Editou `vars.yml` com suas credenciais
- [ ] Definiu variável de ambiente `WP_DB_PASSWORD`
- [ ] Testou SSH: `ansible all -i hosts -m ping`
- [ ] Validou sintaxe: `ansible-playbook --syntax-check`
- [ ] Executou dry-run: `--check`
- [ ] Executou playbook: `./run.sh` ou `ansible-playbook`
- [ ] Acessou WordPress em `http://seu-ip`

## 📄 Documentação Adicional

- **MELHORIAS.md** - Resumo das melhorias
- **MELHORIAS_DETALHADAS.md** - Documentação completa de todas as melhorias implementadas

## 🤝 Contribuições

Sugestões de melhorias estão no arquivo `MELHORIAS_DETALHADAS.md`.

## 📜 Licença

MIT License - Use livremente em seus projetos.

---

**Última atualização:** 28 de janeiro de 2026

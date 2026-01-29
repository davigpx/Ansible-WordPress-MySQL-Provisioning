# Ansible WordPress + MySQL Provisioning

Playbook Ansible para provisionar automaticamente um servidor WordPress com MySQL em múltiplas máquinas.

## 📋 Pré-requisitos

- Ansible 2.10+
- Python 3.x nos hosts remotos
- Acesso SSH aos hosts
- Privilégios sudo nos hosts remotos

### Dependências Python (hosts remotos)
```bash
sudo apt-get update
sudo apt-get install -y python3-pymysql
```

## 🏗️ Estrutura do Projeto

```
ANSIBLE/
├── provisioning.yml       # Playbook principal
├── vars.yml              # Variáveis de configuração
├── hosts                 # Chave privada para pc1
├── pc1                   # Chave privada para pc1
├── pc1.pub               # Chave pública para pc1
├── pc2                   # Chave privada para pc2
├── pc2.pub               # Chave pública para pc2
├── files/
│   └── wordpress.conf    # Configuração Apache para WordPress
├── README.md             # Este arquivo
└── MELHORIAS.md          # Documentação de melhorias
```

## ⚙️ Configuração

### 1. Arquivo de Inventário (`hosts`)

Edite o arquivo `hosts` para definir seus servidores:

```ini
[wordpress]
pc1 ansible_host=192.168.1.10 ansible_user=ubuntu

[mysql]
pc2 ansible_host=192.168.1.12 ansible_user=ubuntu
```

### 2. Variáveis (`vars.yml`)

Configure as variáveis de banco de dados:

```yaml
wp_db_name: wordpress_db
wp_db_user: wordpress_user
wp_db_password: "sua_senha_segura"
mysql_host: 192.168.1.12
```

### 3. Arquivo Apache (`files/wordpress.conf`)

Configure o VirtualHost do Apache conforme necessário para seu ambiente.

## 🚀 Como Usar

### Execução Básica

```bash
ansible-playbook -i hosts provisioning.yml
```

### Com Arquivo de Variáveis Customizado

```bash
ansible-playbook -i hosts provisioning.yml -e @vars.yml
```

### Execução de Tags Específicas

Executar apenas tarefas do WordPress:
```bash
ansible-playbook -i hosts provisioning.yml --tags wordpress
```

Executar apenas tarefas do MySQL:
```bash
ansible-playbook -i hosts provisioning.yml --tags mysql
```

Executar apenas setup (criação de diretórios):
```bash
ansible-playbook -i hosts provisioning.yml --tags setup
```

Executar apenas Apache:
```bash
ansible-playbook -i hosts provisioning.yml --tags apache
```

### Modo Seco (Dry-run)

Simular execução sem fazer alterações:
```bash
ansible-playbook -i hosts provisioning.yml --check
```

### Modo Verbose

Exibir detalhes da execução:
```bash
ansible-playbook -i hosts provisioning.yml -v
```

## 🔒 Segurança

### Usando Variáveis de Ambiente

```bash
export WP_DB_PASSWORD="sua_senha_forte"
ansible-playbook -i hosts provisioning.yml
```

### Usando Ansible Vault (Recomendado para Produção)

Criptografar arquivo de variáveis:
```bash
ansible-vault encrypt vars.yml
```

Executar playbook com vault:
```bash
ansible-playbook -i hosts provisioning.yml --ask-vault-pass
```

Editar variáveis criptografadas:
```bash
ansible-vault edit vars.yml
```

## 📊 Estrutura do Playbook

### Host: wordpress
Instala e configura:
- Apache2
- WordPress (última versão)
- Arquivo de configuração wp-config.php
- Chaves de segurança do WordPress

**Tags**: `setup`, `wordpress`, `apache`

### Host: mysql
Instala e configura:
- MySQL Server
- Python3-pymysql
- Banco de dados WordPress
- Usuário de banco de dados
- Acesso remoto (0.0.0.0)

**Tags**: `mysql`

## 🔄 Workflow Típico

1. Configure o arquivo `hosts` com seus servidores
2. Edite `vars.yml` com suas credenciais
3. Valide a conectividade SSH
4. Execute em modo dry-run: `--check`
5. Execute o playbook completo
6. Verifique a instalação

## 🐛 Troubleshooting

### Erro de conectividade SSH
```bash
ansible all -i hosts -m ping
```

### Verificar variáveis
```bash
ansible-playbook -i hosts provisioning.yml -e @vars.yml --check
```

### Ver output detalhado
```bash
ansible-playbook -i hosts provisioning.yml -vvv
```

### Resetar permissões de arquivo
```bash
ansible wordpress -i hosts -b -m file -a "path=/srv/www owner=www-data group=www-data recurse=yes"
```

## 📝 Notas Importantes

- As chaves de segurança do WordPress estão hardcoded no playbook
- Altere-as por chaves únicas: https://api.wordpress.org/secret-key/1.1/salt/
- O arquivo `wp-config.php` terá modo 0640 por questões de segurança
- MySQL escuta em 0.0.0.0 - restrinja conforme necessário
- Use firewall para controlar acesso entre os hosts

## 🔑 Chaves e Senhas

### Gerar Novas Chaves de Segurança WordPress

```bash
curl https://api.wordpress.org/secret-key/1.1/salt/
```

Copie a saída e atualize as linhas de chave no playbook.

## 📚 Referências

- [Documentação Ansible](https://docs.ansible.com/)
- [Documentação WordPress](https://wordpress.org/documentation/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Apache Documentation](https://httpd.apache.org/docs/)

## 🤝 Contribuição

Para melhorias ou correções, verifique o arquivo `MELHORIAS.md`.

## 📄 Licença

Este projeto está disponível sob a licença MIT.

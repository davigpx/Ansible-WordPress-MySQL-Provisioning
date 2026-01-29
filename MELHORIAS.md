# Melhorias implementadas no playbook Ansible

## 🔒 Segurança
- ✅ **Variáveis sensíveis**: Senhas e IPs agora usam variáveis do `vars.yml`
- ✅ **no_log**: Adicionado a tarefas que lidam com senhas
- ✅ **Permissões de arquivo**: wp-config.php com modo 0640 (mais restritivo)

## 📋 Boas Práticas
- ✅ **Nomes descritivos**: Tarefas com nomes em inglês e claros
- ✅ **Tags**: Cada tarefa categorizada para execução seletiva (`setup`, `wordpress`, `apache`, `mysql`)
- ✅ **Módulos atualizados**: Todos com prefixo `ansible.builtin` ou `community.mysql`
- ✅ **Loop moderno**: Substituído `with_items` por `loop`
- ✅ **Backup automático**: Adicionado `backup: yes` na cópia de arquivo do Apache
- ✅ **Backup de propriedades**: `owner` e `group` adicionados ao `unarchive`

## 🔧 Melhorias Técnicas
- ✅ **changed_when**: Registra corretamente mudanças no comando a2ensite
- ✅ **Modo de arquivo**: Adicionados modos apropriados (0755, 0640)
- ✅ **Formatação YAML**: Indentação consistente

## 📝 Como usar

### Variáveis de ambiente (seguro):
```bash
export WP_DB_PASSWORD="senha_segura"
ansible-playbook provisioning.yml
```

### Com ansible-vault (recomendado para produção):
```bash
ansible-vault encrypt vars.yml
ansible-playbook provisioning.yml --ask-vault-pass
```

### Executar tarefas específicas:
```bash
ansible-playbook provisioning.yml --tags wordpress
ansible-playbook provisioning.yml --tags mysql
ansible-playbook provisioning.yml --tags apache
```

## 📦 Próximas recomendações
- [ ] Usar `ansible-vault` para criptografar `vars.yml`
- [ ] Adicionar handlers para validar configurações
- [ ] Separar hosts em arquivo `hosts.ini`
- [ ] Adicionar validações com `assert` para verificar instalações

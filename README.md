# Rclone-AIO
This Repository contains a shell script that executes various functions using the Rclone tool 

```markdown
# Rclone AIO Script

Este é um script bash para facilitar o uso de comandos rclone com várias opções e funcionalidades adicionais. Ele suporta copiar, sincronizar, mover, deletar arquivos, remover diretórios vazios e limpar o controle remoto. O script também oferece suporte para adicionar filtros e flags adicionais do rclone.

## Requisitos

- [Rclone](https://rclone.org/)
- OpenSSL

## Instalação

1. Clone o repositório ou faça o download do script.
2. Assegure-se de que o script tem permissão de execução:
    ```bash
    chmod +x script.sh
    ```
3. Configure a variável `RCLONE_CONFIG_PASS` conforme necessário para sua instalação do rclone.

## Uso

```bash
./script.sh [opções] origem destino [ -e flags_do_rclone]
```

### Opções

- `-c (Copy)`: Copie arquivos da origem para o destino, ignorando arquivos idênticos.
- `-s (Sync)`: Torne a origem e o destino idênticos, modificando apenas o destino.
- `-m (Move)`: Mova arquivos da origem para o destino.
- `-d (Delete)`: Remova os arquivos no caminho.
- `-r (Remove Dirs)`: Remova os diretórios vazios no caminho.
- `-C (Cleanup)`: Limpe o controle remoto, se possível. Esvazie a lixeira ou exclua versões antigas de arquivos (não suportado por todos os controles remotos).
- `-n (Dry Run)`: Adiciona a flag `--dry-run` ao rclone.
- `-f arquivo`: Adiciona a flag `--filter-from` com o arquivo especificado ao rclone.
- `-e`: Adiciona flags extras ao comando rclone.

### Exemplos

#### Copiar arquivos

```bash
./script.sh -c origem:/caminho origem:/pasta destino:/pasta
```

#### Sincronizar pastas

```bash
./script.sh -s origem:/pasta destino:/pasta
```

#### Mover arquivos

```bash
./script.sh -m origem:/pasta destino:/pasta
```

#### Deletar arquivos

```bash
./script.sh -d destino:/pasta/arquivo
```

#### Remover diretórios vazios

```bash
./script.sh -r destino:/pasta
```

#### Limpar o controle remoto

```bash
./script.sh -C destino:/
```

#### Copiar arquivos com filtro

```bash
./script.sh -c origem:/pasta destino:/pasta -f caminho/para/filtro.lst
```

#### Sincronizar com flags adicionais

```bash
./script.sh -s origem:/pasta destino:/pasta -e --max-age=7d
```

## Logs

O script cria um arquivo de log para registrar as saídas dos comandos em `/var/log/Rclone/Rclone-AIO-$(date +%Y%m%d).log`.

## Contribuição

Sinta-se à vontade para contribuir enviando issues e pull requests. Todas as contribuições são bem-vindas!

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
```

### Sugestões Adicionais

- Substitua o placeholder `script.sh` pelo nome real do seu script.
- Certifique-se de que o caminho para o arquivo de log seja acessível e tenha permissões corretas.
- Adicione qualquer outra informação que considere relevante, como dependências específicas, notas de versão, ou autores.

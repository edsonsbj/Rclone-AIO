# Rclone AIO Script

This is a bash script to facilitate the use of rclone commands with various options and additional features. It supports copying, synchronizing, moving, deleting files, removing empty directories and wiping the remote. The script also supports adding additional rclone filters and flags.

## Requisitos

- [Rclone](https://rclone.org/)

## Instalação

1. Clone the repository or download the script.
2. Make sure the script has execute permission:
    ```bash
    chmod +x script.sh
    ```
## Uso

```bash
Uso: /usr/local/bin/Rclone-Aio-v9 [opções] origem destino [ -e flags_do_rclone]

Opções:
  -c (Copy)     Copie arquivos da origem para o destino, ignorando arquivos idênticos.
  -s (Sync)     Torne a origem e o destino idênticos, modificando apenas o destino.
  -m (Move)     Move arquivos da origem para o destino.
  -d (delete)   Remova os arquivos no caminho.
  -r (rmdirs)   Remova os diretórios vazios no caminho.
  -C (cleanup)  Limpe o controle remoto, se possível. Esvazie a lixeira ou exclua versões antigas de arquivos. Não suportado por todos os controles remotos.
  -n            Adiciona a flag --dry-run ao rclone.
  -f arquivo    Adiciona a flag --filter-from com o arquivo especificado ao rclone.
  -e            Adiciona flags extras ao comando rclone.

Exemplos:
  /usr/local/bin/Rclone-Aio-v9 -c 'local:caminho/origem' 'cloud:caminho/destino'
  /usr/local/bin/Rclone-Aio-v9 -c 'ftp:/caminho/origem' 'cloud:caminho/destino' -e --max-age=7d
  /usr/local/bin/Rclone-Aio-v9 -c 'local:caminho/origem' 'cloud:caminho/destino' -f '/caminho/para/filtro.lst'
  /usr/local/bin/Rclone-Aio-v9 -s 'local:caminho/origem' 'cloud:caminho/destino'
  /usr/local/bin/Rclone-Aio-v9 -s 'ftp:/caminho/origem' 'cloud:caminho/destino' -e --max-age=7d
  /usr/local/bin/Rclone-Aio-v9 -n -s 'local:caminho/origem' 'cloud:caminho/destino' -f '/caminho/para/filtro.lst'
  /usr/local/bin/Rclone-Aio-v9 -n -s 'local:caminho/origem' 'cloud:caminho/destino' -f '/caminho/para/filtro.lst' -e --max-age=7d
  /usr/local/bin/Rclone-Aio-v9 -C 'cloud:/'
  /usr/local/bin/Rclone-Aio-v9 -d 'cloud:caminho/destino'
  /usr/local/bin/Rclone-Aio-v9 -r 'cloud:caminho/destino'

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

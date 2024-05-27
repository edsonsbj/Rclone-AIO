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
## Use

Display the help menu

```bash
./Rclone-AIO.sh -h
```

```bash
Usage: ./Rclone-AIO.sh [options] source destination [ -e flags_do_rclone]

Options:
  -c (Copy)	 Copy files from source to destination, ignoring identical files.
  -s (Sync) 	 Make the source and destination identical, modifying only the destination.
  -m (Move)	 Move files from source to destination.
  -d (delete)	 Remove files in the path.
  -r (rmdirs)	 Remove empty directories in the path.
  -C (cleanup) Clean up the remote if possible. Empty the recycle garbage can or delete old versions of files. Not supported by all remotes.
  -n 		 Adds the --dry-run flag to rclone.
  -f file	 Adds the --filter-from flag with the specified file to rclone.
  -e 		 Adds extra flags to the rclone command.

Examples:
  ./Rclone-AIO.sh -c 'local:path/origin' 'cloud:path/destination'
  ./Rclone-AIO.sh -c 'ftp:/path/origin' 'cloud:path/destination' -e --max-age=7d
  ./Rclone-AIO.sh -c 'local:path/origin' 'cloud:path/destination' -f '/path/to/filter.lst'
  ./Rclone-AIO.sh -s 'local:path/origin' 'cloud:path/destination'
  ./Rclone-AIO.sh -s 'ftp:/path/origin' 'cloud:path/destination' -e --max-age=7d
  ./Rclone-AIO.sh -n -s 'local:path/origin' 'cloud:path/destination' -f '/path/to/filter.lst'
  ./Rclone-AIO.sh -n -s 'local:path/origin' 'cloud:path/destination' -f '/path/to/filter.lst' -e --max-age=7d
  ./Rclone-AIO.sh -C 'cloud:/'
  ./Rclone-AIO.sh -d 'cloud:path/destination'
  ./Rclone-AIO.sh -r 'cloud:path/destination'

```

### Options

 - `-c (Copy)`:	Copy files from source to destination, ignoring identical files.
 - `-s (Sync)`: Make the source and destination identical, modifying only the destination.
 - `-m (Move)`:	Move files from source to destination.
 - `-d (delete)`: Remove files in the path.
 - `-r (rmdirs)`: Remove empty directories in the path.
 - `-C (cleanup)`: Clean up the remote if possible. Empty the recycle garbage can or delete old versions of files. Not supported by all remotes.
 - `-n`: Adds the --dry-run flag to rclone.
 - `-f file`: Adds the --filter-from flag with the specified file to rclone.
 - `-e`: Adds extra flags to the rclone command.

### Examples

#### Copy files or folders

```bash
./Rclone-AIO.sh -c 'local:path/origin' 'cloud:path/destination'
```

#### Synchronize files or folders

```bash
./Rclone-AIO.sh -s 'local:path/origin' 'cloud:path/destination'
```

#### Move files or folders

```bash
./Rclone-AIO.sh -m 'local:path/origin' 'cloud:path/destination'
```

#### Dekete files or folders

```bash
./Rclone-AIO.sh -d 'cloud:path/destination'
```

#### Remove empty directories

```bash
./Rclone-AIO.sh -r 'cloud:path/destination'
```

#### Cleaning the remote control

```bash
./Rclone-AIO.sh -C 'cloud:path/destination'
```

#### Copy files with filter

- Using a filter file would be like adding exclusion patterns to the rclone include command.
- To find out more, see the rclone documentation [Rclone](https://rclone.org/filtering/).
  
```bash
./Rclone-AIO.sh -c 'local:path/origin' 'cloud:path/destination' -f '/path/to/filter.lst'
```

#### Synchronize with additional flags

- The script has already been designed with support for some flags if you want to add others you can do so by following this example

```bash
./Rclone-AIO.sh -s 'ftp:/path/origin' 'cloud:path/destination' -e --max-age=7d
```

## Logs

O script cria um arquivo de log para registrar as saídas dos comandos em `/var/log/Rclone/Rclone-AIO-$(date +%Y%m%d).log`.

## Contribution

Feel free to contribute by sending issues and pull requests. All contributions are welcome!


#!/bin/bash
# Data Criação: 11-09-2024
# @Marcelo Grando
# dir = /tmp/CreateWeknowFileStructure.sh
# Criar estrutura de para receber arquivos para Weknow


# Criar pastas
mkdir /home/weknow
mkdir /home/weknow/FortesDemonstrativos

# Dar permissão
chmod 777 -R /home/weknow

# Arquivo de configuração do Samba
SMB_CONF="/etc/samba/smb.conf"

# Texto a ser inserido
TEXT_TO_ADD="
[weknow]
        path = /home/weknow
        public = yes
        writable = yes
        printable = no
        browseable = no
        force create mode = 777
        force create directory = 777
        write list = weknow
        read list = weknow
"
# Verifica se existem pelo menos 2 linhas em branco no final e adiciona se necessário
# if ! grep -qP '\n\s*\n\s*$' "$SMB_CONF"; then
#     echo -e "\n\n" >> "$SMB_CONF"
# fi

# Adiciona o texto após as 2 linhas em branco
echo -e "$TEXT_TO_ADD" >> "$SMB_CONF"

# Reinicia o serviço do Samba para aplicar as mudanças (opcional)
# sudo systemctl restart smbd

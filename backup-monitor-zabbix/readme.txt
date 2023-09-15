# Data Criação: 15-09-2023
# @Marcelo Grando

Orientações Gerais
1 - Certificar-se de criar usuário e senha na storage.
    - 'username=zabbix','password=<verificar padrao na Atena>' permissão de leitura.

2 - Criar os diretórios onde serão mapeados as pastas de backup do storage.
    - Executar os arquivo "criar_diretorios_backups.sh"

3 - Os arquivos que estão dentro do diretório "script-python" devem ser salvos 
  no sequinte caminho "/etc/zabbix/script-python"

    3.1 - Os arquivos com extensão .py não necessitam de nenhuma mudança.

    3.2 - O arquivo "mount_storage.sh" precisa ser alterado.
        - EX:. "//192.168.0.246/backup_fortes" deve ser informado o caminho 
        da pasta de backup no Storage. Todos os demais caminhos devem ser alterados.
        - Deve ser informado o <extensão_ou_nome_arquivo_backup> conforme linha de sintaxe.
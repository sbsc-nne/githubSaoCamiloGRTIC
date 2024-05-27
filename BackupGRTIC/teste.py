import os

# Obtém o caminho do diretório onde o script está localizado
diretorio_do_script = os.path.dirname(os.path.abspath(__file__))

# Define o diretório de trabalho atual como o diretório do script
os.chdir(diretorio_do_script)

# Obtém novamente o diretório atual de execução
diretorio_atual = os.getcwd()

# Imprime o diretório atual
print("O diretório atual é:", diretorio_atual)

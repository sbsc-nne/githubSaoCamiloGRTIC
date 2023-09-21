# Data Criação: 14-03-2022
# @Marcelo Grando
# Script para retornar o nome do ultimo arquivo criado em uma determinada pasta.
# no arquivo info_last_file_bkp está a função: last_file_name(path): 

from info_last_file_bkp import last_file_name
import sys

path=sys.argv[1]
last_file_name(path)
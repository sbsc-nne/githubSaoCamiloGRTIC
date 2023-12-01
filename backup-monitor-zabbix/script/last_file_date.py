# Data Criação: 14-03-2022
# @Marcelo Grando
# Script para retornar a data de criação do ultimo arquivo em uma determinada pasta.
# no arquivo info_last_file_bkp está a função: last_file_date(path):

from info_last_file_bkp import last_file_date
import sys

path=sys.argv[1] # Informar como primeiro argumento o caminho do arquivo
extension=sys.argv[2] # Informar como segundo argumento a extenção Ex: .zip .exe .backup .7z
last_file_date(path,extension)
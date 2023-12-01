# Data Criação: 14-03-2022
# @Marcelo Grando
# Script com as funções com informação do ultimo arquivo criado em uma determinada pasta.

import os
from datetime import datetime
def last_file_name(path,extension): # Listar o nome do ultimo arquivo criado em uma determinada pasta (path)
    lista_arquivos = os.listdir(path)
    lista_datas = []
    for arquivo in lista_arquivos:
        if extension in arquivo:
            data = os.path.getmtime(f"{path}/{arquivo}")
            lista_datas.append((data, arquivo))
    lista_datas.sort(reverse=True)
    ultimo_arquivo = lista_datas[0]
    print(ultimo_arquivo[1])

def last_file_date(path,extension): # Listar a data de criação do ultimo arquivo criado em uma determinada pasta (path)
    lista_arquivos = os.listdir(path)
    lista_datas = []
    for arquivo in lista_arquivos:
        if extension in arquivo:
            data = os.path.getmtime(f"{path}/{arquivo}")
            lista_datas.append((data, arquivo))
    lista_datas.sort(reverse=True)
    ultimo_arquivo = lista_datas[0]
    data = os.path.getmtime(f"{path}/{ultimo_arquivo[1]}")
    ultima_data = datetime.fromtimestamp(data).strftime('%d/%m/%Y %H:%M')
    print(ultima_data)

def last_file_size(path,extension): # Listar o tamanho em kb do ultimo arquivo criado em uma determinada pasta (path)
    lista_arquivos = os.listdir(path)
    lista_datas = []
    for arquivo in lista_arquivos:
        if extension in arquivo:
            data = os.path.getmtime(f"{path}/{arquivo}")
            lista_datas.append((data, arquivo))
    lista_datas.sort(reverse=True)
    ultimo_arquivo = lista_datas[0]
    f_path = os.path.join(path, ultimo_arquivo[1])
    f_size = os.path.getsize(f_path)
    f_size_kb = f_size / 1024  # obter resultado em kB
    print(f'{f_size_kb:.2f}')
#!/bin/bash

# Defina as pastas de origem e destino
origem_certificado="/home/pgdata-9.4.22/docusign/certificado"
origem_prontuario_digital="/home/pgdata-9.4.22/prontuario_digital"
origem_administrativo="/home/pgdata-9.4.22/administrativo"

destino_certificado="/home/storage/doc_certificado"
destino_prontuario_digital="/home/storage/doc_prontuario_digital"
destino_administrativo="/home/storage/doc_administrativo"

# Execute o rsync para copiar apenas os arquivos mais recentes
rsync -av --update "$origem_certificado/" "$destino_certificado/"

rsync -av --update "$origem_prontuario_digital/" "$destino_prontuario_digital/"

rsync -av --update "$origem_administrativo/" "$destino_administrativo/"

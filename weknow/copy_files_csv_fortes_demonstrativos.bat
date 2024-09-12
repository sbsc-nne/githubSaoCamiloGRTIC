@echo off
REM Define o destino final onde os arquivos serão copiados
set DESTINO="C:\BASE_FORTES_AC_CSV"

REM Copiar os arquivos para o destino
copy "\\10.30.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.31.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.32.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.33.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.34.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.35.15.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.36.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.37.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.38.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.39.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.40.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.41.10.20\weknow\FortesDemonstrativos\*" %DESTINO%
copy "\\10.42.10.20\weknow\FortesDemonstrativos\*" %DESTINO%

REM Mensagem final
echo Todos os arquivos foram copiados para %DESTINO%

timeout /t 5 
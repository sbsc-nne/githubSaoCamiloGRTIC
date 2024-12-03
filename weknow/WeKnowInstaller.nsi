; Define o nome do instalador
Name "WeKnow Installer"
OutFile "WeKnowInstaller.exe"

; Instalação silenciosa
SilentInstall silent

; Solicitar privilégios administrativos
RequestExecutionLevel admin

Section "Main"

    ; Criar atalho na área de trabalho
    SetOutPath "$DESKTOP"
    CreateShortcut "$DESKTOP\WeKnow.url" "http://weknow.saocamilocrateus-upa.local"

    ; Modificar o arquivo de hosts somente se a linha não existir
    FileOpen $1 "$WINDIR\System32\drivers\etc\hosts" "r"
    ClearErrors
    loop_start:
        FileRead $1 $2
        IfErrors not_found
        StrCmp $2 "10.33.10.22 weknow.saocamilocrateus-upa.local$\r$\n" done
        Goto loop_start

    not_found:
    FileClose $1

    ; Linha não encontrada, adicionar
    FileOpen $1 "$WINDIR\System32\drivers\etc\hosts" "a"
    FileWrite $1 "$\r$\n10.33.10.22 weknow.saocamilocrateus-upa.local"
    FileClose $1

    done:
    FileClose $1

SectionEnd

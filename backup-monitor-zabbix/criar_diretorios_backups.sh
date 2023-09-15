#!/bin/bash
# Data Criação: 01-08-2022
# @Marcelo Grando
# Script 

if [! -d "/mnt/bkp_fortes_ac"]; then
    mkdir /mnt/bkp_fortes_ac
fi

if [! -d "/mnt/bkp_fortes_ponto"]; then
    mkdir /mnt/bkp_fortes_ponto
fi

if [! -d "/mnt/bkp_fortes_rh"]; then
    mkdir /mnt/bkp_fortes_rh
fi

if [! -d "/mnt/bkp_systemah2005"]; then
    mkdir /mnt/bkp_systemah2005
fi

if [! -d "/mnt/bkp_wk_sistemas"]; then
    mkdir /mnt/bkp_wk_sistemas
fi

# app/globais.py

import os

DIRETORIO_MAPAS = "static/mapas/"
DIRETORIO_RELATORIOS = "static/relatorios/"
DIRETORIO_IMAGENS = "static/imagens/"

# Garantir que os diretórios existam
os.makedirs(DIRETORIO_MAPAS, exist_ok=True)
os.makedirs(DIRETORIO_RELATORIOS, exist_ok=True)
os.makedirs(DIRETORIO_IMAGENS, exist_ok=True)

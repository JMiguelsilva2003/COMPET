from fastapi import APIRouter, File, UploadFile, Form
import os
from app.database import salvar_imagem, listar_imagens
from app import globais 

router = APIRouter()

@router.post("/upload")
async def upload_imagem(
    imagem: UploadFile = File(...),
    cpf_agricultor: str = Form(...),
    latitude: float = Form(...),
    longitude: float = Form(...)
):
    # Caminho usando o diretório global de imagens
    caminho = os.path.join(globais.DIRETORIO_IMAGENS, imagem.filename)

    # Salvando fisicamente a imagem no diretório definido
    with open(caminho, "wb") as buffer:
        buffer.write(await imagem.read())

    try:
        # Salvar metadados no banco de dados
        salvar_imagem(imagem.filename, cpf_agricultor, latitude, longitude)

        return {
            "mensagem": "Imagem recebida com sucesso",
            "arquivo": imagem.filename,
            "cpf_agricultor": cpf_agricultor,
            "latitude": latitude,
            "longitude": longitude,
            "salvo_em": caminho
        }

    except Exception as e:
        return {
            "erro": "Não foi possível salvar imagem no banco",
            "detalhes": str(e)
        }

import os

import os

@router.get("/listar")
def listar():
    dados = listar_imagens()
    return [
        {
            "arquivo": d[0],
            "cpf_agricultor": d[1],
            "latitude": d[2],
            "longitude": d[3],
            "caminho_local": f"http://192.168.1.16:8000/static/imagens/{d[0]}"
        }
        for d in dados
    ]
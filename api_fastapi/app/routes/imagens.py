from fastapi import APIRouter, File, UploadFile
import os
from globais import DIRETORIO_MAPAS

router = APIRouter()

@router.post("/upload")
async def upload_imagem(imagem: UploadFile = File(...)):
    caminho = os.path.join(DIRETORIO_MAPAS, imagem.filename)
    
    with open(caminho, "wb") as buffer:
        buffer.write(await imagem.read())

    return {"mensagem": "Imagem recebida com sucesso", "arquivo": imagem.filename}

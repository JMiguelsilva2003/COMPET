from fastapi import APIRouter
from fastapi.responses import FileResponse
import os

router = APIRouter()

@router.get("/mapas/{tipo}")
def get_mapa(tipo: str):
    caminho = os.path.abspath(f"static/mapas/mapa_{tipo}.html")
    if os.path.exists(caminho):
        return FileResponse(caminho)
    return {"erro": "Mapa não encontrado"}

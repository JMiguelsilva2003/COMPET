from fastapi import APIRouter

router = APIRouter()

@router.get("/")
def listar_mapas():
    return {"mensagem": "Lista de mapas"}
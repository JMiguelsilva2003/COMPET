from fastapi import APIRouter

router = APIRouter()

@router.get("/")
def listar_relatorios():
    return {"mensagem": "Lista de relatórios"}

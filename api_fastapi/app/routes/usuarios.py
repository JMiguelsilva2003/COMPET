from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, constr
from app.database import salvar_usuario

router = APIRouter()

class UsuarioEntrada(BaseModel):
    nome: constr(min_length=5)
    cpf: constr(min_length=11, max_length=14)
    senha: constr(min_length=8)
    concordou: bool

@router.post("/cadastrar_usuario")
def cadastrar_usuario(usuario: UsuarioEntrada):
    if not usuario.concordou:
        raise HTTPException(status_code=400, detail="Você precisa concordar com os termos para se cadastrar.")
    
    try:
        salvar_usuario(usuario.nome, usuario.cpf, usuario.senha)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Erro ao cadastrar usuário: {e}")
    
    return {"mensagem": "Usuário cadastrado com sucesso!"}

from fastapi import FastAPI
from app.routes import mapas, relatorios, imagens, usuarios
from app.database import inicializar_db

app = FastAPI(title="API Ambiental - CAR e PSA")

# Inicializar banco de dados SQLite na inicialização
@app.on_event("startup")
def startup_event():
    inicializar_db()

# Inclusão das rotas
app.include_router(mapas.router, prefix="/mapas", tags=["Mapas"])
app.include_router(relatorios.router, prefix="/relatorios", tags=["Relatórios"])
app.include_router(imagens.router, prefix="/imagens", tags=["Imagens"])
app.include_router(usuarios.router, prefix="/usuarios", tags=["Usuários"])

from fastapi.staticfiles import StaticFiles

# 🔹 Servindo a pasta 'static' para acesso às imagens
app.mount("/static", StaticFiles(directory="static"), name="static")

# Rota raiz
@app.get("/")
def root():
    return {"mensagem": "API Ambiental no ar"}
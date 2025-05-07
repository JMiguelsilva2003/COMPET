from fastapi import FastAPI
from app.routes import mapas, relatorios, imagens

app = FastAPI(title="API Ambiental - CAR e PSA")

# rotas incluídas
app.include_router(mapas.router, prefix="/mapas", tags=["Mapas"])
app.include_router(relatorios.router, prefix="/relatorios", tags=["Relatórios"])
app.include_router(imagens.router, prefix="/imagens", tags=["Imagens"])

@app.get("/")
def root():
    return {"mensagem": "API Ambiental no ar"}

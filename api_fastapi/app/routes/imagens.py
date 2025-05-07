from fastapi import APIRouter, File, UploadFile, Form
import os
from PIL import Image
from app.database import salvar_imagem, listar_imagens
import piexif

DIRETORIO_MAPAS = "app/mapas"
os.makedirs(DIRETORIO_MAPAS, exist_ok=True)

router = APIRouter()

def converter_gps_para_decimal(gps_data):
    def _convert(val):
        return val[0][0] / val[0][1] + val[1][0] / val[1][1] / 60 + val[2][0] / val[2][1] / 3600

    lat = _convert(gps_data['GPSLatitude'])
    if gps_data['GPSLatitudeRef'] != b'N':
        lat = -lat

    lon = _convert(gps_data['GPSLongitude'])
    if gps_data['GPSLongitudeRef'] != b'E':
        lon = -lon

    return lat, lon

@router.post("/upload")
async def upload_imagem(
    imagem: UploadFile = File(...),
    agricultor: str = Form(...)
):
    caminho = os.path.join(DIRETORIO_MAPAS, imagem.filename)
    with open(caminho, "wb") as buffer:
        buffer.write(await imagem.read())

    try:
        img = Image.open(caminho)
        exif_dict = piexif.load(img.info["exif"])
        gps_info = exif_dict.get("GPS")

        if not gps_info:
            raise ValueError("Imagem não contém informações GPS.")

        lat, lon = converter_gps_para_decimal(gps_info)
        salvar_imagem(imagem.filename, agricultor, lat, lon)

        return {
            "mensagem": "Imagem recebida com sucesso",
            "arquivo": imagem.filename,
            "agricultor": agricultor,
            "latitude": lat,
            "longitude": lon
        }

    except Exception as e:
        return {
            "erro": "Não foi possível extrair localização",
            "detalhes": str(e)
        }

@router.get("/listar")
def listar():
    dados = listar_imagens()
    return [
        {
            "arquivo": d[0],
            "agricultor": d[1],
            "latitude": d[2],
            "longitude": d[3]
        }
        for d in dados
    ]

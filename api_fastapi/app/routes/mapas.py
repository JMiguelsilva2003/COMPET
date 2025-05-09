from fastapi import APIRouter, File, UploadFile
import os
from PIL import Image
from globais import DIRETORIO_MAPAS
from app.database import salvar_imagem
import piexif

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
async def upload_imagem(imagem: UploadFile = File(...)):
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
        salvar_imagem(imagem.filename, lat, lon)

        return {
            "mensagem": "Imagem recebida com sucesso",
            "arquivo": imagem.filename,
            "latitude": lat,
            "longitude": lon
        }

    except Exception as e:
        return {
            "erro": "Não foi possível extrair localização",
            "detalhes": str(e)
        }

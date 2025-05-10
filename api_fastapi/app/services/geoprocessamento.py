import folium
import sqlite3
import os
from geopy.distance import geodesic
from shapely.geometry import LineString
import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))


from app import globais


# 🔹 Definir pasta onde os mapas serão salvos
DIRETORIO_MAPAS = "static/mapas/"
os.makedirs(DIRETORIO_MAPAS, exist_ok=True)  # 🔹 Criar pasta caso não exista

# 🔹 Função para buscar as localizações no banco
def obter_localizacoes():
    conn = sqlite3.connect("app/imagens.db")
    cursor = conn.cursor()
    cursor.execute("SELECT nome_arquivo, latitude, longitude FROM imagens")
    dados = cursor.fetchall()
    conn.close()
    return [{"arquivo": d[0], "latitude": d[1], "longitude": d[2]} for d in dados]

# 🔹 Obter dados do banco
dados = obter_localizacoes()

if not dados:
    print("❌ Nenhum ponto encontrado no banco!")
    exit()

# 🔹 Criar mapa de pontos
mapa_pontos = folium.Map(location=[dados[0]["latitude"], dados[0]["longitude"]], zoom_start=15)

for dado in dados:
    folium.Marker(
        location=[dado["latitude"], dado["longitude"]],
        popup=f'Imagem: {dado["arquivo"]}',
        icon=folium.Icon(color="red")
    ).add_to(mapa_pontos)

# 🔹 Salvar mapa de pontos
caminho_pontos = os.path.join(DIRETORIO_MAPAS, "mapa_pontos.html")
mapa_pontos.save(caminho_pontos)
print(f"✅ Mapa de pontos salvo em: {caminho_pontos}")

# 🔹 Criar mapa de conexões
mapa_conexoes = folium.Map(location=[dados[0]["latitude"], dados[0]["longitude"]], zoom_start=15)

distancias = []
for i in range(len(dados) - 1):
    ponto1 = [dados[i]["latitude"], dados[i]["longitude"]]
    ponto2 = [dados[i+1]["latitude"], dados[i+1]["longitude"]]
    
    linha = folium.PolyLine([ponto1, ponto2], color="blue", weight=3)
    linha.add_to(mapa_conexoes)

    distancia_km = geodesic(ponto1, ponto2).kilometers
    distancias.append(distancia_km)

# 🔹 Salvar mapa de conexões
caminho_conexoes = os.path.join(DIRETORIO_MAPAS, "mapa_conexoes.html")
mapa_conexoes.save(caminho_conexoes)
print(f"✅ Mapa de conexões salvo em: {caminho_conexoes}")

# 🔹 Exibir distâncias
for i, distancia in enumerate(distancias):
    print(f"Distância entre {dados[i]['arquivo']} e {dados[i+1]['arquivo']}: {distancia:.2f} km")

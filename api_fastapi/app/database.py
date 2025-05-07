import sqlite3
import os

# Criação do banco no app
DB_PATH = "app/imagens.db"

def inicializar_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS imagens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_arquivo TEXT NOT NULL,
        agricultor TEXT NOT NULL,
        latitude REAL,
        longitude REAL
    )
    """)
    conn.commit()
    conn.close()

def salvar_imagem(nome_arquivo, agricultor, latitude, longitude):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
    INSERT INTO imagens (nome_arquivo, agricultor, latitude, longitude)
    VALUES (?, ?, ?, ?)
    """, (nome_arquivo, agricultor, latitude, longitude))
    conn.commit()
    conn.close()

def listar_imagens():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT nome_arquivo, agricultor, latitude, longitude FROM imagens")
    resultados = cursor.fetchall()
    conn.close()
    return resultados

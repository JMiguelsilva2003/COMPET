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

def inicializar_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Tabela para imagens
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS imagens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_arquivo TEXT NOT NULL,
        agricultor TEXT NOT NULL,
        latitude REAL,
        longitude REAL
    )
    """)

    # Tabela para usuários
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpf TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
    )
    """)

    conn.commit()
    conn.close()

def salvar_usuario(nome, cpf, senha):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
    INSERT INTO usuarios (nome, cpf, senha)
    VALUES (?, ?, ?)
    """, (nome, cpf, senha))
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

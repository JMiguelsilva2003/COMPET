import sqlite3
import os

# Caminho do banco de dados SQLite
DB_PATH = "app/imagens.db"

# Inicialização do banco de dados
def inicializar_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Tabela para armazenar imagens com nome do agricultor
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS imagens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_arquivo TEXT NOT NULL,
        cpf_agricultor TEXT NOT NULL,
        latitude REAL,
        longitude REAL
    )
    """)

    # Tabela de usuários (nome, cpf, senha)
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

# Salvar imagem com nome, lat, lon
def salvar_imagem(nome_arquivo, cpf_agricultor, latitude, longitude):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
    INSERT INTO imagens (nome_arquivo, cpf_agricultor, latitude, longitude)
    VALUES (?, ?, ?, ?)
    """, (nome_arquivo, cpf_agricultor, latitude, longitude))
    conn.commit()
    conn.close()

# Listar imagens
def listar_imagens():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT nome_arquivo, cpf_agricultor, latitude, longitude FROM imagens")
    resultados = cursor.fetchall()
    conn.close()
    return resultados

# Salvar novo usuário
def salvar_usuario(nome, cpf, senha):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
    INSERT INTO usuarios (nome, cpf, senha)
    VALUES (?, ?, ?)
    """, (nome, cpf, senha))
    conn.commit()
    conn.close()

# Verificar login por CPF e senha
def verificar_usuario(cpf, senha):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
    SELECT id, nome, cpf FROM usuarios WHERE cpf = ? AND senha = ?
    """, (cpf, senha))
    resultado = cursor.fetchone()
    conn.close()
    return resultado  # None se não encontrado

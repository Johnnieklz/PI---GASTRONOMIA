"""
Script para inicializar o banco de dados.
"""
from app.db.init_db import init_db

if __name__ == "__main__":
    print("Criando tabelas no banco de dados...")
    init_db()
    print("Banco de dados inicializado com sucesso!")
    print("\nPara rodar o servidor:")
    print("  python run.py")

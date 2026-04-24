#!/bin/bash
set -e

echo "Aguardando inicialização..."

# Criar diretório de dados se não existir
mkdir -p /app/data

# Inicializar o banco de dados
echo "Inicializando banco de dados..."
python -c "
from app.db.init_db import init_db
init_db()
print('Banco de dados inicializado!')
"

# Iniciar o servidor
echo "Iniciando servidor..."
exec "$@"

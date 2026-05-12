FROM python:3.11

WORKDIR /app

# Instalar curl para healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copiar requirements primeiro para aproveitar cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o resto do código
COPY . .

# Criar diretório para o banco de dados SQLite
RUN mkdir -p /app/data

# Variáveis de ambiente
ENV PYTHONPATH=/app
ENV DATABASE_URL=sqlite:///./data/app.db
ENV DEBUG=True

# Expor porta
EXPOSE 8000

# Comando para iniciar o servidor
CMD ["sh", "-c", "python -c 'from app.db.init_db import init_db; init_db()' && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"]

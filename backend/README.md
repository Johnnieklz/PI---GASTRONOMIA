# Backend FastAPI - Sistema Completo

Backend profissional com FastAPI, SQLAlchemy, JWT, bcrypt e estrutura em camadas.

## Estrutura

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       └── endpoints/        # Rotas (auth, users, products)
│   ├── core/                      # Config, segurança, exceções
│   ├── db/                        # Conexão, sessão, migrations
│   ├── models/                    # Entidades (User, Product)
│   ├── repositories/              # Acesso a dados
│   ├── schemas/                   # Pydantic schemas
│   ├── services/                  # Regras de negócio
│   └── tests/                     # Testes com pytest
├── alembic/                       # Configuração Alembic
├── requirements.txt
├── .env.example
└── run.py
```

## Instalação

### 1. Criar ambiente virtual

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

### 2. Instalar dependências

```bash
pip install -r requirements.txt
```

### 3. Configurar variáveis de ambiente

```bash
cp .env.example .env
# Editar .env com suas configurações
```

### 4. Criar banco de dados

```bash
# Inicializar tabelas
python -c "from app.db.init_db import init_db; init_db()"

# Ou com Alembic
alembic revision --autogenerate -m "Initial migration"
alembic upgrade head
```

## Executar

### Desenvolvimento

```bash
python run.py
```

Ou:

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Produção

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

## Documentação API

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- OpenAPI JSON: http://localhost:8000/openapi.json

## Testes

```bash
# Rodar todos os testes
pytest

# Rodar com verbose
pytest -v

# Cobertura
pytest --cov=app
```

## Rotas

### Auth
- `POST /api/v1/auth/register` - Criar conta
- `POST /api/v1/auth/login` - Login (retorna JWT)

### Users
- `GET /api/v1/users/me` - Perfil do usuário logado
- `PUT /api/v1/users/me` - Atualizar perfil
- `DELETE /api/v1/users/me` - Deletar conta
- `GET /api/v1/users/{id}` - Ver usuário (admin ou próprio)
- `GET /api/v1/users/` - Listar usuários (admin)

### Products
- `GET /api/v1/products/` - Listar produtos
- `POST /api/v1/products/` - Criar produto
- `GET /api/v1/products/{id}` - Ver produto
- `PUT /api/v1/products/{id}` - Atualizar produto
- `DELETE /api/v1/products/{id}` - Deletar produto

## Exemplos de Uso

### Registro
```bash
curl -X POST "http://localhost:8000/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "username": "johndoe",
    "password": "senha123",
    "full_name": "John Doe"
  }'
```

### Login
```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "user@example.com",
    "password": "senha123"
  }'
```

### Criar Produto (com token)
```bash
curl -X POST "http://localhost:8000/api/v1/products/" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "name": "Notebook",
    "description": "Notebook gamer",
    "price": 5000.00,
    "stock": 10,
    "sku": "NB-001"
  }'
```

## Configurações (.env)

```env
# Banco de dados
DATABASE_URL=sqlite:///./app.db
# DATABASE_URL=postgresql://user:pass@localhost:5432/dbname

# Segurança
SECRET_KEY=chave-secreta-muito-segura
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
BACKEND_CORS_ORIGINS=http://localhost:3000,http://localhost:5173

# App
DEBUG=true
PROJECT_NAME=FastAPI Backend
```

## Migrations

```bash
# Criar nova migração
alembic revision --autogenerate -m "Descrição"

# Aplicar migrações
alembic upgrade head

# Reverter
alembic downgrade -1

# Ver histórico
alembic history
```

## Segurança

- JWT para autenticação
- Bcrypt para hash de senhas
- CORS configurado
- Validação de dados com Pydantic
- Rotas protegidas por dependência
- Ownership verification em recursos

## Stack

- Python 3.9+
- FastAPI
- SQLAlchemy 2.0
- Alembic
- Pydantic
- Pytest
- PostgreSQL/SQLite

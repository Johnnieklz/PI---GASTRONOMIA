# Ambiente Docker - Projeto Gastro

Este projeto contém:
- **Backend**: FastAPI (Python) com SQLite
- **Frontend**: Flutter Web

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Estrutura

```
.
├── backend/          # API FastAPI (porta 8000)
├── Projeto_Gastro-main/   # Flutter Frontend (porta 8080)
└── docker-compose.yml
```

## Iniciar o Projeto

### 1. Construir e iniciar todos os serviços

```bash
docker-compose up --build
```

### 2. Acessar a aplicação

- **Frontend (Flutter Web)**: http://localhost:8080
- **Backend API**: http://localhost:8000
- **Documentação API (Swagger)**: http://localhost:8000/docs

### 3. Parar os serviços

```bash
docker-compose down
```

Para parar e remover volumes (apaga o banco de dados):
```bash
docker-compose down -v
```

## Desenvolvimento

### Rodar apenas o backend
```bash
cd backend
docker-compose up --build backend
```

### Rodar apenas o frontend
```bash
docker-compose up --build frontend
```

### Ver logs
```bash
docker-compose logs -f
```

### Ver logs do backend
```bash
docker-compose logs -f backend
```

### Ver logs do frontend
```bash
docker-compose logs -f frontend
```

## Comandos úteis

### Rebuild após mudanças no código
```bash
docker-compose up --build
```

### Shell no container do backend
```bash
docker-compose exec backend bash
```

### Testar API manualmente
```bash
# Health check
curl http://localhost:8000/health

# Listar documentação
curl http://localhost:8000/docs
```

## Solução de Problemas

### Portas em uso
Se as portas 8000 ou 8080 estiverem ocupadas:
```bash
# No docker-compose.yml, altere as portas:
# ports:
#   - "8001:8000"  # backend na porta 8001
#   - "8081:80"    # frontend na porta 8081
```

### Banco de dados
O banco SQLite está em um volume Docker persistente em `/app/data/app.db`.
Para resetar:
```bash
docker-compose down -v
docker-compose up --build
```

### CORS
O backend está configurado para aceitar requisições de:
- http://localhost:8080 (Flutter Web)
- http://localhost:3000
- http://localhost:5173
- Qualquer origem (modo desenvolvimento)

## Funcionalidades

- ✅ Cadastro de usuários
- ✅ Login com JWT
- ✅ CRUD de produtos/receitas
- ✅ Favoritos

## Notas

- O backend usa SQLite para facilitar o desenvolvimento (não precisa de banco externo)
- O frontend Flutter Web é servido pelo Nginx
- O Nginx faz proxy das requisições `/api/*` para o backend

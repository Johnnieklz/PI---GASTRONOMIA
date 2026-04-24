# Integração Frontend Flutter + Backend FastAPI

## Configuração

### 1. Iniciar o Backend

```bash
cd backend

# Criar ambiente virtual (se não existir)
python -m venv venv

# Windows
venv\Scripts\activate

# Instalar dependências
pip install -r requirements.txt

# Configurar .env
cp .env.example .env

# Criar banco de dados
python -c "from app.db.init_db import init_db; init_db()"

# Rodar servidor
python run.py
```

Backend estará em: http://localhost:8000

### 2. Configurar Frontend

No arquivo `lib/services/api_service.dart`, ajuste o `baseUrl`:

```dart
// Para Android Emulator
static const String baseUrl = 'http://10.0.2.2:8000';

// Para iOS/Web
static const String baseUrl = 'http://localhost:8000';

// Para dispositivo físico (substitua pelo IP da máquina)
static const String baseUrl = 'http://192.168.1.100:8000';
```

### 3. Instalar Dependências Flutter

```bash
cd "Projeto_Gastro-main"

flutter pub get
```

### 4. Executar App

```bash
flutter run
```

## Testando a Integração

### Fluxo de Teste:

1. **Tela de Login**
   - Entre com email/username e senha
   - Se não tiver conta, clique em "Cadastre-se"

2. **Tela de Cadastro**
   - Preencha: Nome, Username, E-mail, Senha
   - Clique em "Cadastrar"
   - Login automático após cadastro

3. **Tela Inicial**
   - Acessível após login

4. **Perfil**
   - Mostra dados do usuário logado
   - Editar nome
   - Logout funcional

### API Endpoints Testáveis

| Ação | Endpoint |
|------|----------|
| Login | POST /api/v1/auth/login |
| Cadastro | POST /api/v1/auth/register |
| Perfil | GET /api/v1/users/me |
| Atualizar | PUT /api/v1/users/me |

## Testes com cURL

### Cadastro:
```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@teste.com","username":"teste","password":"123456","full_name":"Teste User"}'
```

### Login:
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"teste@teste.com","password":"123456"}'
```

## Problemas Comuns

### Erro de conexão (Connection refused)
- Verifique se o backend está rodando
- Verifique o IP no `api_service.dart`
- Para Android, use `10.0.2.2` (localhost do emulador)
- Para iOS, use `localhost`

### CORS Error
O backend já tem CORS configurado. Se persistir:
```python
# Em app/main.py, adicione seu IP:
allow_origins=["http://localhost:8000", "http://seu-ip:porta"]
```

### Timeout
- Verifique firewall
- Verifique se as portas estão abertas

## Arquitetura

```
Frontend (Flutter)
    ↓ HTTP
Backend (FastAPI)
    ↓ SQLAlchemy
Banco (SQLite/PostgreSQL)
```

### Segurança
- JWT Token armazenado em SharedPreferences
- Senhas hasheadas com bcrypt
- Rotas protegidas
- Validação de formulários

## Telas Implementadas

1. **Login** - Validação + API
2. **Cadastro** - Validação + API
3. **Perfil** - Dados reais + Editar + Logout

## Checklist de Funcionalidades

- [x] Login com email/username
- [x] Cadastro com validação
- [x] Persistência de token
- [x] Perfil do usuário
- [x] Logout
- [x] Validação de formulários
- [x] Loading states
- [x] Tratamento de erros

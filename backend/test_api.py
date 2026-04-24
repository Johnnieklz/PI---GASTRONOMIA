"""
Script para testar a API do backend.
"""
import requests
import sys

BASE_URL = "http://localhost:8000"

def test_health():
    """Test health endpoint."""
    print("\n=== Testando Health Check ===")
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"Erro: {e}")
        return False

def test_register():
    """Test register endpoint."""
    print("\n=== Testando Cadastro ===")
    try:
        response = requests.post(
            f"{BASE_URL}/api/v1/auth/register",
            json={
                "email": "teste@exemplo.com",
                "username": "testeuser",
                "password": "senha123",
                "full_name": "Teste Usuario"
            },
            timeout=5
        )
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.status_code == 201
    except Exception as e:
        print(f"Erro: {e}")
        return False

def test_login():
    """Test login endpoint."""
    print("\n=== Testando Login ===")
    try:
        response = requests.post(
            f"{BASE_URL}/api/v1/auth/login",
            json={
                "username": "teste@exemplo.com",
                "password": "senha123"
            },
            timeout=5
        )
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")

        if response.status_code == 200:
            data = response.json()
            if data.get("success"):
                return data["data"]["access_token"]
        return None
    except Exception as e:
        print(f"Erro: {e}")
        return None

def test_get_profile(token):
    """Test get profile endpoint."""
    print("\n=== Testando Perfil ===")
    try:
        response = requests.get(
            f"{BASE_URL}/api/v1/users/me",
            headers={"Authorization": f"Bearer {token}"},
            timeout=5
        )
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"Erro: {e}")
        return False

def main():
    print("=" * 50)
    print("TESTANDO API BACKEND")
    print("=" * 50)
    print(f"URL Base: {BASE_URL}")

    # Test 1: Health
    if not test_health():
        print("\n❌ Health check falhou. Verifique se o servidor está rodando.")
        print("   Execute: python run.py")
        sys.exit(1)
    print("✅ Health check OK")

    # Test 2: Register
    if not test_register():
        print("\n⚠️ Cadastro falhou (pode ser usuário já existente)")
    else:
        print("✅ Cadastro OK")

    # Test 3: Login
    token = test_login()
    if not token:
        print("\n❌ Login falhou")
        sys.exit(1)
    print("✅ Login OK")

    # Test 4: Profile
    if not test_get_profile(token):
        print("\n❌ Perfil falhou")
        sys.exit(1)
    print("✅ Perfil OK")

    print("\n" + "=" * 50)
    print("✅ TODOS OS TESTES PASSARAM!")
    print("=" * 50)
    print("\nA API está funcionando corretamente.")
    print("Você pode conectar o Flutter agora.")

if __name__ == "__main__":
    main()

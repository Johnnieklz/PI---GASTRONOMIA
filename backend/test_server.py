"""
Testa o servidor backend localmente.
"""
import subprocess
import time
import sys
import requests

def main():
    print("=" * 50)
    print("INICIANDO TESTE DO SERVIDOR")
    print("=" * 50)

    # Start server
    print("\n1. Iniciando servidor...")
    proc = subprocess.Popen(
        [sys.executable, 'run.py'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd='C:/Users/TECNICO/Desktop/Projeto_Gastro-main/backend'
    )

    # Aguarda inicialização
    print("2. Aguardando 5 segundos...")
    time.sleep(5)

    try:
        # Health check
        print("\n3. Testando Health Check...")
        r = requests.get('http://localhost:8000/health', timeout=10)
        print(f"   Status: {r.status_code}")
        print(f"   Response: {r.json()}")

        # Registro
        print("\n4. Testando Cadastro...")
        r = requests.post(
            'http://localhost:8000/api/v1/auth/register',
            json={
                'email': 'teste@teste.com',
                'username': 'testeuser',
                'password': '123456',
                'full_name': 'Teste User'
            },
            timeout=10
        )
        print(f"   Status: {r.status_code}")
        print(f"   Response: {r.json()}")

        # Login
        print("\n5. Testando Login...")
        r = requests.post(
            'http://localhost:8000/api/v1/auth/login',
            json={
                'username': 'teste@teste.com',
                'password': '123456'
            },
            timeout=10
        )
        print(f"   Status: {r.status_code}")
        data = r.json()
        print(f"   Success: {data.get('success')}")

        if data.get('data') and data['data'].get('access_token'):
            token = data['data']['access_token']
            print(f"   Token: {token[:30]}...")

            # Profile
            print("\n6. Testando Perfil...")
            r = requests.get(
                'http://localhost:8000/api/v1/users/me',
                headers={'Authorization': f'Bearer {token}'},
                timeout=10
            )
            print(f"   Status: {r.status_code}")
            print(f"   Response: {r.json()}")

        print("\n" + "=" * 50)
        print("✅ TESTES CONCLUÍDOS!")
        print("=" * 50)

    except Exception as e:
        print(f"\n❌ ERRO: {e}")
        import traceback
        traceback.print_exc()

    finally:
        print("\n7. Encerrando servidor...")
        proc.terminate()
        proc.wait()
        print("   OK!")

if __name__ == "__main__":
    main()

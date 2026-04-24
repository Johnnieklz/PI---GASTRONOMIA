import pytest
from fastapi.testclient import TestClient


def test_register_success(client: TestClient):
    """Test successful user registration."""
    response = client.post("/api/v1/auth/register", json={
        "email": "newuser@example.com",
        "username": "newuser",
        "password": "newpassword123",
        "full_name": "New User"
    })

    assert response.status_code == 201
    data = response.json()
    assert data["success"] is True
    assert data["data"]["email"] == "newuser@example.com"
    assert data["data"]["username"] == "newuser"
    assert "id" in data["data"]


def test_register_duplicate_email(client: TestClient, test_user):
    """Test registration with duplicate email."""
    response = client.post("/api/v1/auth/register", json={
        "email": "test@example.com",
        "username": "newuser2",
        "password": "newpassword123"
    })

    assert response.status_code == 409
    data = response.json()
    assert data["success"] is False


def test_register_duplicate_username(client: TestClient, test_user):
    """Test registration with duplicate username."""
    response = client.post("/api/v1/auth/register", json={
        "email": "newuser@example.com",
        "username": "testuser",
        "password": "newpassword123"
    })

    assert response.status_code == 409
    data = response.json()
    assert data["success"] is False


def test_login_success(client: TestClient, test_user):
    """Test successful login."""
    response = client.post("/api/v1/auth/login", json={
        "username": "test@example.com",
        "password": "testpassword"
    })

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "access_token" in data["data"]
    assert data["data"]["token_type"] == "bearer"


def test_login_with_username(client: TestClient, test_user):
    """Test login using username instead of email."""
    response = client.post("/api/v1/auth/login", json={
        "username": "testuser",
        "password": "testpassword"
    })

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "access_token" in data["data"]


def test_login_invalid_credentials(client: TestClient):
    """Test login with wrong password."""
    response = client.post("/api/v1/auth/login", json={
        "username": "test@example.com",
        "password": "wrongpassword"
    })

    assert response.status_code == 401
    data = response.json()
    assert data["success"] is False


def test_login_nonexistent_user(client: TestClient):
    """Test login for non-existent user."""
    response = client.post("/api/v1/auth/login", json={
        "username": "nonexistent@example.com",
        "password": "somepassword"
    })

    assert response.status_code == 401
    data = response.json()
    assert data["success"] is False


def test_protected_route_without_token(client: TestClient):
    """Test accessing protected route without token."""
    response = client.get("/api/v1/users/me")

    assert response.status_code == 401


def test_protected_route_with_token(authorized_client):
    """Test accessing protected route with valid token."""
    response = authorized_client.get("/api/v1/users/me")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "email" in data["data"]


def test_register_validation(client: TestClient):
    """Test registration with invalid data."""
    # Invalid email
    response = client.post("/api/v1/auth/register", json={
        "email": "not-an-email",
        "username": "user",
        "password": "123"
    })
    assert response.status_code == 422

    # Short password
    response = client.post("/api/v1/auth/register", json={
        "email": "user@example.com",
        "username": "user",
        "password": "123"
    })
    assert response.status_code == 422

    # Short username
    response = client.post("/api/v1/auth/register", json={
        "email": "user@example.com",
        "username": "ab",
        "password": "password123"
    })
    assert response.status_code == 422

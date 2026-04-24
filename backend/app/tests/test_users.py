import pytest
from fastapi.testclient import TestClient


def test_get_current_user(authorized_client, test_user):
    """Test getting current user profile."""
    response = authorized_client.get("/api/v1/users/me")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["email"] == "test@example.com"
    assert data["data"]["username"] == "testuser"
    assert "id" in data["data"]


def test_update_current_user(authorized_client):
    """Test updating current user profile."""
    response = authorized_client.put("/api/v1/users/me", json={
        "full_name": "Updated Name"
    })

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["full_name"] == "Updated Name"


def test_update_user_duplicate_email(authorized_client, test_superuser):
    """Test updating user with duplicate email."""
    # First update to a new email
    authorized_client.put("/api/v1/users/me", json={
        "email": "unique@example.com"
    })

    # Then try to update to existing superuser email
    response = authorized_client.put("/api/v1/users/me", json={
        "email": "admin@example.com"
    })

    assert response.status_code == 409
    data = response.json()
    assert data["success"] is False


def test_delete_current_user(client: TestClient, user_token):
    """Test deleting current user account."""
    client.headers = {"Authorization": f"Bearer {user_token}"}
    response = client.delete("/api/v1/users/me")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True

    # Verify user can't access protected routes anymore
    response = client.get("/api/v1/users/me")
    assert response.status_code == 401


def test_list_users_as_superuser(client: TestClient, test_superuser):
    """Test listing all users as superuser."""
    from app.core.security import create_access_token
    token = create_access_token(data={"sub": str(test_superuser.id), "email": test_superuser.email})

    client.headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/api/v1/users/")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "pagination" in data
    assert "data" in data


def test_list_users_as_normal_user(authorized_client):
    """Test that normal users can't list all users."""
    response = authorized_client.get("/api/v1/users/")

    assert response.status_code == 403
    data = response.json()
    assert data["success"] is False


def test_get_user_by_id(authorized_client, test_user):
    """Test getting user by ID."""
    response = authorized_client.get(f"/api/v1/users/{test_user.id}")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["id"] == test_user.id


def test_get_other_user_forbidden(authorized_client, test_superuser):
    """Test that users can't view other users."""
    response = authorized_client.get(f"/api/v1/users/{test_superuser.id}")

    assert response.status_code == 403

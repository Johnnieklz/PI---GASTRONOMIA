import pytest
from fastapi.testclient import TestClient


def test_create_product(authorized_client):
    """Test creating a new product."""
    response = authorized_client.post("/api/v1/products/", json={
        "name": "New Product",
        "description": "A brand new product",
        "price": 99.99,
        "stock": 5,
        "sku": "NEW-001"
    })

    assert response.status_code == 201
    data = response.json()
    assert data["success"] is True
    assert data["data"]["name"] == "New Product"
    assert data["data"]["price"] == 99.99
    assert "id" in data["data"]


def test_create_product_invalid_data(authorized_client):
    """Test creating product with invalid data."""
    # Negative price
    response = authorized_client.post("/api/v1/products/", json={
        "name": "Product",
        "price": -10,
        "stock": 5
    })
    assert response.status_code == 422

    # Negative stock
    response = authorized_client.post("/api/v1/products/", json={
        "name": "Product",
        "price": 10,
        "stock": -5
    })
    assert response.status_code == 422


def test_create_product_duplicate_sku(authorized_client, test_product):
    """Test creating product with duplicate SKU."""
    response = authorized_client.post("/api/v1/products/", json={
        "name": "Another Product",
        "price": 49.99,
        "sku": "TEST-001"
    })

    assert response.status_code == 409
    data = response.json()
    assert data["success"] is False


def test_list_products(authorized_client, test_product):
    """Test listing products."""
    response = authorized_client.get("/api/v1/products/")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "data" in data
    assert "pagination" in data
    assert len(data["data"]) >= 1


def test_list_my_products(authorized_client, test_product):
    """Test listing only current user's products."""
    response = authorized_client.get("/api/v1/products/?my_only=true")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    for product in data["data"]:
        assert product["owner_id"] == test_product.owner_id


def test_search_products(authorized_client, test_product):
    """Test searching products by name."""
    response = authorized_client.get(f"/api/v1/products/?search={test_product.name}")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert len(data["data"]) >= 1


def test_get_product_by_id(authorized_client, test_product):
    """Test getting product by ID."""
    response = authorized_client.get(f"/api/v1/products/{test_product.id}")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["id"] == test_product.id
    assert data["data"]["name"] == test_product.name


def test_get_product_not_found(authorized_client):
    """Test getting non-existent product."""
    response = authorized_client.get("/api/v1/products/99999")

    assert response.status_code == 404
    data = response.json()
    assert data["success"] is False


def test_update_product(authorized_client, test_product):
    """Test updating a product."""
    response = authorized_client.put(f"/api/v1/products/{test_product.id}", json={
        "name": "Updated Product Name",
        "price": 39.99
    })

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["name"] == "Updated Product Name"
    assert data["data"]["price"] == 39.99


def test_update_product_not_owner(client, test_product, test_superuser):
    """Test that only owner can update product."""
    from app.core.security import create_access_token
    token = create_access_token(data={"sub": str(test_superuser.id), "email": test_superuser.email})

    client.headers = {"Authorization": f"Bearer {token}"}
    response = client.put(f"/api/v1/products/{test_product.id}", json={
        "name": "Hacked Product"
    })

    assert response.status_code == 403
    data = response.json()
    assert data["success"] is False


def test_delete_product(authorized_client, test_product):
    """Test deleting a product."""
    response = authorized_client.delete(f"/api/v1/products/{test_product.id}")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True

    # Verify product is deleted
    response = authorized_client.get(f"/api/v1/products/{test_product.id}")
    assert response.status_code == 404


def test_delete_product_not_owner(client, test_product, test_superuser):
    """Test that only owner can delete product."""
    from app.core.security import create_access_token
    token = create_access_token(data={"sub": str(test_superuser.id), "email": test_superuser.email})

    client.headers = {"Authorization": f"Bearer {token}"}
    response = client.delete(f"/api/v1/products/{test_product.id}")

    assert response.status_code == 403


def test_product_pagination(authorized_client):
    """Test product listing pagination."""
    response = authorized_client.get("/api/v1/products/?skip=0&limit=5")

    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "pagination" in data
    assert data["pagination"]["per_page"] == 5

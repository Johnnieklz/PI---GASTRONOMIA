from typing import List, Optional
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.product_service import product_service
from app.models.user import User
from app.schemas.product import Product as ProductSchema, ProductCreate, ProductUpdate
from app.schemas.common import APIResponse
from app.core.security import get_current_active_user

router = APIRouter(prefix="/products", tags=["Products"])


@router.post("/", response_model=dict, status_code=status.HTTP_201_CREATED)
def create_product(
    product_data: ProductCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Create a new product.
    """
    product = product_service.create(db, product_data, current_user.id)
    return APIResponse.success(
        data={
            "id": product.id,
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "stock": product.stock,
            "sku": product.sku,
            "is_active": product.is_active,
            "owner_id": product.owner_id,
            "created_at": product.created_at.isoformat() if product.created_at else None
        },
        message="Product created successfully"
    )


@router.get("/", response_model=dict)
def list_products(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    search: Optional[str] = None,
    my_only: bool = Query(False, description="Show only current user's products"),
    active_only: bool = Query(False),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    List products with optional filters.
    """
    if my_only:
        products = product_service.get_by_owner(db, current_user.id, skip=skip, limit=limit)
        total = db.query(Product).filter(Product.owner_id == current_user.id).count()
    elif search:
        products = product_service.search(db, search, skip=skip, limit=limit)
        total = len(products)  # Simplified for search
    else:
        products = product_service.get_multi(db, skip=skip, limit=limit, active_only=active_only)
        query = db.query(Product)
        if active_only:
            query = query.filter(Product.is_active == True)
        total = query.count()

    products_data = []
    for product in products:
        products_data.append({
            "id": product.id,
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "stock": product.stock,
            "sku": product.sku,
            "is_active": product.is_active,
            "owner_id": product.owner_id,
            "created_at": product.created_at.isoformat() if product.created_at else None
        })

    return APIResponse.paginated(
        data=products_data,
        total=total,
        page=(skip // limit) + 1 if limit > 0 else 1,
        per_page=limit
    )


@router.get("/{product_id}", response_model=dict)
def get_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get product by ID.
    """
    from sqlalchemy.orm import joinedload
    product = db.query(Product).options(joinedload(Product.owner)).filter(Product.id == product_id).first()

    if not product:
        from app.core.exceptions import NotFoundException
        raise NotFoundException("Product")

    return APIResponse.success(
        data={
            "id": product.id,
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "stock": product.stock,
            "sku": product.sku,
            "is_active": product.is_active,
            "owner_id": product.owner_id,
            "owner": {
                "id": product.owner.id,
                "username": product.owner.username,
                "email": product.owner.email
            } if product.owner else None,
            "created_at": product.created_at.isoformat() if product.created_at else None
        },
        message="Product retrieved successfully"
    )


@router.put("/{product_id}", response_model=dict)
def update_product(
    product_id: int,
    product_data: ProductUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Update product by ID. Only owner or superuser can update.
    """
    product = product_service.update(db, product_id, product_data, current_user)
    return APIResponse.success(
        data={
            "id": product.id,
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "stock": product.stock,
            "sku": product.sku,
            "is_active": product.is_active,
            "updated_at": product.updated_at.isoformat() if product.updated_at else None
        },
        message="Product updated successfully"
    )


@router.delete("/{product_id}", response_model=dict)
def delete_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Delete product by ID. Only owner or superuser can delete.
    """
    product_service.delete(db, product_id, current_user)
    return APIResponse.success(message="Product deleted successfully")


from app.models.product import Product

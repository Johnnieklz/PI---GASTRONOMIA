from typing import List
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.user_service import user_service
from app.models.user import User
from app.schemas.user import User as UserSchema, UserCreate, UserUpdate, UserProfile
from app.schemas.common import APIResponse, PaginatedResponse
from app.core.security import get_current_active_user
from app.core.exceptions import ForbiddenException

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/me", response_model=dict)
def get_current_user_profile(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Get current authenticated user profile.
    """
    from app.repositories.product_repository import product_repository
    products_count = product_repository.count_by_owner(db, current_user.id)

    user_data = {
        "id": current_user.id,
        "email": current_user.email,
        "username": current_user.username,
        "full_name": current_user.full_name,
        "is_active": current_user.is_active,
        "is_superuser": current_user.is_superuser,
        "created_at": current_user.created_at.isoformat() if current_user.created_at else None,
        "updated_at": current_user.updated_at.isoformat() if current_user.updated_at else None,
        "products_count": products_count
    }

    return APIResponse.success(data=user_data, message="Profile retrieved successfully")


@router.get("/{user_id}", response_model=dict)
def get_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get user by ID.
    """
    if not current_user.is_superuser and current_user.id != user_id:
        raise ForbiddenException("Not authorized to view this user")

    user = user_service.get_by_id(db, user_id)
    return APIResponse.success(
        data={
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "full_name": user.full_name,
            "is_active": user.is_active,
            "created_at": user.created_at.isoformat() if user.created_at else None
        },
        message="User retrieved successfully"
    )


@router.get("/", response_model=dict)
def list_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    List all users. Superuser only.
    """
    if not current_user.is_superuser:
        raise ForbiddenException("Not authorized to list all users")

    users = user_service.get_multi(db, skip=skip, limit=limit)
    total = db.query(User).count()

    users_data = []
    for user in users:
        users_data.append({
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "full_name": user.full_name,
            "is_active": user.is_active,
            "created_at": user.created_at.isoformat() if user.created_at else None
        })

    return APIResponse.paginated(
        data=users_data,
        total=total,
        page=(skip // limit) + 1 if limit > 0 else 1,
        per_page=limit
    )


@router.put("/me", response_model=dict)
def update_current_user(
    user_data: UserUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Update current user profile.
    """
    updated_user = user_service.update(db, current_user.id, user_data)
    return APIResponse.success(
        data={
            "id": updated_user.id,
            "email": updated_user.email,
            "username": updated_user.username,
            "full_name": updated_user.full_name,
            "is_active": updated_user.is_active
        },
        message="Profile updated successfully"
    )


@router.delete("/me", response_model=dict)
def delete_current_user(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Delete current user account.
    """
    user_service.delete(db, current_user.id)
    return APIResponse.success(message="User deleted successfully")

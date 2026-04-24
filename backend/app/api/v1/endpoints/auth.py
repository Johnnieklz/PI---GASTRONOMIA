from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.auth_service import auth_service
from app.schemas.auth import LoginRequest, RegisterRequest, Token, LoginResponse
from app.schemas.common import APIResponse
from app.core.exceptions import UnauthorizedException

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/login", response_model=dict, status_code=status.HTTP_200_OK)
def login(
    login_data: LoginRequest,
    db: Session = Depends(get_db)
):
    """
    Authenticate user and return JWT token.
    Username can be email or username.
    """
    result = auth_service.login(db, login_data)
    return APIResponse.success(
        data={
            "access_token": result["access_token"],
            "token_type": result["token_type"],
            "expires_in": result["expires_in"]
        },
        message="Login successful"
    )


@router.post("/register", response_model=dict, status_code=status.HTTP_201_CREATED)
def register(
    register_data: RegisterRequest,
    db: Session = Depends(get_db)
):
    """
    Register a new user account.
    """
    user = auth_service.register(db, register_data)
    return APIResponse.success(
        data={
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "full_name": user.full_name,
            "is_active": user.is_active
        },
        message="User registered successfully"
    )

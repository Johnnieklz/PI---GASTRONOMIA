from datetime import timedelta
from typing import Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.core.security import verify_password, create_access_token, get_password_hash
from app.core.config import settings
from app.repositories.user_repository import user_repository
from app.schemas.auth import LoginRequest, RegisterRequest
from app.models.user import User
from app.core.exceptions import UnauthorizedException, ConflictException


class AuthService:
    @staticmethod
    def authenticate(db: Session, login_data: LoginRequest) -> Optional[User]:
        user = user_repository.get_by_email_or_username(db, login_data.username)

        if not user:
            return None

        if not user.is_active:
            raise UnauthorizedException("User account is deactivated")

        if not verify_password(login_data.password, user.hashed_password):
            return None

        return user

    @staticmethod
    def login(db: Session, login_data: LoginRequest) -> dict:
        user = AuthService.authenticate(db, login_data)

        if not user:
            raise UnauthorizedException("Invalid credentials")

        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": str(user.id), "email": user.email},
            expires_delta=access_token_expires
        )

        return {
            "access_token": access_token,
            "token_type": "bearer",
            "expires_in": settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60,
            "user": user
        }

    @staticmethod
    def register(db: Session, register_data: RegisterRequest) -> User:
        if user_repository.is_email_taken(db, register_data.email):
            raise ConflictException("Email already registered")

        if user_repository.is_username_taken(db, register_data.username):
            raise ConflictException("Username already taken")

        hashed_password = get_password_hash(register_data.password)

        user_data = {
            "email": register_data.email,
            "username": register_data.username,
            "hashed_password": hashed_password,
            "full_name": register_data.full_name,
            "is_active": True,
            "is_superuser": False
        }

        return user_repository.create(db, obj_in=user_data)


auth_service = AuthService()

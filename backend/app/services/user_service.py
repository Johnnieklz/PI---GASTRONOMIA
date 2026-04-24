from typing import List, Optional
from sqlalchemy.orm import Session

from app.core.security import get_password_hash, verify_password
from app.repositories.user_repository import user_repository
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate, UserPasswordUpdate
from app.core.exceptions import NotFoundException, ConflictException, UnauthorizedException


class UserService:
    @staticmethod
    def get_by_id(db: Session, user_id: int) -> User:
        user = user_repository.get_by_id(db, user_id)
        if not user:
            raise NotFoundException("User")
        return user

    @staticmethod
    def get_by_email(db: Session, email: str) -> Optional[User]:
        return user_repository.get_by_email(db, email)

    @staticmethod
    def get_multi(db: Session, skip: int = 0, limit: int = 100) -> List[User]:
        return user_repository.get_multi(db, skip=skip, limit=limit)

    @staticmethod
    def create(db: Session, user_data: UserCreate) -> User:
        if user_repository.is_email_taken(db, user_data.email):
            raise ConflictException("Email already registered")

        if user_repository.is_username_taken(db, user_data.username):
            raise ConflictException("Username already taken")

        user_dict = user_data.model_dump()
        user_dict["hashed_password"] = get_password_hash(user_dict.pop("password"))
        user_dict["is_active"] = True
        user_dict["is_superuser"] = False

        return user_repository.create(db, obj_in=user_dict)

    @staticmethod
    def update(db: Session, user_id: int, user_data: UserUpdate) -> User:
        user = user_repository.get_by_id(db, user_id)
        if not user:
            raise NotFoundException("User")

        update_data = user_data.model_dump(exclude_unset=True)

        if "email" in update_data:
            if user_repository.is_email_taken(db, update_data["email"], exclude_id=user_id):
                raise ConflictException("Email already registered")

        if "username" in update_data:
            if user_repository.is_username_taken(db, update_data["username"], exclude_id=user_id):
                raise ConflictException("Username already taken")

        return user_repository.update(db, db_obj=user, obj_in=update_data)

    @staticmethod
    def delete(db: Session, user_id: int) -> bool:
        user = user_repository.get_by_id(db, user_id)
        if not user:
            raise NotFoundException("User")
        return user_repository.delete(db, id=user_id)

    @staticmethod
    def update_password(db: Session, user_id: int, password_data: UserPasswordUpdate) -> User:
        user = user_repository.get_by_id(db, user_id)
        if not user:
            raise NotFoundException("User")

        if not verify_password(password_data.current_password, user.hashed_password):
            raise UnauthorizedException("Current password is incorrect")

        hashed_password = get_password_hash(password_data.new_password)
        return user_repository.update(db, db_obj=user, obj_in={"hashed_password": hashed_password})

    @staticmethod
    def deactivate(db: Session, user_id: int) -> User:
        user = user_repository.get_by_id(db, user_id)
        if not user:
            raise NotFoundException("User")
        return user_repository.update(db, db_obj=user, obj_in={"is_active": False})


user_service = UserService()

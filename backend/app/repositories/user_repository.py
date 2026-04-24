from typing import Optional, List
from sqlalchemy.orm import Session
from sqlalchemy import or_

from app.models.user import User
from app.repositories.base_repository import BaseRepository


class UserRepository(BaseRepository[User]):
    def __init__(self):
        super().__init__(User)

    def get_by_email(self, db: Session, email: str) -> Optional[User]:
        return db.query(User).filter(User.email == email).first()

    def get_by_username(self, db: Session, username: str) -> Optional[User]:
        return db.query(User).filter(User.username == username).first()

    def get_by_email_or_username(self, db: Session, login: str) -> Optional[User]:
        return db.query(User).filter(
            or_(User.email == login, User.username == login)
        ).first()

    def is_email_taken(self, db: Session, email: str, exclude_id: int = None) -> bool:
        query = db.query(User).filter(User.email == email)
        if exclude_id:
            query = query.filter(User.id != exclude_id)
        return query.first() is not None

    def is_username_taken(self, db: Session, username: str, exclude_id: int = None) -> bool:
        query = db.query(User).filter(User.username == username)
        if exclude_id:
            query = query.filter(User.id != exclude_id)
        return query.first() is not None


user_repository = UserRepository()

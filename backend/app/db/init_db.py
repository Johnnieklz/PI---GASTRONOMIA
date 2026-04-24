from sqlalchemy.orm import Session
from app.db.base import engine, Base
from app.core.security import get_password_hash
# Importar todas as models para garantir que as tabelas sejam criadas
from app.models.user import User
from app.models.product import Product


def init_db():
    """Create database tables."""
    # Importar models garante que elas sejam registradas no metadata
    Base.metadata.create_all(bind=engine)


def create_first_superuser(db: Session, email: str, password: str, username: str):
    """Create first superuser if not exists."""
    user = db.query(User).filter(User.email == email).first()
    if not user:
        user = User(
            email=email,
            username=username,
            hashed_password=get_password_hash(password),
            full_name="Admin",
            is_active=True,
            is_superuser=True
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        print(f"Superuser {email} created")
    return user


if __name__ == "__main__":
    init_db()
    print("Database initialized")

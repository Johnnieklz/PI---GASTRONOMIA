from typing import Optional, List
from sqlalchemy.orm import Session
from sqlalchemy import desc, asc

from app.models.product import Product
from app.repositories.base_repository import BaseRepository


class ProductRepository(BaseRepository[Product]):
    def __init__(self):
        super().__init__(Product)

    def get_by_owner(
        self,
        db: Session,
        owner_id: int,
        skip: int = 0,
        limit: int = 100
    ) -> List[Product]:
        return db.query(Product).filter(
            Product.owner_id == owner_id
        ).offset(skip).limit(limit).all()

    def get_by_sku(self, db: Session, sku: str) -> Optional[Product]:
        return db.query(Product).filter(Product.sku == sku).first()

    def get_active(self, db: Session, skip: int = 0, limit: int = 100) -> List[Product]:
        return db.query(Product).filter(
            Product.is_active == True
        ).offset(skip).limit(limit).all()

    def search_by_name(self, db: Session, name: str, skip: int = 0, limit: int = 100) -> List[Product]:
        return db.query(Product).filter(
            Product.name.ilike(f"%{name}%")
        ).offset(skip).limit(limit).all()

    def count_by_owner(self, db: Session, owner_id: int) -> int:
        return db.query(Product).filter(Product.owner_id == owner_id).count()

    def is_sku_taken(self, db: Session, sku: str, exclude_id: int = None) -> bool:
        query = db.query(Product).filter(Product.sku == sku)
        if exclude_id:
            query = query.filter(Product.id != exclude_id)
        return query.first() is not None


product_repository = ProductRepository()

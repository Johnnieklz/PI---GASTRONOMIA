from typing import List, Optional
from sqlalchemy.orm import Session

from app.repositories.product_repository import product_repository
from app.repositories.user_repository import user_repository
from app.models.product import Product
from app.models.user import User
from app.schemas.product import ProductCreate, ProductUpdate
from app.core.exceptions import NotFoundException, ConflictException, ForbiddenException


class ProductService:
    @staticmethod
    def get_by_id(db: Session, product_id: int) -> Product:
        product = product_repository.get_by_id(db, product_id)
        if not product:
            raise NotFoundException("Product")
        return product

    @staticmethod
    def get_multi(
        db: Session,
        skip: int = 0,
        limit: int = 100,
        active_only: bool = False
    ) -> List[Product]:
        if active_only:
            return product_repository.get_active(db, skip=skip, limit=limit)
        return product_repository.get_multi(db, skip=skip, limit=limit)

    @staticmethod
    def get_by_owner(
        db: Session,
        owner_id: int,
        skip: int = 0,
        limit: int = 100
    ) -> List[Product]:
        return product_repository.get_by_owner(db, owner_id, skip=skip, limit=limit)

    @staticmethod
    def create(db: Session, product_data: ProductCreate, owner_id: int) -> Product:
        owner = user_repository.get_by_id(db, owner_id)
        if not owner:
            raise NotFoundException("User")

        if product_data.sku and product_repository.is_sku_taken(db, product_data.sku):
            raise ConflictException("SKU already exists")

        product_dict = product_data.model_dump()
        product_dict["owner_id"] = owner_id

        return product_repository.create(db, obj_in=product_dict)

    @staticmethod
    def update(
        db: Session,
        product_id: int,
        product_data: ProductUpdate,
        current_user: User
    ) -> Product:
        product = product_repository.get_by_id(db, product_id)
        if not product:
            raise NotFoundException("Product")

        if product.owner_id != current_user.id and not current_user.is_superuser:
            raise ForbiddenException("Not authorized to update this product")

        update_data = product_data.model_dump(exclude_unset=True)

        if "sku" in update_data and update_data["sku"]:
            if product_repository.is_sku_taken(db, update_data["sku"], exclude_id=product_id):
                raise ConflictException("SKU already exists")

        return product_repository.update(db, db_obj=product, obj_in=update_data)

    @staticmethod
    def delete(db: Session, product_id: int, current_user: User) -> bool:
        product = product_repository.get_by_id(db, product_id)
        if not product:
            raise NotFoundException("Product")

        if product.owner_id != current_user.id and not current_user.is_superuser:
            raise ForbiddenException("Not authorized to delete this product")

        return product_repository.delete(db, id=product_id)

    @staticmethod
    def search(db: Session, name: str, skip: int = 0, limit: int = 100) -> List[Product]:
        return product_repository.search_by_name(db, name, skip=skip, limit=limit)


product_service = ProductService()

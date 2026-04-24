from typing import Generic, TypeVar, Optional, List, Dict, Any
from pydantic import BaseModel, Field

T = TypeVar("T")


class ResponseWrapper(BaseModel, Generic[T]):
    success: bool = True
    message: str = "Success"
    data: Optional[T] = None
    meta: Optional[Dict[str, Any]] = None


class PaginationMeta(BaseModel):
    total: int
    page: int
    per_page: int
    total_pages: int
    has_next: bool
    has_prev: bool


class PaginatedResponse(BaseModel, Generic[T]):
    success: bool = True
    message: str = "Success"
    data: List[T]
    pagination: PaginationMeta


class ErrorResponse(BaseModel):
    success: bool = False
    message: str
    errors: Optional[Dict[str, Any]] = None
    code: Optional[str] = None


class APIResponse:
    @staticmethod
    def success(data: Any = None, message: str = "Success", meta: Dict = None):
        return {
            "success": True,
            "message": message,
            "data": data,
            "meta": meta
        }

    @staticmethod
    def error(message: str, errors: Dict = None, code: str = None):
        return {
            "success": False,
            "message": message,
            "errors": errors,
            "code": code
        }

    @staticmethod
    def paginated(data: List, total: int, page: int, per_page: int):
        total_pages = (total + per_page - 1) // per_page if per_page > 0 else 0

        return {
            "success": True,
            "message": "Success",
            "data": data,
            "pagination": {
                "total": total,
                "page": page,
                "per_page": per_page,
                "total_pages": total_pages,
                "has_next": page < total_pages,
                "has_prev": page > 1
            }
        }

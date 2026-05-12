from typing import List
from pydantic_settings import BaseSettings
import os


class Settings(BaseSettings):
    PROJECT_NAME: str = "FastAPI Backend"
    VERSION: str = "1.0.0"
    DEBUG: bool = False

    # Database
    DATABASE_URL: str = "sqlite:///./app.db"

    # Security
    SECRET_KEY: str = "your-super-secret-key-change-this-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # CORS - Permitir origens do Flutter Web e desenvolvimento
    BACKEND_CORS_ORIGINS: str = (
        "http://localhost:3000,http://localhost:5173,http://localhost:8080,"
        "http://127.0.0.1:8080,http://frontend,http://frontend:80,"
        "http://localhost:80,http://localhost,*"
    )

    @property
    def cors_origins(self) -> List[str]:
        import json

        if isinstance(self.BACKEND_CORS_ORIGINS, str):
            value = self.BACKEND_CORS_ORIGINS.strip()
            if not value:
                return []

            try:
                return json.loads(value)
            except json.JSONDecodeError:
                return [i.strip() for i in value.split(",") if i.strip()]

        return self.BACKEND_CORS_ORIGINS

    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()

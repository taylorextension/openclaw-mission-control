FROM python:3.11-slim
WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar arquivos de dependências
COPY backend/pyproject.toml backend/uv.lock ./

# Instalar dependências Python
RUN pip install uv && uv pip install --system -r pyproject.toml

# Copiar código backend
COPY backend/ ./backend/

EXPOSE 8000

CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]

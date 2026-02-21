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

# Healthcheck mais tolerante
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=5 \
    CMD curl -f http://localhost:8000/healthz || exit 1

EXPOSE 8000

# Comando com mais logs para debug
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000", "--log-level", "info"]

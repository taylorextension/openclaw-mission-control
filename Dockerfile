FROM python:3.11-slim
WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client curl \
    && rm -rf /var/lib/apt/lists/*

# Variáveis de ambiente padrão
ENV AUTH_MODE=local
ENV LOCAL_AUTH_TOKEN=k1vPxUkx7rrKtPXeszrZzFJgP5oBZa3pXkwR5gp4CdkVaMXTYHqK/w==
ENV CORS_ORIGINS=*
ENV DB_AUTO_MIGRATE=false
ENV LOG_LEVEL=info

# Copiar arquivos de dependências
COPY backend/pyproject.toml backend/uv.lock ./

# Instalar dependências Python
RUN pip install uv && uv pip install --system -r pyproject.toml

# Copiar código backend
COPY backend/ ./backend/

# Copiar script de inicialização
COPY start.sh ./
RUN chmod +x start.sh

# Healthcheck
HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=10 \
    CMD curl -f http://localhost:8000/healthz || exit 1

EXPOSE 8000

CMD ["./start.sh"]

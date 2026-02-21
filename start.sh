#!/bin/bash
set -e

echo "🚀 Iniciando Mission Control..."
echo "📍 Diretório: $(pwd)"
ls -la

# Verificar se DATABASE_URL está definido
if [ -z "$DATABASE_URL" ]; then
    echo "⚠️  DATABASE_URL não definido. Usando SQLite temporário..."
    export DATABASE_URL="sqlite:///./tmp.db"
fi

echo "📊 Banco: $DATABASE_URL"
echo "🔑 Auth: $AUTH_MODE"

# Verificar estrutura
echo "📁 Conteúdo de /app:"
ls -la /app/

echo "📁 Conteúdo de /app/backend:"
ls -la /app/backend/ 2>/dev/null || echo "Diretório backend não encontrado!"

# Iniciar uvicorn com o caminho correto
cd /app/backend
exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --log-level info

#!/bin/bash
set -e

echo "🚀 Iniciando Mission Control..."

# Verificar se DATABASE_URL está definido
if [ -z "$DATABASE_URL" ]; then
    echo "⚠️  DATABASE_URL não definido. Usando SQLite temporário..."
    export DATABASE_URL="sqlite:///./tmp.db"
fi

echo "📊 Banco: $DATABASE_URL"
echo "🔑 Auth: $AUTH_MODE"

# Iniciar uvicorn
exec uvicorn backend.main:app --host 0.0.0.0 --port 8000 --log-level info

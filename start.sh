#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

(cd "$ROOT/CrisisConnect-Backend" && npm run start:dev) &
BACKEND_PID=$!

(cd "$ROOT/crisisconnect-frontend" && npm run dev) &
FRONTEND_PID=$!

trap 'kill "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null' INT TERM EXIT

wait

# CrisisConnect

A crisis relief coordination platform connecting NGOs, admins, volunteers,
and donors. NestJS + TypeORM + PostgreSQL backend, Next.js (App Router)
frontend.

## Repo layout

This repo ties together two separate projects as git submodules:

- [`CrisisConnect-Backend`](https://github.com/Rezwoan/CrisisConnect-Backend) — NestJS API (`http://localhost:3000`)
- [`crisisconnect-frontend`](https://github.com/Rezwoan/CrisisConnect-Frontend) — Next.js frontend (`http://localhost:7000`)

Cloning fresh? Pull the submodule contents too:

```bash
git clone --recurse-submodules https://github.com/Rezwoan/CrisisConnect.git
```

Already cloned without that flag:

```bash
git submodule update --init --recursive
```

## Setup

1. Backend — see `CrisisConnect-Backend/AGENTS.md` for full setup, and load
   `CrisisConnect-Backend/schema.sql` into Postgres before first run.
2. Frontend — set `NEXT_PUBLIC_API_ENDPOINT=http://localhost:3000` in
   `crisisconnect-frontend/.env`.
3. Install dependencies in each folder with `npm install`.

## Running

Start both dev servers at once from the repo root:

```bash
./start.sh      # macOS/Linux
start.bat       # Windows
```

Or run each independently with `npm run start:dev` (backend) / `npm run dev`
(frontend).

## Roles

Four independently-built roles share the same backend and unified
login/registration flow: **NGO**, **Admin**, **Volunteer**, **Donor**.

## Other files

- `test_data_tui.py` — local TUI for seeding test volunteer applications
  and donations against the dev database (see the file's docstring for
  usage; requires `psycopg2-binary`).
- `db_backups/` — local Postgres dumps.
- `Final Project - Defense Guide.pdf` — course defense guide.

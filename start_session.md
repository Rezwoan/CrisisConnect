# CrisisConnect — Start-of-Session Briefing

Read this before touching anything. It's the orientation doc for whichever
agent/session starts at this root (`E:\CrisisConnect\`). This file lives
outside both git repos on purpose — it's local-only, never pushed anywhere.

## What this is

CrisisConnect is a 4-person university team project (NestJS + TypeORM +
PostgreSQL backend, Next.js App Router frontend). Four roles — **NGO,
Admin, Volunteer, Donor** — each graded independently on the same rubric
(Axios/CSR/SSR counts, routing, Tailwind layout, auth). Each role is a
different real teammate, building against their own slice of one shared
backend.

The user you're working with (Rezwoan) owns the **NGO** role only. Treat
Admin/Volunteer/Donor as other people's code — see "Ownership rules" below.

## Repo layout

- `CrisisConnect-Backend/` — NestJS API. GitHub: `Rezwoan/CrisisConnect-Backend`.
- `crisisconnect-frontend/` — Next.js frontend. GitHub: `Rezwoan/CrisisConnect-Frontend`.
- `start.sh` / `start.bat` — runs both dev servers at once from this root.
- Backend: `http://localhost:3000`. Frontend: `http://localhost:7000`
  (hardcoded `--port 7000` in `package.json`). Frontend's `.env`
  (gitignored) has `NEXT_PUBLIC_API_ENDPOINT=http://localhost:3000`.

## Read these next, in this order

1. `CrisisConnect-Backend/AGENTS.md` — setup steps, project rules, known
   TypeORM gotchas.
2. `CrisisConnect-Backend/schema.sql` — full DB schema dump; load it with
   `psql` before first run instead of relying on `synchronize` to build it.
3. `crisisconnect-frontend/CONSTRAINTS.md` and `CODINGSTYLE.md` — hard
   rules for how frontend code must look.
4. `crisisconnect-frontend/final-project-plans/README.md` — the unified
   login/registration architecture (see below), then your role's own
   `final-project-plans/<role>/PLAN.md`.

Both repos also carry a `memory.md` (gitignored, backend) and similar local
working notes — background only, never authoritative over the actual course
material or over what's in this file.

## The branch trap — read this before checking out anything

On **both** repos, `main` is the actually-current branch. The
individually-named branches (`admin`, `volunteer`, `donor`, `ngo`, `dev`)
are stale snapshots left over from before each teammate's PR got merged
back into `main` — they're missing real, already-merged work. Always work
off `main` unless the user explicitly says otherwise. Don't assume a
role's own branch reflects that role's current code — check `main` instead
(`git log --oneline -- src/<role>/` if you need to confirm what's real).

## Ownership rules (both repos)

- **Own-folder-only.** Backend: each role edits only `src/<role>/`.
  Frontend: each role edits only `app/<role>/`. Reading another role's
  entity/data via `forFeature` (backend) or calling another role's public
  endpoint (frontend) is fine; editing their files is not.
- Don't add features, guards, or policy to another role's code just because
  a stated requirement seems to imply it — implement only the part that's
  genuinely shared/common, and leave the rest as a note in that role's own
  plan doc, phrased as their choice.
- Exception: if something on `main` is broken for *everyone* (a bad merge,
  a schema mismatch that crashes the app on boot), a minimal, non-destructive
  fix is fair game — e.g. `Volunteer.email`/`password` were made `nullable:
  true` because a teammate's commit added them as required columns the live
  DB never got, crashing `synchronize` for the whole app. Fix only what's
  broken; leave the actual design to the owner.
- Root/shared frontend files (`app/layout.tsx`, `app/page.tsx`, `app/login`,
  `app/register`, `components/`, `globals.css`) — same rule: don't touch
  unless the change is genuinely needed for every role, not just yours.

## The unified auth flow (frontend, all roles)

- `app/login` and `app/register` are **shared** — the only cross-role
  frontend code. `/login` takes email+password, calls `GET
  /auth/role?email=...` (a small shared backend endpoint that looks the
  email up in the `user` table) to find the role, then posts the exact
  `{ email, password }` straight to that role's own `POST /<role>/login` —
  untouched, nothing pre-checked. If the response has an `accessToken` it
  logs the user in immediately (`/<role>/dashboard`); if not, it stores
  `email` in `localStorage` and hands off to `/<role>/login`.
- `/register` is just links to `/<role>/register` for NGO, Volunteer, Donor
  (not Admin — admins aren't self-registered).
- Every role has `app/<role>/login/page.tsx`, `app/<role>/register/page.tsx`,
  `app/<role>/dashboard/page.tsx`. **NGO's are fully built** (real OTP flow:
  register → verify-signup → login → login-code → dashboard). The other
  three are empty base files, ready for whoever owns that role.
- Whether a role uses OTP is entirely that role's own backend's choice —
  the shared layer doesn't assume either way.
- No cookies, no Next.js middleware. Auth token lives in `localStorage`,
  attached as `Authorization: Bearer <token>` only from Client Components.
  This means genuine SSR (a Server Component fetching guarded data) is
  impossible — each role unguards exactly one "browse" GET route on its own
  backend so there's something public to SSR from (see the backend AGENTS.md
  and the plan README for the exact reasoning).

## Current real backend state (as of `main`)

- **NGO** (`src/ngo/`) — fully built, OTP included, real DB-tested.
- **Admin** (`src/admin/`) — fully built, OTP included.
- **Volunteer** (`src/volunteer/`) — fully built, OTP included, but the
  auth code is messier than the others (stores `email`/`password` directly
  on the `Volunteer` entity instead of only on the shared `user` table).
  Not refactored — see "Ownership rules" above.
- **Donor** (`src/donor/`) — still just the starter stub (`GET /donor`
  health check). Needs building from scratch; see its plan doc.

## Hard rules, no exceptions

- **Never mention AI/Claude/Anthropic in anything committed to either
  repo** — code, comments, commit messages, docs. Both repos are shown to
  faculty. This file is the only place that's exempt, since it never gets
  pushed.
- **Never add an AI co-author/session-link trailer to a commit or PR, in
  any project** — plain `git commit -m "..."`, one line, no trailer. This
  is a standing rule from the user, not specific to CrisisConnect.
- Simple, lecture-shaped code only — no generics, no transactions, no
  custom decorators/interceptors, no abstractions beyond what's taught. If
  it's not something you could point at in the course slides, say so
  plainly rather than pretending it's taught material (JWT sign/verify is
  the standing example of an honest exception).
- Axios only, never `fetch`, on the frontend.
- Commit messages: one line, no trailer, no multi-paragraph body — matches
  both repos' existing history.

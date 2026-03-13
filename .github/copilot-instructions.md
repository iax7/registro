# Registro — Project Guidelines

## Domain

Event registry and guest management system. Admins create **Events**; users register and manage **Guests** under a **Registry**, tracking food/transport/lodging preferences and **Payments**. Includes badge generation, CSV/PDF reports, and an admin panel with statistics.

## Stack

| Layer     | Technology                                                |
| --------- | --------------------------------------------------------- |
| Language  | Ruby 4.0 (managed via [mise.toml](../mise.toml))          |
| Framework | Rails 8.1 (Propshaft, Solid Queue/Cache/Cable)            |
| Database  | PostgreSQL — uses `citext`, `unaccent`, JSONB             |
| Views     | **HAML** (not ERB)                                        |
| Frontend  | Hotwire (Turbo + Stimulus), Bootstrap 5                   |
| JS build  | esbuild via `jsbundling-rails`                            |
| CSS build | Sass → PostCSS/autoprefixer via `cssbundling-rails` + bun |
| Node      | 24 (managed via mise) — package manager: **npm**          |
| Reports   | ThinReports (`.tlf` templates in `app/reports/`)          |

## Architecture

**Authentication — two separate layers:**

- **UI routes**: session-based (`session[:user_id]`, `session[:is_admin]`). Helpers `confirm_logged_in` / `require_admin` in `ApplicationController`.
- **API routes** (`/api/v1/`): HTTP Basic Auth enforced in `ApiController < ActionController::API`.
- **JWT tokens**: `lib/auth.rb` issues HS256 tokens (used for passwordless guest links).

**Thread-local context:** `Current < ActiveSupport::CurrentAttributes` exposes `Current.user` and `Current.event`. Set these before any domain logic, never pass them as arguments.

**Controller layout:**

- `ApplicationController` — session auth helpers, `before_action :confirm_logged_in`
- `ApiController` — stateless, Basic Auth, JSON responses only
- Nested resources: `registries` → `guests` (see [config/routes.rb](../config/routes.rb))

**Models of note:**

- `Guest` — 40+ abbreviated columns (`f_v1`, `t_d2`, `l_room`, `fu_v1`). These are intentional — check [docs/db.md](../docs/db.md) or [docs/db.dbml](../docs/db.dbml) before adding new fields.
- `Event` — stores flexible settings and statistics as JSONB (`settings`, `statistics`).
- `Totals` — non-AR model in `app/models/totals.rb` backed by `lib/totals_helper.rb`.

## Build & Test

Use `just` commands (see [justfile](../justfile)):

```bash
just setup        # full setup for a new dev (mise + bundle + npm + db:prepare)
just dev          # start development server (web + js + css)
just test         # run Rails tests (minitest)
just test-system  # Capybara + Selenium system tests
just test-all     # all tests + seeds
just lint         # RuboCop
just lint-fix     # RuboCop --autocorrect
just security     # Brakeman + bundler-audit
just ci           # full CI pipeline (bin/ci)
```

Direct commands when needed:

```bash
bin/rails test                           # unit tests
bin/rails test:system                    # system tests
bin/rubocop                              # linter
bin/brakeman --quiet --no-pager          # security scan
RAILS_ENV=test bin/rails db:seed:replant # verify seeds
```

> **Note:** `spec/` exists from a previous RSpec setup. New tests go in `test/` using **minitest**. CI runs `bin/rails test`, not `rspec`.

## Conventions

- **Language:** All code, comments, variable names, commit messages, and documentation must be written in **English**.
- **Views are HAML.** Always generate `.html.haml`, never `.html.erb`.
- **Double-quoted strings** everywhere — enforced by RuboCop.
- **No frozen string literal comments** — disabled project-wide.
- RuboCop only lints `app/` — `bin/`, `config/`, `db/`, `lib/`, `spec/` are excluded.
- **Credentials:** sensitive config lives in `config/credentials.yml.enc`. App metadata (author, social IDs, URLs) is in [config/initializers/01_config.rb](../config/initializers/01_config.rb).
- **Environment variables:** use `.env` (via `dotenv-rails`). Copy from `.env.template` for new setups.
- **Conventional Commits** enforced (`feat:`, `fix:`, `chore:`, etc.).
- Database uses PostgreSQL `unaccent` extension for accent-insensitive searches — see `lib/unaccent.rb`.

## Key Files

| File/Directory                          | Purpose                                       |
| --------------------------------------- | --------------------------------------------- |
| [config/routes.rb](../config/routes.rb) | Full routing — API, nested resources, reports |
| [docs/db.md](../docs/db.md)             | Database schema documentation                 |
| [docs/db.dbml](../docs/db.dbml)         | DBML source for schema diagrams               |
| [lib/queries.rb](../lib/queries.rb)     | Reusable query objects                        |
| [lib/auth.rb](../lib/auth.rb)           | JWT logic                                     |
| [app/reports/](../app/reports/)         | ThinReports `.tlf` badge templates            |
| [justfile](../justfile)                 | All development commands                      |

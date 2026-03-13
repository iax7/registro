# justfile — registro
# Requires: https://github.com/casey/just
#
# Usage:
#   just          → list all commands
#   just <recipe> → run a command

set dotenv-load := true

# List all available commands (default)
default:
    @just --list

# ─────────────────────────────────────────────
# dev
# ─────────────────────────────────────────────

# Start the development server (web + js + css)
[group('dev')]
dev:
    bin/dev

# Start only the Rails server
[group('dev')]
server:
    bin/rails server

# Open the Rails console
[group('dev')]
console:
    bin/rails console

# Show application routes
[group('dev')]
routes *ARGS:
    bin/rails routes {{ ARGS }}

# Create the database, run migrations, and load seeds
[group('dev')]
db-setup:
    bin/rails db:prepare
    bin/rails db:seed

# Run pending migrations
[group('dev')]
db-migrate:
    bin/rails db:migrate

# Revert the last migration
[group('dev')]
db-rollback:
    bin/rails db:rollback

# Reset the DB (drop + create + migrate + seed)
[group('dev')]
db-reset:
    bin/rails db:reset

# ─────────────────────────────────────────────
# setup
# ─────────────────────────────────────────────

# Install system dependencies (detects Arch, Debian/Ubuntu, or Fedora)
[group('setup')]
sys-deps:
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v brew &>/dev/null; then
        echo "==> Detected Homebrew — using brew"
        brew install openssl@3 readline libyaml gmp autoconf rust
    elif command -v pacman &>/dev/null; then
        echo "==> Detected Arch Linux — using pacman"
        sudo pacman -Sy --needed base-devel rust libffi libyaml openssl zlib postgresql-libs
    elif command -v apt-get &>/dev/null; then
        echo "==> Detected Debian/Ubuntu — using apt-get"
        sudo apt-get install -y install build-essential autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev rustc libpq-dev
    elif command -v dnf &>/dev/null; then
        echo "==> Detected Fedora — using dnf"
        sudo dnf install -y autoconf gcc rust patch make bzip2 openssl-devel libyaml-devel libffi-devel readline-devel gdbm-devel ncurses-devel perl-FindBin postgresql-devel
    else
        echo "ERROR: Unsupported package manager. Install dependencies manually."
        echo "See: https://github.com/rbenv/ruby-build/wiki"
        exit 1
    fi

# Full setup for a new developer
[group('setup')]
setup:
    @echo "==> Installing tools (mise) ..."
    mise install
    @echo "==> Installing gems ..."
    bundle install
    @echo "==> Installing Node packages ..."
    npm install
    @echo "==> Preparing database ..."
    bin/rails db:prepare
    @echo "==> Clearing logs and temp files ..."
    bin/rails log:clear tmp:clear
    @echo ""
    @echo "✓ Setup complete. Run 'just dev' to start."

# Reinstall Ruby and Node dependencies
[group('setup')]
deps:
    bundle install
    npm install

# Update bundler dependencies
[group('setup')]
update-deps:
    bundle update --bundler
    bundle update --all

# Update Node dependencies
[group('setup')]
update-node-deps:
    npm-check-updates --format group --target minor
    npm-check-updates --format group --interactive

# ─────────────────────────────────────────────
# quality
# ─────────────────────────────────────────────

# Run RuboCop (Ruby style analysis)
[group('quality')]
lint:
    bin/rubocop --autocorrect

# Static security analysis with Brakeman
[group('quality')]
security-code:
    bin/brakeman --quiet --no-pager

# Audit gem vulnerabilities
[group('quality')]
security-gems:
    bundle audit update
    bundle audit check

# Run all security checks
[group('quality')]
security: security-code security-gems

# Run all Rails tests (minitest)
[group('quality')]
test:
    bin/rails test

# Run system tests (Capybara + Selenium)
[group('quality')]
test-system:
    bin/rails test:system

# Verify seeds run without errors in test environment
[group('quality')]
test-seeds:
    RAILS_ENV=test bin/rails db:seed:replant

# Run all tests (unit + system + seeds)
[group('quality')]
test-all: test test-system test-seeds

# ─────────────────────────────────────────────
# ci
# ─────────────────────────────────────────────

# Full CI pipeline: setup + linter + security + tests
[group('ci')]
ci:
    bin/ci

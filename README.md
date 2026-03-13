# Registro

[![Rubocop](https://github.com/iax7/registro/actions/workflows/rubocop.yml/badge.svg)](https://github.com/iax7/registro/actions/workflows/rubocop.yml)
[![Ruby][ruby-badge]][ruby-url]
[![Rails][rails-badge]][rails-url]
[![PostgreSQL][psql-badge]][psql-url]
[![NodeJS][node-badge]][node-url]
[![Conventional Commits][cc-img]][cc-url]

## Run Locally

- Install [Mise](https://mise.jdx.dev/installing-mise.html)
- Install [System dependencies](https://github.com/rbenv/ruby-build/wiki)
- Install [Just](https://github.com/casey/just)

```bash
just setup
just db-setup
just dev
```

## Secrets

Edit the **secrets** variables

- If you are starting over:

  ```bash
  # 1. create .env file
  cp .env.template .env
  # 2. create a key
  rake secret | tail -1 | cut -c1-32 > config/master.key
  ```

- Then create a **Credentials** file using `rails credentials:edit` and add the following content:

  ```yaml
  secret_key_base: xxxxxxxx

  google_key: xxxxxxxx
  api_user: xxxxxxxx
  api_pass: xxxxxxxx

  smtp:
    address: xxxxxx.xx.com
    domain: xxxxxxxxxx.com
    user_name: xxxx@xxxxxxxx.com
    password: xxxxxxxx
  ```

## DB

Start **PostgreSQL** DB (with docker)

```bash
docker run --name reg -p 5432:5432 \
      -v ~/dev/data/reg:/var/lib/postgresql/data \
      -e POSTGRES_PASSWORD=123456 -d postgres:13

# or using Podman
podman run --name reg -p 5432:5432 -e POSTGRES_PASSWORD=123456 -d docker.io/library/postgres:18
```

add in your `.env` file the following variables:

```bash
DATABASE_URL=postgresql://postgres:123456@localhost:5432
```

## Documentation

- [Database](docs/db.md)
- [Security Map](docs/security.md)

<!-- Links -->
[ruby-badge]: https://img.shields.io/badge/ruby-4.0-blue?style=flat&logo=ruby&logoColor=CC342D&labelColor=white
[ruby-url]: https://www.ruby-lang.org/en/
[rails-badge]: https://img.shields.io/badge/rails-8.1-blue?style=flat&logo=ruby-on-rails&logoColor=CC0000&labelColor=white
[rails-url]: https://rubyonrails.org/
[psql-badge]: https://img.shields.io/badge/PostgreSQL-18-blue?style=flat&logo=postgresql&logoColor=336791&labelColor=white
[psql-url]: https://www.postgresql.org/download/
[node-badge]: https://img.shields.io/badge/NodeJS-24-blue?style=flat&logo=node.js&logoColor=339933&labelColor=white
[node-url]: https://nodejs.org/en/
[cc-img]: https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=00&labelColor=fff
[cc-url]: https://conventionalcommits.org

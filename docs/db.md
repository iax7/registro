# DataBase

## Diagram

- [2020 (Current)](img/2020-db.png)
- [2019](img/2019-db.png)
- [2018](img/2018-db.png)
- [2015](img/2015-db.png)

```mermaid
erDiagram
direction LR
EVENTS {
  bigint id PK
  string name
  jsonb settings
  jsonb statistics
  datetime created_at
  datetime updated_at
}

USERS {
  bigint id PK
  string name
  string lastname
  string nick
  boolean is_male
  date dob
  string email
  string phone
  boolean is_admin
  string password_digest
  string password_reset_token
  datetime password_reset_sent_at
  string country
  string state
  string city
  jsonb guest_history
  datetime created_at
  datetime updated_at
}

REGISTRIES {
  bigint id PK
  bigint user_id FK
  bigint event_id FK
  text comments
  boolean is_confirmed
  boolean is_present
  boolean is_notified
  integer amount_debt
  integer amount_paid
  integer amount_offering
  bigint paid_by
  datetime created_at
  datetime updated_at
}

GUESTS {
  bigint id PK
  bigint registry_id FK
  string name
  string lastname
  string nick
  boolean is_male
  integer age
  integer relation
  boolean is_pregnant
  boolean is_medicated
  datetime created_at
  datetime updated_at
}

PAYMENTS {
  bigint id PK
  bigint registry_id FK
  bigint user_id FK
  integer amount
  integer kind
  datetime created_at
  datetime updated_at
}

%% Relationships
USERS ||--o{ REGISTRIES : "has many"
EVENTS ||--o{ REGISTRIES : "has many"
REGISTRIES ||--o{ GUESTS : "has many"
REGISTRIES ||--o{ PAYMENTS : "has many"
USERS ||--o{ PAYMENTS : "has many"
```

## Queries

There are a list of common used [queries](queries.md).

### Run DB Commands

All scripts use the following variables:

```bash
db_container=regdb
db=reg
pwd=123456
```

#### Configure JetBrains DataGrip

##### Heroku

```bash
heroku pg:credentials:url
```

Copy the results, and in advanced tab set the following:

- `ssl` => `true`
- `sslfactory` => `org.postgresql.ssl.NonValidatingFactory`

Reset heroku db

```bash
heroku pg:reset --confirm <app_name>
```

Interactive console
(add `-c 'SELECT * FROM users'` to run queries from command line)

```bash
docker run -it --rm -e PGPASSWORD=$pwd \
           --link $db_container:postgres postgres:12.3 \
           psql -h $db_container -d $db
```

---

## DataBase Backups 📦

### Create ⬇️

#### Heroku 🌎

```bash
appname={{HEROKU_APPNAME}}
dump_file="$(date +%y%m%d-%H%M)-db.dump"

heroku pg:backups capture -a $appname
url=$(heroku pg:backups public-url -a $appname)
curl -o "$dump_file" "$url"
```

#### Local 🏠

```bash
docker run -it --rm -v $PWD:/tmp/data -e PGPASSWORD="$pwd" \
           --link $db_container:postgres postgres:12.3 \
           pg_dump -h $db_container -U postgres -d "$db" \
           -Fc --no-acl --no-owner -f "/tmp/data/db.dump"
```

### Restore ⬆️

#### Heroku 🌎

```bash
heroku pg:backups
heroku pg:backups:restore b001 --confirm app_name
```

#### Local 🏠

```bash
docker run -it --rm -v $PWD:/tmp/data:ro -e PGPASSWORD="$pwd" \
           --link $db_container:postgres postgres:12.3 \
           pg_restore --verbose --clean --no-acl --no-owner --no-password \
           -h $db_container -U postgres -d "$db" /tmp/data/db.dump
```

# Setup Guide: dbt Core + PostgreSQL

Assumes you have Python 3.9 to 3.12 and Docker Desktop installed.

1. Start Postgres (run from this folder, where `docker-compose.yml` is):

```
docker compose up -d
```

2. Create a virtual environment:

```
python -m venv venv
```

3. Activate it:

```
.\venv\Scripts\Activate.ps1
```

(macOS/Linux: `source venv/bin/activate`)

4. Install dbt:

```
pip install dbt-postgres
```

5. Create a project:

```
dbt init dbt_learning
cd dbt_learning
```

When `dbt init` asks for the connection, use these (they match `docker-compose.yml`):

- host: `localhost`
- port: `5432`
- user: `dbt`
- pass: `dbt`
- dbname: `dbt_learning`
- schema: `dbt_dev`
- threads: `4`

6. Run it:

```
dbt debug
dbt run
dbt test
```

One test is meant to fail, it's an example. To make it pass, uncomment the last line of
`models/example/my_first_dbt_model.sql` so it reads `where id is not null`, then run
`dbt run` and `dbt test` again.

When you're done, stop Postgres with `docker compose down` (add `-v` to also delete the
data).

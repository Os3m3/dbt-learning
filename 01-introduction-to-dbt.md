# Introduction to dbt

dbt stands for "data build tool". It's how you transform raw data that's already sitting
in your warehouse into clean, tested tables, using plain SQL `SELECT` statements. What
makes it worth using is that it brings normal software practices to that SQL: version
control, testing, documentation, and reusable code.

## The problem it solves

Most companies collect raw data (orders, users, payments, events) and load it into a
database. That raw data usually isn't in a shape that's good for analysis, so someone has
to turn it into clean tables that dashboards and analysts can rely on.

For a long time that work looked like:

- SQL scripts scattered across people's laptops.
- Stored procedures nobody fully understands.
- No tests, so when a number looks off, nobody can tell why.
- No documentation, so new joiners are stuck.
- No version control, so changes break things quietly.

dbt exists to clean that up. The pitch is basically: treat your SQL transformations like
real code.

## Where dbt fits: ETL vs ELT

A data pipeline has three stages: extract, transform, load.

- ETL (the older approach): transform the data before loading it into the warehouse.
- ELT (the modern approach): load the raw data into the warehouse first, then transform
  it there with SQL.

```
   EXTRACT            LOAD                         TRANSFORM
 ┌──────────┐     ┌──────────────┐            ┌──────────────────┐
 │  sources │ ──► │  raw tables  │ ─────────► │   dbt does this  │
 │ (apps,   │     │  in the      │            │  clean / model / │
 │  APIs,   │     │  warehouse   │            │  test / document │
 │  files)  │     │ (PostgreSQL) │            │                  │
 └──────────┘     └──────────────┘            └──────────────────┘
```

dbt only does the transform step. It doesn't extract or load anything. Some other tool or
script gets the raw data into Postgres, and dbt takes over from there.

## The core idea

In dbt, a "model" is a `.sql` file with one `SELECT` statement in it. You write the
`SELECT`; dbt wraps it in the `CREATE VIEW` / `CREATE TABLE` boilerplate and runs it
against the database for you.

So you write this:

```sql
-- models/customers.sql
select
    id as customer_id,
    lower(email) as email,
    created_at
from raw.users
where deleted_at is null
```

And dbt runs roughly this against Postgres:

```sql
create view dbt_dev.customers as (
    select ... -- your SELECT
);
```

You never write the `CREATE`, `DROP`, or `INSERT` yourself. You write the `SELECT` that
describes what you want, and dbt handles building it.

## The main concepts

I'll keep these short for now. We'll actually use them in later sessions.

**Models.** A `.sql` file with a `SELECT`. Each one becomes a table or view in the
database. This is the core of dbt.

**`ref()`.** Instead of hardcoding a table name, you point at another model with
`{{ ref('model_name') }}`:

```sql
-- models/orders_per_customer.sql
select
    customer_id,
    count(*) as total_orders
from {{ ref('orders') }}
group by customer_id
```

This does two useful things. dbt works out the correct build order on its own (build
`orders` before `orders_per_customer`), and it builds a dependency graph of how everything
connects, which is your data lineage.

```
  stg_users ─┐
             ├─► customers ─► orders_per_customer ─► dashboard_metrics
  stg_orders ┘
```

**Sources.** These describe the raw tables your data lands in. You point at them with
`{{ source('raw', 'users') }}`, which lets dbt trace lineage all the way back to the raw
data.

**Tests.** dbt can check your data and fail if something's wrong. The common built-in ones
are:

- `unique` — no duplicates in a column.
- `not_null` — no missing values.
- `accepted_values` — values stay within an allowed set (e.g. status is paid or pending).
- `relationships` — every `customer_id` in `orders` exists in `customers`.

You declare them in YAML, no code needed:

```yaml
models:
  - name: customers
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
```

After that, `dbt test` fails loudly if the data ever breaks. This is a big part of why
people use dbt.

**Documentation.** You describe models and columns in YAML, and dbt generates a docs site
from it, including a lineage diagram.

**Materializations.** You pick how each model gets built:

- `view` (the default): light, always current, computed when queried.
- `table`: stored physically, faster to read.
- `incremental`: only process new or changed rows, for large tables.
- `ephemeral`: not built in the database, inlined into other models.

Changing it is one line of config, not a SQL rewrite.

**Seeds.** Small CSV files in your project (say, a list of country codes) that dbt loads
into the warehouse with `dbt seed`.

**Snapshots.** A way to record how a row changes over time.

**Macros and Jinja.** dbt mixes SQL with Jinja, a templating language, so you can write
reusable SQL functions called macros instead of copy-pasting the same logic everywhere.

## Why people use it

Pulling that together:

- Transformations live in one version-controlled project instead of scattered scripts.
- Data quality is checked automatically with tests.
- Docs and lineage are generated, not hand-maintained.
- Common logic is reused through models and macros.
- dbt works out the build order, so you don't wire it up by hand.
- Everything goes through Git, so changes are reviewable.

## dbt Core vs dbt Cloud

There are two ways to run dbt:

- dbt Core: free, open source, runs from the terminal. This is what we're using today.
- dbt Cloud: a paid hosted version with a web IDE, scheduler, and CI/CD built in. It runs
  on top of dbt Core.

What you learn on Core carries straight over to Cloud.

## A typical workflow

1. Write or edit a model.
2. `dbt run` to build it in Postgres.
3. `dbt test` to check the data.
4. `dbt docs generate` to refresh the docs.
5. Commit to Git, open a pull request, get it reviewed, merge.
6. In production, a scheduler runs `dbt build` on a schedule.

## Commands you'll see today

| Command | What it does |
|---------|--------------|
| `dbt init` | Create a new project. |
| `dbt debug` | Check that dbt can connect to the database. |
| `dbt run` | Build all the models. |
| `dbt test` | Run all the data tests. |
| `dbt build` | Run, test, seed, and snapshot, in dependency order. |
| `dbt docs generate` | Build the documentation site. |
| `dbt docs serve` | Open the documentation site locally. |

## Before the setup guide

The short version: dbt is the transform step in ELT. You write `SELECT` statements, and
dbt builds them into tested, documented tables in the warehouse. `ref()` ties models
together and gives you lineage for free. Tests and docs being built in is what sets it
apart from a pile of SQL scripts.

Next, go to [02-setup-guide.md](02-setup-guide.md) to get it installed.

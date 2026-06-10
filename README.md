# Intro to dbt

A short session to introduce dbt and get everyone set up to run it locally against
Postgres.

We're not doing the full course today. The plan is just to:

1. Explain what dbt is and why it's worth using.
2. Get it installed and talking to a Postgres database.
3. Run the example models so everyone leaves with something working.

## Files

Read them in this order:

- [01-introduction-to-dbt.md](01-introduction-to-dbt.md) — what dbt is, the problem it
  solves, and the main concepts.
- [02-setup-guide.md](02-setup-guide.md) — installing Python, dbt, and connecting to
  Postgres.

## Before we start

You'll want:

- A laptop you can install software on (admin rights help).
- Python 3.9 to 3.12. We check for this in the setup guide.
- Docker Desktop, used to run Postgres. The setup guide starts it with one command.
- A code editor. VS Code is fine.
- A terminal. PowerShell works.

If you're missing some of these, the setup guide covers each one.

## What you'll have by the end

Three commands working:

```
dbt debug
dbt run
dbt test
```

That's the goal for today. Later sessions get into building real models, sources, tests,
and docs.

## Links

- Docs: https://docs.getdbt.com
- Postgres setup: https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup
- Free dbt course: https://learn.getdbt.com
- Command reference: https://docs.getdbt.com/reference/dbt-commands

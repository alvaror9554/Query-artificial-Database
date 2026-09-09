# SQL Interview Practice Database

A hands-on SQLite project for practicing SQL concepts commonly tested in technical interviews. It includes a realistic company database, ten progressively challenging exercises, my query attempts, and verified reference results.

## Goals

- Practice writing SQL directly against a real database.
- Build confidence with joins, grouping, CTEs, window functions, and analytical queries.
- Compare query results to a verified benchmark without viewing the official solution first.

## Database

The SQLite database is located at `archive/test-company.db`.

| Table | Description |
| --- | --- |
| `employees` | 2,500 employees, including salary, hire date, status, pay type, department, and salary grade. |
| `departments` | Ten company departments. |
| `pay_types` | Hourly and salary compensation types. |
| `salary_grades` | Five employee grade tiers. |
| `customers` | One hundred customer companies and their assigned representatives. |
| `transactions` | 5,000 customer transactions with service, sales channel, and net amount data. |

## Exercises

The exercises begin with core aggregation and progress to interview-style analytical SQL:

1. Active employee counts and average salary by pay type.
2. Department headcount filtering with `HAVING`.
3. Employees earning above their department average using a CTE.
4. Top-paid employees per department using `DENSE_RANK()`.
5. Revenue pivoting with conditional aggregation.
6. Customer-representative revenue across four related tables.
7. Salary-grade employee status breakdown using `LEFT JOIN`.
8. Hiring cohorts and retention-rate calculations.
9. Running transaction totals with window functions.
10. Customer spending quartiles with `NTILE(4)`.

## Repository Contents

| File | Purpose |
| --- | --- |
| `SQL_1stquery.sql` | My working answers to the SQL exercises. |
| `sql_interview_practice.pdf` | Questions, hints, and verified target output tables; no SQL solutions. |
| `sql_interview_practice.tex` | LaTeX source for the practice PDF. |
| `sql_interview_guide.pdf` | Full study guide with official SQL solutions and verified outputs. |
| `sql_interview_guide.tex` | LaTeX source for the full study guide. |
| `archive/test-company.db` | SQLite practice database. |

## Practice Workflow

1. Open `SQL_1stquery.sql` in VS Code.
2. Open `sql_interview_practice.pdf` and choose a question.
3. Write and run your query against `archive/test-company.db` using a SQLite extension or command-line client.
4. Compare the result columns, rows, ordering, and calculations to the benchmark in the practice PDF.
5. Consult `sql_interview_guide.pdf` only after attempting the query yourself.

## Run a Query with SQLite

Install the [SQLite command-line tools](https://www.sqlite.org/download.html), then run from the repository root:

```powershell
sqlite3 archive/test-company.db
```

Inside the SQLite prompt, load your file or execute a query:

```sql
.read SQL_1stquery.sql
```

## Upload Changes to GitHub

This repository is connected to:

```text
https://github.com/alvaror9554/Query-artificial-Database
```

Check the files that changed:

```powershell
git status
```

Stage only the project files you intend to upload. For example:

```powershell
git add README.md SQL_1stquery.sql SQL.code-workspace
git add sql_interview_guide.tex sql_interview_guide.pdf
git add sql_interview_practice.tex sql_interview_practice.pdf
```

Create a commit with a clear message and push it:

```powershell
git commit -m "Improve SQL practice exercises and documentation"
git push origin main
```

Avoid staging generated LaTeX temporary files such as `.aux`, `.log`, `.out`, `.toc`, `.fls`, `.fdb_latexmk`, and `.synctex.gz`.

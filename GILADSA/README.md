# Your App

A full-stack application project scaffold containing database definitions, project planning documentation, and interactive front-end prototypes.

---

## 📁 Project Structure

```text
your-app/
├── README.md               # Project overview and setup instructions
├── database/
│   ├── schema.sql          # CREATE TABLE statements and schema definitions
│   └── seed.sql            # Sample INSERT data for local development
├── docs/
│   ├── 01-brief.md         # Project brief, problem statement, and goals
│   ├── 02-crud-map.md      # CRUD operations mapped to entities and views
│   ├── 03-sitemap.png      # Application site map / visual page hierarchy
│   ├── user-flow.png       # User journey and interaction flow diagram
│   ├── 04-wireframes/      # Screen-by-screen wireframe diagrams
│   └── 05-style-guide.md   # Design tokens, typography, and color palette
└── prototype/
    ├── css/
    │   └── style.css       # Shared styles for prototypes
    ├── list.html           # Records list / data table prototype
    └── form.html           # Create / Edit record form prototype
```

---

## 🚀 Getting Started

### 1. Database Setup
Execute the SQL files in order using your database management tool or CLI (e.g., PostgreSQL, MySQL, SQLite):

```bash
# Example using MySQL CLI
mysql -u your_user -p your_database < database/schema.sql
mysql -u your_user -p your_database < database/seed.sql

# Example using PostgreSQL CLI
psql -U your_user -d your_database -f database/schema.sql
psql -U your_user -d your_database -f database/seed.sql
```

### 2. Viewing the Prototype
Open the HTML files in `prototype/` directly in any modern browser:
- Double click [`prototype/list.html`](./prototype/list.html) to view the list and data table interface.
- Double click [`prototype/form.html`](./prototype/form.html) to view the form interface.

---

## 📚 Documentation Summary

- **[01-brief.md](./docs/01-brief.md)**: Product goals, target audience, and feature scope.
- **[02-crud-map.md](./docs/02-crud-map.md)**: Breakdown of Create, Read, Update, and Delete operations for each entity.
- **[03-sitemap.png](./docs/03-sitemap.png)** & **[user-flow.png](./docs/user-flow.png)**: Visual sitemap and user flow diagrams.
- **[04-wireframes/](./docs/04-wireframes/)**: Screen wireframes for major pages.
- **[05-style-guide.md](./docs/05-style-guide.md)**: Color palette, typography, and UI component standards.


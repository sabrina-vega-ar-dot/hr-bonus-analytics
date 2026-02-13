# SQL Layer – HR Bonus Analytics

## Overview

This folder contains the full relational layer supporting the HR Bonus Analytics model.

The SQL layer is structured following a clean separation of concerns:

- **DDL** → Structural objects (schema, tables, constraints)
- **DML** → Seed data and controlled dummy data generation
- **Views** → Business logic / semantic layer consumed by Power BI

This structure ensures maintainability, traceability and reproducibility.

---

# Folder Structure

sql/
│
├── ddl/
│ └── 01_schema_portfolio_analytics.sql
│
├── dml/
│ └── 01_seed_and_dummy_data.sql
│
└── views/
└── 01_views_bonus_model.sql


---

# 1️⃣ DDL Layer (Data Definition)

Location: sql/ddl/

Contains:

- Database creation
- Dimension tables
- Fact tables
- Keys and constraints

This layer defines the **star schema model** used for performance evaluation and bonus calculation.

Main entities:

- dim_fecha (Calendar + Budget logic)
- dim_pais
- dim_manager
- dim_supervisor
- dim_area
- dim_objetivo
- fact_cumplimiento_supervisor
- fact_incidentes

Design principles:

- Surrogate keys for dimensions
- Composite PK for fact table
- Referential integrity via foreign keys
- Budget calendar separated from calendar time

---

# 2️⃣ DML Layer (Data Manipulation)

Location: sql/dml/

Contains:

- Seed data for dimensions
- Operational flags (es_operativo)
- Budget calendar population
- Controlled dummy data generator for fact tables

The dummy generator:

- Is idempotent (safe to re-run)
- Prevents duplicate rows via NOT EXISTS
- Simulates realistic KPI variability
- Preserves primary key integrity

Purpose:

Allows reproducible testing of the bonus model without production data.

---

# 3️⃣ Views Layer (Semantic / Business Logic)

Location: sql/views/


Contains business-ready views consumed by Power BI.

Key responsibilities:

- Calculate compliance percentage
- Normalize KPI scale (0–1 logic)
- Apply objective weights
- Flag critical incidents
- Provide supervisor-level monthly granularity

The view layer acts as:

→ A semantic bridge between relational storage and analytical consumption.

This reduces DAX complexity and improves performance.

---

# Execution Order

To rebuild the database from scratch:

1. Run:
   sql/ddl/01_schema_portfolio_analytics.sql

2. Run:
   sql/dml/01_seed_and_dummy_data.sql

3. Run:
   sql/views/01_views_bonus_model.sql

---

# Design Decisions

• Budget cycle runs Jul–Jun  
• Compliance normalized to decimal scale (0–1)  
• Objective weighting handled in view layer  
• Dummy data generator supports scenario testing  

---

# Integration with Power BI

The semantic model connects to:

vw_hr_bonus_base  
vw_supervisor_monthly_kpi  
vw_supervisor_proporcionalidad  

This approach ensures:

- Reduced context transition complexity in DAX
- Simplified measures
- Better performance at aggregation level
- Clear separation of transformation layers

---

# Versioning Strategy

Changes to SQL objects must follow:

- DDL changes → new versioned script
- View refactor → increment view file version
- Data rule changes → documented in commit message

Recommended commit convention:

feat(sql):  
refactor(sql):  
fix(sql):  

---

# Author

Project developed as part of HR Bonus Analytics modernization initiative.


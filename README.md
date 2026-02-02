# HR Bonus Analytics – Industrial Compensation Model

## 📌 Project Overview
This project simulates a real-world HR and Compensation analytics scenario in an industrial environment, focused on performance-based bonus calculation for supervisors.

The model replicates complex business rules such as:
- Non-calendar budget years
- Safety-critical blocking events
- Weighted performance objectives
- Proportional bonus calculation based on tenure

The project is inspired by real experiences in large industrial organizations.
The project covers the full analytics lifecycle: data modeling, ETL logic, business rules implementation and reporting.

---

## 🏭 Business Context
Supervisors are evaluated annually based on multiple performance dimensions related to:
- Safety and hygiene compliance
- Incident management
- Mandatory training completion
- Materials return and loss prevention

Due to industrial safety standards, certain events (e.g. critical accidents) fully block bonus eligibility.

---

## 🎯 Business Objectives
- Calculate annual supervisor bonuses based on weighted objectives
- Ensure compliance with safety and training standards
- Provide transparency to HR and Compensation teams
- Support managerial decision-making

---

## 🧠 Key Business Rules
- Budget Year runs from **July 1st to June 30th**
- Critical accidents result in **0% bonus**
- Bonus components are weighted (30% / 60% / 5% / 5%)
- Training compliance requires a minimum of **98%**
- Bonuses are adjusted proportionally to time worked

---

## 🛠️ Technology Stack
- SQL Server
- T-SQL (stored procedures, views)
- Mockaroo (dummy data generation)
- Power BI
- GitHub (version control)

---

## 📂 Repository Structure
- docs/ → Functional & technical documentation
- sql/ → Database scripts and stored procedures
- data/ → Raw and processed datasets
- powerbi/ → Power BI reports

---

## 👤 Author: Sabrina Vega
Data Analyst with extensive experience in BI and analytics projects, focused on transforming complex business rules into scalable data models and decision-ready insights.
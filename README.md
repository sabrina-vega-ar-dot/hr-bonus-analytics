# HR Bonus Analytics

## Overview
HR Bonus Analytics is a performance evaluation solution built in SQL Server and Power BI.
It calculates weighted compliance for Supervisors and Managers within a Budget cycle (July–June),
including penalties for critical incidents and automated bonus classification.

## Architecture
Data Layer: SQL Server  
Semantic Layer: Power BI Dataset (Star Schema)  
Presentation Layer: Power BI Report

## Business Rules
- Compliance normalized to 0–1 scale.
- Weighted compliance: Σ (objective compliance × weight).
- Bonus rules:
  ≥ 95% → 100%
  ≥ 60% and < 95% → 50%
  < 60% → 0%
- Critical incidents penalize Incident Management objective.
- Manager compliance = average supervisor compliance.

## Author
Sabrina Vega

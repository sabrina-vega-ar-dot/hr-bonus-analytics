/* ===============================
   DATABASE INITIALIZATION
   =============================== */

CREATE DATABASE PortfolioAnalytics;
GO

USE PortfolioAnalytics;
GO

/* ===============================
   DIMENSION: TIME (MONTH GRAIN)
   =============================== */

CREATE TABLE dim_fecha (
    fecha_id        INT PRIMARY KEY,
    fecha           DATE,
    anio            INT,
    mes             INT,
    nombre_mes      VARCHAR(20),
    anio_mes        VARCHAR(7)
);

ALTER TABLE dbo.dim_fecha
ADD dias_mes_budget INT;

ALTER TABLE [dbo].[dim_fecha]
ADD anio_budget INT,
    mes_budget_num INT,
    mes_budget_label VARCHAR(20),
    ciclo_budget_label VARCHAR(30);

/* ===============================
   DIMENSION: Pais
   =============================== */

CREATE TABLE dim_pais (
    pais_id INT IDENTITY(1,1) PRIMARY KEY,
    pais    VARCHAR(50),
    region  VARCHAR(50)
);

/* ===============================
   DIMENSION: Manager
   =============================== */

CREATE TABLE dim_manager (
    manager_id INT IDENTITY PRIMARY KEY,
    manager    VARCHAR(100),
    pais_id    INT,
    FOREIGN KEY (pais_id) REFERENCES dim_pais(pais_id)
);

ALTER TABLE dim_manager
ADD es_operativo BIT;

/* ===============================
   DIMENSION: Supervisor
   =============================== */

CREATE TABLE dim_supervisor (
    supervisor_id   INT IDENTITY PRIMARY KEY,
    supervisor      VARCHAR(100),
    manager_id      INT,
    activo          BIT,
    FOREIGN KEY (manager_id) REFERENCES dim_manager(manager_id)
);

ALTER TABLE dim_supervisor
ADD fecha_alta DATE,
    fecha_baja DATE NULL;

/* ===============================
   DIMENSION: Area
   =============================== */

CREATE TABLE dim_area (
    area_id INT IDENTITY PRIMARY KEY,
    area    VARCHAR(50)
);

/* ===============================
   DIMENSION: Objetivo
   =============================== */

CREATE TABLE dim_objetivo (
    objetivo_id INT IDENTITY PRIMARY KEY,
    objetivo    VARCHAR(100),
    area_id     INT,
    peso        DECIMAL(5,2),
    FOREIGN KEY (area_id) REFERENCES dim_area(area_id)
);

ALTER TABLE dbo.dim_objetivo
ADD cumplimiento_objetivo DECIMAL(5,4);

ALTER TABLE dbo.dim_objetivo
ADD cumplimiento DECIMAL(5,2);

/* ===============================
   FACT TABLES
   =============================== */

CREATE TABLE fact_cumplimiento_supervisor (
    fecha_id        INT,
    supervisor_id   INT,
    objetivo_id     INT,
    valor_real      DECIMAL(10,2),
    valor_objetivo  DECIMAL(10,2),
    PRIMARY KEY (fecha_id, supervisor_id, objetivo_id),
    FOREIGN KEY (fecha_id) REFERENCES dim_fecha(fecha_id),
    FOREIGN KEY (supervisor_id) REFERENCES dim_supervisor(supervisor_id),
    FOREIGN KEY (objetivo_id) REFERENCES dim_objetivo(objetivo_id)
);

CREATE TABLE fact_incidentes (
    incidente_id   INT IDENTITY PRIMARY KEY,
    supervisor_id  INT,
    fecha_id       INT,
    tipo_incidente VARCHAR(50),
    es_critico     BIT,
    FOREIGN KEY (supervisor_id) REFERENCES dim_supervisor(supervisor_id),
    FOREIGN KEY (fecha_id) REFERENCES dim_fecha(fecha_id)
);

/* ===============================
   DROPS (Model Refactor)
   =============================== */

DROP VIEW IF EXISTS dbo.vw_supervisor_proporcionalidad_mes;
DROP VIEW IF EXISTS dbo.vw_manager_accidente_critico;
DROP VIEW IF EXISTS dbo.vw_supervisor_accidente_critico;

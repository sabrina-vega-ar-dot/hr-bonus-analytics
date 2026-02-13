CREATE OR ALTER VIEW dbo.vw_hr_bonus_base AS
WITH Incidentes AS (
    SELECT
        supervisor_id,
        fecha_id,
        MAX(CAST(es_critico AS INT)) AS tiene_accidente_critico
    FROM dbo.fact_incidentes
    GROUP BY supervisor_id, fecha_id
)
SELECT
    hb.supervisor_id,
    hb.fecha_id,
    hb.objetivo_id,
    hb.valor_real,
    o.cumplimiento_objetivo AS valor_objetivo,

    CAST(
        CASE 
            WHEN o.cumplimiento_objetivo = 0 THEN 0
            ELSE (hb.valor_real / 100.0) / o.cumplimiento_objetivo
        END
    AS DECIMAL(10,4)) AS pct_cumplimiento,

    CAST(
        CASE 
            WHEN hb.objetivo_id = 2 
                 AND ISNULL(i.tiene_accidente_critico,0) = 1
            THEN 1
            ELSE 0
        END
    AS INT) AS tiene_accidente_critico

FROM dbo.fact_cumplimiento_supervisor hb
JOIN dbo.dim_objetivo o
    ON hb.objetivo_id = o.objetivo_id
LEFT JOIN Incidentes i
    ON hb.supervisor_id = i.supervisor_id
    AND hb.fecha_id = i.fecha_id;

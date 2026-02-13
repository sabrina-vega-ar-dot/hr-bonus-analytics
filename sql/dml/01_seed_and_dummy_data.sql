/* ======================================
   SEED DATA – DIM_MANAGER
   Ajuste de nombres ficticios
========================================*/

INSERT INTO dim_manager (manager, pais_id)
SELECT
    CASE p.pais
        WHEN 'Argentina' THEN 'Juan Pérez'
        WHEN 'Bolivia'   THEN 'Carlos Méndez'
        WHEN 'Brasil'    THEN 'Rafael Oliveira'
        WHEN 'Chile'     THEN 'Matías González'
        WHEN 'Uruguay'   THEN 'Federico Silva'
    END AS manager,
    p.pais_id
FROM dim_pais p;

-- Ajuste posterior de nombres

UPDATE dim_manager
SET manager = CASE pais_id
    WHEN (SELECT pais_id FROM dim_pais WHERE pais = 'Argentina') THEN 'Martín López'
    WHEN (SELECT pais_id FROM dim_pais WHERE pais = 'Bolivia') THEN 'Andrés Quispe'
    WHEN (SELECT pais_id FROM dim_pais WHERE pais = 'Brasil') THEN 'Rafael Oliveira'
    WHEN (SELECT pais_id FROM dim_pais WHERE pais = 'Chile') THEN 'Sebastián Rojas'
    WHEN (SELECT pais_id FROM dim_pais WHERE pais = 'Uruguay') THEN 'Nicolás Pereira'
    ELSE manager
END;

/*=====================================
   Flag operativo para bonos
========================================*/

UPDATE dim_manager
SET es_operativo = CASE
    WHEN manager IN ('Andrés Quispe', 'Nicolás Pereira') THEN 0
    ELSE 1
END;


/* ======================================
   SEED DATA – DIM_FECHA (2025)
========================================*/

INSERT INTO dim_fecha VALUES
(202501, '2025-01-01', 2025, 1, 'Enero', '2025-01'),
(202502, '2025-02-01', 2025, 2, 'Febrero', '2025-02'),
(202503, '2025-03-01', 2025, 3, 'Marzo', '2025-03'),
(202504, '2025-04-01', 2025, 4, 'Abril', '2025-04'),
(202505, '2025-05-01', 2025, 5, 'Mayo', '2025-05'),
(202506, '2025-06-01', 2025, 6, 'Junio', '2025-06'),
(202507, '2025-07-01', 2025, 7, 'Julio', '2025-07'),
(202508, '2025-08-01', 2025, 8, 'Agosto', '2025-08'),
(202509, '2025-09-01', 2025, 9, 'Septiembre', '2025-09'),
(202510, '2025-10-01', 2025, 10, 'Octubre', '2025-10'),
(202511, '2025-11-01', 2025, 11, 'Noviembre', '2025-11'),
(202512, '2025-12-01', 2025, 12, 'Diciembre', '2025-12');


/* =========================================================
   Poblado columnas Budget (regla Jul–Jun)
========================================================= */

UPDATE dim_fecha
SET
    anio_budget =
        CASE 
            WHEN mes >= 7 THEN anio
            ELSE anio
        END,

    mes_budget_num =
        CASE 
            WHEN mes >= 7 THEN mes - 6
            ELSE mes + 6
        END,

    mes_budget_label =
        RIGHT(
            '0' + CAST(
                CASE 
                    WHEN mes >= 7 THEN mes - 6
                    ELSE mes + 6
                END AS VARCHAR(2)), 2
        ) + ' - ' + nombre_mes,

    ciclo_budget_label =
        'Jul-' + CAST(anio AS VARCHAR(4))
        + ' a Jun-' + CAST(
            CASE 
                WHEN mes >= 7 THEN anio
                ELSE anio + 1
            END AS VARCHAR(4)
        );


/* =========================================================
   GENERADOR DE DATOS DUMMY – FACT CUMPLIMIENTO SUPERVISOR
   Evita duplicados por PK (fecha_id, supervisor_id, objetivo_id)
========================================================= */

DECLARE @fecha_id INT;
DECLARE @valor_objetivo DECIMAL(10,2) = 100;

DECLARE cur_fecha CURSOR FOR
SELECT fecha_id
FROM dim_fecha
WHERE fecha BETWEEN '2024-07-01' AND '2025-06-01';

OPEN cur_fecha;
FETCH NEXT FROM cur_fecha INTO @fecha_id;

WHILE @@FETCH_STATUS = 0
BEGIN

    INSERT INTO fact_cumplimiento_supervisor
    (
        fecha_id,
        supervisor_id,
        objetivo_id,
        valor_real,
        valor_objetivo
    )
    SELECT
        @fecha_id,
        s.supervisor_id,
        o.objetivo_id,

        CAST(
            CASE 
                WHEN @fecha_id < 202407
                    THEN 85 + (RAND(CHECKSUM(NEWID())) * 15)
                ELSE
                    40 + (RAND(CHECKSUM(NEWID())) * 60)
            END
        AS DECIMAL(10,2)),

        @valor_objetivo

    FROM dim_supervisor s
    CROSS JOIN dim_objetivo o
    WHERE s.activo = 1
      AND NOT EXISTS (
            SELECT 1
            FROM fact_cumplimiento_supervisor f
            WHERE f.fecha_id      = @fecha_id
              AND f.supervisor_id = s.supervisor_id
              AND f.objetivo_id   = o.objetivo_id
      );

    FETCH NEXT FROM cur_fecha INTO @fecha_id;
END

CLOSE cur_fecha;
DEALLOCATE cur_fecha;


/*
Objetivo:
Generar datos dummy de cumplimiento mensual por supervisor y objetivo,
respetando la PK del fact y sin recalcular métricas de negocio.

Notas:
- valor_objetivo fijo = 100
- valor_real simula variabilidad realista
- el script es idempotente (safe re-run)
*/

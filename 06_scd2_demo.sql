-- Lab 1: Step 6 - SCD Type 2 demo for FV Batanes Pearl (V-001)
-- The vessel moves from Navotas Fisherfolk Cooperative to Bataan Coastal
-- Cooperative effective 2026-07-01. Historical reports must not change.

\echo '=== 1. BEFORE - current version of FV Batanes Pearl ==='
SELECT vessel_key, vessel_code, vessel_name, cooperative, owner,
       effective_from, effective_to, is_current
FROM dw.dim_vessel
WHERE vessel_code = 'V-001'
ORDER BY effective_from;

\echo ''
\echo '=== 2. BASELINE - facts on the original surrogate key ==='
SELECT vessel_key AS old_vessel_key
FROM dw.dim_vessel
WHERE vessel_code = 'V-001' AND is_current
\gset

SELECT COUNT(*) AS old_key_rows,
       ROUND(SUM(total_value), 2) AS old_key_value
FROM dw.fact_landing
WHERE vessel_key = :old_vessel_key;

\echo ''
\echo '=== 3. BASELINE - historical report: value per cooperative (landings <= 2026-06-30) ==='
SELECT v.cooperative,
       ROUND(SUM(f.total_value), 2) AS total_value
FROM dw.fact_landing f
JOIN dw.dim_vessel v ON v.vessel_key = f.vessel_key
JOIN dw.dim_date   d ON d.date_key   = f.date_key
WHERE d.full_date <= date '2026-06-30'
GROUP BY v.cooperative
ORDER BY total_value DESC;

\echo ''
\echo '=== 4. APPLYING SCD TYPE 2 CHANGE (cooperative move effective 2026-07-01) ==='
BEGIN;

UPDATE dw.dim_vessel
SET effective_to = date '2026-06-30',
    is_current    = false
WHERE vessel_code = 'V-001'
  AND is_current;

INSERT INTO dw.dim_vessel
    (vessel_code, vessel_name, vessel_type, capacity_tons,
     cooperative, owner, effective_from, effective_to, is_current)
SELECT vessel_code, vessel_name, vessel_type, capacity_tons,
       'Bataan Coastal Cooperative', owner,
       date '2026-07-01', NULL, true
FROM dw.dim_vessel
WHERE vessel_code = 'V-001'
  AND effective_to = date '2026-06-30'
  AND NOT is_current;

COMMIT;

\echo ''
\echo '=== 5. AFTER - FV Batanes Pearl now has two versions ==='
SELECT vessel_key, vessel_code, cooperative, owner,
       effective_from, effective_to, is_current
FROM dw.dim_vessel
WHERE vessel_code = 'V-001'
ORDER BY effective_from;

\echo ''
\echo '=== 6. AFTER - facts on the old surrogate key are untouched ==='
SELECT COUNT(*) AS old_key_rows,
       ROUND(SUM(total_value), 2) AS old_key_value
FROM dw.fact_landing
WHERE vessel_key = :old_vessel_key;

\echo ''
\echo '=== 7. AFTER - historical report is IDENTICAL to baseline (step 3) ==='
SELECT v.cooperative,
       ROUND(SUM(f.total_value), 2) AS total_value
FROM dw.fact_landing f
JOIN dw.dim_vessel v ON v.vessel_key = f.vessel_key
JOIN dw.dim_date   d ON d.date_key   = f.date_key
WHERE d.full_date <= date '2026-06-30'
GROUP BY v.cooperative
ORDER BY total_value DESC;

\echo ''
\echo '=== 8. NEW landings after the change use the NEW surrogate key ==='
INSERT INTO dw.fact_landing (date_key, port_key, species_key, vessel_key, kg_landed, price_per_kg)
SELECT to_char(d, 'YYYYMMDD')::int,
       (SELECT port_key    FROM dw.dim_port    WHERE port_code    = 'P-NAV'),
       (SELECT species_key FROM dw.dim_species WHERE species_code = 'S-TUN'),
       v.vessel_key,
       round((400 + random() * 300)::numeric, 2),
       round((280 + random() * 60)::numeric, 2)
FROM dw.dim_vessel v
CROSS JOIN generate_series(date '2026-07-01', date '2026-07-05', interval '1 day') d
WHERE v.vessel_code = 'V-001'
  AND v.is_current;

SELECT f.landing_id, d.full_date, v.vessel_key, v.cooperative,
       f.kg_landed, f.total_value
FROM dw.fact_landing f
JOIN dw.dim_vessel v ON v.vessel_key = f.vessel_key
JOIN dw.dim_date   d ON d.date_key   = f.date_key
WHERE v.vessel_code = 'V-001'
ORDER BY d.full_date DESC
LIMIT 8;

\echo ''
\echo '=== 9. Point-in-time report - each landing attributed to the version ==='
\echo '=== valid when it happened (old facts -> Navotas, new facts -> Bataan)  ==='
SELECT v.vessel_name,
       d.full_date,
       v.cooperative,
       f.total_value
FROM dw.fact_landing f
JOIN dw.dim_vessel v ON v.vessel_key = f.vessel_key
                    AND f.date_key BETWEEN to_char(v.effective_from, 'YYYYMMDD')::int
                                       AND COALESCE(to_char(v.effective_to, 'YYYYMMDD')::int, 99991231)
JOIN dw.dim_date   d ON d.date_key   = f.date_key
WHERE v.vessel_code = 'V-001'
ORDER BY d.full_date DESC
LIMIT 10;

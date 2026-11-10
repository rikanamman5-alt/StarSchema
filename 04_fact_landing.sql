-- Lab 1: Step 4 - generate 600 fact records
-- Facts span 2020-01-01 .. 2026-06-30 (before the SCD Type 2 changeover date used in step 6)

SELECT setseed(0.42);

INSERT INTO dw.fact_landing (date_key, port_key, species_key, vessel_key, kg_landed, price_per_kg)
SELECT to_char(date '2020-01-01'
               + (random() * (date '2026-06-30' - date '2020-01-01'))::int,
               'YYYYMMDD')::int,
       (ARRAY(SELECT port_key    FROM dw.dim_port))    [1 + floor(random() * (SELECT COUNT(*) FROM dw.dim_port))::int],
       (ARRAY(SELECT species_key FROM dw.dim_species)) [1 + floor(random() * (SELECT COUNT(*) FROM dw.dim_species))::int],
       (ARRAY(SELECT vessel_key  FROM dw.dim_vessel WHERE is_current)) [1 + floor(random() * (SELECT COUNT(*) FROM dw.dim_vessel WHERE is_current))::int],
       round((50 + random() * 800)::numeric, 2),
       round((60 + random() * 240)::numeric, 2)
FROM generate_series(1, 600) AS g(i);

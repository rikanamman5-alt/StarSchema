-- Lab 1: Step 5 - analytical queries

-- Query 1: Total kilograms landed per month
SELECT d.year,
       d.month,
       d.month_name,
       ROUND(SUM(f.kg_landed), 2) AS total_kg,
       COUNT(*)                  AS landings
FROM dw.fact_landing f
JOIN dw.dim_date d ON d.date_key = f.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- Query 2: Top species per port by total kilograms landed
SELECT ranked.port_name,
       ranked.species,
       ROUND(ranked.total_kg, 2) AS total_kg
FROM (
    SELECT p.port_name,
           s.common_name AS species,
           SUM(f.kg_landed) AS total_kg,
           RANK() OVER (PARTITION BY p.port_name
                        ORDER BY SUM(f.kg_landed) DESC) AS rnk
    FROM dw.fact_landing f
    JOIN dw.dim_port    p ON p.port_key    = f.port_key
    JOIN dw.dim_species s ON s.species_key = f.species_key
    GROUP BY p.port_name, s.common_name
) ranked
WHERE ranked.rnk = 1
ORDER BY ranked.total_kg DESC;

-- Query 3: Total landed value per cooperative
SELECT v.cooperative,
       ROUND(SUM(f.total_value), 2) AS total_value,
       COUNT(*)                    AS landings
FROM dw.fact_landing f
JOIN dw.dim_vessel v ON v.vessel_key = f.vessel_key
GROUP BY v.cooperative
ORDER BY total_value DESC;

-- Lab 1: Step 2 - populate dim_date for 2020-2030 using generate_series()

INSERT INTO dw.dim_date
    (date_key, full_date, year, quarter, month, month_name,
     day, day_of_week, day_name, week_of_year, is_weekend)
SELECT to_char(d, 'YYYYMMDD')::int,
       d,
       EXTRACT(YEAR    FROM d)::int,
       EXTRACT(QUARTER FROM d)::int,
       EXTRACT(MONTH   FROM d)::int,
       trim(to_char(d, 'Month')),
       EXTRACT(DAY     FROM d)::int,
       EXTRACT(ISODOW  FROM d)::int,
       trim(to_char(d, 'Day')),
       EXTRACT(WEEK    FROM d)::int,
       EXTRACT(ISODOW  FROM d)::int IN (6, 7)
FROM generate_series(date '2020-01-01', date '2030-12-31', interval '1 day') AS d;

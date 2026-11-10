-- Lab 1: Fisheries Star Schema - Step 1: schema and tables

DROP SCHEMA IF EXISTS dw CASCADE;

CREATE SCHEMA dw;

CREATE TABLE dw.dim_date (
    date_key     integer     PRIMARY KEY,
    full_date    date        NOT NULL UNIQUE,
    year         integer     NOT NULL,
    quarter      integer     NOT NULL,
    month        integer     NOT NULL,
    month_name   text        NOT NULL,
    day          integer     NOT NULL,
    day_of_week  integer     NOT NULL,
    day_name     text        NOT NULL,
    week_of_year integer     NOT NULL,
    is_weekend   boolean     NOT NULL
);

CREATE TABLE dw.dim_port (
    port_key    serial   PRIMARY KEY,
    port_code   text      NOT NULL UNIQUE,
    port_name   text      NOT NULL,
    region      text      NOT NULL,
    country     text      NOT NULL DEFAULT 'Philippines'
);

CREATE TABLE dw.dim_species (
    species_key     serial  PRIMARY KEY,
    species_code    text    NOT NULL UNIQUE,
    common_name     text    NOT NULL,
    scientific_name text    NOT NULL,
    category        text    NOT NULL
);

CREATE TABLE dw.dim_vessel (
    vessel_key     serial       PRIMARY KEY,
    vessel_code    text         NOT NULL,
    vessel_name    text         NOT NULL,
    vessel_type    text         NOT NULL,
    capacity_tons  numeric(8,2) NOT NULL,
    cooperative    text         NOT NULL,
    owner          text         NOT NULL,
    effective_from date         NOT NULL,
    effective_to   date,
    is_current     boolean      NOT NULL DEFAULT true,
    UNIQUE (vessel_code, effective_from)
);

CREATE TABLE dw.fact_landing (
    landing_id    bigint       PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    date_key      integer      NOT NULL REFERENCES dw.dim_date (date_key),
    port_key      integer      NOT NULL REFERENCES dw.dim_port (port_key),
    species_key   integer      NOT NULL REFERENCES dw.dim_species (species_key),
    vessel_key    integer      NOT NULL REFERENCES dw.dim_vessel (vessel_key),
    kg_landed     numeric(10,2) NOT NULL CHECK (kg_landed > 0),
    price_per_kg  numeric(10,2) NOT NULL CHECK (price_per_kg > 0),
    total_value   numeric(12,2) GENERATED ALWAYS AS (kg_landed * price_per_kg) STORED
);

CREATE INDEX idx_fact_landing_date_key    ON dw.fact_landing (date_key);
CREATE INDEX idx_fact_landing_port_key    ON dw.fact_landing (port_key);
CREATE INDEX idx_fact_landing_species_key ON dw.fact_landing (species_key);
CREATE INDEX idx_fact_landing_vessel_key  ON dw.fact_landing (vessel_key);
CREATE INDEX idx_dim_vessel_current       ON dw.dim_vessel (vessel_code) WHERE is_current;

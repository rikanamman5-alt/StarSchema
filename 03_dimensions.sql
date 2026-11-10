-- Lab 1: Step 3 - sample dimension records

INSERT INTO dw.dim_port (port_code, port_name, region) VALUES
    ('P-NAV', 'Navotas Fish Port Complex',   'National Capital Region'),
    ('P-GES', 'General Santos Fish Port',    'Region XII - Soccsksargen'),
    ('P-ILO', 'Iloilo Fishing Port',         'Region VI - Western Visayas'),
    ('P-CEB', 'Cebu Fishing Port Complex',   'Region VII - Central Visayas'),
    ('P-DAV', 'Davao Fish Port',             'Region XI - Davao'),
    ('P-ZAM', 'Zamboanga Fish Port',          'Region IX - Zamboanga Peninsula'),
    ('P-BAT', 'Bataan Coastal Port',          'Region III - Central Luzon'),
    ('P-PAL', 'Palawan Municipal Fish Port', 'Region IV-B - MIMAROPA');

INSERT INTO dw.dim_species (species_code, common_name, scientific_name, category) VALUES
    ('S-TUN', 'Yellowfin Tuna',    'Thunnus albacares',        'Pelagic'),
    ('S-SKJ', 'Skipjack Tuna',     'Katsuwonus pelamis',       'Pelagic'),
    ('S-RRS', 'Roundscad',         'Decapterus macrosoma',     'Pelagic'),
    ('S-SRD', 'Indian Sardine',    'Sardinella longiceps',     'Pelagic'),
    ('S-MRL', 'Blue Marlin',       'Makaira nigricans',        'Pelagic'),
    ('S-BGS', 'Milkfish',          'Chanos chanos',            'Aquaculture'),
    ('S-TIL', 'Nile Tilapia',      'Oreochromis niloticus',    'Aquaculture'),
    ('S-GRP', 'Camouflage Grouper','Epinephelus fuscoguttatus','Demersal'),
    ('S-SQI', 'Bigfin Reef Squid', 'Sepioteuthis lessoniana',  'Cephalopod'),
    ('S-CRB', 'Mud Crab',          'Scylla serrata',           'Crustacean');

INSERT INTO dw.dim_vessel
    (vessel_code, vessel_name, vessel_type, capacity_tons, cooperative, owner, effective_from)
VALUES
    ('V-001', 'FV Batanes Pearl', 'Ring Net',     60.00, 'Navotas Fisherfolk Cooperative',    'Ricardo Cruz',    date '2020-01-01'),
    ('V-002', 'FV Sarangani Star','Purse Seiner', 120.00,'Sarangani Fishing Cooperative',     'Amina Hadji',     date '2020-01-01'),
    ('V-003', 'FV Iloilo Wind',   'Handliner',    15.00, 'Iloilo Small Fishers Association',   'Jose Bautista',   date '2020-01-01'),
    ('V-004', 'FV Davao Current', 'Longliner',    80.00, 'Davao Gulf Fishermen Cooperative',  'Elena Ramos',     date '2020-01-01'),
    ('V-005', 'FV Cebu Tide',     'Crab Pot',    25.00, 'Cebu Coastal Cooperative',           'Miguel Ocampo',   date '2020-01-01'),
    ('V-006', 'FV Zambales Wave', 'Ring Net',    55.00, 'Zambales Fisherfolk Federation',     'Carmelo Reyes',   date '2020-01-01'),
    ('V-007', 'FV Palawan Reef',  'Handliner',   12.00, 'Palawan Artisanal Fishers Guild',    'Nestor Abad',     date '2020-01-01'),
    ('V-008', 'FV Mindoro Mist',  'Gillnetter',  30.00, 'Mindoro Oriental Cooperative',       'Lorna Feliciano', date '2020-01-01'),
    ('V-009', 'FV Bataan Horizon','Trawler',     40.00, 'Bataan Coastal Cooperative',        'Danilo Santos',   date '2020-01-01'),
    ('V-010', 'FV Sorsogon Breeze','Purse Seiner',90.00, 'Sorsogon Deep Sea Cooperative',     'Pablo Villamor',  date '2020-01-01');

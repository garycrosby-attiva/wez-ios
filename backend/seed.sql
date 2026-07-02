-- Seed beaches for the V1 seed regions: Sunshine Coast and Port Fairy.
-- Coordinates are approximate beach centroids; tagsStatic are beach-intrinsic.

DELETE FROM Beach;

INSERT INTO Beach (id, name, region, latitude, longitude, tagsStatic, createdAt) VALUES
  ('moffat',     'Moffat Beach',     'Sunshine Coast', -26.7945, 153.1410, '["Picnic","Shade","Family-easy"]',        '2026-01-01T00:00:00Z'),
  ('kings',      'Kings Beach',      'Sunshine Coast', -26.8014, 153.1442, '["Playground","Family-easy","UV friendly"]','2026-01-01T00:00:00Z'),
  ('mooloolaba', 'Mooloolaba Beach', 'Sunshine Coast', -26.6819, 153.1190, '["Picnic","Family-easy"]',                 '2026-01-01T00:00:00Z'),
  ('east',       'East Beach',       'Port Fairy',     -38.3833, 142.2470, '["Shade","Picnic"]',                       '2026-01-01T00:00:00Z'),
  ('south',      'South Beach',      'Port Fairy',     -38.3950, 142.2300, '["UV friendly"]',                          '2026-01-01T00:00:00Z');

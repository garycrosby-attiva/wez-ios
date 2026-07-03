-- Where's Ez local D1 schema (AD-WEZ-post-metadata-store v2 shape).
-- Beach-intrinsic and post metadata; complex nested fields (captureConditions,
-- derivedTags) are stored as JSON text and round-trip verbatim to the Swift Codable types.

CREATE TABLE IF NOT EXISTS Beach (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  region      TEXT NOT NULL,
  latitude    REAL NOT NULL,
  longitude   REAL NOT NULL,
  tagsStatic  TEXT NOT NULL,   -- JSON array of strings
  createdAt   TEXT NOT NULL    -- ISO8601
);

CREATE TABLE IF NOT EXISTS SpottedPost (
  id                 TEXT PRIMARY KEY,
  beachId            TEXT NOT NULL,
  photoUrl           TEXT NOT NULL,   -- canonical object key, pattern spotted/{id}.jpg
  caption            TEXT,            -- nullable (deferred affordance)
  captureConditions  TEXT NOT NULL,   -- JSON object (BeachConditions)
  derivedTags        TEXT NOT NULL,   -- JSON array of strings
  summary            TEXT,            -- editorial pair: both null or both populated
  author             TEXT,
  createdAt          TEXT NOT NULL    -- ISO8601
);

CREATE INDEX IF NOT EXISTS idx_post_createdAt ON SpottedPost (createdAt DESC);

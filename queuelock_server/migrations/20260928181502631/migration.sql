BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "join_rate_limit_hit" (
    "id" bigserial PRIMARY KEY,
    "queueId" bigint NOT NULL,
    "ipHash" text NOT NULL,
    "tsMs" bigint NOT NULL
);

-- Indexes
CREATE INDEX "join_rate_limit_lookup_idx" ON "join_rate_limit_hit" USING btree ("queueId", "ipHash", "tsMs");


--
-- MIGRATION VERSION FOR queuelock
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('queuelock', '20260928181502631', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928181502631', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;

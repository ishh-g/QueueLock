BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "counter" (
    "id" bigserial PRIMARY KEY,
    "queueId" bigint NOT NULL,
    "name" text NOT NULL,
    "active" boolean NOT NULL DEFAULT true
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ledger_entry" (
    "id" bigserial PRIMARY KEY,
    "queueId" bigint NOT NULL,
    "seq" bigint NOT NULL,
    "type" text NOT NULL,
    "ticketNumber" bigint,
    "counterId" bigint,
    "detail" text,
    "tsMs" bigint NOT NULL,
    "prevHash" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "ledger_entry__queueId__seq__unique_idx" ON "ledger_entry" USING btree ("queueId", "seq");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "queue" (
    "id" bigserial PRIMARY KEY,
    "slug" text NOT NULL,
    "name" text NOT NULL,
    "status" text NOT NULL,
    "callTimeoutSec" bigint NOT NULL DEFAULT 180,
    "lastNumber" bigint NOT NULL DEFAULT 0,
    "headSeq" bigint NOT NULL DEFAULT 0,
    "headHash" text NOT NULL DEFAULT '0000000000000000000000000000000000000000000000000000000000000000'::text,
    "avgServiceSec" double precision NOT NULL DEFAULT 300.0,
    "sampleCount" bigint NOT NULL DEFAULT 0,
    "ownerId" uuid NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "queue__slug__unique_idx" ON "queue" USING btree ("slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "service_sample" (
    "id" bigserial PRIMARY KEY,
    "queueId" bigint NOT NULL,
    "counterId" bigint,
    "hourOfDay" bigint NOT NULL,
    "durationSec" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ticket" (
    "id" bigserial PRIMARY KEY,
    "queueId" bigint NOT NULL,
    "number" bigint NOT NULL,
    "nickname" text,
    "tokenHash" text NOT NULL,
    "status" text NOT NULL,
    "orderKey" double precision NOT NULL,
    "callId" bigint NOT NULL DEFAULT 0,
    "calledAt" timestamp without time zone,
    "counterId" bigint,
    "servingAt" timestamp without time zone,
    "doneAt" timestamp without time zone,
    "reentries" bigint NOT NULL DEFAULT 0,
    "joinedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "ticket__queueId__number__unique_idx" ON "ticket" USING btree ("queueId", "number");
CREATE INDEX "ticket_queue_status_order_idx" ON "ticket" USING btree ("queueId", "status", "orderKey");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "counter"
    ADD CONSTRAINT "counter_fk_0"
    FOREIGN KEY("queueId")
    REFERENCES "queue"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ledger_entry"
    ADD CONSTRAINT "ledger_entry_fk_0"
    FOREIGN KEY("queueId")
    REFERENCES "queue"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "service_sample"
    ADD CONSTRAINT "service_sample_fk_0"
    FOREIGN KEY("queueId")
    REFERENCES "queue"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ticket"
    ADD CONSTRAINT "ticket_fk_0"
    FOREIGN KEY("queueId")
    REFERENCES "queue"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR queuelock
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('queuelock', '20260928092346695', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928092346695', "timestamp" = now();

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

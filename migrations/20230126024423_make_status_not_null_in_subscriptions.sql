-- sqlx does not automatically wrap migrations in a transaction
BEGIN;
    -- backfill 'status' for historical entries
    UPDATE subscription
        SET status = 'confirmed'
        WHERE status IS NULL;
    -- make 'status' mandatory
    ALTER TABLE subscription
    ALTER COLUMN status SET NOT NULL;
COMMIT;
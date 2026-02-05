-- Checkpoint Management System - Audit Table Initialization
-- This table tracks all checkpoints and cleanup operations

CREATE TABLE IF NOT EXISTS CHECKPOINT_AUDIT (
    CHECKPOINT_ID VARCHAR(50) PRIMARY KEY,
    CHECKPOINT_TIMESTAMP TIMESTAMP_NTZ NOT NULL,
    CHECKPOINT_TYPE VARCHAR(20) NOT NULL,  -- 'MANUAL', 'AUTO', 'CLEANUP', 'RESTORE'
    CREATED_BY VARCHAR(100) DEFAULT CURRENT_USER(),
    DESCRIPTION VARCHAR(500),
    OBJECTS_SNAPSHOT VARIANT,  -- JSON array of objects at checkpoint time
    OBJECTS_COUNT NUMBER,  -- Quick count of objects
    STATUS VARCHAR(20) DEFAULT 'ACTIVE',  -- 'ACTIVE', 'RESTORED_TO', 'DELETED'
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    UPDATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    METADATA VARIANT  -- Additional metadata (operation details, errors, etc.)
);

-- Add comment
COMMENT ON TABLE CHECKPOINT_AUDIT IS 'Tracks checkpoints and cleanup operations for demo environment management';

-- Insert initial system checkpoint
INSERT INTO CHECKPOINT_AUDIT (
    CHECKPOINT_ID,
    CHECKPOINT_TIMESTAMP,
    CHECKPOINT_TYPE,
    DESCRIPTION,
    STATUS
)
SELECT 
    'SYSTEM_INIT',
    CURRENT_TIMESTAMP(),
    'AUTO',
    'Initial system checkpoint created during setup',
    'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM CHECKPOINT_AUDIT WHERE CHECKPOINT_ID = 'SYSTEM_INIT');
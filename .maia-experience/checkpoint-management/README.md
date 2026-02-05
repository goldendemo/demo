# Checkpoint Management System

A comprehensive demo environment management system for Snowflake that provides checkpoint creation, cleanup, and restore capabilities using time travel.

---

## 🎯 **Overview**

This system allows you to:
1. ✅ **Create checkpoints** - Save the current state of your schema
2. ✅ **Cleanup selectively** - Remove objects created after a checkpoint
3. ✅ **Full cleanup** - Delete all objects in schema (except audit table)
4. ✅ **Restore dropped objects** - Recover deleted tables/views using Snowflake time travel
5. ✅ **Audit trail** - Persistent history of all checkpoints and operations

---

## 📦 **Components**

### **1. init_checkpoint_audit_table.sql**
**Purpose:** Initializes the audit table that tracks all checkpoints and operations.

**What it creates:**
- `CHECKPOINT_AUDIT` table with columns:
  - `CHECKPOINT_ID` - Unique identifier
  - `CHECKPOINT_TIMESTAMP` - When checkpoint was created
  - `CHECKPOINT_TYPE` - MANUAL, AUTO, CLEANUP, or RESTORE
  - `OBJECTS_SNAPSHOT` - JSON snapshot of all objects at checkpoint
  - `OBJECTS_COUNT` - Quick count of objects
  - `STATUS` - ACTIVE, RESTORED_TO, or DELETED
- Index on `CHECKPOINT_TIMESTAMP` for faster lookups
- Initial `SYSTEM_INIT` checkpoint record

**Two ways to run this:**

**Option A: Via Main Controller (Recommended)**
1. Open ".maia-experience/checkpoint-management/Main Checkpoint Controller.orch.yaml"
2. Set `intent = "INIT_AUDIT_TABLE"`
3. Run the orchestration
4. Table is initialized automatically

**Option B: Direct SQL Execution**
```sql
-- Execute the SQL script directly in Snowflake
-- File: .maia-experience/checkpoint-management/init_checkpoint_audit_table.sql
```

---

### **2. Main Checkpoint Controller.orch.yaml**
**Type:** Orchestration Pipeline

**Purpose:** Single entry point controller that routes to all checkpoint operations.

**Variables:**
- `intent` (TEXT, required)
  - Operation to perform: `CREATE_CHECKPOINT`, `CLEANUP_SINCE`, `FULL_CLEANUP`, or `RESTORE`
- `checkpoint_id` (TEXT)
  - Required for `CLEANUP_SINCE` and `RESTORE`
- `checkpoint_description` (TEXT, default: "Manual checkpoint")
  - Required for `CREATE_CHECKPOINT`
- `dry_run` (TEXT, default: "YES")
  - Used with `CLEANUP_SINCE`, `FULL_CLEANUP`, `RESTORE`
- `confirm_delete_all` (TEXT)
  - Must be "DELETE_ALL" for `FULL_CLEANUP` execution

**What it does:**
- Routes to appropriate child orchestration based on intent value
- Passes variables to child orchestrations
- Provides single interface for all checkpoint operations
- Error handling for invalid intent values

**How to use:**
1. Set `intent` variable to desired operation
2. Set required variables based on intent (see note in pipeline)
3. Run the orchestration
4. Pipeline automatically routes to correct child orchestration

**Intent Values:**
- `INIT_AUDIT_TABLE` - Initialize CHECKPOINT_AUDIT table **(run first!)**
  - No variables required
  - Executes `.maia-experience/checkpoint-management/init_checkpoint_audit_table.sql`
- `CREATE_CHECKPOINT` - Creates new checkpoint
  - Required: `checkpoint_description`
- `CLEANUP_SINCE` - Cleanup objects after checkpoint
  - Required: `checkpoint_id`, `dry_run`
- `FULL_CLEANUP` - Delete all objects
  - Required: `dry_run`, `confirm_delete_all`
- `RESTORE` - Restore dropped objects
  - Required: `checkpoint_id`, `dry_run`

**Benefits:**
- Simplified workflow - one pipeline to rule them all
- Centralized variable management
- Clear documentation note in pipeline
- Easy to extend with new operations

---

### **3. View Available Checkpoints.tran.yaml**
**Type:** Transformation Pipeline

**Purpose:** Displays all available checkpoints with details.

**How to use:**
1. Open the transformation pipeline
2. Click **Sample** on the "Get Checkpoints" component
3. View all checkpoints with their IDs, timestamps, and descriptions
4. Copy the `CHECKPOINT_ID` you want to use for restore/cleanup operations

**What it shows:**
- Checkpoint ID
- Timestamp
- Type (MANUAL, AUTO, CLEANUP, RESTORE)
- Description
- Object count
- Status

---

### **4. Create Checkpoint.orch.yaml**
**Type:** Orchestration Pipeline

**Purpose:** Creates a new checkpoint of the current schema state.

**Variables:**
- `checkpoint_description` (TEXT, default: "Manual checkpoint")
  - Describe what this checkpoint is for

**What it does:**
1. Auto-generates a unique checkpoint ID (e.g., `CP_2024_01_15_14_30`)
2. Queries all tables and views in the current schema
3. Captures metadata (name, type, created date, row count, size)
4. Stores everything as JSON in `CHECKPOINT_AUDIT`
5. Excludes `CHECKPOINT_AUDIT` table itself

**How to use:**
1. Optionally update `checkpoint_description` variable
2. Run the pipeline
3. Checkpoint is created and saved

---

### **5. Cleanup Since Checkpoint.orch.yaml**
**Type:** Orchestration Pipeline

**Purpose:** Removes objects created after a specific checkpoint.

**Variables:**
- `checkpoint_id` (TEXT, required)
  - The checkpoint ID to revert to
  - Sample "View Available Checkpoints" to find IDs
- `dry_run` (TEXT, default: "YES")
  - "YES" = Preview what would be deleted
  - "NO" = Execute deletion

**What it does:**
**Dry run mode (default):**
- Compares current objects vs checkpoint snapshot
- Displays preview with Python Pushdown
- Shows objects grouped by type (views/tables)
- No changes made

**Execute mode:**
- Identifies objects created after checkpoint
- Drops views first (dependency handling)
- Drops tables second
- Preserves `CHECKPOINT_AUDIT` table

**How to use:**
1. Set `checkpoint_id` to the checkpoint you want to revert to
2. Leave `dry_run = "YES"` to preview
3. Review the preview results in task history
4. Set `dry_run = "NO"` to execute
5. Run the pipeline

**Safety:** Always preview first!

---

### **6. Full Schema Cleanup.orch.yaml**
**Type:** Orchestration Pipeline

**Purpose:** Deletes ALL tables and views in the schema (except `CHECKPOINT_AUDIT`).

**Variables:**
- `dry_run` (TEXT, default: "YES")
  - "YES" = Preview what would be deleted
  - "NO" = Execute deletion
- `confirm_delete_all` (TEXT, required for execution)
  - Must be set to "DELETE_ALL" to execute
  - Safety check to prevent accidental deletion

**What it does:**
**Dry run mode (default):**
- Shows all objects that would be deleted
- Displays object names, types, row counts, sizes
- Uses Python Pushdown for detailed preview
- No changes made

**Execute mode:**
- Requires `confirm_delete_all = "DELETE_ALL"`
- Drops all views first
- Drops all tables second
- Preserves `CHECKPOINT_AUDIT` table
- Logs cleanup operation in audit table

**How to use:**
1. Leave `dry_run = "YES"` to preview
2. Review what would be deleted in task history
3. Set `confirm_delete_all = "DELETE_ALL"`
4. Set `dry_run = "NO"`
5. Run the pipeline

**Safety:** Requires TWO confirmations (confirm variable + dry_run flag)

---

### **7. Restore Dropped Objects.orch.yaml**
**Type:** Orchestration Pipeline

**Purpose:** Restores dropped tables/views using Snowflake time travel.

**Variables:**
- `checkpoint_id` (TEXT, required)
  - Checkpoint to restore objects from
  - Sample "View Available Checkpoints" to find IDs
- `dry_run` (TEXT, default: "YES")
  - "YES" = Preview what would be restored
  - "NO" = Execute restore

**What it does:**
**Dry run mode (default):**
- Identifies objects that existed at checkpoint but don't exist now
- Shows object names, types, and UNDROP commands
- Uses Python Pushdown for detailed preview
- No changes made

**Execute mode:**
- Uses Snowflake `UNDROP TABLE` and `UNDROP VIEW` commands
- Restores objects within time travel retention window
- Logs restore operation in audit table
- Continues on errors (object might be outside retention period)

**How to use:**
1. Set `checkpoint_id` to checkpoint with objects you want to restore
2. Leave `dry_run = "YES"` to preview
3. Review what would be restored in task history
4. Set `dry_run = "NO"` to execute
5. Run the pipeline

**Important:**
- Only works within Snowflake time travel retention period
- Standard edition: 1 day retention
- Enterprise edition: up to 90 days (configurable)

---

## 🚀 **Quick Start Guide**

**Two Ways to Use This System:**
1. **Main Controller (Recommended)** - Use "Main Checkpoint Controller" orchestration as single entry point
2. **Individual Pipelines** - Run each child orchestration directly

### **Method 1: Using Main Controller (Easiest)**

#### **Step 1: Initialize the Audit Table**
1. Open ".maia-experience/checkpoint-management/Main Checkpoint Controller.orch.yaml"
2. Set variables:
   - `intent = "INIT_AUDIT_TABLE"`
3. Run the pipeline
4. CHECKPOINT_AUDIT table is created

#### **Step 2: Create Your First Checkpoint**
1. Keep the same orchestration open
2. Set variables:
   - `intent = "CREATE_CHECKPOINT"`
   - `checkpoint_description = "Initial state"`
3. Run the pipeline again
4. Your baseline checkpoint is created

#### **Step 3: Work on Your Demo**
- Create tables, views, load data
- Make changes as needed

#### **Step 4: View Checkpoints**
1. Open ".maia-experience/checkpoint-management/View Available Checkpoints.tran.yaml"
2. Sample to see your checkpoints
3. Copy the checkpoint ID you want

#### **Step 5: Reset to Checkpoint**
1. Open ".maia-experience/checkpoint-management/Main Checkpoint Controller.orch.yaml"
2. Set variables:
   - `intent = "CLEANUP_SINCE"`
   - `checkpoint_id = "CP_2024_01_15_14_30"` (your ID)
   - `dry_run = "YES"`
3. Run to preview
4. Set `dry_run = "NO"` and run again to execute

---

### **Method 2: Using Individual Pipelines**

#### **Step 1: Initialize the Audit Table**

**Option A: Via Main Controller**
1. Open ".maia-experience/checkpoint-management/Main Checkpoint Controller.orch.yaml"
2. Set `intent = "INIT_AUDIT_TABLE"`
3. Run the pipeline

**Option B: Direct SQL Execution**
```sql
-- Execute the SQL script directly in Snowflake
-- File: .maia-experience/checkpoint-management/init_checkpoint_audit_table.sql
```

#### **Step 2: Create Your First Checkpoint**
1. Open ".maia-experience/checkpoint-management/Create Checkpoint.orch.yaml"
2. Set `checkpoint_description` to "Initial state"
3. Run the pipeline
4. Your baseline checkpoint is created

#### **Step 3: Work on Your Demo**
- Create tables, views, load data
- Make changes as needed

#### **Step 4: Create Another Checkpoint** (optional)
1. Before making major changes
2. Run "Create Checkpoint" again
3. Set meaningful description

#### **Step 5: Reset to Checkpoint**
1. Open ".maia-experience/checkpoint-management/View Available Checkpoints.tran.yaml"
2. Sample to see your checkpoints
3. Copy the checkpoint ID you want
4. Open ".maia-experience/checkpoint-management/Cleanup Since Checkpoint.orch.yaml"
5. Set `checkpoint_id` to your desired checkpoint
6. Run with `dry_run = "YES"` first
7. Review preview, then run with `dry_run = "NO"`

---

## 💡 **Common Use Cases**

### **Use Case 1: Demo Reset**
**Scenario:** After each demo, reset to clean state

**Steps:**
1. Create checkpoint before first demo
2. Run demos, create test data
3. Use "Cleanup Since Checkpoint" to reset
4. Ready for next demo!

### **Use Case 2: Experiment Safely**
**Scenario:** Try something risky, need rollback capability

**Steps:**
1. Create checkpoint before experiment
2. Run experiment, create objects
3. If it works: keep it!
4. If it fails: cleanup since checkpoint

### **Use Case 3: Complete Wipe**
**Scenario:** Start completely fresh

**Steps:**
1. Run "Full Schema Cleanup"
2. Preview with dry run
3. Confirm and execute
4. Everything gone except audit trail

### **Use Case 4: Recover Mistake**
**Scenario:** Accidentally dropped important table

**Steps:**
1. Find checkpoint before the drop
2. Run "Restore Dropped Objects"
3. Preview what would be restored
4. Execute restore
5. Table recovered!

---

## ⚠️ **Important Notes**

### **Time Travel Limitations**
- Standard Snowflake: 1 day retention
- Enterprise Snowflake: Up to 90 days (you have Enterprise)
- Objects outside retention window cannot be restored

### **Safety Features**
- **Dry run mode default:** All destructive operations default to preview
- **Confirmation required:** Full cleanup requires explicit confirmation
- **Audit trail:** All operations logged in `CHECKPOINT_AUDIT`
- **Preserves audit table:** Cleanup operations never delete `CHECKPOINT_AUDIT`
- **Python Pushdown previews:** Dry runs display actual data, not just temp tables

### **Best Practices**
1. **Always preview first** - Run dry run before any deletion
2. **Create checkpoints frequently** - Before major changes
3. **Use descriptive names** - Make checkpoint descriptions meaningful
4. **Check time travel window** - Know your retention period
5. **Review audit table** - Sample "View Available Checkpoints" regularly
6. **Check task history** - Review Python Pushdown output for detailed previews

---

## 🔍 **Troubleshooting**

### **"No objects to restore"**
**Cause:** Objects are outside time travel retention window
**Solution:** Cannot restore - create new checkpoint going forward

### **"Checkpoint not found"**
**Cause:** Invalid `checkpoint_id` provided
**Solution:** Sample "View Available Checkpoints" to get valid IDs

### **"Safety check failed"**
**Cause:** `confirm_delete_all` not set to "DELETE_ALL"
**Solution:** Set variable correctly for full cleanup

### **View drop fails with dependency error**
**Cause:** Views with complex dependencies
**Solution:** Pipeline drops views first, but some may fail - safe to ignore

### **"JWT token is invalid" validation warnings**
**Cause:** Temporary validation issue with Python Pushdown components
**Solution:** These are expected and won't affect pipeline execution

---

## 📊 **Architecture**

```
Checkpoint Management System (.maia-experience/checkpoint-management/)
│
├── CHECKPOINT_AUDIT (table)
│   └── Stores all checkpoints and metadata
│
├── Main Checkpoint Controller (orchestration) ⭐
│   ├── Single entry point for all operations
│   ├── Routes by intent variable
│   ├── INIT_AUDIT_TABLE: Executes init_checkpoint_audit_table.sql
│   └── Calls child orchestrations:
│       ├── Create Checkpoint
│       ├── Cleanup Since Checkpoint
│       ├── Full Schema Cleanup
│       └── Restore Dropped Objects
│
├── View Available Checkpoints (transformation)
│   └── Query interface to see checkpoints
│
├── Create Checkpoint (orchestration)
│   └── Captures current state
│
├── Cleanup Since Checkpoint (orchestration)
│   ├── Dry run: Python Pushdown preview with data display
│   └── Execute: Drop objects via SQL Executor
│
├── Full Schema Cleanup (orchestration)
│   ├── Safety check with Print Variables + End Failure
│   ├── Dry run: Python Pushdown preview with sizes
│   └── Execute: Drop everything via SQL Executor
│
└── Restore Dropped Objects (orchestration)
    ├── Dry run: Python Pushdown preview with UNDROP commands
    └── Execute: UNDROP objects via SQL Executor
```

---

## 🎓 **How It Works**

### **Checkpoint Creation**
1. Query `INFORMATION_SCHEMA.TABLES` for all objects
2. Extract metadata (name, type, created, row count, size)
3. Convert to JSON and store in `OBJECTS_SNAPSHOT` column
4. Generate unique checkpoint ID
5. Insert record into `CHECKPOINT_AUDIT`

### **Cleanup Logic**
1. Retrieve checkpoint snapshot from `CHECKPOINT_AUDIT`
2. Query current objects from `INFORMATION_SCHEMA.TABLES`
3. Compare: find objects in current but not in checkpoint
4. **Dry run:** Python Pushdown displays preview to task history
5. **Execute:** Generate and run DROP statements via SQL Executor
6. Execute in correct order (views first, then tables)

### **Restore Logic**
1. Retrieve checkpoint snapshot
2. Query current objects
3. Compare: find objects in checkpoint but not current
4. **Dry run:** Python Pushdown shows UNDROP commands
5. **Execute:** Run UNDROP statements with error handling
6. Log restore operation in audit table

---

## 📝 **Variables Reference**

| Variable | Pipeline | Type | Default | Description |
|----------|----------|------|---------|-------------|
| `intent` | Main Checkpoint Controller | TEXT | "" | Operation: INIT_AUDIT_TABLE, CREATE_CHECKPOINT, CLEANUP_SINCE, FULL_CLEANUP, RESTORE |
| `checkpoint_id` | Main Checkpoint Controller | TEXT | "" | For CLEANUP_SINCE and RESTORE |
| `checkpoint_description` | Main Checkpoint Controller | TEXT | "Manual checkpoint" | For CREATE_CHECKPOINT |
| `dry_run` | Main Checkpoint Controller | TEXT | "YES" | For CLEANUP_SINCE, FULL_CLEANUP, RESTORE |
| `confirm_delete_all` | Main Checkpoint Controller | TEXT | "" | Must be "DELETE_ALL" for FULL_CLEANUP |
| `checkpoint_description` | Create Checkpoint | TEXT | "Manual checkpoint" | Description of checkpoint |
| `checkpoint_id` | Cleanup Since Checkpoint | TEXT | "" | Checkpoint to revert to |
| `dry_run` | Cleanup Since Checkpoint | TEXT | "YES" | Preview or execute |
| `dry_run` | Full Schema Cleanup | TEXT | "YES" | Preview or execute |
| `confirm_delete_all` | Full Schema Cleanup | TEXT | "" | Must be "DELETE_ALL" |
| `checkpoint_id` | Restore Dropped Objects | TEXT | "" | Checkpoint to restore from |
| `dry_run` | Restore Dropped Objects | TEXT | "YES" | Preview or execute |

---

## 🛠️ **Technical Details**

### **Component Architecture**
- **100% Native Components** - No custom Python scripts for messaging
- **Python Pushdown** - For preview operations with data display
- **SQL Executor** - For DDL operations (DROP, UNDROP, table creation)
  - References external SQL file for initialization: `init_checkpoint_audit_table.sql`
- **Print Variables** - For status messages in task history
- **End Failure** - For proper error handling and pipeline termination
- **If Components** - For routing and conditional logic
- **Update Scalar** - For variable management in Main Controller

### **Preview vs Execute Patterns**
- Dry runs use Python Pushdown to query and display data
- Execute mode uses SQL Executor for DDL operations
- All outputs visible in task history
- Clear separation between read (preview) and write (execute)

---

## ✅ **System Requirements**

- ✅ Snowflake Enterprise Edition (for extended time travel)
- ✅ Environment configured with database and schema defaults
- ✅ Appropriate permissions to CREATE/DROP tables and views
- ✅ Access to `INFORMATION_SCHEMA` views
- ✅ Python Pushdown enabled (for preview functionality)

---

## 🎉 **You're All Set!**

The Checkpoint Management System is ready to use in `.maia-experience/checkpoint-management/`.

**Quick Start (3 Steps):**
1. **Initialize:** Run Main Controller with `intent = "INIT_AUDIT_TABLE"`
2. **Create Checkpoint:** Run Main Controller with `intent = "CREATE_CHECKPOINT"`
3. **Explore:** Try preview modes with `dry_run = "YES"` to see how it works

**Everything can be done through the Main Checkpoint Controller orchestration!**

For questions or issues, refer to the troubleshooting section or review the individual pipeline descriptions above.

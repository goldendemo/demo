# Maia Demo Experience - User Guide

Welcome to the Maia Demo Experience! This guide will help you configure and customize your personalized AI-powered demo environment.

## Table of Contents

- [Getting Started](#getting-started)
- [Configuration File Reference](#configuration-file-reference)
- [Pipeline Behavior Options](#pipeline-behavior-options)
- [Advanced Features](#advanced-features)
- [Troubleshooting](#troubleshooting)

---

## Getting Started

### Two Ways to Create Your Demo Environment

#### Option 1: Branch Naming Convention (Immediate Setup)

Create a branch using the format: `company_role_name`

**Example:** `Acme_DataEngineer_John`

- Uses hyphens within each segment for spaces (e.g., `Global-Analytics_Senior-Architect_Jane-Smith`)
- Triggers automation immediately upon branch creation
- Generates demo environment based on branch name

#### Option 2: Configuration File (Flexible Setup)

Create a branch with any name and configure via `maia_demo_config.yaml`

1. Create your branch (any name except `main`, `develop`, or `feature*`)
2. Wait for automation to create initial files
3. **Pull Remote Changes** in Matillion DPC
4. Update `maia_demo_config.yaml` with your details
5. Commit and push to trigger automation

---

## Configuration File Reference

**File Location:** `.maia-experience/maia_demo_config.yaml`

The `maia_demo_config.yaml` file controls all aspects of your demo environment.

### Required Section: Demo Information

```yaml
demo:
  company: "Your Company Name"
  role: "Your Role Title"
  name: "Your Name"
  description: "Brief description of your data goals and use case"
  environment_name: "demo"  # Optional: Target DPC environment
```

**Fields:**
- **company**: Your organization name
- **role**: Your primary job role or perspective
- **name**: Your name or identifier
- **description**: 1-2 sentences describing your data focus
- **environment_name** (optional): Target DPC environment for pipeline execution
  - Default: `"demo"`
  - Must match your DPC environment name exactly (case-sensitive)
  - Examples: `"demo"`, `"demo-arawan-gajajiva"`, `"demo-joe-herbert"`
  - Change this if using a custom-named environment
  - Leave commented out unless overriding the mapping defined in .`maia-experience/user-environment-mappings.yaml`

### Optional Section: Preferences

```yaml
preferences:
  # Additional role perspectives
  roles:
    - "Data Scientist"
    - "Data Analyst"
    - "BI Developer"
  
  # Tools and technologies you work with
  tools:
    - "dbt"
    - "Snowflake"
    - "Tableau"
    - "Python"
```

**Purpose:**
- Provides additional context for content generation
- Influences AI-generated rules and examples
- Creates more personalized demo scenarios

### Optional Section: Pipeline Behavior

```yaml
pipeline:
  # Control data regeneration
  generate_data: true
  
  # AI generation engine
  ai_generation_mode: "cortex"
```

See [Pipeline Behavior Options](#pipeline-behavior-options) for detailed explanations.

### Optional Section: Content Files
**NOTE: DO NOT USE - Feature not yet live.**

```yaml
content:
  - file: ".maia-experience/additional-assets/discovery-call-transcript.md"
    description: "Discovery call with stakeholders"
  
  - file: ".maia-experience/additional-assets/requirements-document.md"
    description: "Technical requirements"
```

**Requirements:**
- Files must exist in the `.maia-experience/additional-assets/` folder before committing
- Files should be in Markdown format
- Provides rich context for AI generation

---

## Environment Configuration

### Environment Name Determination

The system uses a **3-tier priority logic** to determine which DPC environment to target:

#### Priority 1: Config File (Highest)
Explicit `environment_name` in the config file

```yaml
demo:
  company: "Acme Corp"
  role: "Data Engineer"
  name: "John Doe"
  description: "Building data pipelines"
  environment_name: "my-custom-env"  # Explicit override
```

#### Priority 2: User Mapping
GitHub username mapped in `.maia-experience/user-environment-mappings.yaml`

```yaml
mappings:
  mtln-john: demo-john-smith
  mtln-jane: demo-jane-doe
```

If your GitHub username is `mtln-john`, the system automatically uses `demo-john-smith` environment.

#### Priority 3: Default Fallback
Defaults to `"demo"` if neither Priority 1 nor 2 applies.

### Target Environment: `environment_name`

**Default:** `"demo"` (or user-mapped value)

**Location:** Under the `demo:` section (NOT in `metadata`)

```yaml
demo:
  company: "Acme Corp"
  role: "Data Engineer"
  name: "John Doe"
  description: "Building data pipelines"
  environment_name: "staging"  # Target this environment
```

#### What It Does

Specifies which Matillion DPC environment to use for:
- Pipeline execution
- Data initialization
- Demo environment setup

#### When to Change

✅ **Change from default when:**
- Using a custom-named environment in DPC

❌ **Keep default when:**
- Using the standard "demo" environment
- Not sure which environment to target

#### Important Notes

- **Case-Sensitive**: Must match DPC environment name exactly
- **Environment Must Exist**: The environment must be created in DPC first
- **Single Environment**: All pipelines use this one environment
- **Branch-Specific**: Different branches can target different environments

#### Example Configurations

**Personal Custom Environment:**
```yaml
demo:
  company: "Acme Corp"
  role: "Data Engineer"
  name: "Dev Testing"
  description: "Development environment for testing"
  environment_name: "demo-arawan-gajajiva-custom"
```

**Shared Demo Environment:**
```yaml
demo:
  company: "Acme Corp"
  role: "Solutions Architect"
  name: "Client Demo"
  description: "Production demo for client presentation"
  environment_name: "demo"
```

**User Mapping (No explicit environment_name needed):**
```yaml
# In .maia-experience/user-environment-mappings.yaml:
mappings:
  mtln-arawan: demo-arawan-gajajiva

# In .maia-experience/maia_demo_config.yaml:
demo:
  company: "XYZ Corp"
  role: "VP Services"
  name: "Arawan Gajajiva"
  description: "Hospitality data pipelines"
  # No environment_name specified - uses mapped value: demo-arawan-gajajiva
```

---

## Pipeline Behavior Options

### Data Generation Control: `generate_data`

**Default:** `true`

#### When `generate_data: true`

✅ **Use when:**
- Setting up a new demo environment
- You want fresh data based on config changes
- Testing different data scenarios

**Behavior:**
- Generates new data landscape definitions
- Creates fresh SQL initialization scripts
- Updates all data-related files

#### When `generate_data: false`

✅ **Use when:**
- You have an established data landscape
- Only updating roles, tools, or preferences
- Iterating on configuration without data changes
- Preserving custom data modifications

**Behavior:**
- Preserves existing data landscape files
- Keeps current SQL scripts unchanged
- Only updates AI rules and preferences

---

### AI Generation Mode: `ai_generation_mode`

**Default:** `cortex`

Controls which AI engine generates tools and roles content.

#### `legacy` Mode

```yaml
pipeline:
  ai_generation_mode: "legacy"
```

- Uses [Advanced Prompts Google Sheet](https://docs.google.com/spreadsheets/d/1aHBtIQug20ldVaGpdbxRq5EbG0KDasR2dAIvUqvHjlY/edit)
- Original content generation method
- Consistent with historical demos

**Use when:**
- You need consistent results with previous demos
- Testing against established baselines
- Google Sheets-based content is preferred

#### `cortex` Mode (Default)

```yaml
pipeline:
  ai_generation_mode: "cortex"
```

- Uses Snowflake Cortex AI
- Enhanced, context-aware content generation
- Leverages Snowflake's native AI capabilities

**Use when:**
- You want the best AI-generated content (recommended)
- Demonstrating Snowflake AI features
- Need dynamic, context-aware responses

#### `bedrock` Mode

```yaml
pipeline:
  ai_generation_mode: "bedrock"
```

- Uses AWS Bedrock AI
- Alternative AI engine option
- AWS-native AI generation

**Use when:**
- Demonstrating AWS integrations
- AWS Bedrock is your preferred AI platform
- Testing cross-cloud AI capabilities

---

## Checkpoint Management System

### Overview

The checkpoint system allows you to create snapshots of your schema state and restore to previous states, enabling safe experimentation with your demo data.

### Available Pipelines

All checkpoint management pipelines are located in `.maia-experience/checkpoint-management/`:

#### Core Operations

**Create Checkpoint**
- Creates a snapshot of current schema state
- Captures all tables, views, and their structures
- Stores metadata in CHECKPOINT_AUDIT table

**Restore Dropped Objects**
- Restores objects that were dropped after a specific checkpoint
- Recreates tables and views as they existed at checkpoint time

**Cleanup Since Checkpoint**
- Removes all objects created after a specific checkpoint
- Useful for rolling back experimental changes

**Full Schema Cleanup**
- Removes all tables, views, sequences, stages, and file formats
- Use with caution - complete schema wipe

**View Available Checkpoints**
- Browse checkpoint history
- See checkpoint descriptions, types, and timestamps

**Main Checkpoint Controller**
- Orchestrates checkpoint operations
- Provides workflow for common checkpoint scenarios

### Checkpoint-Enabled Initialization

**Standard Init:** `.maia-experience/sql-init/Maia Init.orch.yaml`
- Runs initialization script directly
- No checkpoint creation

**Checkpoint-Enabled Init:** `.maia-experience/sql-init/Maia Init - With Checkpoints.orch.yaml`
- Checks if CHECKPOINT_AUDIT table exists
- If exists:
  - Creates PRE_DEPLOYMENT checkpoint
  - Runs initialization script
  - Creates POST_DEPLOYMENT checkpoint
- If not exists:
  - Runs initialization script only (first-time setup)

### Public Variables

Checkpoint pipelines use these public variables:

```yaml
checkpoint_description:
  type: TEXT
  visibility: PUBLIC
  default: "Manual checkpoint"
  
checkpoint_type:
  type: TEXT
  visibility: PUBLIC
  default: "MANUAL"
  # Options: MANUAL, PRE_DEPLOYMENT, POST_DEPLOYMENT
```

### Usage Examples

**Before Making Changes:**
```
1. Run "Create Checkpoint" pipeline
2. Provide description: "Before adding new data sources"
3. Make your changes
4. If something goes wrong, run "Restore Dropped Objects"
```

**Clean Up Experiments:**
```
1. Note the checkpoint ID from before experiments
2. Run "Cleanup Since Checkpoint"
3. Provide the checkpoint ID
4. All experimental objects are removed
```

**Complete Reset:**
```
1. Run "Full Schema Cleanup"
2. Confirm you want to proceed
3. All objects removed
4. Re-run initialization to start fresh
```

### Key Features

- ✅ **Python Pushdown**: All pipelines use Python Pushdown (not SQL Executor) for better error handling
- ✅ **Automatic Checkpoints**: Deployment pipelines can create checkpoints automatically
- ✅ **Safe Experimentation**: Test changes without fear of losing work
- ✅ **Audit Trail**: Complete history of checkpoint operations

---

## Advanced Features

### Combining Configuration Options

**Example: Update preferences without regenerating data**

```yaml
demo:
  company: "Acme Corp"
  role: "Data Engineer"
  name: "John Doe"
  description: "Building modern data pipelines"
  environment_name: "staging"  # Target staging environment

preferences:
  roles:
    - "Data Architect"  # Added new perspective
  tools:
    - "dbt"
    - "Airflow"  # Added new tool

pipeline:
  generate_data: false  # Preserve existing data
  ai_generation_mode: "cortex"  # Use Cortex AI
```

**Example: Multi-environment setup using branches**

```yaml
# Branch: dev-demo
demo:
  company: "Acme Corp"
  role: "Developer"
  name: "Dev Environment"
  description: "Development and testing"
  environment_name: "dev"  # Development environment

# Branch: prod-demo
demo:
  company: "Acme Corp"
  role: "Sales Engineer"
  name: "Production Demo"
  description: "Client-facing demos"
  environment_name: "prod"  # Production environment
```

### Iterative Configuration

1. **Initial Setup**: Use `generate_data: true` to create your data landscape
2. **Refinement**: Set `generate_data: false` and iterate on preferences
3. **Testing**: Try different `ai_generation_mode` options for comparison
4. **Finalization**: Lock in configuration with `generate_data: false`

---

## Committing and Pushing Changes

### Using Matillion DPC Git Panel

1. **View Changes**: Open the Git panel to see modified files
2. **Stage Changes**: Select files to commit
3. **Commit**: Add a descriptive commit message
   - [Learn more about committing](https://docs.matillion.com/data-productivity-cloud/designer/docs/git-commit/)
4. **Push**: Click "Push Local Changes" to trigger automation
   - [Learn more about pushing](https://docs.matillion.com/data-productivity-cloud/designer/docs/git-push/)

### What Happens After Pushing

The automation will:
1. ✅ Validate your configuration
2. ✅ Process your settings
3. ✅ Generate personalized AI rules
4. ✅ Create/update demo data (unless `generate_data: false`)
5. ✅ Commit results back to your branch
6. ✅ Publish and run initialization pipeline (if data changed)

---

## Troubleshooting

### Configuration Not Working

**Check:**
- YAML syntax is valid (proper indentation)
- Branch name is not `main`, `develop`, or `feature*`
- You've pulled remote changes before editing
- Commit message doesn't start with "Merge"
- `environment_name` matches an existing DPC environment (if specified)

### Pipeline Fails with "Environment Not Found"

**Cause:** The `environment_name` in your config doesn't match any DPC environment

**Solution:**
1. Check available environments in DPC
2. Verify spelling and case (must match exactly)
3. Update `environment_name` in config file
4. Commit and push changes

**Example:**
```yaml
# Wrong (if your environment is named "Demo")
environment_name: "demo"

# Correct
environment_name: "Demo"
```

### Data Not Regenerating

**Check:**
- `generate_data` is set to `true`
- SQL files in `Maia Init/` were actually modified
- GitHub Actions workflow completed successfully

### AI Mode Not Applied

**Check:**
- `ai_generation_mode` value is one of: `legacy`, `cortex`, `bedrock`
- Value is in quotes: `"cortex"` not `cortex`
- Configuration file committed and pushed

### Automation Not Triggering

**Check:**
- File name is exactly `maia_demo_config.yaml` (case-sensitive)
- File is at `.maia-experience/maia_demo_config.yaml` (NEW location, not repository root)
- Branch is not `main`, `develop`, or `feature*`
- GitHub Actions are enabled for the repository
- Check workflow logs in GitHub Actions tab

### Environment Name Not Being Used

**Symptom:** Downstream pipeline reports "Environment Name: (not specified)"

**Check:**
1. **Config File Location**: Ensure `environment_name` is in `demo` section (NOT in `metadata`)
   ```yaml
   # Correct:
   demo:
     environment_name: "my-env"
   
   # Wrong:
   metadata:
     environment_name: "my-env"  # This won't work!
   ```

2. **User Mappings**: If not using explicit `environment_name`, check `.maia-experience/user-environment-mappings.yaml`
   - Verify your GitHub username is mapped correctly
   - Ensure YAML syntax is valid

3. **Workflow Logs**: Check "Determine Environment Name" step output
   - Should show which priority level was used
   - Should display the determined environment name

### Checkpoint Operations Failing

**Check:**
- CHECKPOINT_AUDIT table exists (run init script first)
- Checkpoint ID is valid when restoring/cleaning up
- Sufficient permissions on schema objects
- Python Pushdown component is available (not SQL Executor)

---

## Support and Resources

### Documentation

- [Matillion DPC Documentation](https://docs.matillion.com/data-productivity-cloud/)
- [Git Operations in DPC](https://docs.matillion.com/data-productivity-cloud/designer/docs/git-operations/)

### Example Configurations

See `.maia-experience/config-examples/` for:
- `maia_demo_config.yaml` - Fully documented template
- `minimal-example.yaml` - Minimal required fields
- `full-example.yaml` - All options demonstrated

### Checkpoint Management

Pipelines located in `.maia-experience/checkpoint-management/`:
- `Create Checkpoint.orch.yaml`
- `Restore Dropped Objects.orch.yaml`
- `Cleanup Since Checkpoint.orch.yaml`
- `Full Schema Cleanup.orch.yaml`
- `View Available Checkpoints.tran.yaml`
- `Main Checkpoint Controller.orch.yaml`

### Environment Mappings

Configure user-to-environment mappings in:
- `.maia-experience/user-environment-mappings.yaml`

### Getting Help

If you encounter issues:
1. Check the `.matillion/maia/rules/context.md` for status updates
2. Review GitHub Actions workflow logs
3. Check environment name determination in workflow logs
4. Verify checkpoint system is initialized (if using checkpoints)
5. Consult example configurations in `.maia-experience/config-examples/`
6. Review user mappings in `.maia-experience/user-environment-mappings.yaml`
7. Reach out to your Matillion support contact

---

**Happy demoing with Maia! 🚀**

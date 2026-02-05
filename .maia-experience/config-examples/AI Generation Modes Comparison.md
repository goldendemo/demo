# AI Generation Modes Comparison

## Overview

The Maia Rules Generator supports three AI generation modes, each optimized for different use cases and audiences. This document compares their output characteristics and recommended usage.

---

## Three Generation Modes

### 1. **Legacy** - Migration Tutorial Approach 🎓

**Backend:** Snowflake Cortex (Claude)  
**Focus:** Teaching Informatica → Matillion migration patterns

**Output Structure:**
- Starts with "Agentic AI Enhancement" guidance bullets
- Explains migration concepts and recommendations
- Simplified conceptual Informatica XML example
- Detailed Matillion conversion steps
- Visual pipeline diagram showing Matillion components

**Example Output:**

```markdown
## Example: For Informatica to Matillion Migration

* **Automated Mapping Analysis**: Analyze existing Informatica...
* **Snowflake-Native Conversion**: Convert Informatica Lookup...
* **Job Blueprint Generation**: Generate conceptual Matillion...
```

```xml
## Informatica File for Demo Conversion (Conceptual Example)
<MAPPING NAME="m_pet_session_analytics">
  <SOURCE NAME="SQ_PET_PROFILES" TYPE="Source Qualifier">
    <TRANSFORMATION_PIN NAME="pet_id"/>
  </SOURCE>
</MAPPING>
```

```markdown
## Conceptual Matillion Conversion Steps in Snowflake
**Step 1: Data Ingestion**
- **Matillion Component**: Table Input components...
```

---

### 2. **Cortex** - Educational Code Example 📖

**Backend:** Snowflake Cortex (Claude Sonnet 4)  
**Focus:** Comprehensive educational code examples

**Output Structure:**
- Brief description (1-2 sentences)
- Complete Informatica pseudo-XML code
- 3+ source tables with rich business logic
- Multiple transformations (joins, expressions, filters)
- Workflow orchestration with automation
- "Key Features" summary

**Example Output:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<PowerCenter>
  <!-- Source Connection: SQL Server -->
  <Connection name="MSSQL_Source" type="Microsoft SQL Server">
    <Property name="ServerName" value="se-library-mssql.database.windows.net"/>
  </Connection>
  
  <!-- Mapping: Pet Sitting Revenue Analytics -->
  <Mapping name="m_pet_revenue_analytics">
    <SourceQualifier name="SQ_PET_PROFILES">
      <SQLOverride>SELECT pet_id, owner_id, pet_name...</SQLOverride>
    </SourceQualifier>
    
    <Joiner name="JNR_PET_SESSIONS" type="Normal Join">
      <JoinCondition>SQ_PET_PROFILES.pet_id = SQ_SITTING_SESSIONS.pet_id</JoinCondition>
    </Joiner>
    
    <Expression name="EXP_CALCULATE_METRICS">
      <Port name="revenue_per_hour">total_cost / duration_hours</Port>
      <Port name="high_value_session">IIF(total_cost > 200, 'Y', 'N')</Port>
    </Expression>
  </Mapping>
  
  <Workflow name="wf_daily_pet_analytics">
    <EmailTask name="notify_completion"/>
  </Workflow>
</PowerCenter>
```

**Key Features:**
- Extract: 3 sources from SQL Server
- Transform: Joins, calculations, filters
- Load: Snowflake analytics table
- Automation: Workflow with notifications

---

### 3. **Bedrock** - Production-Ready Code 🏭

**Backend:** AWS Bedrock (Claude Opus 4)  
**Focus:** Production-ready, importable Informatica XML

**Output Structure:**
- Brief description (1-2 sentences)
- Proper DTD/POWERMART XML structure
- Authentic Informatica syntax (importable to PowerCenter)
- 2 source tables with aggregation logic
- Complete session and connection configuration
- Production transformations with proper attributes

**Example Output:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE POWERMART SYSTEM "powrmart.dtd">
<POWERMART CREATION_DATE="11/12/2025" REPOSITORY_VERSION="181.96">
  <REPOSITORY NAME="XYZ_Corp_Repo" VERSION="181" CODEPAGE="UTF-8">
    
    <!-- Source Definition: SQL Server -->
    <SOURCE NAME="SRC_SITTING_SESSIONS" DATABASETYPE="Microsoft SQL Server">
      <SOURCEFIELD NAME="session_id" DATATYPE="varchar" PRECISION="10" NULLABLE="NOTNULL"/>
      <CONNECTIONREFERENCE CNXREFNAME="SQL_Server_Library"/>
    </SOURCE>
    
    <!-- Mapping -->
    <MAPPING NAME="m_PetSitting_Revenue_Analysis" OBJECTVERSION="1">
      <TRANSFORMATION NAME="AGG_REVENUE_METRICS" TYPE="Aggregator" REUSABLE="NO">
        <TRANSFORMFIELD NAME="total_revenue" DATATYPE="decimal" EXPRESSION="SUM(total_cost)"/>
      </TRANSFORMATION>
      
      <CONNECTOR FROMINSTANCE="SRC_SITTING_SESSIONS" TOINSTANCE="SQ_SITTING_SESSIONS"/>
    </MAPPING>
    
    <!-- Session Configuration -->
    <SESSION NAME="s_PetSitting_Revenue_Analysis" MAPPINGNAME="m_PetSitting_Revenue_Analysis">
      <SESSIONEXTENSION NAME="Relational Writer" TYPE="WRITER">
        <ATTRIBUTE NAME="Target load type" VALUE="Normal"/>
      </SESSIONEXTENSION>
    </SESSION>
    
  </REPOSITORY>
</POWERMART>
```

---

## Detailed Comparison Table

| Aspect | **Legacy** | **Cortex** | **Bedrock** |
|--------|-----------|-----------|------------|
| **Primary Focus** | Migration Tutorial | Code Education | Production Code |
| **Output Format** | Guidance + Code + Conversion | Code Example | Code Example |
| **Informatica XML** | Simplified conceptual | Pseudo-XML (educational) | Real DTD/POWERMART |
| **Source Tables** | 2 sources | 3 sources | 2 sources |
| **Business Logic** | Basic (lookup + expression) | Rich (4+ calculations) | Medium (aggregation) |
| **Unique Elements** | Migration steps, Matillion conversion, visual diagram | Workflow orchestration, rich calculations | Proper XML structure, session config |
| **Includes Matillion?** | ✅ Yes (conversion steps) | ❌ No | ❌ No |
| **Importable to PowerCenter?** | ❌ No (conceptual) | ❌ No (pseudo-XML) | ✅ Yes (production-ready) |
| **Output Length** | Longest (tutorial + code) | Medium (code + features) | Medium (code + config) |
| **Execution Time** | ~45s - 2min | ~45s - 2min | ~1-2 min |
| **Technical Accuracy** | 5/10 (conceptual) | 6/10 (educational) | 9.5/10 (production) |
| **Best For** | Migration planning | Learning & documentation | Actual code migration |

---

## Use Case Recommendations

### Use **Legacy** When:
- ✅ Planning an Informatica → Matillion migration
- ✅ Need to explain migration concepts to stakeholders
- ✅ Want Matillion component mappings
- ✅ Teaching migration patterns and strategies
- ✅ Creating migration documentation

**Ideal Audience:** Migration architects, business stakeholders, project managers

---

### Use **Cortex** When:
- ✅ Teaching Informatica concepts
- ✅ Need comprehensive code examples
- ✅ Documenting business logic and transformations
- ✅ Creating stakeholder presentations
- ✅ Training materials for ETL developers
- ✅ Demonstrating workflow orchestration

**Ideal Audience:** Developers learning Informatica, business analysts, documentation writers

---

### Use **Bedrock** When:
- ✅ Need production-ready, importable code
- ✅ Performing actual code migration
- ✅ Code needs to be validated/imported into PowerCenter
- ✅ Technical accuracy is critical
- ✅ Working with experienced Informatica developers
- ✅ Creating reference implementations

**Ideal Audience:** Senior ETL developers, migration engineers, technical architects

---

## Key Differences Illustrated

### **Legacy = Migration Guide**
```
🎓 Tutorial Structure:
1. "For Informatica to Matillion Migration" heading
2. Agentic AI enhancement bullet points
3. Conceptual Informatica XML
4. "Conceptual Matillion Conversion Steps" section
5. Visual pipeline diagram (Text-based)
6. Component mapping guidance
```

### **Cortex = Comprehensive Code**
```
📖 Educational Code:
1. Brief introductory sentence
2. Full Informatica pseudo-XML
   - 3 sources with rich SQL
   - Multiple joins (2+)
   - Rich calculations (4+ derived fields)
   - Workflow with email automation
3. "Key Features" summary
4. Readable, stakeholder-friendly format
```

### **Bedrock = Production XML**
```
🏭 Production Code:
1. Brief introductory sentence
2. Real Informatica POWERMART XML
   - Proper DTD declaration
   - REPOSITORY hierarchy
   - 2 sources with proper attributes
   - Production transformations (Aggregator, Joiner, Expression)
   - Session configuration with writer extensions
3. Importable to PowerCenter without modification
4. Authentic Informatica syntax and structure
```

---

## Configuration Details

### Token Limits
- **Legacy**: Auto (default Cortex limits)
- **Cortex**: Auto (default Cortex limits)
- **Bedrock**: 8192 (Tools), 4096 (Roles) - explicitly set to prevent truncation

### Models
- **Legacy**: Snowflake Cortex (Claude - version managed by Snowflake)
- **Cortex**: Snowflake Cortex (Claude Sonnet 4)
- **Bedrock**: AWS Bedrock Claude Opus 4 (Tools), Claude Sonnet 4 (Roles)

### Retry Behavior
- **Legacy**: Snowflake Cortex automatic retry (may take 2-3 attempts)
- **Cortex**: Snowflake Cortex automatic retry (may take 2-3 attempts)
- **Bedrock**: AWS Bedrock native timeout handling

---

## Summary

All three modes serve distinct purposes and excel in different scenarios:

1. **Legacy** = Migration tutorial (concept → conversion)
2. **Cortex** = Educational code (comprehensive examples)  
3. **Bedrock** = Production code (importable XML)

This trio covers the complete spectrum of needs:
- **Migration planning** (Legacy)
- **Learning/documentation** (Cortex)  
- **Technical implementation** (Bedrock)

**Recommendation:** Keep all three modes available to support different stages of a migration journey and diverse audience needs.

---

## Version History

- **v2.3** (2025-11-12): Documented three distinct AI generation modes
- Enhanced Bedrock with maxTokens (8192/4096) and Claude Opus 4/Sonnet 4
- Reverted prompts to original for optimal speed/reliability
- Fixed timestamp consistency and merge logic across all modes

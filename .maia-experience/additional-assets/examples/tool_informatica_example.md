ELT pipeline extracting customer analytics from SQL Server, applying churn risk filtering, and loading to Snowflake for VP Analytics reporting.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PowerCenter>
  <!-- Source Definition -->
  <Source name="SRC_CUSTOMER_ANALYTICS" type="Relational">
    <Connection>
      <Database>se-library-demo</Database>
      <Server>se-library-mssql.database.windows.net</Server>
      <Port>1433</Port>
      <Username>matillion</Username>
      <Schema>maia_experience</Schema>
    </Connection>
    <Table>XYZ_CUSTOMER_ANALYTICS</Table>
    <Columns>
      <Column name="CUSTOMER_ID" datatype="VARCHAR(10)"/>
      <Column name="SEGMENT" datatype="VARCHAR(20)"/>
      <Column name="LIFETIME_VALUE" datatype="NUMBER(10,2)"/>
      <Column name="CHURN_RISK" datatype="VARCHAR(10)"/>
      <Column name="REGION" datatype="VARCHAR(20)"/>
    </Columns>
  </Source>

  <!-- Transformation Logic -->
  <Transformation name="FILTER_HIGH_VALUE_CUSTOMERS" type="Filter">
    <Condition>LIFETIME_VALUE > 50000 AND CHURN_RISK != 'High'</Condition>
  </Transformation>

  <Transformation name="EXP_ADD_ANALYTICS_FIELDS" type="Expression">
    <Expression name="RISK_SCORE">
      IIF(CHURN_RISK = 'Low', 1, IIF(CHURN_RISK = 'Medium', 2, 3))
    </Expression>
    <Expression name="VALUE_TIER">
      IIF(LIFETIME_VALUE > 150000, 'Premium', 
          IIF(LIFETIME_VALUE > 75000, 'Gold', 'Standard'))
    </Expression>
    <Expression name="LOAD_DATE">SYSDATE</Expression>
  </Transformation>

  <!-- Target Definition -->
  <Target name="TGT_CUSTOMER_ANALYTICS_SF" type="Relational">
    <Connection>
      <Database>XYZ_ANALYTICS_DW</Database>
      <Server>xyz-corp.snowflakecomputing.com</Server>
      <Warehouse>ANALYTICS_WH</Warehouse>
      <Schema>CUSTOMER_MART</Schema>
    </Connection>
    <Table>DIM_CUSTOMER_ANALYTICS</Table>
    <LoadType>INSERT</LoadType>
  </Target>

  <!-- Mapping Flow -->
  <Mapping name="m_Customer_Analytics_ELT">
    <Flow>
      SRC_CUSTOMER_ANALYTICS → 
      FILTER_HIGH_VALUE_CUSTOMERS → 
      EXP_ADD_ANALYTICS_FIELDS → 
      TGT_CUSTOMER_ANALYTICS_SF
    </Flow>
  </Mapping>

  <!-- Workflow -->
  <Workflow name="wf_Daily_Customer_Analytics">
    <Session name="s_Customer_Analytics_Load">
      <Mapping>m_Customer_Analytics_ELT</Mapping>
      <Schedule>Daily at 02:00 AM</Schedule>
    </Session>
  </Workflow>
</PowerCenter>
```

**Key Features:**
- Filters high-value, low-risk customers (>$50K lifetime value)
- Adds risk scoring and value tier classifications
- Incremental load to Snowflake customer dimension
- Automated daily refresh for VP Analytics dashboards

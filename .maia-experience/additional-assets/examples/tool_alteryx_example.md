This Alteryx workflow extracts ZZZ Corp financial metrics from SQL Server, applies department filtering, and loads to Snowflake for executive analytics.

```xml
<?xml version="1.0"?>
<AlteryxDocument yxmdVer="2023.1">
  <Nodes>
    <!-- SQL Server Input -->
    <Node ToolID="1">
      <GuiSettings Plugin="AlteryxConnectorGui.DbFileInput.DbFileInput">
        <Position x="54" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <Passwords />
          <CxnString>Driver=SQL Server;Server=se-library-mssql.database.windows.net,1433;Database=se-library-demo;UID=matillion;</CxnString>
          <Query>SELECT 
            METRIC_ID,
            DEPARTMENT, 
            REVENUE_USD,
            COST_USD,
            PROFIT_MARGIN,
            QUARTER,
            YEAR,
            REGION
          FROM maia_experience.ZZZ_FINANCIAL_METRICS
          WHERE YEAR = 2024</Query>
        </Configuration>
      </Properties>
    </Node>

    <!-- Filter High Revenue Departments -->
    <Node ToolID="2">
      <GuiSettings Plugin="AlteryxBasePluginsGui.Filter.Filter">
        <Position x="186" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <Expression>[REVENUE_USD] &gt; 1000000</Expression>
        </Configuration>
      </Properties>
    </Node>

    <!-- Formula - Calculate Revenue Growth -->
    <Node ToolID="3">
      <GuiSettings Plugin="AlteryxBasePluginsGui.Formula.Formula">
        <Position x="318" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <FormulaFields>
            <FormulaField expression="[REVENUE_USD] - [COST_USD]" field="NET_PROFIT" size="19" type="FixedDecimal" />
            <FormulaField expression="DateTimeNow()" field="ETL_TIMESTAMP" size="19" type="DateTime" />
          </FormulaFields>
        </Configuration>
      </Properties>
    </Node>

    <!-- Snowflake Output -->
    <Node ToolID="4">
      <GuiSettings Plugin="SnowflakeOutputGui.SnowflakeOutput">
        <Position x="450" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <Account>zzzcorp.snowflakecomputing.com</Account>
          <Database>ZZZ_ANALYTICS_DW</Database>
          <Schema>EXECUTIVE_REPORTING</Schema>
          <Table>FINANCIAL_METRICS_FACT</Table>
          <OutputMode>Overwrite</OutputMode>
          <Warehouse>ANALYTICS_WH</Warehouse>
        </Configuration>
      </Properties>
    </Node>
  </Nodes>

  <!-- Connections between tools -->
  <Connections>
    <Connection>
      <Origin ToolID="1" Connection="Output" />
      <Destination ToolID="2" Connection="Input" />
    </Connection>
    <Connection>
      <Origin ToolID="2" Connection="True" />
      <Destination ToolID="3" Connection="Input" />
    </Connection>
    <Connection>
      <Origin ToolID="3" Connection="Output" />
      <Destination ToolID="4" Connection="Input" />
    </Connection>
  </Connections>
</AlteryxDocument>
```

**Key Components:**
- **Input (1):** JDBC connection to SQL Server with filtered query
- **Filter (2):** Business rule for high-revenue departments only  
- **Formula (3):** Calculated fields for profit analysis + ETL timestamp
- **Output (4):** Direct load to Snowflake analytics warehouse

ELT workflow extracting customer analytics from SQL Server, applying churn risk filtering, and loading to Snowflake for VP Analytics reporting.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<AlteryxDocument yxmdVer="2023.1">
  <Nodes>
    <!-- SQL Server Input -->
    <Node ToolID="1">
      <GuiSettings Plugin="AlteryxConnectorGui.DbFileInput.DbFileInput">
        <Position x="54" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <ConnectionName>MSSQL_XYZ_Source</ConnectionName>
          <ServerName>se-library-mssql.database.windows.net</ServerName>
          <DatabaseName>se-library-demo</DatabaseName>
          <Schema>maia_experience</Schema>
          <TableName>XYZ_CUSTOMER_ANALYTICS</TableName>
          <UserName>matillion</UserName>
          <Password>EncryptedPassword</Password>
          <Query>SELECT CUSTOMER_ID, SEGMENT, ACQUISITION_DATE, LIFETIME_VALUE, CHURN_RISK, REGION FROM XYZ_CUSTOMER_ANALYTICS</Query>
        </Configuration>
      </Properties>
    </Node>

    <!-- Filter High-Value Customers -->
    <Node ToolID="2">
      <GuiSettings Plugin="AlteryxBasePluginsGui.Filter.Filter">
        <Position x="186" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <Expression>[LIFETIME_VALUE] > 50000 AND [CHURN_RISK] != "High"</Expression>
        </Configuration>
      </Properties>
    </Node>

    <!-- Add Calculated Fields -->
    <Node ToolID="3">
      <GuiSettings Plugin="AlteryxBasePluginsGui.Formula.Formula">
        <Position x="318" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <FormulaFields>
            <FormulaField field="CUSTOMER_TIER" type="V_WString" size="20" expression="IF [LIFETIME_VALUE] > 100000 THEN 'Premium' ELSE 'Standard' ENDIF" />
            <FormulaField field="LOAD_DATE" type="Date" expression="DateTimeNow()" />
          </FormulaFields>
        </Configuration>
      </Properties>
    </Node>

    <!-- Snowflake Output -->
    <Node ToolID="4">
      <GuiSettings Plugin="AlteryxConnectorGui.Snowflake.Snowflake">
        <Position x="450" y="162" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <ConnectionName>Snowflake_XYZ_DW</ConnectionName>
          <Server>xyz-corp.snowflakecomputing.com</Server>
          <Database>ANALYTICS_DW</Database>
          <Schema>CUSTOMER_MART</Schema>
          <Table>DIM_CUSTOMERS_FILTERED</Table>
          <Warehouse>ANALYTICS_WH</Warehouse>
          <Role>VP_ANALYTICS_ROLE</Role>
          <OutputMode>Overwrite</OutputMode>
          <PreSQL>TRUNCATE TABLE ANALYTICS_DW.CUSTOMER_MART.DIM_CUSTOMERS_FILTERED;</PreSQL>
          <PostSQL>GRANT SELECT ON ANALYTICS_DW.CUSTOMER_MART.DIM_CUSTOMERS_FILTERED TO ROLE ANALYST_ROLE;</PostSQL>
        </Configuration>
      </Properties>
    </Node>

    <!-- Sales Data Join (Optional Enhancement) -->
    <Node ToolID="5">
      <GuiSettings Plugin="AlteryxConnectorGui.DbFileInput.DbFileInput">
        <Position x="54" y="282" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <ConnectionName>MSSQL_XYZ_Source</ConnectionName>
          <Query>SELECT CUSTOMER_ID, SUM(AMOUNT) as TOTAL_SALES FROM XYZ_SALES_OPERATIONS GROUP BY CUSTOMER_ID</Query>
        </Configuration>
      </Properties>
    </Node>

    <!-- Join Customer + Sales -->
    <Node ToolID="6">
      <GuiSettings Plugin="AlteryxBasePluginsGui.Join.Join">
        <Position x="318" y="222" />
      </GuiSettings>
      <Properties>
        <Configuration>
          <JoinInfo connection="Left">
            <Field field="CUSTOMER_ID" />
          </JoinInfo>
          <JoinInfo connection="Right">
            <Field field="CUSTOMER_ID" />
          </JoinInfo>
          <SelectConfiguration>
            <Configuration outputConnection="Join">
              <OrderChanged value="False" />
              <CommaDecimal value="False" />
              <SelectFields>
                <SelectField field="*Unknown" selected="True" input="Left_" />
                <SelectField field="TOTAL_SALES" selected="True" input="Right_" />
              </SelectFields>
            </Configuration>
          </SelectConfiguration>
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
      <Destination ToolID="6" Connection="Left" />
    </Connection>
    <Connection>
      <Origin ToolID="5" Connection="Output" />
      <Destination ToolID="6" Connection="Right" />
    </Connection>
    <Connection>
      <Origin ToolID="6" Connection="Join" />
      <Destination ToolID="4" Connection="Input" />
    </Connection>
  </Connections>

  <!-- Workflow Properties -->
  <Properties>
    <MetaInfo>
      <Name>XYZ_Customer_Analytics_ELT</Name>
      <Description>Extract high-value customers from SQL Server, transform with tier classification, and load to Snowflake data warehouse</Description>
      <Author>VP Analytics</Author>
    </MetaInfo>
    <Events>
      <Enabled value="True" />
    </Events>
    <CancelOnError value="False" />
    <DisableBrowse value="False" />
  </Properties>
</AlteryxDocument>
```

**Key Components:**
- **Input Tool (1):** Connects to SQL Server using provided credentials, extracts customer analytics data
- **Filter Tool (2):** Removes high-churn, low-value customers (LIFETIME_VALUE > 50K, CHURN_RISK != "High")  
- **Formula Tool (3):** Adds CUSTOMER_TIER classification and LOAD_DATE timestamp
- **Join Tool (6):** Enriches with aggregated sales data from SALES_OPERATIONS table
- **Snowflake Output (4):** Loads transformed data to CUSTOMER_MART schema with proper permissions

**Execution:** Scheduled daily via Alteryx Server for VP Analytics dashboard refresh.

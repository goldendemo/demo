Informatica ELT pipeline extracting ZZZ Corp financial metrics from SQL Server, applying department-based filtering, and loading to Snowflake for executive analytics.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<POWERMART>
  <REPOSITORY NAME="ZZZ_CORP_REPO">
    <FOLDER NAME="Executive_Analytics">
      
      <!-- Source Definition -->
      <SOURCE NAME="SQ_ZZZ_FINANCIAL_METRICS" DATABASETYPE="Microsoft SQL Server">
        <SOURCEFIELD DATATYPE="string" NAME="METRIC_ID" PRECISION="10"/>
        <SOURCEFIELD DATATYPE="string" NAME="DEPARTMENT" PRECISION="50"/>
        <SOURCEFIELD DATATYPE="decimal" NAME="REVENUE_USD" PRECISION="15" SCALE="2"/>
        <SOURCEFIELD DATATYPE="decimal" NAME="COST_USD" PRECISION="15" SCALE="2"/>
        <SOURCEFIELD DATATYPE="decimal" NAME="PROFIT_MARGIN" PRECISION="5" SCALE="2"/>
        <SOURCEFIELD DATATYPE="string" NAME="QUARTER" PRECISION="10"/>
        <SOURCEFIELD DATATYPE="integer" NAME="YEAR" PRECISION="4"/>
        <SOURCEFIELD DATATYPE="string" NAME="REGION" PRECISION="50"/>
      </SOURCE>

      <!-- Target Definition -->
      <TARGET NAME="TGT_FINANCIAL_ANALYTICS" DATABASETYPE="Snowflake">
        <TARGETFIELD DATATYPE="string" NAME="METRIC_ID" PRECISION="10"/>
        <TARGETFIELD DATATYPE="string" NAME="DEPARTMENT" PRECISION="50"/>
        <TARGETFIELD DATATYPE="decimal" NAME="REVENUE_USD" PRECISION="15" SCALE="2"/>
        <TARGETFIELD DATATYPE="decimal" NAME="COST_USD" PRECISION="15" SCALE="2"/>
        <TARGETFIELD DATATYPE="decimal" NAME="PROFIT_MARGIN" PRECISION="5" SCALE="2"/>
        <TARGETFIELD DATATYPE="string" NAME="QUARTER" PRECISION="10"/>
        <TARGETFIELD DATATYPE="integer" NAME="YEAR" PRECISION="4"/>
        <TARGETFIELD DATATYPE="string" NAME="REGION" PRECISION="50"/>
        <TARGETFIELD DATATYPE="decimal" NAME="NET_PROFIT" PRECISION="15" SCALE="2"/>
        <TARGETFIELD DATATYPE="timestamp" NAME="LOAD_TIMESTAMP"/>
      </TARGET>

      <!-- Mapping -->
      <MAPPING NAME="m_Financial_Metrics_ELT">
        
        <!-- Source Qualifier -->
        <TRANSFORMATION NAME="SQ_ZZZ_FINANCIAL_METRICS" TYPE="Source Qualifier">
          <TRANSFORMFIELD DATATYPE="string" NAME="METRIC_ID" PRECISION="10"/>
          <TRANSFORMFIELD DATATYPE="string" NAME="DEPARTMENT" PRECISION="50"/>
          <TRANSFORMFIELD DATATYPE="decimal" NAME="REVENUE_USD" PRECISION="15" SCALE="2"/>
          <TRANSFORMFIELD DATATYPE="decimal" NAME="COST_USD" PRECISION="15" SCALE="2"/>
          <TRANSFORMFIELD DATATYPE="decimal" NAME="PROFIT_MARGIN" PRECISION="5" SCALE="2"/>
          <TRANSFORMFIELD DATATYPE="string" NAME="QUARTER" PRECISION="10"/>
          <TRANSFORMFIELD DATATYPE="integer" NAME="YEAR" PRECISION="4"/>
          <TRANSFORMFIELD DATATYPE="string" NAME="REGION" PRECISION="50"/>
          <!-- Filter for high-performing departments -->
          <TABLEATTRIBUTE NAME="Sql Query" VALUE="SELECT * FROM maia_experience.ZZZ_FINANCIAL_METRICS WHERE PROFIT_MARGIN > 0.25 AND YEAR = 2024"/>
        </TRANSFORMATION>

        <!-- Expression Transformation -->
        <TRANSFORMATION NAME="EXP_Calculate_Metrics" TYPE="Expression">
          <TRANSFORMFIELD DATATYPE="string" NAME="METRIC_ID" PRECISION="10"/>
          <TRANSFORMFIELD DATATYPE="string" NAME="DEPARTMENT" PRECISION="50"/>
          <TRANSFORMFIELD DATATYPE="decimal" NAME="REVENUE_USD" PRECISION="15" SCALE="2"/>
          <TRANSFORMFIELD DATATYPE="decimal" NAME="COST_USD" PRECISION="15" SCALE="2"/>
          <TRANSFORMFIELD DATATYPE="decimal" NAME="PROFIT_MARGIN" PRECISION="5" SCALE="2"/>
          <TRANSFORMFIELD DATATYPE="string" NAME="QUARTER" PRECISION="10"/>
          <TRANSFORMFIELD DATATYPE="integer" NAME="YEAR" PRECISION="4"/>
          <TRANSFORMFIELD DATATYPE="string" NAME="REGION" PRECISION="50"/>
          <!-- Calculate net profit -->
          <TRANSFORMFIELD DATATYPE="decimal" NAME="NET_PROFIT" PRECISION="15" SCALE="2" 
                         EXPRESSION="REVENUE_USD - COST_USD"/>
          <!-- Add load timestamp -->
          <TRANSFORMFIELD DATATYPE="timestamp" NAME="LOAD_TIMESTAMP" 
                         EXPRESSION="SYSDATE"/>
        </TRANSFORMATION>

        <!-- Connector from Source to Expression -->
        <CONNECTOR FROMFIELD="METRIC_ID" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="METRIC_ID" TOINSTANCE="EXP_Calculate_Metrics"/>
        <CONNECTOR FROMFIELD="DEPARTMENT" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="DEPARTMENT" TOINSTANCE="EXP_Calculate_Metrics"/>
        <CONNECTOR FROMFIELD="REVENUE_USD" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="REVENUE_USD" TOINSTANCE="EXP_Calculate_Metrics"/>
        <CONNECTOR FROMFIELD="COST_USD" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="COST_USD" TOINSTANCE="EXP_Calculate_Metrics"/>
        <CONNECTOR FROMFIELD="PROFIT_MARGIN" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="PROFIT_MARGIN" TOINSTANCE="EXP_Calculate_Metrics"/>
        <CONNECTOR FROMFIELD="QUARTER" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="QUARTER" TOINSTANCE="EXP_Calculate_Metrics"/>
        <CONNECTOR FROMFIELD="YEAR" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="YEAR" TOINSTANCE="EXP_Calculate_Metrics"/>
        <CONNECTOR FROMFIELD="REGION" FROMINSTANCE="SQ_ZZZ_FINANCIAL_METRICS" 
                  TOFIELD="REGION" TOINSTANCE="EXP_Calculate_Metrics"/>

        <!-- Connector from Expression to Target -->
        <CONNECTOR FROMFIELD="METRIC_ID" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="METRIC_ID" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="DEPARTMENT" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="DEPARTMENT" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="REVENUE_USD" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="REVENUE_USD" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="COST_USD" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="COST_USD" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="PROFIT_MARGIN" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="PROFIT_MARGIN" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="QUARTER" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="QUARTER" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="YEAR" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="YEAR" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="REGION" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="REGION" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="NET_PROFIT" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="NET_PROFIT" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>
        <CONNECTOR FROMFIELD="LOAD_TIMESTAMP" FROMINSTANCE="EXP_Calculate_Metrics" 
                  TOFIELD="LOAD_TIMESTAMP" TOINSTANCE="TGT_FINANCIAL_ANALYTICS"/>

      </MAPPING>

      <!-- Session Configuration -->
      <SESSION NAME="s_Financial_Metrics_ELT" MAPPINGNAME="m_Financial_Metrics_ELT">
        <!-- SQL Server Source Connection -->
        <CONNECTIONREFERENCE CONNECTIONNAME="MSSQL_ZZZ_SOURCE" 
                           CONNECTIONTYPE="relational" 
                           REFTYPE="shared">
          <CONNECTIONATTRIBUTE NAME="Database host name" VALUE="se-library-mssql.database.windows.net"/>
          <CONNECTIONATTRIBUTE NAME="Database name" VALUE="se-library-demo"/>
          <CONNECTIONATTRIBUTE NAME="Port number" VALUE="1433"/>
          <CONNECTIONATTRIBUTE NAME="User name" VALUE="matillion"/>
        </CONNECTIONREFERENCE>
        
        <!-- Snowflake Target Connection -->
        <CONNECTIONREFERENCE CONNECTIONNAME="SNOWFLAKE_ZZZ_TARGET" 
                           CONNECTIONTYPE="relational" 
                           REFTYPE="shared">
          <CONNECTIONATTRIBUTE NAME="Database host name" VALUE="zzzcorp.snowflakecomputing.com"/>
          <CONNECTIONATTRIBUTE NAME="Database name" VALUE="ANALYTICS_DW"/>
          <CONNECTIONATTRIBUTE NAME="Schema name" VALUE="FINANCIAL_MARTS"/>
        </CONNECTIONREFERENCE>

        <!-- Session Properties -->
        <SESSTRANSFORMATIONINST TRANSFORMATIONNAME="TGT_FINANCIAL_ANALYTICS" 
                               TRANSFORMATIONTYPE="Target">
          <PARTITION DESCRIPTION="" NAME="Partition #1">
            <TARGETATTRIBUTE NAME="Target load type" VALUE="Normal"/>
            <TARGETATTRIBUTE NAME="Insert" VALUE="YES"/>
            <TARGETATTRIBUTE NAME="Update" VALUE="NO"/>
            <TARGETATTRIBUTE NAME="Delete" VALUE="NO"/>
          </PARTITION>
        </SESSTRANSFORMATIONINST>
      </SESSION>

      <!-- Workflow -->
      <WORKFLOW NAME="wf_Financial_Analytics_Daily">
        <WORKFLOWVARIABLE NAME="$$InputDir" DATATYPE="string" VALUE="/data/input/"/>
        <WORKFLOWVARIABLE NAME="$$OutputDir" DATATYPE="string" VALUE="/data/output/"/>
        
        <WORKFLOWTASK NAME="Start" TYPE="Start"/>
        <WORKFLOWTASK NAME="s_Financial_Metrics_ELT" TYPE="Session" 
                     REUSABLEOBJECTNAME="s_Financial_Metrics_ELT"/>
        <WORKFLOWTASK NAME="End" TYPE="End"/>
        
        <!-- Task Dependencies -->
        <WORKFLOWLINK FROMTASK="Start" TOTASK="s_Financial_Metrics_ELT"/>
        <WORKFLOWLINK FROMTASK="s_Financial_Metrics_ELT" TOTASK="End"/>
      </WORKFLOW>

    </FOLDER>
  </REPOSITORY>
</POWERMART>
```

**Key Features:**
- **Source:** SQL Server connection to `se-library-mssql.database.windows.net`
- **Filter:** Extracts only high-margin departments (>25%) for 2024
- **Transform:** Calculates net profit and adds load timestamp
- **Target:** Loads to Snowflake analytics warehouse
- **Automation:** Daily workflow execution for executive reporting

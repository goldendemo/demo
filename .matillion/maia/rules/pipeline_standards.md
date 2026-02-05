* Prefix tables per `data_landscape.md`.
* Add `_STG` suffix to load targets.
* Use **Basic mode** for loads.
* **ALL CAPS** for table/column NAMES.
* RDBMS load priority:
    1.  Specific component
    2.  Database Query
    3.  JDBC Load
* Favor native components over custom SQL execution.
* When loading files from S3:
    1. If the file is JSON, always create a staging table with a single variant column to load the data into.
    2. File prefixes will be in UPPERCASE. File suffixes will bein in lowercase. Example: MY_DATA.json
    3. When configuring the S3 Load component, the S3 Object Prefix should be the full path to the file in S3 and the Pattern should always be .*

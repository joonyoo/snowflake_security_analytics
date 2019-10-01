//===========================================================
// Create service account, warehouse, and role structure
// for a Tableau BI connection
//===========================================================
// create a BI service account user
USE ROLE SECURITYADMIN;
CREATE USER IF NOT EXISTS
  TABLEAU_SNOWALERT_SERVICE_ACCOUNT
  PASSWORD = 'my cool password here' // use your own password, dummy 
  MUST_CHANGE_PASSWORD = FALSE;

// create roles
USE ROLE SECURITYADMIN;
CREATE ROLE IF NOT EXISTS TABLEAU_ADMIN_ROLE;
CREATE ROLE IF NOT EXISTS TABLEAU_SNOWALERT_USER_ROLE;
GRANT ROLE TABLEAU_ADMIN_ROLE          TO ROLE SYSADMIN;
GRANT ROLE TABLEAU_SNOWALERT_USER_ROLE TO ROLE SYSADMIN;
GRANT ROLE TABLEAU_SNOWALERT_USER_ROLE TO ROLE TABLEAU_ADMIN_ROLE;
GRANT ROLE TABLEAU_SNOWALERT_USER_ROLE TO USER TABLEAU_SNOWALERT_SERVICE_ACCOUNT;

// create warehouse
USE ROLE SYSADMIN;
CREATE WAREHOUSE IF NOT EXISTS
  TABLEAU_SNOWALERT_WH
  COMMENT='Warehouse for snowalert dashboard development in Tableau'
  WAREHOUSE_SIZE=XSMALL
  AUTO_SUSPEND=60
  INITIALLY_SUSPENDED=TRUE;
GRANT OWNERSHIP ON WAREHOUSE TABLEAU_SNOWALERT_WH TO ROLE TABLEAU_ADMIN_ROLE;

// permission the role
USE ROLE SECURITYADMIN;
GRANT USAGE ON WAREHOUSE TABLEAU_SNOWALERT_WH TO ROLE TABLEAU_SNOWALERT_USER_ROLE;
GRANT ROLE SNOWALERT_BI_READ_ROLE             TO ROLE TABLEAU_SNOWALERT_USER_ROLE;

// set service account default values
ALTER USER 
  TABLEAU_SERVICE_ACCOUNT
SET
  DEFAULT_WAREHOUSE = TABLEAU_SNOWALERT_WH
  DEFAULT_ROLE = TABLEAU_SNOWALERT_USER_ROLE;
//===========================================================
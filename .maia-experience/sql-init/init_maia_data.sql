-- ZZZ Corp Analytics Data Sources SQL Script
-- Complete table creation and data insertion for Snowflake

-- Create and populate ZZZ_FINANCIAL_METRICS table
CREATE OR REPLACE TABLE ZZZ_FINANCIAL_METRICS (
    METRIC_ID VARCHAR(16777216),
    DEPARTMENT VARCHAR(16777216),
    REVENUE_USD VARCHAR(16777216),
    COST_USD VARCHAR(16777216),
    PROFIT_MARGIN VARCHAR(16777216),
    QUARTER VARCHAR(16777216),
    YEAR VARCHAR(16777216),
    REGION VARCHAR(16777216)
);

INSERT INTO ZZZ_FINANCIAL_METRICS VALUES
('FM001', 'Sales', '2500000', '1800000', '0.28', 'Q1', '2024', 'North America'),
('FM002', 'Marketing', '450000', '320000', '0.29', 'Q1', '2024', 'Europe'),
('FM003', 'Operations', '1200000', '950000', '0.21', 'Q1', '2024', 'Asia Pacific'),
('FM004', 'Sales', '2750000', '1950000', '0.29', 'Q2', '2024', 'North America'),
('FM005', 'R&D', '800000', '720000', '0.10', 'Q2', '2024', 'Global'),
('FM006', 'Sales', '2650000', '1850000', '0.30', 'Q3', '2024', 'North America'),
('FM007', 'Marketing', '520000', '350000', '0.33', 'Q2', '2024', 'Europe'),
('FM008', 'Operations', '1350000', '1000000', '0.26', 'Q2', '2024', 'Asia Pacific'),
('FM009', 'R&D', '850000', '750000', '0.12', 'Q3', '2024', 'Global'),
('FM010', 'Sales', '2800000', '1980000', '0.29', 'Q4', '2024', 'North America'),
('FM011', 'Marketing', '480000', '340000', '0.29', 'Q3', '2024', 'Europe'),
('FM012', 'Operations', '1280000', '970000', '0.24', 'Q3', '2024', 'Asia Pacific'),
('FM013', 'Sales', '2450000', '1750000', '0.29', 'Q1', '2024', 'Europe'),
('FM014', 'Marketing', '560000', '380000', '0.32', 'Q4', '2024', 'Europe'),
('FM015', 'Operations', '1400000', '1050000', '0.25', 'Q4', '2024', 'Asia Pacific'),
('FM016', 'R&D', '900000', '780000', '0.13', 'Q4', '2024', 'Global'),
('FM017', 'Sales', '2300000', '1650000', '0.28', 'Q1', '2024', 'Asia Pacific'),
('FM018', 'Marketing', '420000', '300000', '0.29', 'Q1', '2024', 'North America'),
('FM019', 'Operations', '1150000', '900000', '0.22', 'Q1', '2024', 'Europe'),
('FM020', 'R&D', '750000', '680000', '0.09', 'Q1', '2024', 'Global');

-- Create and populate ZZZ_EMPLOYEE_PERFORMANCE table
CREATE OR REPLACE TABLE ZZZ_EMPLOYEE_PERFORMANCE (
    EMP_ID VARCHAR(16777216),
    DEPARTMENT VARCHAR(16777216),
    PERFORMANCE_SCORE VARCHAR(16777216),
    SALARY_USD VARCHAR(16777216),
    TENURE_MONTHS VARCHAR(16777216),
    TRAINING_HOURS VARCHAR(16777216),
    MANAGER_ID VARCHAR(16777216),
    LOCATION VARCHAR(16777216)
);

INSERT INTO ZZZ_EMPLOYEE_PERFORMANCE VALUES
('EP001', 'Analytics', '4.2', '95000', '24', '40', 'MG001', 'New York'),
('EP002', 'Sales', '3.8', '75000', '18', '25', 'MG002', 'Chicago'),
('EP003', 'Marketing', '4.5', '82000', '36', '35', 'MG003', 'London'),
('EP004', 'Operations', '3.9', '68000', '12', '30', 'MG004', 'Singapore'),
('EP005', 'R&D', '4.7', '105000', '48', '50', 'MG001', 'San Francisco'),
('EP006', 'Sales', '4.1', '78000', '22', '28', 'MG002', 'Dallas'),
('EP007', 'Marketing', '3.7', '79000', '30', '32', 'MG003', 'Berlin'),
('EP008', 'Operations', '4.3', '71000', '15', '35', 'MG004', 'Tokyo'),
('EP009', 'R&D', '4.6', '110000', '42', '55', 'MG005', 'Boston'),
('EP010', 'Analytics', '4.0', '92000', '20', '38', 'MG001', 'Seattle'),
('EP011', 'Sales', '3.9', '76000', '16', '26', 'MG002', 'Miami'),
('EP012', 'Marketing', '4.2', '85000', '28', '40', 'MG003', 'Paris'),
('EP013', 'Operations', '4.1', '69000', '14', '33', 'MG004', 'Sydney'),
('EP014', 'R&D', '4.8', '115000', '52', '60', 'MG005', 'Austin'),
('EP015', 'Analytics', '3.8', '88000', '18', '35', 'MG001', 'Denver'),
('EP016', 'Sales', '4.4', '82000', '26', '30', 'MG002', 'Phoenix'),
('EP017', 'Marketing', '4.0', '80000', '32', '37', 'MG003', 'Madrid'),
('EP018', 'Operations', '3.6', '65000', '10', '28', 'MG004', 'Bangkok'),
('EP019', 'R&D', '4.5', '108000', '45', '52', 'MG005', 'Portland'),
('EP020', 'Analytics', '4.3', '97000', '27', '42', 'MG001', 'Atlanta');

-- Create and populate ZZZ_OPERATIONAL_KPI table
CREATE OR REPLACE TABLE ZZZ_OPERATIONAL_KPI (
    KPI_ID VARCHAR(16777216),
    PROCESS_NAME VARCHAR(16777216),
    EFFICIENCY_PCT VARCHAR(16777216),
    DOWNTIME_HOURS VARCHAR(16777216),
    QUALITY_SCORE VARCHAR(16777216),
    COST_PER_UNIT VARCHAR(16777216),
    DATE VARCHAR(16777216),
    FACILITY VARCHAR(16777216)
);

INSERT INTO ZZZ_OPERATIONAL_KPI VALUES
('OK001', 'Manufacturing', '87.5', '2.5', '4.3', '12.50', '2024-03-15', 'Plant_A'),
('OK002', 'Logistics', '92.1', '1.2', '4.6', '8.75', '2024-03-15', 'Warehouse_B'),
('OK003', 'Quality_Control', '95.2', '0.8', '4.8', '15.20', '2024-03-15', 'Lab_C'),
('OK004', 'Manufacturing', '89.3', '1.9', '4.4', '11.80', '2024-03-16', 'Plant_A'),
('OK005', 'Customer_Service', '88.7', '3.1', '4.2', '22.30', '2024-03-16', 'Call_Center_D'),
('OK006', 'Manufacturing', '91.2', '1.5', '4.5', '12.10', '2024-03-17', 'Plant_B'),
('OK007', 'Logistics', '89.8', '2.0', '4.4', '9.20', '2024-03-17', 'Warehouse_C'),
('OK008', 'Quality_Control', '93.7', '1.1', '4.7', '14.80', '2024-03-17', 'Lab_A'),
('OK009', 'Customer_Service', '90.3', '2.8', '4.3', '21.50', '2024-03-18', 'Call_Center_E'),
('OK010', 'Manufacturing', '86.9', '2.8', '4.2', '13.20', '2024-03-18', 'Plant_C'),
('OK011', 'Logistics', '94.5', '0.9', '4.7', '8.45', '2024-03-19', 'Warehouse_A'),
('OK012', 'Quality_Control', '96.1', '0.6', '4.9', '15.60', '2024-03-19', 'Lab_B'),
('OK013', 'Customer_Service', '87.2', '3.5', '4.1', '23.10', '2024-03-20', 'Call_Center_F'),
('OK014', 'Manufacturing', '88.7', '2.2', '4.3', '12.80', '2024-03-20', 'Plant_A'),
('OK015', 'Logistics', '91.3', '1.7', '4.5', '9.10', '2024-03-21', 'Warehouse_D'),
('OK016', 'Quality_Control', '94.8', '0.9', '4.8', '15.40', '2024-03-21', 'Lab_C'),
('OK017', 'Customer_Service', '89.6', '2.9', '4.4', '22.80', '2024-03-22', 'Call_Center_D'),
('OK018', 'Manufacturing', '90.1', '1.8', '4.4', '11.95', '2024-03-22', 'Plant_B'),
('OK019', 'Logistics', '93.2', '1.3', '4.6', '8.90', '2024-03-23', 'Warehouse_B'),
('OK020', 'Quality_Control', '95.7', '0.7', '4.8', '15.10', '2024-03-23', 'Lab_A');

-- XYZ Corp Analytics Data Sources - Complete SQL Setup

-- Table 1: XYZ_CUSTOMER_ANALYTICS
CREATE OR REPLACE TABLE XYZ_CUSTOMER_ANALYTICS (
    CUSTOMER_ID VARCHAR(16777216),
    SEGMENT VARCHAR(16777216),
    ACQUISITION_DATE VARCHAR(16777216),
    LIFETIME_VALUE VARCHAR(16777216),
    CHURN_RISK VARCHAR(16777216),
    REGION VARCHAR(16777216)
);

INSERT INTO XYZ_CUSTOMER_ANALYTICS VALUES
('C001', 'Enterprise', '2023-01-15', '125000', 'Low', 'North America'),
('C002', 'SMB', '2023-02-20', '45000', 'Medium', 'Europe'),
('C003', 'Enterprise', '2023-01-08', '200000', 'Low', 'Asia Pacific'),
('C004', 'Startup', '2023-03-12', '15000', 'High', 'North America'),
('C005', 'SMB', '2023-02-28', '67000', 'Low', 'Europe'),
('C006', 'Enterprise', '2023-03-05', '180000', 'Low', 'North America'),
('C007', 'Startup', '2023-03-18', '22000', 'High', 'Asia Pacific'),
('C008', 'SMB', '2023-02-14', '55000', 'Medium', 'Europe'),
('C009', 'Enterprise', '2023-01-22', '310000', 'Low', 'Asia Pacific'),
('C010', 'SMB', '2023-03-01', '38000', 'Medium', 'North America'),
('C011', 'Startup', '2023-03-20', '18000', 'High', 'Europe'),
('C012', 'Enterprise', '2023-01-30', '275000', 'Low', 'North America'),
('C013', 'SMB', '2023-02-10', '72000', 'Low', 'Asia Pacific'),
('C014', 'Startup', '2023-03-25', '12000', 'High', 'Europe'),
('C015', 'Enterprise', '2023-02-05', '195000', 'Medium', 'North America'),
('C016', 'SMB', '2023-03-08', '41000', 'Medium', 'Asia Pacific'),
('C017', 'Startup', '2023-03-15', '25000', 'High', 'Europe'),
('C018', 'Enterprise', '2023-01-18', '220000', 'Low', 'Asia Pacific'),
('C019', 'SMB', '2023-02-22', '63000', 'Low', 'North America'),
('C020', 'Startup', '2023-03-28', '16000', 'High', 'Europe');

-- Table 2: XYZ_PRODUCT_PERFORMANCE
CREATE OR REPLACE TABLE XYZ_PRODUCT_PERFORMANCE (
    PRODUCT_ID VARCHAR(16777216),
    PRODUCT_NAME VARCHAR(16777216),
    CATEGORY VARCHAR(16777216),
    REVENUE_Q1 VARCHAR(16777216),
    UNITS_SOLD VARCHAR(16777216),
    MARGIN_PCT VARCHAR(16777216),
    LAUNCH_DATE VARCHAR(16777216)
);

INSERT INTO XYZ_PRODUCT_PERFORMANCE VALUES
('P001', 'Analytics Pro', 'Software', '850000', '340', '65.2', '2022-06-15'),
('P002', 'Data Insights Basic', 'Software', '420000', '890', '45.8', '2022-09-20'),
('P003', 'Enterprise Dashboard', 'Platform', '1200000', '125', '72.1', '2021-11-10'),
('P004', 'Mobile Analytics', 'Mobile', '320000', '1250', '38.5', '2023-01-05'),
('P005', 'Custom Reports', 'Services', '180000', '45', '85.0', '2022-12-01'),
('P006', 'Advanced Metrics', 'Software', '675000', '280', '58.3', '2022-08-12'),
('P007', 'Real-time Monitor', 'Platform', '950000', '95', '68.7', '2022-04-18'),
('P008', 'Data Warehouse Pro', 'Platform', '1450000', '75', '78.2', '2021-09-25'),
('P009', 'Mobile Lite', 'Mobile', '195000', '2100', '32.1', '2023-02-14'),
('P010', 'Consulting Plus', 'Services', '240000', '28', '89.5', '2022-10-08'),
('P011', 'Analytics Starter', 'Software', '285000', '650', '42.6', '2023-01-20'),
('P012', 'Executive Views', 'Platform', '780000', '110', '71.8', '2022-07-03'),
('P013', 'Field Analytics', 'Mobile', '410000', '980', '41.2', '2022-11-15'),
('P014', 'Premium Support', 'Services', '320000', '52', '82.7', '2022-05-22'),
('P015', 'Data Studio', 'Software', '560000', '420', '55.9', '2022-12-18'),
('P016', 'Cloud Dashboard', 'Platform', '1100000', '88', '74.5', '2021-12-05'),
('P017', 'Tablet Analytics', 'Mobile', '275000', '1580', '35.8', '2023-03-02'),
('P018', 'Training Services', 'Services', '155000', '38', '87.3', '2022-09-10'),
('P019', 'Insights Advanced', 'Software', '720000', '315', '62.4', '2022-06-28'),
('P020', 'Enterprise Suite', 'Platform', '1650000', '65', '79.6', '2021-10-12');

-- Table 3: XYZ_SALES_OPERATIONS
CREATE OR REPLACE TABLE XYZ_SALES_OPERATIONS (
    SALES_ID VARCHAR(16777216),
    CUSTOMER_ID VARCHAR(16777216),
    PRODUCT_ID VARCHAR(16777216),
    SALE_DATE VARCHAR(16777216),
    AMOUNT VARCHAR(16777216),
    SALES_REP VARCHAR(16777216),
    CHANNEL VARCHAR(16777216)
);

INSERT INTO XYZ_SALES_OPERATIONS VALUES
('S001', 'C001', 'P003', '2023-03-15', '45000', 'John Smith', 'Direct'),
('S002', 'C002', 'P002', '2023-03-18', '12000', 'Sarah Johnson', 'Partner'),
('S003', 'C003', 'P001', '2023-03-20', '28000', 'Mike Chen', 'Online'),
('S004', 'C001', 'P004', '2023-03-22', '15000', 'John Smith', 'Direct'),
('S005', 'C004', 'P002', '2023-03-25', '8000', 'Lisa Wong', 'Online'),
('S006', 'C005', 'P007', '2023-03-28', '32000', 'David Brown', 'Partner'),
('S007', 'C006', 'P008', '2023-03-30', '85000', 'John Smith', 'Direct'),
('S008', 'C007', 'P009', '2023-04-02', '5500', 'Anna Martinez', 'Online'),
('S009', 'C008', 'P006', '2023-04-05', '22000', 'Sarah Johnson', 'Partner'),
('S010', 'C009', 'P020', '2023-04-08', '95000', 'Mike Chen', 'Direct'),
('S011', 'C010', 'P011', '2023-04-10', '9500', 'Lisa Wong', 'Online'),
('S012', 'C011', 'P013', '2023-04-12', '7200', 'David Brown', 'Partner'),
('S013', 'C012', 'P016', '2023-04-15', '78000', 'John Smith', 'Direct'),
('S014', 'C013', 'P015', '2023-04-18', '18500', 'Anna Martinez', 'Online'),
('S015', 'C014', 'P017', '2023-04-20', '4800', 'Sarah Johnson', 'Partner'),
('S016', 'C015', 'P012', '2023-04-22', '42000', 'Mike Chen', 'Direct'),
('S017', 'C016', 'P019', '2023-04-25', '25000', 'Lisa Wong', 'Online'),
('S018', 'C017', 'P014', '2023-04-28', '6800', 'David Brown', 'Partner'),
('S019', 'C018', 'P005', '2023-04-30', '15500', 'Anna Martinez', 'Direct'),
('S020', 'C019', 'P010', '2023-05-02', '12200', 'John Smith', 'Online');

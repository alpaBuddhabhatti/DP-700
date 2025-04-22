INSERT INTO config.PipelineDetails 
(Spec_Code, Description, Source_Type, Data_Source, Load_Type, Metadata_Config, Additional_Configurations, Target_Type, Target_Name, Sheet_Name, Row_Range)
VALUES 
-- CSV File Example
('SPEC_12345', 'Inflation-related BO for sales data', 'File', 'CSV', 'Delta', 
 '{"delimiter": ",", "row_terminator": "\\n", "escape_character": "\\""}', 
 'Encoding: UTF-8', 
 'Fabric Table', 'Sales_Data', NULL, '1-1000'),  -- No Sheet Name, Row Range 1 to 1000

-- XLSX File Example (with Sheet Name and Row Range)
('SPEC_67890', 'BO for sales data in Excel', 'File', 'XLSX', 'Full', 
 '{"delimiter": ",", "sheet_name": "SalesData", "row_range": "1-500"}', 
 'Encoding: UTF-8', 
 'Data Lake', 'Excel_SalesData', 'SalesData', '1-500'),

-- API Example
('SPEC_24680', 'BO for real-time stock market inflation data', 'API', 'JSON', 'Incremental', 
 '{"endpoint": "/data?updated_since={date}", "auth_type": "OAuth", "pagination": "cursor"}', 
 'Auth Type: OAuth', 
 'Data Lake', 'API_Stock_Market', NULL, NULL),

-- Database Table Example
('SPEC_54321', 'BO for tracking inflation-adjusted customer orders', 'Database', 'Tables', 'Full', 
 '{"primary_key": "ID", "partition_key": "Date", "query": "SELECT Col1, Col3 FROM table1 WHERE created_date > ''2024-11-08''"}', 
 'Index Strategy: Clustered Index', 
 'SQL DB', 'Customer_Orders', NULL, NULL);



/*update config.PipelineDetails 
set Metadata_Config = (select Replace(Metadata_Config,'{"ColumnDelimiter": ";"','{"ColumnDelimiter": ","') from config.PipelineDetails where id=10)
where id=9

select Metadata_Config from config.PipelineDetails where id=9 */

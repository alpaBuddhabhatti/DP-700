INSERT INTO [config].[PipelineDetails] (
    [Spec_Code],
    [Description],
    [Source_Type],
    [Data_Source],
    [Load_Type],
    [Metadata_Config],
    [Target_Type],
    [Target_Name],
    [Sheet_Name],
    [Row_Range]
)
VALUES
-- Record 1
('BO2', 'Business Outcode 1 - CSV File', 'CSV', 'file1.csv', 'Full Load',
 N'{"ColumnDelimiter":",","RowDelimiter":"\n","Encoding":"UTF-8","FirstRowAsHeader":true,"EscapeCharacter":"\\","QuoteCharacter":"\"","NullValue":"NULL","CompressionType":"None","FileExtension":".csv","SearchStart":"0","TableActionOption":"None"}',
 'Table', 'Table1', NULL, NULL),

-- Record 2
('BO2', 'Business Outcode 2 - CSV File', 'CSV', 'file2.csv', 'Full Load',
 N'{"ColumnDelimiter":";","RowDelimiter":"\n","Encoding":"UTF-8","FirstRowAsHeader":true,"EscapeCharacter":"\\","QuoteCharacter":"\"","NullValue":"NULL","CompressionType":"None","FileExtension":".csv","SearchStart":"0","TableActionOption":"None"}',
 'Table', 'Table2', NULL, NULL),

-- Record 3
( 'BO3', 'Business Outcode 3 - Excel File', 'Excel', 'File1.xlsx', 'Full Load',
 N'{"CompressionType":"None","ColumnDelimiter":",","RowDelimiter":"\r\n","Encoding":"UTF-8","EscapeCharacter":"¬","QuoteCharacter":"\"","FirstRowAsHeader":true,"NullValue":"","CompressionLevel":"Optimal","FileExtension":".xlsx","SearchStart":"0","TableActionOption":"None"}',
 'Table', 'Table3', 'Sheet1', 'A1:D6'),

-- Record 4
('BO3', 'Business Outcode 4 - Excel File', 'Excel', 'File2.xlsx', 'Full Load',
 N'{"CompressionType":"None","ColumnDelimiter":",","RowDelimiter":"\r\n","Encoding":"UTF-8","EscapeCharacter":"¬","QuoteCharacter":"\"","FirstRowAsHeader":true,"NullValue":"","CompressionLevel":"Optimal","FileExtension":".xlsx","SearchStart":"0","TableActionOption":"None"}',
 'Table', 'Table4', 'Sheet1', 'B3:D8');

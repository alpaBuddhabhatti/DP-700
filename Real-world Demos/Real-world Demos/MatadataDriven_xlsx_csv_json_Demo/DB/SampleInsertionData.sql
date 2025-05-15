INSERT INTO [config].[BusinessSourceDetails]
    (
      [Spec_Code]
    , [Source_Location_Type]
    , [Source_Location_Details]
    , [Target_Location_Type]
    , [Target_Location_Details]
    , [Spec_Code_ID]
    ) values('BO2', 'ONELAKE','BO2','BO2','BO2',10)
----------------------------------------------------

update
  
    [config].[PipelineDetails] 
    set spec_Code ='BO3'

    where spec_Code='BO4'

    update
    [config].[PipelineDetails] 
    set Source_type ='CSV'

    where Source_type='File'


    update
  
    [config].[PipelineDetails] 
    set Data_Source ='file2.csv'
    where Data_Source='File2.csv'


  
    update [config].[PipelineDetails] 
    set Metadata_config =N'{"ColumnDelimiter":",","RowDelimiter":"\n","Encoding":"UTF-8","FirstRowAsHeader":true,"EscapeCharacter":"\\","QuoteCharacter":"\"","NullValue":"NULL","CompressionType":"None","FileExtension":".csv","SearchStart":"0","TableActionOption":"None"}'
    where Data_Source='file1.csv'


update 
   [config].[PipelineDetails] set Row_Range='A1:D6' where id=11

-- Or, to do it for all rows ending in “.csv”:
UPDATE [config].[PipelineDetails]
SET Source_Type = 'File'
WHERE Source_Type = 'CSV'


-- Update Id = 8: set FirstRowAsHeader to false
UPDATE [config].[PipelineDetails]
SET Metadata_Config = N'{"CompressionType":"None","ColumnDelimiter":",","RowDelimiter":"\r\n","Encoding":"UTF-8","EscapeCharacter":"¬","QuoteCharacter":"\"","FirstRowAsHeader":true,"NullValue":"","CompressionLevel":"Optimal","FileExtension":".xlsx","SearchStart":"0","TableActionOption":"None"}'
WHERE Id = 12;


-- Update Id = 8: set FirstRowAsHeader to false
UPDATE [config].[PipelineDetails]
SET Metadata_Config = N'{"CompressionType":"None","ColumnDelimiter":",","RowDelimiter":"\r\n","Encoding":"UTF-8","EscapeCharacter":"¬","QuoteCharacter":"\"","FirstRowAsHeader":true,"NullValue":"","CompressionLevel":"Optimal","FileExtension":".xlsx","SearchStart":"0","TableActionOption":"None"}'
WHERE Id = 12;
GO



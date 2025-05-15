Create schema config
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [config].[PipelineDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Spec_Code] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[Source_Type] [nvarchar](50) NOT NULL,
	[Data_Source] [nvarchar](50) NOT NULL,
	[Load_Type] [nvarchar](50) NOT NULL,
	[Metadata_Config] [nvarchar](max) NULL,
	[Additional_Configurations] [nvarchar](255) NULL,
	[Target_Type] [nvarchar](50) NOT NULL,
	[Target_Name] [nvarchar](100) NOT NULL,
	[Sheet_Name] [nvarchar](100) NULL,
	[Row_Range] [nvarchar](50) NULL,
	[Created_At] [datetime] NULL,
	[Updated_At] [datetime] NULL,
	[Where_Condition] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [config].[PipelineDetails] ADD PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [config].[PipelineDetails] ADD  DEFAULT (getdate()) FOR [Created_At]
GO
ALTER TABLE [config].[PipelineDetails] ADD  DEFAULT (getdate()) FOR [Updated_At]
GO


-------------------------------------------------------
----------------------------------------------------


CREATE TABLE [config].[BusinessSourceDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Spec_Code] [nvarchar](255) NULL,
	[Source_Location_Type] [nvarchar](255) NULL,
	[Source_Location_Details] [nvarchar](255) NULL,
	[Target_Location_Type] [nvarchar](255) NULL,
	[Target_Location_Details] [nvarchar](255) NULL,
	[Spec_Code_ID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [config].[BusinessSourceDetails] ADD PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
------------------------------------------------------------------------
-----------------------------------------------------------


CREATE TABLE [config].[DeltaLoadTable](
	[Id] [int] NOT NULL,
	[Modified_Date] [datetime] NULL,
	[Min_Load_Date] [datetime] NULL,
	[Max_Load_Date] [datetime] NULL,
	[Page_Number] [int] NULL,
	[Last_Loaded_Id] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [config].[DeltaLoadTable] ADD PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



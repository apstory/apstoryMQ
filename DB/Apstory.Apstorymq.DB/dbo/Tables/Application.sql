CREATE TABLE [dbo].[Application] (
    [ApplicationId]   INT            IDENTITY (1, 1) NOT NULL,
    [ApplicationName] NVARCHAR (255) NOT NULL,
    [CompanyId]       INT            NOT NULL,
	[Key] NVARCHAR(500) NULL, 
    [IsActive]        BIT            CONSTRAINT [DF_Application_IsActive] DEFAULT ((1)) NOT NULL,
    [CreateDT]        DATETIME       CONSTRAINT [DF_Application_CreateDT] DEFAULT (getdate()) NOT NULL,
    [UpdateDT]        DATETIME       CONSTRAINT [DF_Application_UpdateDT] DEFAULT (getdate()) NULL,    
    CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED ([ApplicationId] ASC),
    CONSTRAINT [FK_Application_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


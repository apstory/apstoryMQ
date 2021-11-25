CREATE TABLE [dbo].[Company] (
    [CompanyId]   INT            IDENTITY (1, 1) NOT NULL,
    [CompanyName] NVARCHAR (500) NOT NULL,
    [IsActive]    BIT            CONSTRAINT [DF_Company_IsActive] DEFAULT ((1)) NOT NULL,
    [CreateDT]    DATETIME       CONSTRAINT [DF_Company_CreateDT] DEFAULT (getdate()) NOT NULL,
    [UpdateDT]    DATETIME       CONSTRAINT [DF_Company_UpdateDT] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED ([CompanyId] ASC)
);


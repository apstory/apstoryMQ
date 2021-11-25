CREATE TABLE [dbo].[User] (
    [UserId]           INT            NOT NULL,
    [UserName]         NVARCHAR (255) NOT NULL,
    [UserEmail]        NVARCHAR (255) NOT NULL,
    [FirstName]        NVARCHAR (255) NOT NULL,
    [LastName]         NVARCHAR (255) NOT NULL,
    [ContactNum]       NVARCHAR (20)  NULL,
    [IsReceiveUpdate]  BIT            CONSTRAINT [DF_User_IsReceiveUpdate] DEFAULT ((0)) NOT NULL,
    [IsReceiveWelcome] BIT            CONSTRAINT [DF_User_IsReceiveWelcome] DEFAULT ((0)) NOT NULL,
    [DeviceOS]         NVARCHAR (50)  NULL,
    [Version]          NVARCHAR (50)  NULL,
    [ProfileImage]     NVARCHAR (500) NULL,
    [DnnId]            INT            NULL,
    [CreateDT]         DATETIME       CONSTRAINT [DF_User_CreateDT] DEFAULT (getdate()) NOT NULL,
    [UpdateDT]         DATETIME       CONSTRAINT [DF_User_UpdateDT] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserId] ASC)
);


﻿CREATE TABLE [dbo].[Subscription] (
    [SubscriptionId] INT           IDENTITY (1, 1) NOT NULL,
    [ApplicationId]  INT           NOT NULL,
    [Client]         VARCHAR (255) NOT NULL,
    [Topic]          VARCHAR (255) NOT NULL,
    [CreateDT]       DATETIME      CONSTRAINT [DF_Subscription_CreateDT] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED ([SubscriptionId] ASC),
    CONSTRAINT [FK_Subscription_Application] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([ApplicationId])
);




GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Subscription_01] ON [dbo].[Subscription]
(
	[ApplicationId] ASC,
	[Client] ASC,
	[Topic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

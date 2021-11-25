CREATE TABLE [dbo].[PubSubMapping] (
    [PubSubMappingId]  INT              IDENTITY (1, 1) NOT NULL,
    [PubClient]        VARCHAR (255)    NOT NULL,
    [PubTopic]         VARCHAR (255)    NOT NULL,
    [SubscriptionId]   INT NOT NULL,
    [SubClient]        VARCHAR (255)    NOT NULL,
    [SubTopic]         VARCHAR (255)    NOT NULL,
    [CreateDT]         DATETIME         NOT NULL,
    [LastPublishDT]    DATETIME         NOT NULL,
    PRIMARY KEY CLUSTERED ([PubSubMappingId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_PubSubMapping_01] ON [dbo].[PubSubMapping]
(
	[PubClient] ASC,
	[PubTopic] ASC,
	[SubscriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

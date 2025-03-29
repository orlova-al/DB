USE boxOffice; -- чтобы создавались юзеры только для этой БД

--CREATE LOGIN ViktorTalis -- юзер 1
--WITH PASSWORD = 'WhyDoYouPersist';
--GO

--CREATE USER ViktorTalis
--FOR LOGIN ViktorTalis;
--GO

--CREATE LOGIN JayceTalis
--WITH PASSWORD = 'BecauseIPromisedYou';
--GO

--CREATE USER JayceTalis -- юзер 2
--FOR LOGIN JayceTalis;
--GO

--CREATE ROLE theaterOwner; -- владелец
--GO

--CREATE ROLE ticketSeller; -- продавец
--GO

-- всё для владельца
GRANT SELECT, INSERT, DELETE, UPDATE ON Actor TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Schedule TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Show TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Starring TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Ticket TO theaterOwner;

-- всё для продавца
GRANT SELECT, INSERT, UPDATE ON Ticket TO ticketSeller; -- первая мысль
REVOKE UPDATE, INSERT ON Ticket TO ticketSeller; -- убрать возможности
GRANT UPDATE(bought) ON Ticket TO ticketSeller; -- раз продавец пусть умеет менять только это

GRANT SELECT ON Show TO ticketSeller;
GRANT SELECT ON Schedule TO ticketSeller;

-- даю роли юзерам
ALTER ROLE theaterOwner ADD MEMBER ViktorTalis;
ALTER ROLE ticketSeller ADD MEMBER JayceTalis;
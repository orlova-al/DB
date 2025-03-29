USE boxOffice; -- ����� ����������� ����� ������ ��� ���� ��

--CREATE LOGIN ViktorTalis -- ���� 1
--WITH PASSWORD = 'WhyDoYouPersist';
--GO

--CREATE USER ViktorTalis
--FOR LOGIN ViktorTalis;
--GO

--CREATE LOGIN JayceTalis
--WITH PASSWORD = 'BecauseIPromisedYou';
--GO

--CREATE USER JayceTalis -- ���� 2
--FOR LOGIN JayceTalis;
--GO

--CREATE ROLE theaterOwner; -- ��������
--GO

--CREATE ROLE ticketSeller; -- ��������
--GO

-- �� ��� ���������
GRANT SELECT, INSERT, DELETE, UPDATE ON Actor TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Schedule TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Show TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Starring TO theaterOwner;
GRANT SELECT, INSERT, DELETE, UPDATE ON Ticket TO theaterOwner;

-- �� ��� ��������
GRANT SELECT, INSERT, UPDATE ON Ticket TO ticketSeller; -- ������ �����
REVOKE UPDATE, INSERT ON Ticket TO ticketSeller; -- ������ �����������
GRANT UPDATE(bought) ON Ticket TO ticketSeller; -- ��� �������� ����� ����� ������ ������ ���

GRANT SELECT ON Show TO ticketSeller;
GRANT SELECT ON Schedule TO ticketSeller;

-- ��� ���� ������
ALTER ROLE theaterOwner ADD MEMBER ViktorTalis;
ALTER ROLE ticketSeller ADD MEMBER JayceTalis;
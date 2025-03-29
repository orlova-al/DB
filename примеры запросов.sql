--a)  ���������� ������� ������ ������� �� ����� � ������ �������� ������
--select INN_company, sum(amount) as s
--from Car as c join Assigned as a on a.VIN_num = c.VIN_num
--join Deal as d on d.contract_number  = a.contract_number
--where date_of_issue >= '2024-11-01'
--group by INN_company




--b)  ��� ������� ���� � ������ ���������� ������� ���������� �����, ��������� � �����
--select type_car, model, count(*) as cnt from Car 
--group by type_car, model

--c)  ����� ������, �� ������������ ������� (� ������ �������� ���� �� ���������� ���� ������� �� ���� ��������� �� ����� ������)

--select distinct model
--from Car
--where Car.VIN_num not in (select c.VIN_num
--from Car as c  join Assigned as a on a.VIN_num = c.VIN_num  join Deal as d on d.contract_number = a.contract_number
--where d.date_of_issue >= '2024-01-01' AND d.date_of_issue < '2025-01-01')

--d)  ����� ���������� �������� (�������������� �������� ����� ����� 3-� ���) � ���������� ��� ��� ������ ������ (����., ���� ������ ����� ������ � 4-� ��� � ������ 2%, � 6-� � 4%, � 8-� � 6%, �� ���� ������ ��� �����-���� ����������, �� ������ �� ���������������)


--WITH client_orders AS (
--    SELECT 
--        c.passport,
--        COUNT(o.contract_number) AS total_rents,
--        SUM(CASE WHEN fine2 = '��' THEN 1 ELSE 0 END) AS has_fines
--    FROM clients c
--    LEFT JOIN deal o ON c.passport = o.passport_of_clients
--    GROUP BY c.passport
--	having COUNT(o.contract_number) >= 3
--),
--discounts AS (
--    SELECT 
--        passport,
--        CASE 
--            WHEN total_rents >= 8 AND has_fines = 0 THEN 6
--            WHEN total_rents >= 6 AND has_fines = 0 THEN 4
--            WHEN total_rents >= 4 AND has_fines = 0 THEN 2
--            ELSE 0
--        END AS discount_percent
--    FROM client_orders
--)
--SELECT 
--    c.full_name,
--    co.total_rents,
--    d.discount_percent
--FROM clients c
--JOIN client_orders co ON c.passport = co.passport
--JOIN discounts d ON co.passport = d.passport;

--e)  ����� ��������, �������� ����� ������������ �������� �������, � ������ ��� ��� ����� ����� ������������ ������
--SELECT 
--	TOP 3
--    passport,
--	full_name,
--    COUNT(contract_number) AS number_of_rentals,
--    SUM(amount) AS total_amount
--FROM 
--    Deal as d join Clients as c on c.passport = d.passport_of_clients
--GROUP BY 
--    passport, full_name
--ORDER BY 
--    number_of_rentals DESC;


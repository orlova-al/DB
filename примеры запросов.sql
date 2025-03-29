--a)  Рассчитать выручку пункта проката по датам с начала текущего месяца
--select INN_company, sum(amount) as s
--from Car as c join Assigned as a on a.VIN_num = c.VIN_num
--join Deal as d on d.contract_number  = a.contract_number
--where date_of_issue >= '2024-11-01'
--group by INN_company




--b)  Для каждого типа и модели автомобиля вывести количество машин, имеющихся в фирме
--select type_car, model, count(*) as cnt from Car 
--group by type_car, model

--c)  Найти модели, не пользующиеся спросом (с начала текущего года на автомобили этих моделей не было заключено ни одной сделки)

--select distinct model
--from Car
--where Car.VIN_num not in (select c.VIN_num
--from Car as c  join Assigned as a on a.VIN_num = c.VIN_num  join Deal as d on d.contract_number = a.contract_number
--where d.date_of_issue >= '2024-01-01' AND d.date_of_issue < '2025-01-01')

--d)  Найти постоянных клиентов (пользовавшихся услугами фирмы более 3-х раз) и рассчитать для них размер скидки (напр., если клиент берет машину в 4-й раз – скидка 2%, в 6-й – 4%, в 8-й – 6%, но если клиент был когда-либо оштрафован, то скидка не предоставляется)


--WITH client_orders AS (
--    SELECT 
--        c.passport,
--        COUNT(o.contract_number) AS total_rents,
--        SUM(CASE WHEN fine2 = 'да' THEN 1 ELSE 0 END) AS has_fines
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

--e)  Найти клиентов, наиболее часто пользующихся услугами проката, и выдать для них общую сумму заключеннных сделок
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


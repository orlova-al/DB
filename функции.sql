---- a) Скалярная функция, возвращающая среднее количество сделок в день
CREATE or alter FUNCTION avgDate1()
RETURNS float
AS
BEGIN
    DECLARE @avg_deals_per_day float

    SELECT @avg_deals_per_day = AVG(daily_count)
    FROM (
        SELECT COUNT(*) as daily_count
        FROM Deal
        GROUP BY date_of_issue
    ) AS daily_counts;

    RETURN @avg_deals_per_day;
END;


---- Тестируем функцию
SELECT dbo.avgDate1();


--	b) Inline-функция, возвращающая список автомобилей, которые находятся в данный момент в прокате в виде: 
--идентификатор авто (напр., гос.регистрационный номер), модель, тип, ФИО клиента, срок возврата

CREATE OR ALTER FUNCTION udf_GetCurrentRentals()
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 
        c.VIN_num AS ID,
        c.model AS Model,
        c.type_car AS _Type,
        cl.full_name AS Clients,
        d.date_of_refund AS ReturnDate
    FROM 
        dbo.Car c
    INNER JOIN 
        dbo.Assigned a ON c.VIN_num = a.VIN_num
    INNER JOIN 
        dbo.Deal d ON a.contract_number = d.contract_number
    INNER JOIN 
        dbo.Clients cl ON d.passport_of_clients = cl.passport
    WHERE 
        d.returnDate IS NULL
);
    
SELECT * FROM dbo.udf_GetCurrentRentals();

--	c) Multi-statement-функция, выдающая выручку фирмы по месяцам заданного года

CREATE OR ALTER FUNCTION ufn_GetMonthlyRevenue(@year INT)
RETURNS @monthlyRevenue TABLE (
    MonthNumber INT,
    Revenue MONEY
)
AS
BEGIN
    DECLARE @month INT;
    SET @month = 1;

    WHILE (@month <= 12)
    BEGIN
        -- Вычисляем выручку за текущий месяц
        DECLARE @currentMonthRevenue MONEY ;
        
        SELECT @currentMonthRevenue = ISNULL(SUM(d.amount),0)
        FROM Deal as d join Assigned as a on a.contract_number = d.contract_number join Car as cr on cr.VIN_num = a.VIN_num 
		join Carsharing as c on c.INN_company = cr.INN_company
        WHERE YEAR(d.date_of_issue) = @year
          AND MONTH(d.date_of_issue) = @month;

        -- Добавляем строку в результирующую таблицу
        INSERT INTO @monthlyRevenue (MonthNumber, Revenue)
        VALUES (@month, @currentMonthRevenue);

        -- Переходим к следующему месяцу
        SET @month += 1;
    END

    RETURN;
END;

Select *  from dbo.ufn_GetMonthlyRevenue (2023)
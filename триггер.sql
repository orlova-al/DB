--	a) ������� ������ ���� �� ���������� ������ � ���� ������ �����-���� ��������� ���� �� 
--������� �� ������� ��� � ������ ���������, �� ������ �� �����������, � ��������� ������ �������, 
--������� ��� ������ ����������� ������ ��������, � � ����������� �� ����� ������ ��� ������ ��� ������� ����� ������

CREATE or alter TRIGGER trg_insertDeal
ON Deal
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @contract_num varchar(5)
    DECLARE @date1 DATE
    DECLARE @date2 DATE
    DECLARE @amount MONEY
    DECLARE @fine MONEY
    DECLARE @pass_cl NVARCHAR(10)
    DECLARE @fine2 NVARCHAR(10)
    DECLARE @condition_b VARCHAR(50)
    DECLARE @returndate DATE
    DECLARE @rentalcount INT
    DECLARE @discount DECIMAL(5, 2) = 0.0 

    SELECT
        @contract_num = i.contract_number,
        @date1 = i.date_of_issue,
        @date2 = i.date_of_refund,
        @amount = i.amount,
        @fine = i.fine,
        @pass_cl = i.passport_of_clients,
        @fine2 = i.fine2,
        @returndate = i.returnDate,
        @condition_b = i.Condition_before
    FROM
        inserted i

    -- �������� �� ������ ������� ������
    IF EXISTS (
        SELECT 1
        FROM Deal d
        WHERE d.passport_of_clients = @pass_cl
            AND (d.returnDate > d.date_of_refund OR d.Condition_before = '������')
    )
    BEGIN
        RAISERROR('������ ����� ������ ������� ������.', 16, 1)
        RETURN -- ������ ��������
    END

    -- ������� ���������� ����� � ������ ������
    SELECT
        @rentalcount = COUNT(*)
    FROM
        Deal d
    WHERE
        d.passport_of_clients = @pass_cl

    IF @rentalcount >= 5
        SET @discount = 0.20
    ELSE IF @rentalcount >= 3
        SET @discount = 0.15
    ELSE IF @rentalcount >= 2
        SET @discount = 0.10

    -- ���������� ������ � ����� ������
    SET @amount = @amount * (1 - @discount)

    -- ������� ����� ������ � ������� Deal
    INSERT INTO Deal (
        contract_number,
        date_of_issue,
        date_of_refund,
        amount,
        fine,
        passport_of_clients,
        fine2,
        returnDate,
        Condition_before
    ) VALUES (
        @contract_num,
        @date1,
        @date2,
        @amount,
        @fine,
        @pass_cl,
        @fine2,
        @returndate,
        @condition_b
    )
END



INSERT INTO Deal (
    contract_number,
    date_of_issue,
    date_of_refund,
    amount,
    fine,
    passport_of_clients,
    fine2,
    returnDate,
    Condition_before
) VALUES (
    '90912',
    '2024-11-01',
    '2024-11-01',
    9000,
    300,
    '2344123123',
    '���',
    '2024-12-06',
    '�������'
);
disable trigger trg_insertDeal on Deal 
--	b)  ����������� ������� �� ��������� ��������� ������� ����������� � ���������  --�������� ������ 
--������� ���� ������ ������ ��� �����������, ������� � ������ ������ �� ��������� � �������

create or alter trigger trg_updateCar
ON Car
AFTER UPDATE
AS
BEGIN
    DECLARE @new_price MONEY,
            @old_price MONEY,
            @vin VARCHAR(17);

    
    SELECT @vin = i.VIN_num, @new_price = i.rent FROM inserted i;
    SELECT @old_price = d.rent FROM deleted d;

    
    IF (@new_price <> @old_price)
    BEGIN
        
        IF EXISTS (
            SELECT 1
            FROM Car c
            JOIN Assigned a ON c.VIN_num = a.VIN_num
            JOIN Deal d ON d.contract_number = a.contract_number
            WHERE c.VIN_num = @vin AND d.returnDate IS NULL
        )
        BEGIN
           
            RAISERROR('���������� ������ � �������, �������� ���� ����������.', 16, 1);
           ROLLBACK TRANSACTION;
        END
    END
END;



-- update Car
-- set rent = 12000
-- where VIN_num = 'WBA3C5C53FD557812'


--disable trigger trg_updateCar on Car


--��������� if 
--c) ���������� ������� �� �������� �������� ���������� � ������� ����� ������ ���������� ������ 15 ���, 
--������� �� ������������ � �������, ������� ������ ���������

create or alter trigger trg_delCar
on Car
instead of delete
as
begin
declare @vin nvarchar(17), 
		@year int,
		@con nvarchar(20)

declare cur cursor for 
select d.VIN_num, d.year_of_release, d.con from deleted d
 
 open cur

 fetch next from cur into @vin, @year, @con

 while @@FETCH_STATUS = 0
 begin

 if year(getdate()) - @year < 15
 begin
            raiserror('���������� ������ 15 ��� ������ �������.', 16, 1);
            close cur;
            deallocate cur;
            return;
 end

  if EXISTS (
            SELECT 1
            FROM Deal d join Assigned a on a.contract_number = d.contract_number join Car c on c.VIN_num = a.VIN_num
            WHERE c.VIN_num = @vin
        )
        BEGIN
            RAISERROR('����������, ����������� � �������, ������ �������.', 16, 1);
            CLOSE cur;
            DEALLOCATE cur;
            RETURN;
        END

 if @con = '�������'
  begin
            raiserror('���������� � ������� ��������� ������ �������.', 16, 1);
            close cur;
            deallocate cur;
            return;
 end
 delete from Car
        where VIN_num = @vin;

        fetch next from cur into @vin, @year, @con;
    end

    close cur;
    deallocate cur;
end


--disable trigger trg_delCar on Car
--enable trigger trg_delCar on Car

--delete from Car 
--where VIN_num = 'WA1AAF4G1DN001111'
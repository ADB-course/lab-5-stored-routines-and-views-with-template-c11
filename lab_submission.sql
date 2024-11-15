-- (i) A Procedure called PROC_LAB5
DELIMITER $$
CREATE PROCEDURE `PROC_LAB5`()
BEGIN
    SELECT 
        offices.officeCode AS `Office Code`,
        offices.city AS `Office City`,
        offices.country AS `Office Country`,
        employees.employeeNumber AS `Employee ID`,
        CONCAT(employees.firstName, ' ', employees.lastName) AS `Employee Name`,
        COUNT(DISTINCT orders.orderNumber) AS `Total Orders Handled`,
        FORMAT(SUM(payments.amount), 2) AS `Total Payments Processed`
    FROM 
        employees
    JOIN offices ON employees.officeCode = offices.officeCode
    LEFT JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
    LEFT JOIN orders ON customers.customerNumber = orders.customerNumber
    LEFT JOIN payments ON customers.customerNumber = payments.customerNumber
    GROUP BY 
        offices.officeCode, employees.employeeNumber
    ORDER BY 
        offices.officeCode, `Total Payments Processed` DESC;
END$$
DELIMITER ;


-- (ii) A Function called FUNC_LAB5
DELIMITER $$
CREATE FUNCTION `FUNC_LAB5`(customerID INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE avgPayment DECIMAL(10, 2);
    SELECT 
        IFNULL(AVG(payments.amount), 0.00)
    INTO avgPayment
    FROM payments
    WHERE payments.customerNumber = customerID;
    RETURN avgPayment;
END$$
DELIMITER ;


-- (iii) A View called VIEW_LAB5
CREATE VIEW `VIEW_LAB5` AS
SELECT 
    customers.customerNumber AS `Customer ID`,
    customers.customerName AS `Customer Name`,
    COUNT(orders.orderNumber) AS `Total Orders`,
    FORMAT(SUM(payments.amount), 2) AS `Total Payments`,
    CONCAT(employees.firstName, ' ', employees.lastName) AS `Sales Representative`,
    offices.city AS `Office City`
FROM 
    customers
LEFT JOIN orders ON customers.customerNumber = orders.customerNumber
LEFT JOIN payments ON customers.customerNumber = payments.customerNumber
LEFT JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
LEFT JOIN offices ON employees.officeCode = offices.officeCode
GROUP BY 
    customers.customerNumber
ORDER BY 
    `Total Payments` DESC;

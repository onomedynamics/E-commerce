CREATE DATABASE seyi;

USE seyi;

CREATE TABLE customers
(customer_id INT PRIMARY KEY
,name VARCHAR(30),
email VARCHAR(30),
balance DECIMAL(10,2));

INSERT INTO customers(customer_id,name,email,balance)
 VALUES (1,'alice johnson','alicejohnson@gmail.com','5000'),
		(2,'bob smith','bobsmith@gmail.com','1000'),
		(3,'charlie brown','charliebrown@gmail.com','200');
        

CREATE TABLE products(product_id INT PRIMARY KEY, name VARCHAR(30),price DECIMAL(10,2), stock_quantity INT);
INSERT INTO products (product_id,name,price,stock_quantity)
				VALUES (1,'laptop','1500',10),
						(2,'phone','800','20'),
                        (3,'headphones','200','50');
                        
CREATE TABLE orders(order_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
customer_id INT,
product_id int, quantity INT,
order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (product_id) REFERENCES products(product_id));
DROP TABLE orders;

CREATE TABLE transactions(transaction_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
customer_id INT,
amount VARCHAR(50),
transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));
DROP TABLE transactions;

INSERT INTO orders (order_id,customer_id,product_id,quantity,order_date)
		VALUES(101,1,1,2,'2025-03-26'),
				(102,2,2,1,'2025-03-26'),
                (103,1,3,3,'2025-03-26');

INSERT INTO transactions(transaction_id,order_id,customer_id,amount,transaction_date)
		VALUES (201,101,1,'3000','2025-03-24'),
				(202,102,2,'800','2025-03-25'),
                (203,103,1,'600','2025-03-26');

--           MY TASKS
-- Now, try to implement triggers for real-world scenarios such as: 
-- Preventing negative stock when an order is placed.
-- Automatically reducing stock after an order.
-- Deducting customer balance after a transaction.
-- Blocking orders if a customer has insufficient balance.
-- Logging deleted orders for future reference.alter

--   1. Preventing negative stock when an order is placed.

DELIMITER $$
CREATE TRIGGER before_order_insert
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
	DECLARE availabLe_stock INT;
-- get current stock on the product
	SELECT stock_quantity INTO available_stock FROM products WHERE product_id=NEW.product_id;

-- check if other quantity exceeds stock 
	if NEW.quantity > available_stock THEN 
	SIGNAL SQLSTATE '45000'
	SET  MESSAGE_TEXT='insufficient for this order!';
END IF;
END $$
DELIMITER ;

INSERT INTO orders (customer_id, product_id, quantity) VALUES (2, 1, 15);

SELECT stock_quantity FROM products WHERE product_id=1

-- problem 2 : automatically reducing stock when an order is placed
DELIMITER $$
CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
-- reduce stock based on order quantity
	UPDATE products 
	SET stock_quantity= stock_quantity-NEW.quantity
	WHERE product_id=NEW.product_id;
END $$
DELIMITER ;

INSERT INTO orders (customer_id, product_id, quantity) VALUES (1, 2, 3);

SELECT* FROM orders;

-- Deducting customer balance after a transaction
DELIMITER $$
CREATE TRIGGER after_insert_transactions
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
	UPDATE customers
	SET balance=balance-NEW.amount
    WHERE customer_id=NEW.customer_id;
END $$
DELIMITER ;

INSERT INTO transactions (order_id, customer_id, amount) VALUES (101, 1, 3000);

SELECT customer_id, name, balance FROM customers WHERE name = 'Alice johnson';


-- blocking orders if a customer has insufficient balance
DELIMITER $$
CREATE TRIGGER before_transactions_insert
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
	DECLARE customer_balance DECIMAL(10,2);
    -- get a customer current balance
    SELECT balance INTO customer_balance FROM customers WHERE customer_id=NEW.customer_id;
    -- check if balance is sufficient
    IF customer_balance < NEW.amount THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='insufficient balance for this transactions!';
END IF;
END $$
DELIMITER ;

INSERT INTO transactions (order_id, customer_id, amount) VALUES (102, 3, 500);
-- charlie with customer_id has 200 in his balance so he cant initiate a 500 amount transactions.alter

-- logging deleted order for future reference





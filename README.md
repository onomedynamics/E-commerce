# E-commerce
You are managing the database of an e-commerce company that sells various products. Your tasks involve handling orders, managing customer accounts, tracking transactions, and ensuring that business rules are followed.
## Tasks
 Task 1: Prevent Negative Stock
💡 Problem:
When a customer places an order, ensure that stock is available before allowing the purchase. If stock is insufficient, prevent the order from being placed.

✅ Create a BEFORE INSERT trigger on the orders table that checks stock before inserting a new order.

📝 Task 2: Auto-Reduce Stock After Purchase
💡 Problem:
When an order is placed, the stock of the purchased product should automatically decrease.

✅ Create an AFTER INSERT trigger on the orders table that updates the products table to subtract the ordered quantity.

📝 Task 3: Auto-Deduct Customer Balance After Purchase
💡 Problem:
When a customer places an order, their account balance should be deducted by the total cost of the order.

✅ Create an AFTER INSERT trigger on the transactions table that updates the customers table and deducts the transaction amount.

📝 Task 4: Prevent Orders If Customer Has Insufficient Balance
💡 Problem:
A customer should not be able to place an order if they do not have enough money in their account.

✅ Create a BEFORE INSERT trigger on the orders table that checks if the customer's balance is sufficient before processing the order.

📝 Task 5: Log Canceled Orders
💡 Problem:
If an order is deleted, store its details in an order_logs table for reference.

✅ Create an AFTER DELETE trigger on the orders table that saves deleted order details into order_logs.


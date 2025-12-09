-- SHORTCUTS--
SELECT * FROM Books;          -- 500 Distinct Book --
SELECT * FROM Customer;       -- 496 Distinct Customers --
SELECT * FROM Orders;         -- 317 Distinct Books Ordered --

-- Creating Database -- 
CREATE DATABASE online_bookstore;

-- Creating Table Books --

CREATE TABLE Books (
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR (100),
	Author VARCHAR (100),
	Genre VARCHAR (50),
	Published_Year INT,
	Price NUMERIC (10,2),
	Stock INT
);

SELECT * FROM Books;

-- Creating Table Customer --


CREATE TABLE Customer(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR (100),
	Email VARCHAR (100),
	Phone VARCHAR (15),
	City VARCHAR (50),
	Country VARCHAR (150)
);

SELECT * FROM Customer;

-- Creating Table Orders --

CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customer(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC (10,2)
);

SELECT * FROM Orders;

-- I IMPORTED THE DATA / .CSV FILES BY RIGHT CLICKING ON THE TABLE NAME i.e. 'books' , 'customer' , 'orders'.
-- MANUALLY WITHOUT WRITING ANY QUERY.

-- Here I performed all possible queries all by MYSELF that can prove my SQL knowledge.

-- BASIC QUERY QUESTIONS --

-- 1. Retrieve all the books in the "Fiction" genre.
SELECT * FROM Books WHERE genre='Fiction';

-- 2. Find all the books published after the year 1950.
SELECT * FROM Books WHERE published_year>'1950'

-- 3. List all the customers from Canada.
SELECT * FROM Customer WHERE country='Canada';

-- 4. Show orders placed in November 2023.
SELECT * FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Retrieve the total stock of books available.
SELECT SUM(Stock) FROM Books AS Total_Stock;

-- 6. Find the details of the most expensive Book.
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

-- 7. Show all customers who ordered more than 1 qty of a book.
SELECT * FROM Orders WHERE Quantity>1;

-- 8. Show all Orders which exceeds the total amount $20.
SELECT * FROM orders WHERE total_amount>20.00 LIMIT 10;

-- 9. List all genres available in the Books table.
SELECT DISTINCT genre FROM Books;

-- 10. Find the book with the lowest stock.
SELECT * FROM Books ORDER BY Stock LIMIT 10;

-- 11. Calculate the total revenue generated from all orders.
SELECT SUM(Total_amount) AS Revenue FROM Orders ;


-- ADVANCE QUERY QUESTION --

-- 1. Retrieve the total books sold for each genre.
SELECT * FROM orders;
SELECT b.Genre , SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b 
ON o.Book_ID = b.Book_ID;
GROUP BY b.Genre;

-- 2. Find the AVG price of books in "Fantasy" Genre.
SELECT AVG(price) AS AVERAGE_PRICE FROM Books 
WHERE genre='Fantasy';

-- 3. List customers_id who have placed atleast 2 orders (without JOINS).
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id 
HAVING COUNT(order_id)>=2;

-- 4. List customers_name who have placed atleast 2 orders (with JOINS).
SELECT customer_id,

-- 5. Find the most frequently ordered book.
SELECT book_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY book_id
ORDER BY order_count DESC LIMIT 1;

-- 6. Show the top 3 most expensive book in a 'Fantasy' genre.
SELECT book_id, title, genre, price FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 7. Retrieve the total quantity of books sold by each Author.
SELECT b.author, SUM(o.quantity) AS total_book_sold
FROM orders o
JOIN books b 
ON o.book_id = b.book_id
GROUP BY b.author;

-- 8. List the cities who spent over $300 on orders.
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customer c
ON o.customer_id=c.customer_id
WHERE o.total_amount>300;

-- 9. Find the customer who spent the most on orders.
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM customer c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC LIMIT 1;

-- 10. Calculate the stock remaining after fulfilling all orders.
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(quantity), 0) AS ordered_quantity, 
b.stock-COALESCE(SUM(quantity), 0) AS remaining_quantity
FROM books b
LEFT JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.book_id; 
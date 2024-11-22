-- Create Database
CREATE DATABASE clothify;
USE clothify;

-- Customer Table with UserRole (Customer/Admin)
CREATE TABLE Customer
(
    Customer_ID INT PRIMARY KEY,
    First_name VARCHAR(50) NOT NULL,
    Last_name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    PhoneNumber VARCHAR(11) NOT NULL,
    DateOfBirth DATE NOT NULL,
    UserRole VARCHAR(10) NOT NULL DEFAULT 'Customer',
    CONSTRAINT chk_UserRole CHECK (UserRole IN ('Admin', 'Customer'))
);

-- Payment_methods Table
CREATE TABLE Payment_methods
(
    Payment_type_ID INT PRIMARY KEY,
    payment_method_name VARCHAR(50) NOT NULL
);

-- Payment Table
CREATE TABLE Payment
(
    PaymentID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    PaymentType INT NOT NULL, 
    CardholderName VARCHAR(100),
    CardNumber VARCHAR(16),
    ExpiryDate DATE,
    CVV VARCHAR(4), -- card verification value (unique no. at the back of credit card)
    FOREIGN KEY (CustomerID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (PaymentType) REFERENCES Payment_methods(Payment_type_ID)
);

-- Category Table
CREATE TABLE Category 
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

-- Product Table with AverageRating
CREATE TABLE Product 
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description VARCHAR(500),
    ImageURL VARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(12, 2) NOT NULL,
    StockCount INT NOT NULL,
    AverageRating DECIMAL(3, 2) DEFAULT 0, -- Added to store product average rating
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Orders Table
CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    ShippingAddress VARCHAR(200) NOT NULL,
    TotalPrice DECIMAL(12, 2) NOT NULL,
    payment_id INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (payment_id) REFERENCES Payment(PaymentID)
);

-- OrderItem Table
CREATE TABLE OrderItem 
(
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Ratings Table
CREATE TABLE Ratings
(
    Rating_ID INT PRIMARY KEY,
    Remarks VARCHAR(40)
);

-- Review Table
CREATE TABLE Review 
(
    ReviewID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Rating INT NOT NULL,
    Comment VARCHAR(500),
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (Rating) REFERENCES Ratings(Rating_ID)
);

-- Discounts Table for sales functionality
CREATE TABLE Discounts 
(
    DiscountID INT PRIMARY KEY,
    ProductID INT,
    CategoryID INT,
    DiscountPercentage DECIMAL(5, 2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Trigger to update stock after an order is placed
CREATE TRIGGER update_stock_after_order
ON OrderItem
AFTER INSERT
AS
BEGIN
    UPDATE Product 
    SET StockCount = StockCount - i.Quantity 
    FROM Product p
    INNER JOIN inserted i ON p.ProductID = i.ProductID;
END;

-- Inserting into the Customers table
INSERT INTO Customer (Customer_ID, First_name, Last_name, Email, Address, PhoneNumber, DateOfBirth)
VALUES 
(1, 'Ahmad', 'Iyaz', 'AMD@gmail.com', 'Hunza Block near jamia Masjid, Lahore', '03001234567', '2003-02-17'),
(2, 'Suleiman', 'Asif', 'SuleimanA228@gamil.com', 'Baharia Town Sector B, Lahore', '03212312744', '2001-03-23'),
(3, 'Daem', 'Azeem', 'DaemBuilder11@outlook.com', 'Khayaban e Amin, Block G, Defense Road, Lahore', '03334556780', '2002-04-22'),
(4, 'Saleh', 'Ahmad', 'SalehXYZ@outlook.com', 'Ravi Block Allama Iqbal Town, Lahore', '03219787756', '2003-09-03'),
(5, 'Sohaib', 'Fiaz', 'SohaibF222@gmail.com', 'Tariq Block Allama Iqbal Town, Lahore', '03337779125', '2003-09-09'),
(6, 'Sift', 'Ullah', 'SiftullahPro939@outlook.com', 'Baharia Town Sector D, Lahore', '03210099954', '2003-02-06'),
(7, 'Emaan', 'Butt', 'EmaanButt332@gmail.com', 'Askari11, Lahore', '03316667912', '1999-09-03');


-- Inserting into Payment_methods table
INSERT INTO Payment_methods VALUES (1, 'Debit Card');
INSERT INTO Payment_methods VALUES (2, 'Credit card');
INSERT INTO Payment_methods VALUES (3, 'Cash on Delivery');

-- Inserting into Payment table
INSERT INTO Payment VALUES (1, 1, 2, 'Ahmad Iyaz Butt', '1111666789999111', '02-07-2028', '4641');
INSERT INTO Payment VALUES (2, 6, 1, 'Siftullah', '1233904487771239', '03-07-2026', '5454');
INSERT INTO Payment VALUES (3, 2, 2, 'Rana Suleiman Asif', '1344974728283930', '08-09-2028', '5520');
INSERT INTO Payment VALUES (4, 1, 1, 'Ahmad Iyaz Butt', '1111666789999111', '10-04-2029', '8541');
INSERT INTO Payment VALUES (5, 4, 2, 'Saleh Ahmad', '1775900937228888', '10-10-2030', '7432');
INSERT INTO Payment VALUES (6, 7, 1, 'Emaan Butt', '1998181830098881', '10-09-2028', '5066');
INSERT INTO Payment VALUES (7, 5, 2, 'Sohaib Fiaz', '1449225598760169', '01-09-2028', '7964');
INSERT INTO Payment VALUES (8, 3, 1, 'Deam Azeem', '1232999923456006', '10-26-2026', '3258');
INSERT INTO Payment VALUES (9, 7, 1, 'Emaan Butt', '1771282765631919', '10-09-2028', '5066');
INSERT INTO Payment VALUES (10, 1, 3, NULL, NULL, NULL, NULL);

-- Inserting into Category table
INSERT INTO Category VALUES (1, 'Men wear');
INSERT INTO Category VALUES (2, 'Women wear');
INSERT INTO Category VALUES (3, 'Kids wear');
INSERT INTO Category VALUES (4, 'Men Perfume');
INSERT INTO Category VALUES (5, 'Women Perfume');
INSERT INTO Category VALUES (6, 'Kids Perfume');

-- Inserting into Product table
INSERT INTO Product (ProductID, ProductName, Description, ImageURL, CategoryID, Price, StockCount)
VALUES 
(1, 'Romantic Blast', 'Perfume just for women made by our experts', 'www.ourwebsite.com', 5, 750, 234),
(2, 'Run n Dash', 'Mens Perfume with the best aroma to make the environment cool', 'www.ourwebsite.com', 4, 1000, 200),
(3, 'Unicorn madness', 'Kids perfume with beautiful fragrance', 'www.ourwebsite.com', 6, 650, 344),
(4, 'Retro Style Blue pants for Men', 'Mens pants made by the best material and in a 90s style', 'www.ourwebsite.com', 1, 870, 57),
(5, 'Red bow tie beach hat for women', 'Womens hat for beach wear made just for the beach vibes', 'www.ourwebsite.com', 2, 320, 87),
(6, 'Goku rocks', 'Only the perfume for those men who are Goku fans', 'www.ourwebsite.com', 4, 1450, 400);

-- ... [Continue with other Product entries] ...

-- Inserting into Ratings table
INSERT INTO Ratings VALUES (1, 'Worst');
INSERT INTO Ratings VALUES (2, 'Bad');
INSERT INTO Ratings VALUES (3, 'OK');
INSERT INTO Ratings VALUES (4, 'Good');
INSERT INTO Ratings VALUES (5, 'Best');


-- Inserting into Review table
INSERT INTO Review VALUES 
(1, 1, 6, 5, 'One of the best perfumes I have ever used makes me feel strong and energetic Like Goku', '04-06-2023'),
(2, 7, 1, 5, 'This perfume has such a beautiful and an everlasting and lovely scent. I loved it that at such a reasonable price I would such a lovely and wonderful perfume, Perfect!!', '04-06-2023'),
(3, 3, 19, 5, 'This suit is amazing. Feels so awesome and has exquisite quality', '04-06-2023');

-- Select all records from tables
SELECT * FROM Customer;
SELECT * FROM Payment_methods;
SELECT * FROM Payment;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM OrderItem;
SELECT * FROM Ratings;
SELECT * FROM Review;

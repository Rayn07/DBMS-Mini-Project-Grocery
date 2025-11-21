---------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------Create Tables--------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS Grocery_Inventory;
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    brand VARCHAR(100),
    CHECK (price > 0)
);
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE Customer_Phone (
    customer_id INT,
    phone_number VARCHAR(15),
    PRIMARY KEY (customer_id, phone_number),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(100),
    salary DECIMAL(10, 2),
    dob DATE,
    store_id INT,
    CHECK (salary >= 0)
);
CREATE TABLE Store (
    store_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    zipcode VARCHAR(16),
    manager_id INT UNIQUE,
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id) ON DELETE
    SET NULL
);
ALTER TABLE Employee
ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES Store(store_id) ON DELETE
SET NULL;
CREATE TABLE Purchase(
    purchase_id INT PRIMARY KEY,
    purchase_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    CHECK (total_amount >= 0)
);
CREATE TABLE Shipment (
    shipment_id INT,
    supplier_id INT,
    shipment_date DATE,
    arrival_date DATE,
    PRIMARY KEY (shipment_id, supplier_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON DELETE CASCADE
);
CREATE TABLE Stock (
    store_id INT,
    product_id INT,
    quantity_in_stock INT NOT NULL,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES Store(store_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE,
    CHECK (quantity_in_stock >= 0)
);
CREATE TABLE Product_Supply (
    supplier_id INT,
    product_id INT,
    wholesale_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (supplier_id, product_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE,
    CHECK (wholesale_price > 0)
);
CREATE TABLE Purchase_Items (
    purchase_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (purchase_id, product_id),
    FOREIGN KEY (purchase_id) REFERENCES Purchase(purchase_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE RESTRICT,
    CHECK (quantity > 0)
);
--------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------CRUD Operations-----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: Grocery_Inventory
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.22.04.1
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;
/*!50503 SET NAMES utf8mb4 */
;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */
;
/*!40103 SET TIME_ZONE='+00:00' */
;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */
;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
;
--
-- Table structure for table `Customer`
--
DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Customer` (
    `customer_id` int NOT NULL,
    `name` varchar(100) NOT NULL,
    PRIMARY KEY (`customer_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Customer`
--
LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */
;
INSERT INTO `Customer`
VALUES (1, 'Rohan Sharma'),
    (2, 'Priya Patel'),
    (3, 'Arjun Singh'),
    (4, 'Ananya Gupta'),
    (5, 'Vikram Reddy'),
    (6, 'Sneha Iyer'),
    (7, 'Aditya Kumar'),
    (8, 'Ishita Das'),
    (9, 'Sameer Khan'),
    (10, 'Neha Joshi'),
    (11, 'Karan Malhotra'),
    (12, 'Sonia Agarwal'),
    (13, 'Rahul Desai'),
    (14, 'Meera Krishnan'),
    (15, 'Ankit Jain');
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Customer_Phone`
--
DROP TABLE IF EXISTS `Customer_Phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Customer_Phone` (
    `customer_id` int NOT NULL,
    `phone_number` varchar(15) NOT NULL,
    PRIMARY KEY (`customer_id`, `phone_number`),
    CONSTRAINT `Customer_Phone_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Customer_Phone`
--
LOCK TABLES `Customer_Phone` WRITE;
/*!40000 ALTER TABLE `Customer_Phone` DISABLE KEYS */
;
INSERT INTO `Customer_Phone`
VALUES (1, '9876543210'),
    (2, '9876543211'),
    (3, '9876543212'),
    (4, '9876543213'),
    (5, '9876543214'),
    (6, '9876543215'),
    (7, '9876543216'),
    (8, '9876543217'),
    (9, '9876543218'),
    (10, '9876543219'),
    (11, '9876543220'),
    (12, '9876543221'),
    (13, '9876543222'),
    (14, '9876543223'),
    (15, '9876543224');
/*!40000 ALTER TABLE `Customer_Phone` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Employee`
--
DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Employee` (
    `employee_id` int NOT NULL,
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    `role` varchar(100) DEFAULT NULL,
    `salary` decimal(10, 2) DEFAULT NULL,
    `dob` date DEFAULT NULL,
    `store_id` int DEFAULT NULL,
    PRIMARY KEY (`employee_id`),
    KEY `fk_store` (`store_id`),
    CONSTRAINT `fk_store` FOREIGN KEY (`store_id`) REFERENCES `Store` (`store_id`) ON DELETE
    SET NULL,
        CONSTRAINT `Employee_chk_1` CHECK ((`salary` >= 0))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Employee`
--
LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */
;
INSERT INTO `Employee`
VALUES (
        1,
        'Suresh Kumar',
        'Verma',
        'Manager',
        75000.00,
        '1985-04-12',
        1
    ),
    (
        2,
        'Deepika',
        'Rao',
        'Manager',
        78000.00,
        '1988-11-20',
        4
    ),
    (
        3,
        'Manish',
        'Chopra',
        'Manager',
        72000.00,
        '1990-01-30',
        8
    ),
    (
        4,
        'Pooja',
        'Mehta',
        'Cashier',
        35000.00,
        '1995-07-15',
        1
    ),
    (
        5,
        'Rajesh',
        'Nair',
        'Stocker',
        32000.00,
        '1998-09-05',
        1
    ),
    (
        6,
        'Sunita',
        'Krishnan',
        'Cashier',
        36000.00,
        '1994-03-25',
        4
    ),
    (
        7,
        'Amit',
        'Banerjee',
        'Stocker',
        33000.00,
        '1997-06-18',
        4
    ),
    (
        8,
        'Kavita',
        'Singh',
        'Cashier',
        38000.00,
        '1993-12-01',
        8
    ),
    (
        9,
        'Harpreet',
        'Singh',
        'Stocker',
        34000.00,
        '1996-02-22',
        8
    ),
    (
        10,
        'Bibhash',
        'Roy',
        'Cleaner',
        25000.00,
        '2000-05-10',
        1
    ),
    (
        11,
        'Rina',
        'Deshpande',
        'Cashier',
        35000.00,
        '1995-01-11',
        2
    ),
    (
        12,
        'Sameer',
        'Jha',
        'Stocker',
        32000.00,
        '1998-02-12',
        2
    ),
    (
        13,
        'Tanya',
        'Sharma',
        'Cashier',
        36000.00,
        '1994-04-14',
        5
    ),
    (
        14,
        'Vinod',
        'Patil',
        'Stocker',
        33000.00,
        '1997-08-19',
        5
    ),
    (
        15,
        'Aisha',
        'Begum',
        'Cashier',
        38000.00,
        '1993-11-03',
        9
    );
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Product`
--
DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Product` (
    `product_id` int NOT NULL,
    `name` varchar(100) NOT NULL,
    `price` decimal(10, 2) NOT NULL,
    `brand` varchar(100) DEFAULT NULL,
    PRIMARY KEY (`product_id`),
    CONSTRAINT `Product_chk_1` CHECK ((`price` > 0))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Product`
--
LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */
;
INSERT INTO `Product`
VALUES (1, 'Toned Milk 1L', 55.00, 'Amul'),
    (2, 'Marie Gold Biscuits', 30.00, 'Britannia'),
    (3, 'Aashirvaad Atta 5kg', 250.00, 'ITC'),
    (4, 'Parle-G Biscuits', 10.00, 'Parle'),
    (5, 'Aloo Bhujia 200g', 50.00, 'Haldiram\'s'),
    (6, 'Maggi Noodles', 14.00, 'Nestlé'),
    (7, 'Lay\'s Classic Chips', 20.00, 'PepsiCo'),
    (8, 'Coke Zero 500ml', 40.00, 'Coca-Cola'),
    (9, 'Dairy Milk Chocolate', 45.00, 'Cadbury'),
    (10, 'Dove Soap', 60.00, 'Hindustan Unilever'),
    (11, 'Dant Kanti Toothpaste', 90.00, 'Patanjali'),
    (12, 'Real Fruit Juice 1L', 110.00, 'Dabur'),
    (13, 'Parachute Coconut Oil', 150.00, 'Marico'),
    (14, 'Instant Khaman Dhokla Mix', 85.00, 'Gits'),
    (15, 'Deggi Mirch Masala', 70.00, 'MDH');
/*!40000 ALTER TABLE `Product` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Product_Supply`
--
DROP TABLE IF EXISTS `Product_Supply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Product_Supply` (
    `supplier_id` int NOT NULL,
    `product_id` int NOT NULL,
    `wholesale_price` decimal(10, 2) NOT NULL,
    PRIMARY KEY (`supplier_id`, `product_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `Product_Supply_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `Supplier` (`supplier_id`) ON DELETE CASCADE,
    CONSTRAINT `Product_Supply_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `Product_Supply_chk_1` CHECK ((`wholesale_price` > 0))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Product_Supply`
--
LOCK TABLES `Product_Supply` WRITE;
/*!40000 ALTER TABLE `Product_Supply` DISABLE KEYS */
;
INSERT INTO `Product_Supply`
VALUES (1, 1, 50.00),
    (1, 9, 39.00),
    (2, 2, 25.00),
    (2, 4, 8.50),
    (3, 3, 220.00),
    (4, 4, 8.00),
    (5, 5, 42.00),
    (6, 6, 11.00),
    (7, 7, 15.00),
    (8, 8, 32.00),
    (9, 9, 38.00),
    (10, 10, 52.00),
    (11, 11, 75.00),
    (12, 12, 95.00),
    (13, 13, 130.00);
/*!40000 ALTER TABLE `Product_Supply` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Purchase`
--
DROP TABLE IF EXISTS `Purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Purchase` (
    `purchase_id` int NOT NULL,
    `purchase_date` date NOT NULL,
    `total_amount` decimal(10, 2) NOT NULL,
    `customer_id` int NOT NULL,
    PRIMARY KEY (`purchase_id`),
    KEY `customer_id` (`customer_id`),
    CONSTRAINT `Purchase_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`) ON DELETE CASCADE,
    CONSTRAINT `Purchase_chk_1` CHECK ((`total_amount` >= 0))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Purchase`
--
LOCK TABLES `Purchase` WRITE;
/*!40000 ALTER TABLE `Purchase` DISABLE KEYS */
;
INSERT INTO `Purchase`
VALUES (1, '2025-09-01', 140.00, 1),
    (2, '2025-09-02', 30.00, 2),
    (3, '2025-09-03', 250.00, 3),
    (4, '2025-09-04', 50.00, 4),
    (5, '2025-09-05', 100.00, 5),
    (6, '2025-09-06', 42.00, 6),
    (7, '2025-09-07', 40.00, 7),
    (8, '2025-09-08', 80.00, 8),
    (9, '2025-09-09', 90.00, 9),
    (10, '2025-09-10', 120.00, 10),
    (11, '2025-09-11', 110.00, 1),
    (12, '2025-09-12', 45.00, 2),
    (13, '2025-09-13', 180.00, 11),
    (14, '2025-09-14', 220.00, 12),
    (15, '2025-09-15', 300.00, 1);
/*!40000 ALTER TABLE `Purchase` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Purchase_Items`
--
DROP TABLE IF EXISTS `Purchase_Items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Purchase_Items` (
    `purchase_id` int NOT NULL,
    `product_id` int NOT NULL,
    `quantity` int NOT NULL,
    PRIMARY KEY (`purchase_id`, `product_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `Purchase_Items_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `Purchase` (`purchase_id`) ON DELETE CASCADE,
    CONSTRAINT `Purchase_Items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`) ON DELETE RESTRICT,
    CONSTRAINT `Purchase_Items_chk_1` CHECK ((`quantity` > 0))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Purchase_Items`
--
LOCK TABLES `Purchase_Items` WRITE;
/*!40000 ALTER TABLE `Purchase_Items` DISABLE KEYS */
;
INSERT INTO `Purchase_Items`
VALUES (1, 1, 1),
    (1, 7, 2),
    (1, 14, 1),
    (2, 4, 3),
    (2, 15, 1),
    (3, 3, 1),
    (4, 5, 1),
    (5, 5, 2),
    (6, 6, 3),
    (7, 8, 1),
    (8, 7, 4),
    (9, 9, 2),
    (10, 10, 2),
    (11, 1, 1),
    (11, 2, 2),
    (12, 9, 1),
    (13, 11, 2),
    (14, 12, 2),
    (15, 13, 2);
/*!40000 ALTER TABLE `Purchase_Items` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Shipment`
--
DROP TABLE IF EXISTS `Shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Shipment` (
    `shipment_id` int NOT NULL,
    `supplier_id` int NOT NULL,
    `shipment_date` date DEFAULT NULL,
    `arrival_date` date DEFAULT NULL,
    PRIMARY KEY (`shipment_id`, `supplier_id`),
    KEY `supplier_id` (`supplier_id`),
    CONSTRAINT `Shipment_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `Supplier` (`supplier_id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Shipment`
--
LOCK TABLES `Shipment` WRITE;
/*!40000 ALTER TABLE `Shipment` DISABLE KEYS */
;
INSERT INTO `Shipment`
VALUES (101, 1, '2025-08-20', '2025-08-22'),
    (102, 2, '2025-08-21', '2025-08-23'),
    (103, 3, '2025-08-22', '2025-08-24'),
    (104, 4, '2025-08-23', '2025-08-25'),
    (105, 5, '2025-08-24', '2025-08-26'),
    (106, 6, '2025-08-25', '2025-08-27'),
    (107, 7, '2025-08-26', '2025-08-28'),
    (108, 8, '2025-08-27', '2025-08-29'),
    (109, 9, '2025-08-28', '2025-08-30'),
    (110, 10, '2025-08-29', '2025-08-31'),
    (111, 1, '2025-09-01', '2025-09-03'),
    (112, 2, '2025-09-02', '2025-09-04'),
    (113, 1, '2025-09-03', '2025-09-05'),
    (114, 11, '2025-09-04', '2025-09-06'),
    (115, 12, '2025-09-05', '2025-09-07');
/*!40000 ALTER TABLE `Shipment` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Stock`
--
DROP TABLE IF EXISTS `Stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Stock` (
    `store_id` int NOT NULL,
    `product_id` int NOT NULL,
    `quantity_in_stock` int NOT NULL,
    PRIMARY KEY (`store_id`, `product_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `Stock_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `Store` (`store_id`) ON DELETE CASCADE,
    CONSTRAINT `Stock_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `Stock_chk_1` CHECK ((`quantity_in_stock` >= 0))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Stock`
--
LOCK TABLES `Stock` WRITE;
/*!40000 ALTER TABLE `Stock` DISABLE KEYS */
;
INSERT INTO `Stock`
VALUES (1, 1, 150),
    (1, 2, 200),
    (1, 3, 50),
    (2, 4, 500),
    (2, 5, 120),
    (3, 6, 300),
    (3, 7, 250),
    (4, 1, 100),
    (4, 8, 180),
    (4, 9, 220),
    (5, 10, 160),
    (5, 11, 90),
    (6, 12, 80),
    (7, 13, 70),
    (8, 14, 100),
    (8, 15, 110),
    (9, 1, 120),
    (10, 2, 150),
    (11, 3, 60),
    (12, 4, 400),
    (13, 5, 130),
    (14, 6, 250),
    (15, 7, 200);
/*!40000 ALTER TABLE `Stock` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Store`
--
DROP TABLE IF EXISTS `Store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Store` (
    `store_id` int NOT NULL,
    `name` varchar(100) NOT NULL,
    `city` varchar(100) DEFAULT NULL,
    `zipcode` varchar(16) DEFAULT NULL,
    `manager_id` int DEFAULT NULL,
    PRIMARY KEY (`store_id`),
    UNIQUE KEY `manager_id` (`manager_id`),
    CONSTRAINT `Store_ibfk_1` FOREIGN KEY (`manager_id`) REFERENCES `Employee` (`employee_id`) ON DELETE
    SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Store`
--
LOCK TABLES `Store` WRITE;
/*!40000 ALTER TABLE `Store` DISABLE KEYS */
;
INSERT INTO `Store`
VALUES (
        1,
        'FreshMart Koramangala',
        'Bengaluru',
        '560034',
        1
    ),
    (
        2,
        'DailyNeeds Jayanagar',
        'Bengaluru',
        '560041',
        NULL
    ),
    (
        3,
        'QuickStop Indiranagar',
        'Bengaluru',
        '560038',
        NULL
    ),
    (4, 'ValueMart Powai', 'Mumbai', '400076', 2),
    (
        5,
        'CityGrocers Bandra',
        'Mumbai',
        '400050',
        NULL
    ),
    (
        6,
        'SouthMart T. Nagar',
        'Chennai',
        '600017',
        NULL
    ),
    (
        7,
        'GreenBasket Adyar',
        'Chennai',
        '600020',
        NULL
    ),
    (
        8,
        'Capital Grocers CP',
        'New Delhi',
        '110001',
        3
    ),
    (
        9,
        'NCR Provisions Gurgaon',
        'Gurgaon',
        '122002',
        NULL
    ),
    (
        10,
        'PrimeMart Salt Lake',
        'Kolkata',
        '700091',
        NULL
    ),
    (
        11,
        'MegaSaver Whitefield',
        'Bengaluru',
        '560066',
        NULL
    ),
    (
        12,
        'LocalFoods Andheri',
        'Mumbai',
        '400053',
        NULL
    ),
    (
        13,
        'AnnaNagar Staples',
        'Chennai',
        '600040',
        NULL
    ),
    (
        14,
        'DelhiBelly Grocers',
        'New Delhi',
        '110017',
        NULL
    ),
    (
        15,
        'Howrah Market Hub',
        'Kolkata',
        '711101',
        NULL
    );
/*!40000 ALTER TABLE `Store` ENABLE KEYS */
;
UNLOCK TABLES;
--
-- Table structure for table `Supplier`
--
DROP TABLE IF EXISTS `Supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Supplier` (
    `supplier_id` int NOT NULL,
    `name` varchar(100) NOT NULL,
    `location` varchar(100) DEFAULT NULL,
    PRIMARY KEY (`supplier_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `Supplier`
--
LOCK TABLES `Supplier` WRITE;
/*!40000 ALTER TABLE `Supplier` DISABLE KEYS */
;
INSERT INTO `Supplier`
VALUES (1, 'Amul Dairy', 'Anand'),
    (2, 'Britannia Industries', 'Kolkata'),
    (3, 'ITC Limited', 'Kolkata'),
    (4, 'Parle Products', 'Mumbai'),
    (5, 'Haldiram\'s', 'Nagpur'),
    (6, 'Nestlé India', 'Gurgaon'),
    (7, 'PepsiCo India', 'New Delhi'),
    (8, 'Coca-Cola India', 'Pune'),
    (9, 'Cadbury India', 'Mumbai'),
    (10, 'Hindustan Unilever', 'Mumbai'),
    (11, 'Patanjali Ayurved', 'Haridwar'),
    (12, 'Dabur India', 'Ghaziabad'),
    (13, 'Marico Limited', 'Mumbai'),
    (14, 'Gits Food', 'Pune'),
    (15, 'MDH Spices', 'New Delhi');
/*!40000 ALTER TABLE `Supplier` ENABLE KEYS */
;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */
;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */
;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */
;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */
;
-- Dump completed on 2025-10-29 21:10:18
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------Trigger, Function, and Procedure Definitions--------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
--===============================================================================
--TRIGGER
--Check if employee is 18 years or older
DELIMITER $$ CREATE TRIGGER trg_check_employee_dob BEFORE
INSERT ON Employee FOR EACH ROW BEGIN IF NEW.dob > (CURDATE() - INTERVAL 18 YEAR) THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Employee must be at least 18 years old.';
END IF;
END $$ DELIMITER;
-- ===============================================================================
-- PROCEDURE
-- Finds items whose stock lies below a given threshold
DELIMITER $$ CREATE PROCEDURE sp_get_low_stock_items(IN in_store_id INT, IN in_threshold INT) BEGIN
SELECT p.name AS product_name,
    p.brand,
    s.quantity_in_stock
FROM Stock s
    JOIN Product p ON s.product_id = p.product_id
WHERE s.store_id = in_store_id
    AND s.quantity_in_stock < in_threshold
ORDER BY s.quantity_in_stock ASC;
END $$ DELIMITER;
-- Call Procedure
CALL sp_get_low_stock_items(1, 160);
-- ===============================================================================
-- FUNCTION
-- Returns a given customer's total spending
DELIMITER $$ CREATE FUNCTION fn_get_customer_total_spent(in_customer_id INT) RETURNS DECIMAL(10, 2) DETERMINISTIC READS SQL DATA BEGIN
DECLARE total_spent DECIMAL(10, 2);
SELECT SUM(total_amount) INTO total_spent
FROM Purchase
WHERE customer_id = in_customer_id;
IF total_spent IS NULL THEN
SET total_spent = 0.00;
END IF;
RETURN total_spent;
END $$ DELIMITER;
-- Call Function
SELECT fn_get_customer_total_spent(1) AS total_spent;
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------SQL Queries-----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
-- NESTED QUERY (SUBQUERY)
-- Find all products stocked in any store in Bengaluru
SELECT name,
    brand
FROM Product
WHERE product_id IN (
        SELECT product_id
        FROM Stock
        WHERE store_id IN (
                SELECT store_id
                FROM Store
                WHERE city = 'Bengaluru'
            )
    );
-- ===============================================================================
-- JOIN QUERY
-- Get detailed purchase information
SELECT c.name AS customer_name,
    p.purchase_date,
    pr.name AS product_name,
    pr.brand,
    pi.quantity,
    (pr.price * pi.quantity) AS item_total_price
FROM Customer c
    JOIN Purchase p ON c.customer_id = p.customer_id
    JOIN Purchase_Items pi ON p.purchase_id = pi.purchase_id
    JOIN Product pr ON pi.product_id = pr.product_id
ORDER BY p.purchase_date DESC,
    c.name;
-- ===============================================================================
-- AGGREGATE QUERY
-- Find total units sold per product
SELECT p.name,
    p.brand,
    SUM(pi.quantity) AS total_units_sold
FROM Purchase_Items pi
    JOIN Product p ON pi.product_id = p.product_id
GROUP BY p.product_id,
    p.name,
    p.brand
ORDER BY total_units_sold DESC;
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------Project Users---------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------
-- 1. Create Roles
-- ---------------------------------
CREATE ROLE IF NOT EXISTS 'manager',
'cashier',
'stocker';
-- ---------------------------------
-- 2. Grant Privileges to Roles
-- ---------------------------------
-- 'manager' role: Can select from all tables, and insert/update/delete on key operational tables.
GRANT SELECT ON Grocery_Inventory.* TO 'manager';
GRANT INSERT,
    UPDATE,
    DELETE ON Grocery_Inventory.Employee TO 'manager';
GRANT INSERT,
    UPDATE,
    DELETE ON Grocery_Inventory.Stock TO 'manager';
GRANT INSERT,
    UPDATE,
    DELETE ON Grocery_Inventory.Product TO 'manager';
GRANT EXECUTE ON FUNCTION Grocery_Inventory.fn_get_customer_total_spent TO 'manager';
GRANT EXECUTE ON PROCEDURE Grocery_Inventory.sp_get_low_stock_items TO 'manager';
-- 'cashier' role: Can manage purchases and customers, and view products/stock.
-- Cannot see sensitive Employee data.
GRANT SELECT ON Grocery_Inventory.Product TO 'cashier';
GRANT SELECT ON Grocery_Inventory.Stock TO 'cashier';
GRANT SELECT,
    INSERT ON Grocery_Inventory.Customer TO 'cashier';
GRANT SELECT,
    INSERT ON Grocery_Inventory.Customer_Phone TO 'cashier';
GRANT SELECT,
    INSERT ON Grocery_Inventory.Purchase TO 'cashier';
GRANT SELECT,
    INSERT ON Grocery_Inventory.Purchase_Items TO 'cashier';
GRANT EXECUTE ON FUNCTION Grocery_Inventory.fn_get_customer_total_spent TO 'cashier';
-- 'stocker' role: Can only view and update stock levels and see product/store info.
GRANT SELECT,
    UPDATE ON Grocery_Inventory.Stock TO 'stocker';
GRANT SELECT ON Grocery_Inventory.Product TO 'stocker';
GRANT SELECT ON Grocery_Inventory.Store TO 'stocker';
GRANT SELECT ON Grocery_Inventory.Shipment TO 'stocker';
GRANT EXECUTE ON PROCEDURE Grocery_Inventory.sp_get_low_stock_items TO 'stocker';
-- ---------------------------------
-- 3. Create Users
-- ---------------------------------
-- (Uses sample employee names from your data)
CREATE USER IF NOT EXISTS 'manager_suresh' @'localhost' IDENTIFIED BY 'StrongManagerPass!2025';
CREATE USER IF NOT EXISTS 'cashier_pooja' @'localhost' IDENTIFIED BY 'StrongCashierPass!789';
CREATE USER IF NOT EXISTS 'stocker_rajesh' @'localhost' IDENTIFIED BY 'StrongStockerPass!456';
-- Create admin user with a strong password
CREATE USER 'user_admin' @'localhost' IDENTIFIED BY 'StrongAdminPass!123';
GRANT CREATE USER ON *.* TO 'user_admin' @'localhost';
GRANT ROLE_ADMIN ON *.* TO 'user_admin' @'localhost';
GRANT 'manager',
    'cashier',
    'stocker' TO 'user_admin' @'localhost' WITH ADMIN OPTION;
-- ---------------------------------
-- 4. Assign Roles to Users
-- ---------------------------------
GRANT 'manager' TO 'manager_suresh' @'localhost';
GRANT 'cashier' TO 'cashier_pooja' @'localhost';
GRANT 'stocker' TO 'stocker_rajesh' @'localhost';
-- ---------------------------------
-- 5. Set Default Roles & Apply Changes
-- ---------------------------------
SET DEFAULT ROLE 'manager' TO 'manager_suresh' @'localhost';
SET DEFAULT ROLE 'cashier' TO 'cashier_pooja' @'localhost';
SET DEFAULT ROLE 'stocker' TO 'stocker_rajesh' @'localhost';
-- Apply all privilege changes
FLUSH PRIVILEGES;
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------Project End-----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
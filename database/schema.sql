-- =====================================================
-- Restaurant Order & Queue Optimization System
-- Database Schema
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

-- =====================================================
-- Tables Table
-- Stores restaurant table information
-- =====================================================
CREATE TABLE IF NOT EXISTS tables (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT NOT NULL UNIQUE,
    capacity INT NOT NULL,
    status ENUM('AVAILABLE', 'OCCUPIED', 'RESERVED') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- Staff Table
-- Stores staff/waiter information
-- =====================================================
CREATE TABLE IF NOT EXISTS staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    role ENUM('WAITER', 'CHEF', 'MANAGER') DEFAULT 'WAITER',
    status ENUM('AVAILABLE', 'BUSY', 'OFF_DUTY') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- Orders Table
-- Stores order information
-- =====================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    staff_id INT,
    order_number VARCHAR(20) NOT NULL UNIQUE,
    status ENUM('PENDING', 'PREPARING', 'READY', 'SERVED', 'CANCELLED') DEFAULT 'PENDING',
    priority INT DEFAULT 5 COMMENT '1=Highest, 10=Lowest',
    estimated_time INT NOT NULL COMMENT 'Estimated preparation time in minutes',
    actual_time INT COMMENT 'Actual preparation time in minutes',
    total_amount DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES tables(table_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- Order Items Table
-- Stores individual items in each order
-- =====================================================
CREATE TABLE IF NOT EXISTS order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_name VARCHAR(200) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- Sample Data
-- =====================================================

-- Insert sample tables
INSERT INTO tables (table_number, capacity, status) VALUES
(1, 4, 'AVAILABLE'),
(2, 2, 'OCCUPIED'),
(3, 6, 'AVAILABLE'),
(4, 4, 'OCCUPIED'),
(5, 8, 'AVAILABLE');

-- Insert sample staff
INSERT INTO staff (name, role, status) VALUES
('John Smith', 'WAITER', 'AVAILABLE'),
('Sarah Johnson', 'WAITER', 'AVAILABLE'),
('Mike Davis', 'CHEF', 'AVAILABLE'),
('Emily Brown', 'WAITER', 'BUSY'),
('David Wilson', 'MANAGER', 'AVAILABLE');

-- Insert sample orders (20 orders total)
INSERT INTO orders (table_id, staff_id, order_number, status, priority, estimated_time, total_amount) VALUES
(1, 1, 'ORD-001', 'PENDING', 3, 15, 45.50),
(2, 2, 'ORD-002', 'PENDING', 5, 20, 78.00),
(3, 1, 'ORD-003', 'PENDING', 2, 10, 32.25),
(4, 4, 'ORD-004', 'PENDING', 7, 25, 95.75),
(5, 2, 'ORD-005', 'PENDING', 4, 18, 62.00),
(1, 3, 'ORD-006', 'PENDING', 1, 8, 28.50),
(3, 1, 'ORD-007', 'PENDING', 6, 22, 88.25),
(2, 2, 'ORD-008', 'PENDING', 3, 12, 55.00),
(4, 4, 'ORD-009', 'PENDING', 8, 30, 120.75),
(5, 1, 'ORD-010', 'PENDING', 2, 9, 38.50),
(1, 2, 'ORD-011', 'PENDING', 4, 16, 72.00),
(3, 3, 'ORD-012', 'PENDING', 5, 19, 65.25),
(2, 1, 'ORD-013', 'PENDING', 1, 7, 42.00),
(4, 2, 'ORD-014', 'PENDING', 6, 21, 98.50),
(5, 4, 'ORD-015', 'PENDING', 3, 14, 58.75),
(1, 1, 'ORD-016', 'PENDING', 7, 26, 105.00),
(3, 2, 'ORD-017', 'PENDING', 2, 11, 48.25),
(2, 3, 'ORD-018', 'PENDING', 4, 17, 82.50),
(4, 1, 'ORD-019', 'PENDING', 5, 20, 75.00),
(5, 2, 'ORD-020', 'PENDING', 3, 13, 52.25);

-- Insert sample order items (for all 20 orders)
INSERT INTO order_items (order_id, item_name, quantity, price) VALUES
-- Order 1
(1, 'Caesar Salad', 2, 12.50),
(1, 'Grilled Chicken', 1, 20.50),
-- Order 2
(2, 'Pasta Carbonara', 2, 24.00),
(2, 'Garlic Bread', 1, 6.00),
(2, 'Tiramisu', 1, 8.00),
-- Order 3
(3, 'Soup of the Day', 1, 8.25),
(3, 'Burger', 1, 15.00),
(3, 'Fries', 1, 9.00),
-- Order 4
(4, 'Steak', 2, 35.00),
(4, 'Wine', 1, 25.75),
-- Order 5
(5, 'Pizza Margherita', 1, 18.00),
(5, 'Pizza Pepperoni', 1, 20.00),
(5, 'Soft Drinks', 2, 12.00),
-- Order 6
(6, 'Chicken Wings', 1, 14.50),
(6, 'Cola', 2, 7.00),
-- Order 7
(7, 'Fish & Chips', 2, 22.00),
(7, 'Beer', 2, 12.00),
(7, 'Apple Pie', 1, 8.25),
-- Order 8
(8, 'Salmon Fillet', 1, 28.00),
(8, 'Rice', 1, 5.00),
(8, 'Green Salad', 1, 7.00),
-- Order 9
(9, 'Ribeye Steak', 2, 42.00),
(9, 'Mashed Potatoes', 2, 8.00),
(9, 'Red Wine', 1, 30.75),
-- Order 10
(10, 'Chicken Sandwich', 1, 12.50),
(10, 'French Fries', 1, 6.00),
(10, 'Milkshake', 1, 8.00),
-- Order 11
(11, 'Spaghetti Bolognese', 2, 26.00),
(11, 'Garlic Bread', 1, 6.00),
(11, 'Caesar Salad', 1, 12.50),
-- Order 12
(12, 'BBQ Ribs', 1, 32.00),
(12, 'Corn on the Cob', 2, 8.00),
(12, 'Iced Tea', 2, 6.00),
-- Order 13
(13, 'Club Sandwich', 1, 15.00),
(13, 'Onion Rings', 1, 7.00),
(13, 'Lemonade', 2, 5.00),
-- Order 14
(14, 'Lobster Tail', 1, 45.00),
(14, 'Butter', 1, 3.00),
(14, 'White Wine', 1, 28.50),
-- Order 15
(15, 'Chicken Curry', 2, 24.00),
(15, 'Naan Bread', 2, 6.00),
(15, 'Mango Lassi', 2, 5.00),
-- Order 16
(16, 'Beef Tenderloin', 2, 48.00),
(16, 'Roasted Vegetables', 1, 10.00),
(16, 'Champagne', 1, 35.00),
-- Order 17
(17, 'Tacos', 3, 18.00),
(17, 'Guacamole', 1, 8.00),
(17, 'Salsa', 1, 4.00),
-- Order 18
(18, 'Pasta Alfredo', 2, 28.00),
(18, 'Breadsticks', 1, 6.00),
(18, 'Tiramisu', 1, 8.00),
-- Order 19
(19, 'Grilled Salmon', 1, 32.00),
(19, 'Asparagus', 1, 9.00),
(19, 'White Wine', 1, 22.00),
-- Order 20
(20, 'Hamburger', 1, 14.00),
(20, 'Cheese Burger', 1, 16.00),
(20, 'Soft Drinks', 2, 6.00);


USE restaurant_db;

-- Delete existing orders if you want to start fresh (optional)
-- DELETE FROM order_items;
-- DELETE FROM orders;

-- Insert 15 additional orders (ORD-006 to ORD-020)
INSERT INTO orders (table_id, staff_id, order_number, status, priority, estimated_time, total_amount) VALUES
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

-- Insert order items for the new orders
INSERT INTO order_items (order_id, item_name, quantity, price) VALUES
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


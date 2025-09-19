
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS refunds;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE,
  created_at TEXT NOT NULL,
  region TEXT
);

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT,
  price_cents INTEGER NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  order_date TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending','paid','refunded','canceled')),
  FOREIGN KEY(customer_id) REFERENCES customers(id)
);

CREATE TABLE payments (
  id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  amount_cents INTEGER NOT NULL,
  paid_at TEXT,
  method TEXT,
  status TEXT NOT NULL CHECK (status IN ('succeeded','failed','refunded','pending')),
  FOREIGN KEY(order_id) REFERENCES orders(id)
);

CREATE TABLE refunds (
  id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  amount_cents INTEGER NOT NULL,
  refunded_at TEXT NOT NULL,
  reason TEXT,
  FOREIGN KEY(order_id) REFERENCES orders(id)
);

CREATE TABLE order_items (
  id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price_cents INTEGER NOT NULL,
  FOREIGN KEY(order_id) REFERENCES orders(id),
  FOREIGN KEY(product_id) REFERENCES products(id)
);

-- Seed data
INSERT INTO customers (id, name, email, created_at, region) VALUES
(1, 'Ayesha Khan', 'ayesha@example.com', '2025-01-15', 'APAC'),
(2, 'Bilal Ahmed', 'bilal@example.com', '2025-02-03', 'APAC'),
(3, 'Chris Evans', 'chris@example.com', '2025-03-20', 'NA'),
(4, 'Diana Prince', 'diana@example.com', '2025-04-11', 'EU'),
(5, 'Ethan Lee', 'ethan@example.com', '2025-05-05', 'NA'),
(6, 'Fatima Noor', 'fatima@example.com', '2025-06-25', 'APAC');

INSERT INTO products (id, name, category, price_cents) VALUES
(1, 'Aurora Lamp', 'Home', 4999),
(2, 'Nimbus Headphones', 'Electronics', 12999),
(3, 'Terra Mug', 'Home', 1999),
(4, 'Zephyr Jacket', 'Apparel', 8999),
(5, 'Pulse Fitness Band', 'Electronics', 5999),
(6, 'Orbit Backpack', 'Apparel', 7499);

INSERT INTO orders (id, customer_id, order_date, status) VALUES
(101, 1, '2025-06-30', 'paid'),
(102, 1, '2025-07-02', 'paid'),
(103, 2, '2025-07-10', 'refunded'),
(104, 3, '2025-07-14', 'paid'),
(105, 4, '2025-07-20', 'pending'),
(106, 4, '2025-08-01', 'paid'),
(107, 5, '2025-08-03', 'paid'),
(108, 6, '2025-08-05', 'paid'),
(109, 6, '2025-08-10', 'canceled'),
(110, 2, '2025-08-12', 'paid'),
(111, 3, '2025-08-15', 'paid'),
(112, 5, '2025-08-18', 'refunded');

INSERT INTO payments (id, order_id, amount_cents, paid_at, method, status) VALUES
(1001, 101,  6998, '2025-06-30', 'card', 'succeeded'),
(1002, 102, 12999, '2025-07-02', 'card', 'succeeded'),
(1003, 103,  8999, '2025-07-10', 'card', 'refunded'),
(1004, 104,  4999, '2025-07-14', 'paypal', 'succeeded'),
(1005, 105,  1999, NULL, 'card', 'pending'),
(1006, 106, 142,   '2025-08-01', 'card', 'succeeded'), -- tiny test amount
(1007, 107, 13498, '2025-08-03', 'card', 'succeeded'),
(1008, 108,  5999, '2025-08-05', 'card', 'succeeded'),
(1009, 109,  7499, NULL, 'card', 'failed'),
(1010, 110,  7499, '2025-08-12', 'paypal', 'succeeded'),
(1011, 111,  6998, '2025-08-15', 'card', 'succeeded'),
(1012, 112, 14998, '2025-08-18', 'card', 'refunded');

INSERT INTO refunds (id, order_id, amount_cents, refunded_at, reason) VALUES
(2001, 103, 8999, '2025-07-12', 'damaged'),
(2002, 112, 9999, '2025-08-19', 'late delivery');

INSERT INTO order_items (id, order_id, product_id, quantity, unit_price_cents) VALUES
(3001, 101, 1, 1, 4999),
(3002, 101, 3, 1, 1999),
(3003, 102, 2, 1, 12999),
(3004, 103, 4, 1, 8999),
(3005, 104, 1, 1, 4999),
(3006, 105, 3, 1, 1999),
(3007, 106, 6, 1, 7499),
(3008, 106, 5, 1, 5999),
(3009, 107, 2, 1, 12999),
(3010, 107, 1, 1, 4999),
(3011, 108, 5, 1, 5999),
(3012, 109, 6, 1, 7499),
(3013, 110, 6, 1, 7499),
(3014, 111, 1, 1, 4999),
(3015, 111, 3, 1, 1999),
(3016, 112, 2, 1, 12999),
(3017, 112, 1, 1, 4999);
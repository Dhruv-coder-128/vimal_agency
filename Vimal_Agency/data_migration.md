# Data Migration Guide: MySQL to Supabase PostgreSQL

This guide provides the SQL queries needed to migrate your existing data from MySQL to PostgreSQL.
Since PostgreSQL uses different syntaxes and types, simply importing a standard MySQL dump won't work automatically in most cases.

## Method 1: Supabase Migration Tool (Recommended)
You can use `pgloader` or the Supabase standard migration tool which will do this for you automatically.
1. Create a free account on [Supabase](https://supabase.com/).
2. Setup the connection and use Supabase's `pgloader` integration or the Google Colab migration script provided in their official documentation to map your MySQL endpoint directly into Supabase.

## Method 2: Manual SQL Seed Migration
If you prefer migrating the data manually via SQL, run the following `seed.sql` script in your Supabase SQL editor **AFTER** you have created the tables using the provided `schema.sql`.

### `seed.sql`

```sql
-- Disable constraints temporarily if needed, though inserts below are ordered safely.

-- 1. Insert Users
INSERT INTO users (id, username, email, password, role, status, created_at) VALUES
(1, 'Admin', 'admin@gmail.com', '123', 'admin', 1, '2026-02-09 11:27:14'),
(2, 'Karan', 'karan@va.com', '123', 'admin', 1, '2026-02-09 11:27:25'),
(3, 'Vimal', 'vimal@gmail.com', '123', 'user', 1, '2026-02-09 14:03:34'),
(5, 'hemit', 'hemit@gmail.com', '123', 'user', 1, '2026-02-11 02:55:10'),
(7, 'extra', 'ext@gmail.com', '1', 'admin', 1, '2026-02-11 04:27:51'),
(10, 'harsh', 'harsh@va.com', '123', 'user', 1, '2026-02-11 15:29:53'),
(11, 'praful', 'praful@va.com', 'Praful@123', 'user', 0, '2026-02-12 03:06:41'),
(12, 'divyesh', 'divyesh@va.com', 'DDD', 'user', 1, '2026-02-12 03:16:34'),
(13, 'Dhruv', 'dhruv@va.com', 'DShah@123', 'user', 1, '2026-02-12 03:50:40');

-- Reset sequences for Users
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));

-- 2. Insert Promos
INSERT INTO promo (id, code_name, discount_percentage, description, category_name, min_order_amount) VALUES
(2, 'WELCOME20', 20, 'Special 20% off for our new customers.', 'Namkeen', 0),
(3, 'FREE50', 50, 'Mega sale: Flat 50% discount!', NULL, 0),
(6, 'VIMAL10', 10, '10% off on total order', NULL, 0),
(7, 'WAFERS20', 20, '20% off only on Wafers', 'Wafers', 200),
(8, 'MEGA50', 50, '50% OFF on orders above 4500', 'All', 4500),
(10, 'NEW10', 10, 'All Product Valid', 'All', 200);

-- Reset sequences for Promos
SELECT setval('promo_id_seq', (SELECT MAX(id) FROM promo));

-- 3. Insert Products
INSERT INTO products (listing_code, code, product_name, product_price, product_category, product_describe, product_image) VALUES
(1, 'WF101', 'CRUNCHEM - SIMPLY SALTED.', 1200, 'Wafers', 'Introducing potato wafers with iodised salt for a mild, classic flavor.', './Product/sadi_wafers_.png'),
(2, 'WF102', 'CRUNCHEM - MASALA WAFER', 10, 'Wafers', 'Pure bliss of spicy indian masala to shake things up a bit.', './Product/masala_wafer.png');
-- (Add remaining products from your MySQL dump)

-- 4. Insert Offers
INSERT INTO offers (id, offer_text, is_active) VALUES
(4, '🚚 Free Shipping on Orders Over Rs. 1000!', 1),
(5, '🔥 Buy 3 Packs Get 1 Free', 1);

-- Reset sequences for Offers
SELECT setval('offers_id_seq', (SELECT MAX(id) FROM offers));

-- 5. Orders and Order Items
INSERT INTO orders (order_id, user_id, customer_name, address, city, pincode, phone, subtotal, discount, shipping, final_total, status, order_date) VALUES
(1, 2, 'Karan Sanghavi', '..', '..', '..', '9054541906', 10, 5, 100, 105, 'Cancelled', '2026-02-10 16:16:46');
-- (Add remaining orders)

-- Reset sequences for Orders
SELECT setval('orders_order_id_seq', (SELECT MAX(order_id) FROM orders));
```

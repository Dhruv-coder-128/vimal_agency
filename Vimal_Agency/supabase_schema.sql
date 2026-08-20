-- ==========================================================
-- PostgreSQL Database Schema for Vimal Agency (Supabase)
-- ==========================================================

-- 1. Admin Notes Table
CREATE TABLE IF NOT EXISTS admin_notes (
    id SERIAL PRIMARY KEY,
    note_title VARCHAR(255) NOT NULL,
    note_desc TEXT DEFAULT NULL,
    is_active SMALLINT DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Cart Table
CREATE TABLE IF NOT EXISTS cart (
    cart_id SERIAL PRIMARY KEY,
    user_id INTEGER DEFAULT NULL,
    product_id INTEGER DEFAULT NULL,
    product_name VARCHAR(100) DEFAULT NULL,
    price INTEGER DEFAULT NULL,
    qty INTEGER DEFAULT NULL,
    image VARCHAR(200) DEFAULT NULL
);

-- 3. Contact Us Inquiries Table
CREATE TABLE IF NOT EXISTS contact_us (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    cno VARCHAR(20) NOT NULL,
    message VARCHAR(500) NOT NULL,
    created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Customer Feedback Table
CREATE TABLE IF NOT EXISTS feedback (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    mail VARCHAR(150) NOT NULL,
    experience INTEGER NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5. Marketing Offers Table
CREATE TABLE IF NOT EXISTS offers (
    id SERIAL PRIMARY KEY,
    offer_text VARCHAR(1000) NOT NULL,
    is_active SMALLINT NOT NULL DEFAULT 1
);

-- 6. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    customer_name VARCHAR(100) DEFAULT NULL,
    address TEXT DEFAULT NULL,
    city VARCHAR(50) DEFAULT NULL,
    pincode VARCHAR(10) DEFAULT NULL,
    phone VARCHAR(15) DEFAULT NULL,
    subtotal INTEGER DEFAULT NULL,
    discount INTEGER DEFAULT NULL,
    shipping INTEGER DEFAULT NULL,
    final_total INTEGER DEFAULT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 7. Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER DEFAULT NULL,
    product_name VARCHAR(100) DEFAULT NULL,
    price INTEGER DEFAULT NULL,
    qty INTEGER DEFAULT NULL,
    image VARCHAR(255) DEFAULT NULL
);

-- 8. Products Inventory Table
CREATE TABLE IF NOT EXISTS products (
    listing_code SERIAL PRIMARY KEY,
    code VARCHAR(20) DEFAULT NULL,
    product_name VARCHAR(255) DEFAULT NULL,
    product_price INTEGER DEFAULT NULL,
    product_category VARCHAR(100) DEFAULT NULL,
    product_describe TEXT DEFAULT NULL,
    product_image VARCHAR(255) DEFAULT NULL
);

-- 9. Promo Codes Table
CREATE TABLE IF NOT EXISTS promo (
    id SERIAL PRIMARY KEY,
    code_name VARCHAR(50) NOT NULL UNIQUE,
    discount_percentage INTEGER NOT NULL,
    description VARCHAR(255) DEFAULT NULL,
    category_name VARCHAR(100) DEFAULT NULL,
    min_order_amount INTEGER DEFAULT 0
);

-- 10. Users Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recovery_key_hash VARCHAR(255) DEFAULT NULL,
    recovery_key_created_at TIMESTAMP DEFAULT NULL,
    notify_orders SMALLINT DEFAULT 1,
    notify_promos SMALLINT DEFAULT 1
);

-- Safe Alter Table Migrations (for pre-existing databases)
ALTER TABLE users ADD COLUMN IF NOT EXISTS recovery_key_hash VARCHAR(255) DEFAULT NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS recovery_key_created_at TIMESTAMP DEFAULT NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS notify_orders SMALLINT DEFAULT 1;
ALTER TABLE users ADD COLUMN IF NOT EXISTS notify_promos SMALLINT DEFAULT 1;

-- Indexes for Query Performance
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_cart_user_id ON cart(user_id);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(product_category);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

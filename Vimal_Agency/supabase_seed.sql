-- ==========================================================
-- PostgreSQL Database Seed Data for Vimal Agency (Supabase)
-- ==========================================================

-- 1. Admin Notes
INSERT INTO admin_notes (id, note_title, note_desc, is_active, created_at) VALUES
(1, 'All Stock Clear 31-03-2026', '1. Stock Count
2. Debit Bill Clear (Receiver & Payer).', 1, '2026-03-09 04:32:16')
ON CONFLICT (id) DO NOTHING;

-- 2. Cart Data
INSERT INTO cart (cart_id, user_id, product_id, product_name, price, qty, image) VALUES
(1, 1, NULL, 'CRUNCHEM - MASALA WAFER', 10, 1, './Product/masala_wafer.png'),
(2, 1, NULL, 'CRUNCHEM - TOMATO TWIST', 10, 1, './Product/tomato_twist.png'),
(3, 1, NULL, 'CRUNCHEM - PIZZY MASALA', 10, 1, './Product/pizza.png'),
(4, 1, NULL, 'CRUNCHEM - PERI PERI', 10, 1, './Product/peri_peri.png'),
(42, 5, NULL, 'SNACK’EM – PONGA MASALA', 5, 4, './Product/ponga_masala.png'),
(48, 2, NULL, 'CRUNCHEM - MASALA WAFER', 10, 10, './Product/masala_wafer.png'),
(49, 2, NULL, 'ALOO SEV', 5, 5, './Product/aloo_Sev.jpg'),
(51, 2, NULL, 'CRUNCHEM - SIMPLY SALTED.', 1200, 4, './Product/sadi_wafers_.png'),
(57, 12, NULL, 'CRUNCHEM - MASALA WAFER', 10, 101, './Product/masala_wafer.png')
ON CONFLICT (cart_id) DO NOTHING;

-- 3. Contact Us Inquiries
INSERT INTO contact_us (id, name, email, cno, message, created_time) VALUES
(1, 'Karan Sanghavi', 'karansanghvi7143@gmail.com', '9054541906', 'Please Contact Fast', '2026-02-09 03:21:32'),
(2, 'Dhruv', 'dhruv@gmail.com', '8866039007', '.', '2026-02-09 03:22:16'),
(3, 'Dhruv', 'admin@mail.com', '9054541906', 'ok', '2026-02-09 03:31:24'),
(4, 'Karan Sanghavi', 'karansanghvi7143@gmail.com', '9054541906', 'ok', '2026-02-09 03:51:08'),
(5, 'Karan Sanghavi', 'karansanghvi7143@gmail.com', '9054541906', 'ok', '2026-02-09 03:51:23'),
(6, 'Harsh Sanghavi', 'harsh@va.com', '6359812590', 'Good Services', '2026-02-09 09:13:49'),
(7, 'Harsh Sanghavi', 'harsh@va.com', '6359812590', 'Good Services', '2026-02-09 09:14:25'),
(8, 'Divyang', 'admin@mail.com', '9726675224', 'ok', '2026-02-09 10:14:13'),
(9, 'Harsh Sanghavi', 'harsh@va.com', '6359812590', 'Good Work', '2026-02-09 12:32:24'),
(10, 'Ruparel Education', 'ruparel@gmail.com', '7600000000', 'good', '2026-02-10 03:47:15'),
(11, 'Karan Sanghavi', 'karansanghvi7143@gmail.com', '9054541906', '
.', '2026-02-10 17:42:55'),
(13, 'extra', 'ext@gmail.com', '9054541906', 'Please Contact Fast', '2026-02-11 04:29:44')
ON CONFLICT (id) DO NOTHING;

-- 4. Customer Feedback
INSERT INTO feedback (id, name, mail, experience, message, created_at) VALUES
(1, 'Karan Sanghavi', 'karan@va.com', 5, 'Good Work!', '2026-02-09 03:23:46'),
(2, 'Karan Sanghavi', 'karan@va.com', 3, 'ok', '2026-02-09 03:29:13'),
(3, 'Karan Sanghavi', 'karan@va.com', 5, 'ok', '2026-02-09 03:31:36'),
(7, 'harsh', 'harsh@va.com', 5, 'Your Online Services Very Best', '2026-02-11 15:32:20'),
(8, 'Karan', 'praful@va.com', 5, 'Good Services...', '2026-02-12 03:08:26'),
(9, 'divyesh', 'divyesh@va.com', 5, 'good', '2026-02-12 03:24:51'),
(10, 'Karan', 'divyesh@va.com', 5, 'good', '2026-02-12 03:36:14')
ON CONFLICT (id) DO NOTHING;

-- 5. Marketing Offers
INSERT INTO offers (id, offer_text, is_active) VALUES
(4, '🚚 Free Shipping on Orders Over Rs. 1000! 🎉 Shipping via logistics partner; delivery times may vary by distance, weather, and other factors. T&Cs apply.', 1),
(5, '🔥 Buy 3 Packs Get 1 Free', 1)
ON CONFLICT (id) DO NOTHING;

-- 6. Orders
INSERT INTO orders (order_id, user_id, customer_name, address, city, pincode, phone, subtotal, discount, shipping, final_total, status, order_date) VALUES
(1, 2, 'Karan Sanghavi', '..', '..', '..', '9054541906', 10, 5, 100, 105, 'Cancelled', '2026-02-10 16:16:46'),
(4, 2, '.', '.', '.', '..', '.', 90, 0, 100, 190, 'Cancelled', '2026-02-10 16:18:26'),
(5, 2, 'Karan Sanghavi', 'JND', 'JNS', '362001', '9054541906', 410, 36, 100, 474, 'Delivered', '2026-02-10 19:24:05'),
(6, 5, 'Hemit Kotadiya', 'Sasan Gir', 'Junagadh', '362001', '6359268337', 20, 4, 100, 116, 'Pending', '2026-02-11 02:56:41'),
(7, 2, 'Gokul ', 'Junagadh', 'Junagadh', '362001', '9005454541', 40, 0, 100, 140, 'Cancelled', '2026-02-11 04:49:07'),
(8, 2, 'Karan', 'lklkl', 'JNS', '362001', '9054541906', 30, 0, 100, 130, 'Pending', '2026-02-11 05:05:06'),
(9, 10, 'Harsh Sanghavi', 'Khamdhrol Road, Balaji Wafers Dealer', 'Junagadh', '362001', '6359812590', 6000, 3000, 0, 3000, 'Delivered', '2026-02-11 15:31:01'),
(10, 11, 'Praful Bhai ', 'Kadiyavad, ', 'Junagadh', '3620001', '8780810913', 1230, 615, 0, 615, 'Delivered', '2026-02-12 03:07:50')
ON CONFLICT (order_id) DO NOTHING;

-- 7. Order Items
INSERT INTO order_items (item_id, order_id, product_name, price, qty, image) VALUES
(1, 1, 'PUNJABI TADKA', 5, 2, './Product/punjabi_tadka.jpg'),
(2, 4, 'CRUNCHEM - MASALA WAFER', 10, 9, './Product/masala_wafer.png'),
(3, 5, 'KHATA MITHA MIX', 5, 5, './Product/khata_mitha.png'),
(4, 5, 'SALTED PEANUTS', 10, 6, './Product/sadi_shing.png'),
(5, 5, 'METHI KHAKRA', 40, 2, './Product/methi_khakra.png'),
(6, 5, 'CRUNCHEM - TOMATO TWIST', 10, 2, './Product/tomato_twist.png'),
(7, 5, 'CRUNCHEM - MASALA WAFER', 10, 4, './Product/masala_wafer.png'),
(8, 5, 'CRUNCHEM - SIMPLY SALTED', 10, 2, './Product/sadi_wafers_.png'),
(9, 5, 'INSTANT BHEL MIX', 50, 3, './Product/instant_bhel.png'),
(10, 5, 'TIKHA MITHA MIX', 5, 1, './Product/tikha_mitha.png'),
(11, 5, 'YUMSTIX', 5, 1, './Product/yumstix.png'),
(12, 5, 'CHOCOLATE CREAM WAFERS', 5, 1, './Product/chocalate.png'),
(13, 5, 'CRUNCHEM - SIMPLY SALTED.', 10, 2, './Product/sadi_wafers_.png'),
(18, 6, 'KATAK BATAK – CHILLI LEMON', 5, 1, './Product/katak_batak.png'),
(19, 6, 'KATAK BATAK – DESI MASALA', 5, 1, './Product/katak_batak_desi.png'),
(20, 6, 'KHATA MITHA MIX', 5, 1, './Product/khata_mitha.png'),
(21, 6, 'TIKHA MITHA MIX', 5, 1, './Product/tikha_mitha.png'),
(25, 7, 'CRUNCHEM - TOMATO TWIST', 10, 1, './Product/tomato_twist.png'),
(26, 7, 'CRUNCHEM - CHAAT CHASKA', 10, 2, './Product/chat_chaska.png'),
(27, 7, 'JUICY STRAWBERRY CREAM WAFERS', 5, 1, './Product/strowbarry.png'),
(28, 7, 'KATAK BATAK – DESI MASALA', 5, 1, './Product/katak_batak_desi.png'),
(32, 8, 'CRUNCHEM - TOMATO TWIST', 10, 3, './Product/tomato_twist.png'),
(33, 9, 'CRUNCHEM - SIMPLY SALTED.', 1200, 5, './Product/sadi_wafers_.png'),
(34, 10, 'CRUNCHEM - SIMPLY SALTED.', 1200, 1, './Product/sadi_wafers_.png'),
(35, 10, 'CRUNCHEM - TOMATO TWIST', 10, 1, './Product/tomato_twist.png'),
(36, 10, 'CRUNCHEM - PERI PERI', 10, 1, './Product/peri_peri.png'),
(37, 10, 'CRUNCHEX - CHILLI LEMON', 10, 1, './Product/lemon_chili.png')
ON CONFLICT (item_id) DO NOTHING;

-- 8. Products
INSERT INTO products (listing_code, code, product_name, product_price, product_category, product_describe, product_image) VALUES
(1, 'WF101', 'CRUNCHEM - SIMPLY SALTED.', 1200, 'Wafers', 'Introducing potato wafers with iodised salt for a mild, classic flavor.', './Product/sadi_wafers_.png'),
(2, 'WF102', 'CRUNCHEM - MASALA WAFER', 10, 'Wafers', 'Pure bliss of spicy indian masala to shake things up a bit.', './Product/masala_wafer.png'),
(3, 'WF103', 'CRUNCHEM - TOMATO TWIST', 10, 'Wafers', 'Delight in the rich, sweet, and tangy flavors of ripe tomatoes', './Product/tomato_twist.png'),
(4, 'WF104', 'CRUNCHEM - CHAAT CHASKA', 10, 'Wafers', 'Spicy, tangy, minty yet salty character.', './Product/chat_chaska.png'),
(5, 'WF105', 'CRUNCHEM - CREAM & ONION', 10, 'Wafers', 'Delicious wafers with sour cream, herbs and onion.', './Product/cream_onion.png'),
(6, 'WF106', 'CRUNCHEM - PERI PERI', 10, 'Wafers', 'Irresistible chilli heat on crispy wafers.', './Product/peri_peri.png'),
(7, 'WF107', 'CRUNCHEM - PIZZY MASALA', 10, 'Wafers', 'Pepper, oregano and cheese pizza flavour.', './Product/pizza.png'),
(8, 'WF108', 'CRUNCHEX - SIMPLY SALTED', 10, 'Wafers', 'Hand cooked classic salted wafers.', './Product/crunchex_new.jpg'),
(9, 'WF109', 'CRUNCHEX - CHILI TADKA', 10, 'Wafers', 'Hand cooked wafers with fiery chilli kick.', './Product/chili_tadka.png'),
(10, 'WF110', 'CRUNCHEX - MIRCH MASALA', 10, 'Wafers', 'Crunchy wafers with bold masala blend.', './Product/mirch_masala.png'),
(11, 'WF111', 'CRUNCHEX - CHILLI LEMON', 10, 'Wafers', 'Tangy lemon and chilli crunch.', './Product/lemon_chili.png'),
(12, 'WF112', 'RUMBLE - PUDINA TWIST', 10, 'Wafers', 'Refreshing pudina flavour snack.', './Product/rumble.png'),
(13, 'WF113', 'RUMBLE - HOT CHILLI', 10, 'Wafers', 'Fiery hot chilli crunch.', './Product/hot_Chili.png'),
(14, 'WF114', 'BANANA WAFERS - MASALA', 10, 'Wafers', 'Spiced banana wafers.', './Product/BANANA_MASALA.png'),
(15, 'WF115', 'BANANA WAFERS - MARI', 10, 'Wafers', 'Peppered banana wafers.', './Product/BANANA_MARI.png'),
(16, 'WS101', 'YUMSTIX', 5, 'Western Snacks', 'Chatpata masala snack sticks.', './Product/yumstix.png'),
(17, 'WS102', 'PUNJABI TADKA', 5, 'Western Snacks', 'Crispy spicy western snack.', './Product/punjabi_tadka.jpg'),
(18, 'WS103', 'AMAIZE – SIMPLY SALTED NACHOS', 5, 'Western Snacks', 'Classic salted nachos.', './Product/simple_nachos.jpg'),
(19, 'WS104', 'AMAIZE – FLAMIN HOT NACHOS', 5, 'Western Snacks', 'Flaming hot chilli nachos.', './Product/black_nachos.png'),
(20, 'WS105', 'AMAIZE – CHEESE CHILLI NACHOS', 5, 'Western Snacks', 'Cheese chilli nachos.', './Product/cheese_nachos.png'),
(21, 'WS106', 'FUNNE – SPICY PUNCH', 5, 'Western Snacks', 'Tube like spicy snack.', './Product/funne.png'),
(22, 'WS107', 'NOODLE STICKS – MASALA FLAVOUR', 5, 'Western Snacks', 'Crunchy noodle sticks.', './Product/noodle_sticks.png'),
(23, 'WS108', 'SCOOPITOS', 5, 'Western Snacks', 'Light crispy scoop snack.', './Product/scoopitos.png'),
(24, 'WS109', 'POP RINGS – YUMMY CHEESE', 5, 'Western Snacks', 'Roasted corn cheese rings.', './Product/cheese_ring.jpg'),
(25, 'WS110', 'POP RINGS – MASALA', 5, 'Western Snacks', 'Roasted corn masala rings.', './Product/popring.png'),
(26, 'WS111', 'POP RINGS – SHAPES', 5, 'Western Snacks', 'Corn roasted shapes snack.', './Product/popring_shapes.png'),
(27, 'WS112', 'CP – MASALA MASTI', 5, 'Western Snacks', 'Spicy evening snack.', './Product/chataka_patak.png'),
(28, 'WS113', 'CP – TANGY TOMATO', 5, 'Western Snacks', 'Tangy tomato snack.', './Product/chataka_pataka_tomato.png'),
(29, 'WS114', 'CP – FLAMIN HOT', 5, 'Western Snacks', 'Hot and sour snack.', './Product/chataka_pataka_flamin_hot.png'),
(30, 'WS115', 'CP – CHINESE CHASKA', 5, 'Western Snacks', 'Chinese flavoured snack.', './Product/chinese_chataka.png'),
(31, 'WS116', 'CP – LASANIYA', 5, 'Western Snacks', 'Garlic spicy snack.', './Product/lasaniya_chataka.png'),
(32, 'SP101', 'SNACK’EM – PILLOWS MASALA', 5, 'Snack Pellets', 'Masala pillow snack.', './Product/pillow.png'),
(33, 'SP102', 'SNACK’EM – PONGA MASALA', 5, 'Snack Pellets', 'Crispy masala ponga.', './Product/ponga_masala.png'),
(34, 'SP103', 'WHEELOS - MASALA', 5, 'Snack Pellets', 'Wheel shaped snack.', './Product/wheelos.png'),
(35, 'SP104', 'SNACK’EM – CHOKDI', 5, 'Snack Pellets', 'Masaledar crunchy snack.', './Product/CHOKDI.png'),
(36, 'NK101', 'KATAK BATAK – CHILLI LEMON', 5, 'Namkeen', 'Chilli lemon peanuts.', './Product/katak_batak.png'),
(37, 'NK102', 'KATAK BATAK – DESI MASALA', 5, 'Namkeen', 'Desi masala peanuts.', './Product/katak_batak_desi.png'),
(38, 'NK103', 'KHATA MITHA MIX', 5, 'Namkeen', 'Sweet and tangy mix.', './Product/khata_mitha.png'),
(39, 'NK104', 'TIKHA MITHA MIX', 5, 'Namkeen', 'Sweet spicy mix.', './Product/tikha_mitha.png'),
(40, 'NK105', 'MITHA FARALI CHIVDA', 10, 'Namkeen', 'Crispy fasting snack.', './Product/mitho_chevdo.png'),
(41, 'NK106', 'FARALI CHEVDO', 5, 'Namkeen', 'Light spicy chevdo.', './Product/farali_chevdo.jpg'),
(42, 'NK107', 'CHANA JOR GARAM', 5, 'Namkeen', 'Spicy Indian snack.', './Product/chanajor.png'),
(43, 'NK108', 'BHEL MIX', 5, 'Namkeen', 'Spicy tangy sweet bhel mix.', './Product/bhel.png'),
(44, 'NK109', 'MUNG DAL', 10, 'Namkeen', 'Crunchy mung dal.', './Product/mung_dal.png'),
(45, 'NK110', 'CHANA DAL', 5, 'Namkeen', 'Spicy chana dal.', './Product/chanda_Dal.png'),
(46, 'NK111', 'MASALA PEAS', 5, 'Namkeen', 'Chilli coated peas.', './Product/masala_pead.png'),
(47, 'NK112', 'SHING BHUJIA', 5, 'Namkeen', 'Masala peanuts bhujia.', './Product/shing_bhujia.png'),
(48, 'NK113', 'NIMBU SHING BHUJIA', 5, 'Namkeen', 'Lemon peanuts bhujia.', './Product/nimbu_bhujia.png'),
(49, 'NK114', 'ALOO SEV', 5, 'Namkeen', 'Classic aloo sev.', './Product/aloo_Sev.jpg'),
(50, 'NK115', 'CLASSIC SEV', 5, 'Namkeen', 'Salted sev snack.', './Product/classic_Sev.png'),
(51, 'NK116', 'GATHIYA', 5, 'Namkeen', 'Gujarati gathiya snack.', './Product/gathiya.png'),
(52, 'NK117', 'NAVRATAN MIX', 5, 'Namkeen', 'Mixed namkeen snack.', './Product/navratn-mix.png'),
(53, 'NK118', 'SEV MURMURA', 5, 'Namkeen', 'Sev kurmura mix.', './Product/sada_mamra.png'),
(54, 'NK119', 'MASALA SEV MURMURA', 5, 'Namkeen', 'Masala murmura mix.', './Product/masala_mamra.jpg'),
(55, 'NK120', 'MASALA CHANA', 5, 'Namkeen', 'Spicy chickpeas.', './Product/masala_chana.png'),
(56, 'NK121', 'RATLAMI SEV', 5, 'Namkeen', 'Ratlami style sev.', './Product/ratlami_sev.png'),
(57, 'NK122', 'PAPDI GATHIYA', 5, 'Namkeen', 'Crunchy papdi gathiya.', './Product/papdi_gathiya.png'),
(58, 'NK123', 'BHUJIA SEV', 50, 'Namkeen', 'Crunchy spicy bhujia sev.', './Product/BhujiaSev.png'),
(59, 'NK124', 'INSTANT BHEL MIX', 50, 'Namkeen', 'Instant bhel mix.', './Product/instant_bhel.png'),
(60, 'PA101', 'SALTED PEANUTS', 10, 'Peantus', 'Salted peanuts snack.', './Product/sadi_shing.png'),
(61, 'PA102', 'MASALA SHING', 10, 'Peantus', 'Masala peanuts.', './Product/masala_shing.png'),
(62, 'KH101', 'PLAIN KHAKHRA', 40, 'Khakhra', 'Classic Gujarati khakhra.', './Product/plain_khakhra.png'),
(63, 'KH102', 'MASALA KHAKHRA', 40, 'Khakhra', 'Masala flavoured khakhra.', './Product/masala_khakhra.png'),
(64, 'KH103', 'METHI KHAKRA', 40, 'Khakhra', 'Fenugreek khakhra.', './Product/methi_khakra.png'),
(65, 'KH104', 'JEERA KHAKHRA', 40, 'Khakhra', 'Jeera flavoured khakhra.', './Product/jeera_khakhra.png'),
(66, 'CH101', 'CHOCOLATE CREAM WAFERS', 5, 'Chocalate', 'Chocolate cream wafers.', './Product/chocalate.png'),
(67, 'CH102', 'TANGY ORANGE CREAM WAFERS', 5, 'Chocalate', 'Orange cream wafers.', './Product/Orange.png'),
(68, 'CH103', 'JUICY STRAWBERRY CREAM WAFERS', 5, 'Chocalate', 'Strawberry wafers.', './Product/strowbarry.png'),
(69, 'CH104', 'YUMMY VANILLA CREAM WAFERS', 5, 'Chocalate', 'Vanilla cream wafers.', './Product/Venilla.png'),
(70, 'CH105', 'CRUNCHY COCONUT CREAM WAFERS', 5, 'Chocalate', 'Coconut wafers.', './Product/coconut.png'),
(71, 'CF101', 'SOFT IMLY CANDY', 1, 'Confectionary', 'Tamarind candy.', './Product/amli.png'),
(72, 'CF102', 'NIMBU PANI CANDY', 1, 'Confectionary', 'Lemon candy.', './Product/Limbu.png'),
(73, 'GN101', 'GIPPI - MASALA NOODLES', 10, 'Gippi', 'Masala noodles.', './Product/gippi_new.png'),
(74, 'GN102', 'GIPPI - FLAMIN CHILLI NOODLES', 10, 'Gippi', 'Spicy chilli noodles.', './Product/gippi_chili.png'),
(75, 'OE101', 'OLEE - DYNOBITE', 5, 'Olee', 'Chocolate wafer bar.', './Product/Dyno.png'),
(76, 'OE102', 'OLEE - CHOCO STIX', 5, 'Olee', 'Chocolate wafer sticks.', './Product/CHOCO_STIK.png')
ON CONFLICT (listing_code) DO NOTHING;

-- 9. Promo Codes
INSERT INTO promo (id, code_name, discount_percentage, description, category_name, min_order_amount) VALUES
(2, 'WELCOME20', 20, 'Special 20% off for our new customers.', 'Namkeen', 0),
(3, 'FREE50', 50, 'Mega sale: Flat 50% discount!', NULL, 0),
(6, 'VIMAL10', 10, '10% off on total order', NULL, 0),
(7, 'WAFERS20', 20, '20% off only on Wafers', 'Wafers', 200),
(8, 'MEGA50', 50, '50% OFF on orders above 4500', 'All', 4500),
(10, 'NEW10', 10, 'All Product Valid', 'All', 200)
ON CONFLICT (id) DO NOTHING;

-- 10. Users
INSERT INTO users (id, username, email, password, role, status, created_at) VALUES
(1, 'Admin', 'admin@gmail.com', '123', 'admin', 1, '2026-02-09 11:27:14'),
(2, 'Karan', 'karan@va.com', '123', 'admin', 1, '2026-02-09 11:27:25'),
(3, 'Vimal', 'vimal@gmail.com', '123', 'user', 1, '2026-02-09 14:03:34'),
(5, 'hemit', 'hemit@gmail.com', '123', 'user', 1, '2026-02-11 02:55:10'),
(7, 'extra', 'ext@gmail.com', '1', 'admin', 1, '2026-02-11 04:27:51'),
(10, 'harsh', 'harsh@va.com', '123', 'user', 1, '2026-02-11 15:29:53'),
(11, 'praful', 'praful@va.com', 'Praful@123', 'user', 0, '2026-02-12 03:06:41'),
(12, 'divyesh', 'divyesh@va.com', 'DDD', 'user', 1, '2026-02-12 03:16:34'),
(13, 'Dhruv', 'dhruv@va.com', 'DShah@123', 'user', 1, '2026-02-12 03:50:40')
ON CONFLICT (id) DO NOTHING;

-- ==========================================================
-- Sequence Synchronization (Prevents duplicate primary key collisions)
-- ==========================================================
SELECT setval(pg_get_serial_sequence('admin_notes', 'id'), COALESCE((SELECT MAX(id) FROM admin_notes), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('cart', 'cart_id'), COALESCE((SELECT MAX(cart_id) FROM cart), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('contact_us', 'id'), COALESCE((SELECT MAX(id) FROM contact_us), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('feedback', 'id'), COALESCE((SELECT MAX(id) FROM feedback), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('offers', 'id'), COALESCE((SELECT MAX(id) FROM offers), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('orders', 'order_id'), COALESCE((SELECT MAX(order_id) FROM orders), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('order_items', 'item_id'), COALESCE((SELECT MAX(item_id) FROM order_items), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('products', 'listing_code'), COALESCE((SELECT MAX(listing_code) FROM products), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('promo', 'id'), COALESCE((SELECT MAX(id) FROM promo), 0) + 1, false);
SELECT setval(pg_get_serial_sequence('users', 'id'), COALESCE((SELECT MAX(id) FROM users), 0) + 1, false);

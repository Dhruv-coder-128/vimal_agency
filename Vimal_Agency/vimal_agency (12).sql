-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2026 at 04:10 PM
-- Server version: 10.6.25-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vimal_agency`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_notes`
--

CREATE TABLE `admin_notes` (
  `id` int(11) NOT NULL,
  `note_title` varchar(255) NOT NULL,
  `note_desc` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `admin_notes`
--

INSERT INTO `admin_notes` (`id`, `note_title`, `note_desc`, `is_active`, `created_at`) VALUES
(1, 'All Stock Clear 31-03-2026', '1. Stock Count\r\n2. Debit Bill Clear (Receiver & Payer).', 1, '2026-03-09 04:32:16');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `image` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `user_id`, `product_id`, `product_name`, `price`, `qty`, `image`) VALUES
(1, 1, NULL, 'CRUNCHEM - MASALA WAFER', 10, 1, './Product/masala_wafer.png'),
(2, 1, NULL, 'CRUNCHEM - TOMATO TWIST', 10, 1, './Product/tomato_twist.png'),
(3, 1, NULL, 'CRUNCHEM - PIZZY MASALA', 10, 1, './Product/pizza.png'),
(4, 1, NULL, 'CRUNCHEM - PERI PERI', 10, 1, './Product/peri_peri.png'),
(42, 5, NULL, 'SNACK’EM – PONGA MASALA', 5, 4, './Product/ponga_masala.png'),
(57, 12, NULL, 'CRUNCHEM - MASALA WAFER', 10, 101, './Product/masala_wafer.png'),
(158, 2, NULL, 'NOODLE STICKS – MASALA FLAVOUR', 720, 7, './Product/noodle_sticks.png');

-- --------------------------------------------------------

--
-- Table structure for table `contact_us`
--

CREATE TABLE `contact_us` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `cno` varchar(20) NOT NULL,
  `message` varchar(500) NOT NULL,
  `created_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_us`
--

INSERT INTO `contact_us` (`id`, `name`, `email`, `cno`, `message`, `created_time`) VALUES
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
(11, 'Karan Sanghavi', 'karansanghvi7143@gmail.com', '9054541906', '\r\n.', '2026-02-10 17:42:55'),
(13, 'extra', 'ext@gmail.com', '9054541906', 'Please Contact Fast', '2026-02-11 04:29:44'),
(15, 'Karan', 'karan@va.com', '9054541906', '.', '2026-02-19 17:25:53'),
(16, 'Karan', 'karan', '9054541906', 'Please Contact', '2026-03-08 17:44:09');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `mail` varchar(150) NOT NULL,
  `experience` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `name`, `mail`, `experience`, `message`, `created_at`) VALUES
(1, 'Karan Sanghavi', 'karan@va.com', 5, 'Good Work!', '2026-02-09 03:23:46'),
(2, 'Karan Sanghavi', 'karan@va.com', 3, 'ok', '2026-02-09 03:29:13'),
(3, 'Meet', 'meet#va.com', 4, 'Good Work', '2026-02-09 03:31:36'),
(7, 'harsh', 'harsh@va.com', 5, 'Your Online Services Very Best', '2026-02-11 15:32:20'),
(9, 'divyesh', 'divyesh@va.com', 5, 'good', '2026-02-12 03:24:51'),
(13, 'Karan', 'karan@va.com', 4, 'Good Services..', '2026-02-19 17:25:20'),
(14, 'praful', 'praful', 5, 'Good Services', '2026-03-09 04:21:09');

-- --------------------------------------------------------

--
-- Table structure for table `offers`
--

CREATE TABLE `offers` (
  `id` int(11) NOT NULL,
  `offer_text` varchar(1000) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `offers`
--

INSERT INTO `offers` (`id`, `offer_text`, `is_active`) VALUES
(4, '🚚 Free Shipping on Orders Over Rs. 1000! 🎉 Shipping via logistics partner; delivery times may vary by distance, weather, and other factors. T&Cs apply.\n', 1),
(5, 'Buy 3 Packs Get 1 Free', 0),
(16, 'Birthday Discount (80 % Of On Wafers Biscuit)', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `subtotal` int(11) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `shipping` int(11) DEFAULT NULL,
  `final_total` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Pending',
  `order_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `customer_name`, `address`, `city`, `pincode`, `phone`, `subtotal`, `discount`, `shipping`, `final_total`, `status`, `order_date`) VALUES
(1, 2, 'Karan Sanghavi', '..', '..', '..', '9054541906', 10, 5, 100, 105, 'Cancelled', '2026-02-10 16:16:46'),
(4, 2, '.', '.', '.', '..', '.', 90, 0, 100, 190, 'Delivered', '2026-02-10 16:18:26'),
(5, 2, 'Karan Sanghavi', 'JND', 'JNS', '362001', '9054541906', 410, 36, 100, 474, 'Delivered', '2026-02-10 19:24:05'),
(6, 5, 'Hemit Kotadiya', 'Sasan Gir', 'Junagadh', '362001', '6359268337', 20, 4, 100, 116, 'Pending', '2026-02-11 02:56:41'),
(7, 2, 'Gokul ', 'Junagadh', 'Junagadh', '362001', '9005454541', 40, 0, 100, 140, 'Cancelled', '2026-02-11 04:49:07'),
(8, 2, 'Karan', 'lklkl', 'JNS', '362001', '9054541906', 30, 0, 100, 130, 'Pending', '2026-02-11 05:05:06'),
(9, 10, 'Harsh Sanghavi', 'Khamdhrol Road, Balaji Wafers Dealer', 'Junagadh', '362001', '6359812590', 6000, 3000, 0, 3000, 'Pending', '2026-02-11 15:31:01'),
(10, 11, 'Praful Bhai ', 'Kadiyavad, ', 'Junagadh', '3620001', '8780810913', 1230, 615, 0, 615, 'Pending', '2026-02-12 03:07:50'),
(11, 2, 'Karan Sanghavi', 'Jagmal Chowk, ', 'Junagadh', '362001', '9054541906', 6000, 3000, 0, 3000, 'Delivered', '2026-02-19 17:26:31'),
(12, 2, 'Ridham Divraniya', 'Dhandhusar', 'Junagadh', '362002', '7359290653', 3600, 1800, 0, 1800, 'Cancelled', '2026-02-20 03:07:28'),
(13, 16, 'Sujal ', 'Kalana,', 'Junagadh', '362001', '9879253857', 1800, 900, 0, 900, 'Delivered', '2026-02-24 03:36:46'),
(14, 7, 'Praful Bhai ', 'Kadiyavad', 'Junagadh', '362001', '8780810913', 20700, 10350, 0, 10350, 'Cancelled', '2026-03-03 02:54:55'),
(15, 2, 'Mitesh ', 'Madhuram', 'Junagadh', '362001', '9979385180', 40020, 0, 0, 40020, 'Delivered', '2026-03-03 03:12:24'),
(16, 2, 'Saurabh Vora', 'Pune', '.', '362001', '7600022692', 4100, 3280, 0, 820, 'Cancelled', '2026-03-03 04:42:31'),
(17, 2, 'Dhruv', 'Ruparel Education', 'Junagadh', '362001', '8866039007', 5500, 0, 0, 5500, 'Cancelled', '2026-03-03 05:02:57'),
(18, 7, 'Praful Katakpara', 'Kadiyavad, Javahar Road,', 'Junagadh', '362001', '8780810913', 68440, 0, 0, 68440, 'Pending', '2026-03-09 16:53:39'),
(19, 2, 'Dilip Makvana', 'Khamdhrol Road, Near Laxmi Narayan Temple, \"Aashirvad\" Tenament', 'Junagadh', '362001', '6354869203', 26700, 0, 0, 26700, 'Pending', '2026-03-13 18:11:43'),
(22, 2, 'Dhruv', 'Sur Sangam', 'Junagadh', '362001', '8866039007', 1200, 0, 0, 1200, 'Pending', '2026-03-13 18:28:49'),
(23, 18, 'Ayush Gohel', 'Nagar Road,', 'Junagadh', '362001', '9265148013', 8400, 0, 0, 8400, 'Delivered', '2026-03-14 04:34:26'),
(24, 2, 'Kajal Sanghavi', 'Pune', 'Junagadh', '362001', '9426117634', 10000, 10000, 0, 0, 'Delivered', '2026-03-15 17:54:25'),
(25, 18, 'Ayush', 'Vanzari Chowk', 'Junagadh', '362001', '9099973740', 4800, 4752, 0, 48, 'Pending', '2026-03-19 04:29:30'),
(26, 19, 'Jayvadan', 'Rayji Baug', 'Junagadh', '362001', '9586540272', 11160, 0, 0, 11160, 'Pending', '2026-03-19 04:35:35');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `item_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`item_id`, `order_id`, `product_name`, `price`, `qty`, `image`) VALUES
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
(37, 10, 'CRUNCHEX - CHILLI LEMON', 10, 1, './Product/lemon_chili.png'),
(38, 11, 'CRUNCHEM - SIMPLY SALTED.', 1200, 3, './Product/sadi_wafers_.png'),
(39, 11, 'SNACK’EM – PONGA MASALA', 600, 2, './Product/ponga_masala.png'),
(40, 11, 'CRUNCHEM - MASALA WAFER', 1200, 1, './Product/masala_wafer.png'),
(41, 12, 'AMAIZE – SIMPLY SALTED NACHOS', 1200, 2, './Product/simple_nachos.jpg'),
(42, 12, 'PUNJABI TADKA', 1200, 1, './Product/punjabi_tadka.jpg'),
(43, 13, 'FARALI CHEVDO', 1800, 1, './Product/farali_chevdo.jpg'),
(44, 14, 'CRUNCHEM - SIMPLY SALTED.', 1200, 3, './Product/sadi_wafers_.png'),
(45, 14, 'CRUNCHEM - MASALA WAFER', 1200, 1, './Product/masala_wafer.png'),
(46, 14, 'CRUNCHEM - TOMATO TWIST', 1200, 1, './Product/tomato_twist.png'),
(47, 14, 'CRUNCHEM - CHAAT CHASKA', 1200, 1, './Product/chat_chaska.png'),
(48, 14, 'MITHA FARALI CHIVDA', 1800, 1, './Product/mitho_chevdo.png'),
(49, 14, 'FARALI CHEVDO', 1800, 1, './Product/farali_chevdo.jpg'),
(50, 14, 'OLEE - DYNOBITE', 1500, 1, './Product/Dyno.png'),
(51, 14, 'OLEE - CHOCO STIX', 1500, 1, './Product/CHOCO_STIK.png'),
(52, 14, 'GIPPI - MASALA NOODLES', 1000, 1, './Product/gippi_new.png'),
(53, 14, 'SOFT IMLY CANDY', 1600, 1, './Product/amli.png'),
(54, 14, 'NIMBU PANI CANDY', 1600, 1, './Product/Limbu.png'),
(55, 14, 'CHOCOLATE CREAM WAFERS', 100, 1, './Product/chocalate.png'),
(56, 14, 'JUICY STRAWBERRY CREAM WAFERS', 1000, 1, './Product/strowbarry.png'),
(57, 14, 'PLAIN KHAKHRA', 800, 1, './Product/plain_khakhra.png'),
(58, 14, 'METHI KHAKRA', 800, 1, './Product/methi_khakra.png'),
(59, 15, 'CRUNCHEM - SIMPLY SALTED.', 1200, 25, './Product/sadi_wafers_.png'),
(60, 15, 'CRUNCHEM - TOMATO TWIST', 1200, 1, './Product/tomato_twist.png'),
(61, 15, 'CRUNCHEM - CHAAT CHASKA', 1200, 1, './Product/chat_chaska.png'),
(62, 15, 'CRUNCHEM - CREAM & ONION', 1200, 1, './Product/cream_onion.png'),
(63, 15, 'CRUNCHEM - PERI PERI', 1200, 1, './Product/peri_peri.png'),
(64, 15, 'CRUNCHEM - PIZZY MASALA', 1200, 1, './Product/pizza.png'),
(65, 15, 'CRUNCHEX - SIMPLY SALTED', 1200, 1, './Product/crunchex_new.jpg'),
(66, 15, 'KHATA MITHA MIX', 1020, 1, './Product/khata_mitha.png'),
(67, 15, 'BANANA WAFERS - MASALA', 1800, 1, './Product/BANANA_MASALA.png'),
(68, 16, 'CRUNCHY COCONUT CREAM WAFERS', 1000, 1, './Product/coconut.png'),
(69, 16, 'CHOCOLATE CREAM WAFERS', 100, 1, './Product/chocalate.png'),
(70, 16, 'TANGY ORANGE CREAM WAFERS', 1000, 1, './Product/Orange.png'),
(71, 16, 'JUICY STRAWBERRY CREAM WAFERS', 1000, 1, './Product/strowbarry.png'),
(72, 16, 'YUMMY VANILLA CREAM WAFERS', 1000, 1, './Product/Venilla.png'),
(75, 17, 'MASALA SHING', 1500, 1, './Product/masala_shing.png'),
(76, 17, 'SALTED PEANUTS', 1500, 1, './Product/sadi_shing.png'),
(77, 17, 'BHUJIA SEV', 500, 1, './Product/BhujiaSev.png'),
(78, 17, 'INSTANT BHEL MIX', 500, 1, './Product/instant_bhel.png'),
(79, 17, 'PAPDI GATHIYA', 1500, 1, './Product/papdi_gathiya.png'),
(82, 18, 'CRUNCHEM - SIMPLY SALTED.', 1200, 6, './Product/sadi_wafers_.png'),
(83, 18, 'CRUNCHEM - MASALA WAFER', 1200, 6, './Product/masala_wafer.png'),
(84, 18, 'CRUNCHEX - CHILI TADKA', 1200, 3, './Product/chili_tadka.png'),
(85, 18, 'CRUNCHEX - SIMPLY SALTED', 1200, 3, './Product/crunchex_new.jpg'),
(86, 18, 'CP – MASALA MASTI', 1200, 1, './Product/chataka_patak.png'),
(87, 18, 'FARALI CHEVDO', 1800, 5, './Product/farali_chevdo.jpg'),
(88, 18, 'MASALA SEV MURMURA', 1200, 4, './Product/masala_mamra.jpg'),
(89, 18, 'PLAIN KHAKHRA', 800, 1, './Product/plain_khakhra.png'),
(90, 18, 'METHI KHAKRA', 800, 1, './Product/methi_khakra.png'),
(91, 18, 'TANGY ORANGE CREAM WAFERS', 1000, 2, './Product/Orange.png'),
(92, 18, 'SOFT IMLY CANDY', 1600, 1, './Product/amli.png'),
(93, 18, 'GIPPI - MASALA NOODLES', 1000, 1, './Product/gippi_new.png'),
(94, 18, 'OLEE - DYNOBITE', 1500, 1, './Product/Dyno.png'),
(95, 18, 'CRUNCHEX - MIRCH MASALA', 1200, 6, './Product/mirch_masala.png'),
(96, 18, 'CRUNCHEM - TOMATO TWIST', 1200, 1, './Product/tomato_twist.png'),
(97, 18, 'WHEELOS - MASALA', 600, 2, './Product/wheelos.png'),
(98, 18, 'ALOO SEV', 1020, 2, './Product/aloo_Sev.jpg'),
(99, 18, 'SEV MURMURA', 1200, 2, './Product/sada_mamra.png'),
(100, 18, 'SALTED PEANUTS', 1500, 1, './Product/sadi_shing.png'),
(101, 18, 'MASALA SHING', 1500, 1, './Product/masala_shing.png'),
(102, 18, 'CRUNCHY COCONUT CREAM WAFERS', 1000, 1, './Product/coconut.png'),
(103, 18, 'NIMBU PANI CANDY', 1600, 1, './Product/Limbu.png'),
(104, 18, 'GIPPI - FLAMIN CHILLI NOODLES', 1000, 2, './Product/gippi_chili.png'),
(105, 18, 'OLEE - CHOCO STIX', 1500, 1, './Product/CHOCO_STIK.png'),
(106, 18, 'CHOCOLATE CREAM WAFERS', 1000, 1, './Product/chocalate.png'),
(107, 19, 'CRUNCHEM - TOMATO TWIST', 1200, 1, './Product/tomato_twist.png'),
(108, 19, 'CRUNCHEM - CHAAT CHASKA', 1200, 1, './Product/chat_chaska.png'),
(109, 19, 'CRUNCHEM - MASALA WAFER', 1200, 5, './Product/masala_wafer.png'),
(110, 19, 'CRUNCHEM - SIMPLY SALTED.', 1200, 6, './Product/sadi_wafers_.png'),
(111, 19, 'MASALA SHING', 1500, 1, './Product/masala_shing.png'),
(112, 19, 'CRUNCHEX - MIRCH MASALA', 1200, 2, './Product/mirch_masala.png'),
(113, 19, 'CRUNCHEX - CHILLI LEMON', 1200, 1, './Product/lemon_chili.png'),
(114, 19, 'RUMBLE - PUDINA TWIST', 1200, 1, './Product/rumble.png'),
(115, 19, 'BANANA WAFERS - MARI', 1800, 1, './Product/BANANA_MARI.png'),
(116, 19, 'TANGY ORANGE CREAM WAFERS', 1000, 1, './Product/Orange.png'),
(117, 19, 'JUICY STRAWBERRY CREAM WAFERS', 1000, 1, './Product/strowbarry.png'),
(118, 19, 'YUMMY VANILLA CREAM WAFERS', 1000, 1, './Product/Venilla.png'),
(122, 20, 'TANGY ORANGE CREAM WAFERS', 1000, 1, './Product/Orange.png'),
(123, 20, 'CRUNCHEM - MASALA WAFER', 1200, 1, './Product/masala_wafer.png'),
(124, 20, 'CRUNCHEM - TOMATO TWIST', 1200, 1, './Product/tomato_twist.png'),
(125, 21, 'CRUNCHY COCONUT CREAM WAFERS', 1000, 1, './Product/coconut.png'),
(126, 21, 'TANGY ORANGE CREAM WAFERS', 1000, 1, './Product/Orange.png'),
(127, 21, 'PUNJABI TADKA', 1200, 1, './Product/punjabi_tadka.jpg'),
(128, 22, 'CRUNCHEM - SIMPLY SALTED.', 1200, 1, './Product/sadi_wafers_.png'),
(129, 23, 'CRUNCHEM - SIMPLY SALTED.', 1200, 5, './Product/sadi_wafers_.png'),
(130, 23, 'CRUNCHEM - MASALA WAFER', 1200, 2, './Product/masala_wafer.png'),
(131, 24, 'TANGY ORANGE CREAM WAFERS', 1000, 3, './Product/Orange.png'),
(132, 24, 'JUICY STRAWBERRY CREAM WAFERS', 1000, 1, './Product/strowbarry.png'),
(133, 24, 'CRUNCHEM - TOMATO TWIST', 1200, 4, './Product/tomato_twist.png'),
(134, 24, 'CRUNCHEM - CHAAT CHASKA', 1200, 1, './Product/chat_chaska.png'),
(138, 25, 'PUNJABI TADKA', 1200, 1, './Product/punjabi_tadka.jpg'),
(139, 25, 'AMAIZE – SIMPLY SALTED NACHOS', 1200, 1, './Product/simple_nachos.jpg'),
(140, 25, 'AMAIZE – FLAMIN HOT NACHOS', 1200, 1, './Product/black_nachos.png'),
(141, 25, 'YUMSTIX', 1200, 1, './Product/yumstix.png'),
(145, 26, 'YUMSTIX', 1200, 2, './Product/yumstix.png'),
(146, 26, 'PUNJABI TADKA', 1200, 1, './Product/punjabi_tadka.jpg'),
(147, 26, 'AMAIZE – SIMPLY SALTED NACHOS', 1200, 1, './Product/simple_nachos.jpg'),
(148, 26, 'AMAIZE – FLAMIN HOT NACHOS', 1200, 3, './Product/black_nachos.png'),
(149, 26, 'SCOOPITOS', 600, 1, './Product/scoopitos.png'),
(150, 26, 'NOODLE STICKS ', 720, 3, './Product/noodle_sticks.png');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `listing_code` int(11) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_price` int(11) DEFAULT NULL,
  `product_category` varchar(100) DEFAULT NULL,
  `product_describe` text DEFAULT NULL,
  `product_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `listing_code`, `code`, `product_name`, `product_price`, `product_category`, `product_describe`, `product_image`) VALUES
(1, 1, 'WF101', 'CRUNCHEM - SIMPLY SALTED.', 1200, 'Wafers', 'Introducing potato wafers with iodised salt for a mild, classic flavor.', './Product/sadi_wafers_.png'),
(2, 2, 'WF102', 'CRUNCHEM - MASALA WAFER', 1200, 'Wafers', 'Pure bliss of spicy indian masala to shake things up a bit.', './Product/masala_wafer.png'),
(3, 3, 'WF103', 'CRUNCHEM - TOMATO TWIST', 1200, 'Wafers', 'Delight in the rich, sweet, and tangy flavors of ripe tomatoes', './Product/tomato_twist.png'),
(4, 4, 'WF105', 'CRUNCHEM - CHAAT CHASKA', 1200, 'Wafers', 'Spicy, tangy, minty yet salty character.', './Product/chat_chaska.png'),
(5, 5, 'WF105', 'CRUNCHEM - CREAM & ONION', 1200, 'Wafers', 'Delicious wafers with sour cream, herbs and onion.', './Product/cream_onion.png'),
(6, 6, 'WF106', 'CRUNCHEM - PERI PERI', 1200, 'Wafers', 'Irresistible chilli heat on crispy wafers.', './Product/peri_peri.png'),
(7, 7, 'WF107', 'CRUNCHEM - PIZZY MASALA', 1200, 'Wafers', 'Pepper, oregano and cheese pizza flavour.', './Product/pizza.png'),
(8, 8, 'WF108', 'CRUNCHEX - SIMPLY SALTED', 1200, 'Wafers', 'Hand cooked classic salted wafers.', './Product/crunchex_new.jpg'),
(9, 9, 'WF109', 'CRUNCHEX - CHILI TADKA', 1200, 'Wafers', 'Hand cooked wafers with fiery chilli kick.', './Product/chili_tadka.png'),
(10, 10, 'WF110', 'CRUNCHEX - MIRCH MASALA', 1200, 'Wafers', 'Crunchy wafers with bold masala blend.', './Product/mirch_masala.png'),
(11, 11, 'WF111', 'CRUNCHEX - CHILLI LEMON', 1200, 'Wafers', 'Tangy lemon and chilli crunch.', './Product/lemon_chili.png'),
(12, 12, 'WF112', 'RUMBLE - PUDINA TWIST', 1200, 'Wafers', 'Refreshing pudina flavour snack.', './Product/rumble.png'),
(13, 13, 'WF113', 'RUMBLE - HOT CHILLI', 1200, 'Wafers', 'Fiery hot chilli crunch.', './Product/hot_Chili.png'),
(14, 14, 'WF114', 'BANANA WAFERS - MASALA', 1800, 'Wafers', 'Spiced banana wafers.', './Product/BANANA_MASALA.png'),
(15, 15, 'WF115', 'BANANA WAFERS - MARI', 1800, 'Wafers', 'Peppered banana wafers.', './Product/BANANA_MARI.png'),
(16, 16, 'WS101', 'YUMSTIX', 1200, 'Western Snacks', 'Chatpata masala snack sticks.', './Product/yumstix.png'),
(17, 17, 'WS102', 'PUNJABI TADKA', 1200, 'Western Snacks', 'Crispy spicy western snack.', './Product/punjabi_tadka.jpg'),
(18, 18, 'WS103', 'AMAIZE – SIMPLY SALTED NACHOS', 1200, 'Western Snacks', 'Classic salted nachos.', './Product/simple_nachos.jpg'),
(19, 19, 'WS104', 'AMAIZE – FLAMIN HOT NACHOS', 1200, 'Western Snacks', 'Flaming hot chilli nachos.', './Product/black_nachos.png'),
(20, 20, 'WS105', 'AMAIZE – CHEESE CHILLI NACHOS', 1200, 'Western Snacks', 'Cheese chilli nachos.', './Product/cheese_nachos.png'),
(21, 21, 'WS106', 'FUNNE – SPICY PUNCH', 720, 'Western Snacks', 'Tube like spicy snack.', './Product/funne.png'),
(22, 22, 'WS107', 'NOODLE STICKS ', 720, 'Western Snacks', 'Crunchy noodle sticks.', './Product/noodle_sticks.png'),
(23, 23, 'WS108', 'SCOOPITOS', 600, 'Western Snacks', 'Light crispy scoop snack.', './Product/scoopitos.png'),
(24, 24, 'WS109', 'POP RINGS – SHAPES', 720, 'Western Snacks', 'Roasted corn cheese rings.', './Product/cheese_ring.jpg'),
(25, 25, 'WS110', 'POP RINGS – MASALA', 720, 'Western Snacks', 'Roasted corn masala rings.', './Product/popring.png'),
(26, 26, 'WS111', 'POP RINGS – SHAPES', 720, 'Western Snacks', 'Corn roasted shapes snack.', './Product/popring_shapes.png'),
(27, 27, 'WS112', 'CP – MASALA MASTI', 1200, 'Western Snacks', 'Spicy evening snack.', './Product/chataka_patak.png'),
(28, 28, 'WS113', 'CP – TANGY TOMATO', 1200, 'Western Snacks', 'Tangy tomato snack.', './Product/chataka_pataka_tomato.png'),
(29, 29, 'WS114', 'CP – FLAMIN HOT', 1200, 'Western Snacks', 'Hot and sour snack.', './Product/chataka_pataka_flamin_hot.png'),
(30, 30, 'WS115', 'CP – CHINESE CHASKA', 1200, 'Western Snacks', 'Chinese flavoured snack.', './Product/chinese_chataka.png'),
(31, 31, 'WS116', 'CP – LASANIYA', 1200, 'Western Snacks', 'Garlic spicy snack.', './Product/lasaniya_chataka.png'),
(32, 32, 'SP101', 'SNACK’EM – PILLOWS MASALA', 600, 'Snack Pellets', 'Masala pillow snack.', './Product/pillow.png'),
(33, 33, 'SP102', 'SNACK’EM – PONGA MASALA', 600, 'Snack Pellets', 'Crispy masala ponga.', './Product/ponga_masala.png'),
(34, 34, 'SP103', 'WHEELOS - MASALA', 600, 'Snack Pellets', 'Wheel shaped snack.', './Product/wheelos.png'),
(35, 35, 'SP104', 'SNACK’EM – CHOKDI', 600, 'Snack Pellets', 'Masaledar crunchy snack.', './Product/CHOKDI.png'),
(36, 36, 'NK101', 'KATAK BATAK – CHILLI LEMON', 1020, 'Namkeen', 'Chilli lemon peanuts.', './Product/katak_batak.png'),
(37, 37, 'NK102', 'KATAK BATAK – DESI MASALA', 1020, 'Namkeen', 'Desi masala peanuts.', './Product/katak_batak_desi.png'),
(38, 38, 'NK103', 'KHATA MITHA MIX', 1020, 'Namkeen', 'Sweet and tangy mix.', './Product/khata_mitha.png'),
(39, 39, 'NK104', 'TIKHA MITHA MIX', 1020, 'Namkeen', 'Sweet spicy mix.', './Product/tikha_mitha.png'),
(40, 40, 'NK105', 'MITHA FARALI CHIVDA', 1800, 'Namkeen', 'Crispy fasting snack.', './Product/mitho_chevdo.png'),
(41, 41, 'NK106', 'FARALI CHEVDO', 1800, 'Namkeen', 'Light spicy chevdo.', './Product/farali_chevdo.jpg'),
(42, 42, 'NK107', 'CHANA JOR GARAM', 1020, 'Namkeen', 'Spicy Indian snack.', './Product/chanajor.png'),
(43, 43, 'NK108', 'BHEL MIX', 1020, 'Namkeen', 'Spicy tangy sweet bhel mix.', './Product/bhel.png'),
(44, 44, 'NK109', 'MUNG DAL', 1440, 'Namkeen', 'Crunchy mung dal.', './Product/mung_dal.png'),
(45, 45, 'NK110', 'CHANA DAL', 1440, 'Namkeen', 'Spicy chana dal.', './Product/chanda_Dal.png'),
(46, 46, 'NK111', 'MASALA PEAS', 1400, 'Namkeen', 'Chilli coated peas.', './Product/masala_pead.png'),
(47, 47, 'NK112', 'SHING BHUJIA', 1440, 'Namkeen', 'Masala peanuts bhujia.', './Product/shing_bhujia.png'),
(48, 48, 'NK113', 'NIMBU SHING BHUJIA', 1440, 'Namkeen', 'Lemon peanuts bhujia.', './Product/nimbu_bhujia.png'),
(49, 49, 'NK114', 'ALOO SEV', 1020, 'Namkeen', 'Classic aloo sev.', './Product/aloo_Sev.jpg'),
(50, 50, 'NK115', 'CLASSIC SEV', 1020, 'Namkeen', 'Salted sev snack.', './Product/classic_Sev.png'),
(51, 51, 'NK116', 'GATHIYA', 1020, 'Namkeen', 'Gujarati gathiya snack.', './Product/gathiya.png'),
(52, 52, 'NK117', 'NAVRATAN MIX', 1020, 'Namkeen', 'Mixed namkeen snack.', './Product/navratn-mix.png'),
(53, 53, 'NK118', 'SEV MURMURA', 1200, 'Namkeen', 'Sev kurmura mix.', './Product/sada_mamra.png'),
(54, 54, 'NK119', 'MASALA SEV MURMURA', 1200, 'Namkeen', 'Masala murmura mix.', './Product/masala_mamra.jpg'),
(55, 55, 'NK120', 'MASALA CHANA', 1200, 'Namkeen', 'Spicy chickpeas.', './Product/masala_chana.png'),
(56, 56, 'NK121', 'RATLAMI SEV', 1200, 'Namkeen', 'Ratlami style sev.', './Product/ratlami_sev.png'),
(57, 57, 'NK122', 'PAPDI GATHIYA', 1500, 'Namkeen', 'Crunchy papdi gathiya.', './Product/papdi_gathiya.png'),
(58, 58, 'NK123', 'BHUJIA SEV', 500, 'Namkeen', 'Crunchy spicy bhujia sev.', './Product/BhujiaSev.png'),
(59, 59, 'NK124', 'INSTANT BHEL MIX', 500, 'Namkeen', 'Instant bhel mix.', './Product/instant_bhel.png'),
(60, 60, 'PA101', 'SALTED PEANUTS', 1500, 'Peantus', 'Salted peanuts snack.', './Product/sadi_shing.png'),
(61, 61, 'PA102', 'MASALA SHING', 1500, 'Peantus', 'Masala peanuts.', './Product/masala_shing.png'),
(62, 62, 'KH101', 'PLAIN KHAKHRA', 800, 'Khakhra', 'Classic Gujarati khakhra.', './Product/plain_khakhra.png'),
(63, 63, 'KH102', 'MASALA KHAKHRA', 800, 'Khakhra', 'Masala flavoured khakhra.', './Product/masala_khakhra.png'),
(64, 64, 'KH103', 'METHI KHAKRA', 800, 'Khakhra', 'Fenugreek khakhra.', './Product/methi_khakra.png'),
(65, 65, 'KH104', 'JEERA KHAKHRA', 800, 'Khakhra', 'Jeera flavoured khakhra.', './Product/jeera_khakhra.png'),
(66, 66, 'CH101', 'CHOCOLATE CREAM WAFERS', 1000, 'Wafer Biscuit', 'Chocolate cream wafers.', './Product/chocalate.png'),
(67, 67, 'CH102', 'TANGY ORANGE CREAM WAFERS', 1000, 'Wafer Biscuit', 'Orange cream wafers.', './Product/Orange.png'),
(68, 68, 'CH103', 'JUICY STRAWBERRY CREAM WAFERS', 1000, 'Wafer Biscuit', 'Strawberry wafers.', './Product/strowbarry.png'),
(69, 69, 'CH104', 'YUMMY VANILLA CREAM WAFERS', 1000, 'Wafer Biscuit', 'Vanilla cream wafers.', './Product/Venilla.png'),
(70, 70, 'CH105', 'CRUNCHY COCONUT CREAM WAFERS', 1000, 'Wafer Biscuit', 'Coconut wafers.', './Product/coconut.png'),
(71, 71, 'CF101', 'SOFT IMLY CANDY', 1600, 'Confectionary', 'Tamarind candy.', './Product/amli.png'),
(72, 72, 'CF102', 'NIMBU PANI CANDY', 1600, 'Confectionary', 'Lemon candy.', './Product/Limbu.png'),
(73, 73, 'GN101', 'GIPPI - MASALA NOODLES', 1000, 'Gippi', 'Masala noodles.', './Product/gippi_new.png'),
(74, 74, 'GN102', 'GIPPI - FLAMIN CHILLI NOODLES', 1000, 'Gippi', 'Spicy chilli noodles.', './Product/gippi_chili.png'),
(75, 75, 'OE101', 'OLEE - DYNOBITE', 1500, 'Olee', 'Chocolate wafer bar.', './Product/Dyno.png'),
(76, 76, 'OE102', 'OLEE - CHOCO STIX', 1500, 'Olee', 'Chocolate wafer sticks.', './Product/CHOCO_STIK.png');

-- --------------------------------------------------------

--
-- Table structure for table `promo`
--

CREATE TABLE `promo` (
  `id` int(11) NOT NULL,
  `code_name` varchar(50) NOT NULL,
  `discount_percentage` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `category_name` varchar(100) DEFAULT NULL,
  `min_order_amount` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `promo`
--

INSERT INTO `promo` (`id`, `code_name`, `discount_percentage`, `description`, `category_name`, `min_order_amount`) VALUES
(2, 'WELCOME20', 20, 'Special 20% off for our new customers.', 'Namkeen', 0),
(3, 'FREE50', 50, 'Mega sale: Flat 50% discount!', NULL, 0),
(6, 'VIMAL10', 10, '10% off on total order', NULL, 0),
(7, 'WAFERS20', 20, '20% off only on Wafers', 'Wafers', 200),
(8, 'MEGA99', 99, '99% OFF on orders above 4500', 'All', 4500),
(12, 'BIRTHDAY', 80, 'All Wafer Biscuit', 'Wafer Biscuit', 1000);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) DEFAULT 'user',
  `status` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `mobile`, `dob`, `password`, `role`, `status`, `created_at`) VALUES
(1, 'Admin', 'admin@gmail.com', NULL, NULL, '123', 'admin', 1, '2026-02-09 11:27:14'),
(2, 'Karan', 'karansanghvi7143@gmail.com', '9054541906', '2006-10-12', '123', 'admin', 1, '2026-02-09 11:27:25'),
(3, 'Vimal', 'vimal@gmail.com', NULL, NULL, '123', 'user', 1, '2026-02-09 14:03:34'),
(4, 'hemit', 'hemit@va.com', NULL, NULL, '123', 'user', 1, '2026-02-11 02:55:10'),
(5, 'extra', 'ext@gmail.com', NULL, NULL, '1', 'admin', 1, '2026-02-11 04:27:51'),
(6, 'harsh', 'harsh@va.com', NULL, NULL, '123', 'user', 1, '2026-02-11 15:29:53'),
(7, 'praful', 'praful13katakpara@gmail.com', NULL, NULL, '123', 'user', 1, '2026-02-12 03:06:41'),
(8, 'divyesh', 'divyesh@va.com', NULL, NULL, 'DDD', 'user', 1, '2026-02-12 03:16:34'),
(9, 'Dhruv', 'dhruv@va.com', NULL, NULL, '123', 'user', 1, '2026-02-12 03:50:40'),
(10, 'Aman', 'aman@va.com', NULL, NULL, 'Aman', 'user', 1, '2026-02-14 03:38:38'),
(15, 'Meet', 'meet@va.com', NULL, NULL, '123', 'user', 1, '2026-02-15 14:30:12'),
(16, 'Sujal', 'sujal@va.com', NULL, NULL, '1', 'user', 0, '2026-02-24 03:35:42'),
(18, 'Ayush', 'ayushgohel634@gmail.com', NULL, NULL, '123', 'user', 1, '2026-03-14 04:33:43'),
(19, 'Divyang', 'divyangdhanesha06@gmail.com', NULL, NULL, '123', 'user', 1, '2026-03-19 04:31:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_notes`
--
ALTER TABLE `admin_notes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `contact_us`
--
ALTER TABLE `contact_us`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`listing_code`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `promo`
--
ALTER TABLE `promo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_name` (`code_name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_notes`
--
ALTER TABLE `admin_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=172;

--
-- AUTO_INCREMENT for table `contact_us`
--
ALTER TABLE `contact_us`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `offers`
--
ALTER TABLE `offers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `promo`
--
ALTER TABLE `promo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

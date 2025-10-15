-- Create database
CREATE DATABASE IF NOT EXISTS product_db;
USE product_db;

-- Sample categories data (will be auto-created by TypeORM, but we'll add data)
-- Tables will be created automatically by TypeORM synchronize feature

-- Sample data for categories (to be inserted after tables are created)
-- INSERT INTO kategori (nama_kategori) VALUES 
-- ('Elektronik'),
-- ('Pakaian'),
-- ('Makanan & Minuman'),
-- ('Peralatan Rumah'),
-- ('Otomotif'),
-- ('Kesehatan & Kecantikan'),
-- ('Buku & Alat Tulis'),
-- ('Mainan & Hobi');

-- Sample data for products (to be inserted after tables are created)
-- INSERT INTO barang (nama_barang, kategori_id, stok, kelompok_barang, harga) VALUES
-- ('Laptop Gaming ASUS ROG', 1, 15, 'Premium', 15000000.00),
-- ('Smartphone Samsung Galaxy', 1, 25, 'Premium', 8500000.00),
-- ('Kemeja Formal Putih', 2, 50, 'Regular', 250000.00),
-- ('Celana Jeans Denim', 2, 30, 'Regular', 350000.00),
-- ('Kopi Arabica Premium', 3, 100, 'Premium', 75000.00),
-- ('Teh Hijau Organik', 3, 80, 'Regular', 45000.00),
-- ('Panci Stainless Steel', 4, 20, 'Regular', 180000.00),
-- ('Blender Philips', 4, 12, 'Premium', 450000.00);
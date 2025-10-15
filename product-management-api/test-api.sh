#!/bin/bash

echo "Testing NestJS API Endpoints..."

# Test 1: Create categories
echo "1. Creating categories..."
curl -X POST http://localhost:3001/api/categories -H "Content-Type: application/json" -d '{"nama_kategori": "Elektronik"}'
echo ""

curl -X POST http://localhost:3001/api/categories -H "Content-Type: application/json" -d '{"nama_kategori": "Pakaian"}'
echo ""

curl -X POST http://localhost:3001/api/categories -H "Content-Type: application/json" -d '{"nama_kategori": "Makanan & Minuman"}'
echo ""

# Test 2: Get all categories
echo "2. Getting all categories..."
curl -X GET http://localhost:3001/api/categories
echo ""

# Test 3: Create products
echo "3. Creating products..."
curl -X POST http://localhost:3001/api/products -H "Content-Type: application/json" -d '{
  "nama_barang": "Laptop Gaming ASUS ROG",
  "kategori_id": 1,
  "stok": 15,
  "kelompok_barang": "Premium",
  "harga": 15000000
}'
echo ""

curl -X POST http://localhost:3001/api/products -H "Content-Type: application/json" -d '{
  "nama_barang": "Smartphone Samsung Galaxy",
  "kategori_id": 1,
  "stok": 25,
  "kelompok_barang": "Premium",
  "harga": 8500000
}'
echo ""

curl -X POST http://localhost:3001/api/products -H "Content-Type: application/json" -d '{
  "nama_barang": "Kemeja Formal Putih",
  "kategori_id": 2,
  "stok": 50,
  "kelompok_barang": "Regular",
  "harga": 250000
}'
echo ""

# Test 4: Get all products
echo "4. Getting all products..."
curl -X GET http://localhost:3001/api/products
echo ""

# Test 5: Search products
echo "5. Searching products..."
curl -X GET "http://localhost:3001/api/products/search?q=laptop"
echo ""

echo "API testing completed!"
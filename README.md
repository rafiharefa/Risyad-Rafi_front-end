# Product Management System

A complete full-stack mobile application for product management built with **Flutter** (frontend) and **NestJS** (backend API) with MySQL database.

## 🏗️ Project Structure

```
siscom/
├── product_management_app/     # Flutter Mobile App
│   ├── lib/
│   │   ├── app/
│   │   │   ├── modules/
│   │   │   │   └── products/   # Product management module
│   │   │   └── data/           # Models and services
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── README.md
├── product-management-api/     # NestJS Backend API
│   ├── src/
│   │   ├── categories/         # Categories module
│   │   ├── products/           # Products module
│   │   └── main.ts
│   ├── database-setup.sql      # Database initialization script
│   ├── package.json
│   └── README.md
└── README.md                   # This file
```

## 🚀 Features

### Mobile App (Flutter)
- ✅ **Product Management** - Complete CRUD operations
- ✅ **Category Management** - Dropdown selection
- ✅ **Search Functionality** - Real-time product search
- ✅ **Bulk Operations** - Multi-select and bulk delete
- ✅ **Pagination** - Efficient data loading
- ✅ **Responsive UI** - Professional material design
- ✅ **Form Validation** - Input validation and error handling
- ✅ **State Management** - GetX for reactive UI

### Backend API (NestJS)
- ✅ **RESTful API** - Complete REST endpoints
- ✅ **Database Integration** - TypeORM with MySQL
- ✅ **Data Validation** - Class-validator for input validation
- ✅ **CORS Support** - Ready for mobile app integration
- ✅ **Error Handling** - Comprehensive error responses
- ✅ **Pagination Support** - Query-based pagination
- ✅ **Search Capability** - Product name search

## 🛠️ Technology Stack

| Component | Technology | Version |
|-----------|------------|---------|
| **Frontend** | Flutter | 3.9.2+ |
| **State Management** | GetX | 4.7.2 |
| **HTTP Client** | http | 1.5.0 |
| **Backend** | NestJS | 11.0.1 |
| **Database** | MySQL | 8.0+ |
| **ORM** | TypeORM | 11.0.0 |
| **Validation** | class-validator | 0.14.2 |

## 📋 Prerequisites

Before running this project, make sure you have the following installed:

- **Node.js** (v18 or higher)
- **Flutter SDK** (3.9.2 or higher)
- **MySQL** (8.0 or higher)
- **Android Studio** (for Android development)
- **VS Code** (recommended editor)

## 🗄️ Database Setup

### 1. Install MySQL
```bash
# macOS (using Homebrew)
brew install mysql
brew services start mysql

# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql

# Windows
# Download and install from https://dev.mysql.com/downloads/mysql/
```

### 2. Create Database and Tables

Run the following SQL script to set up the database:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS product_db;
USE product_db;

-- Categories table (will be auto-created by TypeORM)
-- But you can create manually if needed:
CREATE TABLE IF NOT EXISTS kategori (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(255) NOT NULL
);

-- Products table (will be auto-created by TypeORM)
-- But you can create manually if needed:
CREATE TABLE IF NOT EXISTS barang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_barang VARCHAR(255) NOT NULL,
    kategori_id INT,
    stok INT DEFAULT 0,
    kelompok_barang VARCHAR(255),
    harga DECIMAL(15,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (kategori_id) REFERENCES kategori(id) ON DELETE SET NULL
);

-- Insert sample categories
INSERT INTO kategori (nama_kategori) VALUES 
('Elektronik'),
('Pakaian'),
('Makanan & Minuman'),
('Peralatan Rumah'),
('Otomotif'),
('Kesehatan & Kecantikan'),
('Buku & Alat Tulis'),
('Mainan & Hobi');

-- Insert sample products
INSERT INTO barang (nama_barang, kategori_id, stok, kelompok_barang, harga) VALUES
('Laptop Gaming ASUS ROG', 1, 15, 'Premium', 15000000.00),
('Smartphone Samsung Galaxy', 1, 25, 'Premium', 8500000.00),
('Kemeja Formal Putih', 2, 50, 'Regular', 250000.00),
('Celana Jeans Denim', 2, 30, 'Regular', 350000.00),
('Kopi Arabica Premium', 3, 100, 'Premium', 75000.00),
('Teh Hijau Organik', 3, 80, 'Regular', 45000.00),
('Panci Stainless Steel', 4, 20, 'Regular', 180000.00),
('Blender Philips', 4, 12, 'Premium', 450000.00);
```

### 3. Alternative: Use the provided SQL file
```bash
mysql -u root -p < product-management-api/database-setup.sql
```

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd siscom
```

### 2. Backend Setup (NestJS API)
```bash
# Navigate to API directory
cd product-management-api

# Install dependencies
npm install

# Setup environment variables
cp .env.example .env

# Edit .env file with your database credentials
# DB_HOST=localhost
# DB_PORT=3306
# DB_USERNAME=root
# DB_PASSWORD=your_password
# DB_NAME=product_db
# PORT=3001

# Start the API server
npm run start:dev
```

The API will be running at `http://localhost:3001`

### 3. Frontend Setup (Flutter App)
```bash
# Navigate to Flutter app directory
cd ../product_management_app

# Get Flutter dependencies
flutter pub get

# Run the app (make sure you have an emulator/device connected)
flutter run
```

## 📱 Mobile App Usage

### Key Features:
1. **Product List**: View all products with pagination
2. **Search**: Search products by name in real-time
3. **Add Product**: Create new products with category selection
4. **Edit Product**: Update existing product information
5. **Delete**: Single or bulk delete operations
6. **Categories**: Manage product categories

### Navigation:
- **Home Screen**: Product list with search and actions
- **Add/Edit Forms**: Comprehensive product forms
- **Selection Mode**: Long-press to enter multi-select mode

## 📡 API Endpoints

### Categories
- `GET /api/categories` - Get all categories
- `POST /api/categories` - Create new category
- `PATCH /api/categories/:id` - Update category
- `DELETE /api/categories/:id` - Delete category

### Products
- `GET /api/products` - Get products (with pagination & search)
- `POST /api/products` - Create new product
- `PATCH /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete single product
- `DELETE /api/products/bulk` - Bulk delete products

### Query Parameters
- `page` - Page number for pagination
- `limit` - Items per page
- `search` - Search term for product names

## 🧪 Testing

### Backend API Testing
```bash
cd product-management-api

# Start the server
npm run start:dev

# Test API endpoints (if test script exists)
./test-api.sh
```

### Flutter App Testing
```bash
cd product_management_app

# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 🔧 Configuration

### Backend Configuration (.env)
```env
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=your_password
DB_NAME=product_db
PORT=3001
NODE_ENV=development
```

### Flutter Configuration
The app automatically detects the platform and uses appropriate API URLs:
- **Android Emulator**: `http://10.0.2.2:3001`
- **iOS Simulator**: `http://localhost:3001`
- **Physical Device**: Update IP address in API service

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ Supported | Tested on Android 8.0+ |
| **iOS** | ✅ Supported | Tested on iOS 12.0+ |
| **Web** | 🚧 Experimental | Limited testing |

## 🐛 Troubleshooting

### Common Issues:

1. **Database Connection Error**
   - Ensure MySQL is running
   - Check credentials in `.env` file
   - Verify database exists

2. **Flutter App Can't Connect to API**
   - For Android emulator, use `10.0.2.2:3001`
   - For iOS simulator, use `localhost:3001`
   - For physical devices, use your computer's IP address

3. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Ensure Flutter SDK is up to date
   - Check minimum SDK requirements

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [NestJS Documentation](https://docs.nestjs.com/)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [TypeORM Documentation](https://typeorm.io/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- **Development Team** - Initial work and maintenance

## 🔄 Version History

- **v1.0.0** - Initial release with full CRUD functionality
- Complete product management system
- Reactive UI with GetX state management
- RESTful API with comprehensive validation

---

## 🎯 Quick Start Summary

1. **Setup Database**: Run MySQL and execute the SQL script above
2. **Start Backend**: `cd product-management-api && npm install && npm run start:dev`
3. **Start Frontend**: `cd product_management_app && flutter pub get && flutter run`
4. **Test**: Open the app and start managing products!

**API Base URL**: `http://localhost:3001`  
**App Platform**: Android/iOS Mobile Application
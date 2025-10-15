# Product Management API

Backend API for Product Management System built with NestJS, TypeORM, and MySQL.

## 🚀 Features

- **Complete CRUD Operations** for Products and Categories
- **Search Functionality** - Search products by name
- **Pagination** - Efficient data loading
- **Bulk Operations** - Delete multiple products at once
- **Input Validation** - Data validation using class-validator
- **Database Relations** - Foreign key relationships
- **CORS Enabled** - Ready for Flutter frontend

## 📋 Requirements Met

✅ Categories management (dropdown for Flutter)  
✅ Product CRUD operations (nama_barang, kategori_id, stok, kelompok_barang, harga)  
✅ Search products by name  
✅ Bulk delete functionality  
✅ Pagination support  
✅ Input validation and error handling  

## 🛠️ Installation

```bash
# Install dependencies
npm install

# Setup environment variables
cp .env.example .env
# Edit .env with your database credentials

# Start MySQL service
brew services start mysql

# Create database
mysql -u root -e "CREATE DATABASE IF NOT EXISTS product_db;"

# Start the application
npm start
# or for development
npm run start:dev
```

## 🗄️ Database Schema

### Categories Table (kategori)
- `id` - Primary key
- `nama_kategori` - Category name

### Products Table (barang)
- `id` - Primary key
- `nama_barang` - Product name
- `kategori_id` - Foreign key to categories
- `stok` - Stock quantity
- `kelompok_barang` - Product group
- `harga` - Price
- `created_at` - Creation timestamp
- `updated_at` - Update timestamp

## 📡 API Endpoints

### Categories
- `GET /api/categories` - Get all categories
- `POST /api/categories` - Create new category
- `GET /api/categories/:id` - Get specific category
- `PATCH /api/categories/:id` - Update category
- `DELETE /api/categories/:id` - Delete category

### Products
- `GET /api/products` - Get all products (supports pagination & search)
- `POST /api/products` - Create new product
- `GET /api/products/:id` - Get specific product
- `PATCH /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete single product
- `DELETE /api/products/bulk` - Bulk delete products
- `GET /api/products/search?q={query}` - Search products

## 🧪 Testing

Run the API test script:
```bash
# Make sure server is running first
npm start

# In another terminal
./test-api.sh
```

## 🔧 Configuration

Environment variables in `.env`:
```
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=
DB_NAME=product_db
PORT=3001
NODE_ENV=development
```

## 🏗️ Project Structure

```
src/
├── app.module.ts          # Main application module
├── main.ts               # Application entry point
├── config/
│   └── database.config.ts # Database configuration
├── categories/           # Categories module
│   ├── categories.controller.ts
│   ├── categories.service.ts
│   ├── categories.module.ts
│   ├── dto/
│   └── entities/
└── products/            # Products module
    ├── products.controller.ts
    ├── products.service.ts
    ├── products.module.ts
    ├── dto/
    └── entities/
```

## 🎯 Frontend Integration

This API is designed to work with a Flutter frontend application. The base URL is:
```
http://localhost:3001
```

Perfect for mobile app development with features like:
- Product listing with pagination
- Search functionality
- Add/Edit/Delete operations
- Category dropdown data
- Bulk operations support

## 🚀 Deployment Notes

For production deployment:
1. Set `NODE_ENV=production` in environment
2. Use proper database credentials
3. Consider using PM2 for process management
4. Set up proper CORS origins for security
  <!--[![Backers on Open Collective](https://opencollective.com/nest/backers/badge.svg)](https://opencollective.com/nest#backer)
  [![Sponsors on Open Collective](https://opencollective.com/nest/sponsors/badge.svg)](https://opencollective.com/nest#sponsor)-->

## Description

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Project setup

```bash
$ npm install
```

## Compile and run the project

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deployment

When you're ready to deploy your NestJS application to production, there are some key steps you can take to ensure it runs as efficiently as possible. Check out the [deployment documentation](https://docs.nestjs.com/deployment) for more information.

If you are looking for a cloud-based platform to deploy your NestJS application, check out [Mau](https://mau.nestjs.com), our official platform for deploying NestJS applications on AWS. Mau makes deployment straightforward and fast, requiring just a few simple steps:

```bash
$ npm install -g @nestjs/mau
$ mau deploy
```

With Mau, you can deploy your application in just a few clicks, allowing you to focus on building features rather than managing infrastructure.

## Resources

Check out a few resources that may come in handy when working with NestJS:

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.
- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).
- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).
- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.
- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).
- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).
- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).
- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).

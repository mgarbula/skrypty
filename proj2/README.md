# Mikolaj's Shop

A simple shop application with a REST API server and React client.

## Installation

```bash
npm install
```

## Running

```bash
npm start
```

The server will start on `http://localhost:3000`.

## API Endpoints

- `GET /api/products` — Get all products
- `POST /api/products` — Add a product (requires name and price)
- `DELETE /api/products/:id` — Remove a product by ID

## Admin Pages

- `/admin/addProduct` — Add a new product
- `/admin/removeProduct` — Remove a product by ID

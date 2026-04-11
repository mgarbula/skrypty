const express = require("express");
const path = require("path");
const sqlite3 = require("sqlite3").verbose();

const app = express();
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

// Initialize database
const db = new sqlite3.Database("./products.db", (err) => {
  if (err) {
    console.error("Error opening database:", err.message);
  } else {
    console.log("Connected to SQLite database.");
  }
});

// Create products table if it doesn't exist
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      description TEXT
    )
  `);

  // Insert initial products if table is empty
  db.get("SELECT COUNT(*) as count FROM products", (err, row) => {
    if (err) {
      console.error("Error checking products count:", err.message);
    } else if (row.count === 0) {
      const initialProducts = [
        { name: "Lord of The Rings", price: 60.99, description: "Amazing book about hobbits" },
        { name: "Notebook", price: 6.5, description: "Cool notebook you can write in" }
      ];

      const stmt = db.prepare("INSERT INTO products (name, price, description) VALUES (?, ?, ?)");
      initialProducts.forEach(product => {
        stmt.run(product.name, product.price, product.description);
      });
      stmt.finalize();
      console.log("Initial products inserted.");
    }
  });
});

app.get("/api/products", (req, res) => {
  db.all("SELECT * FROM products", (err, rows) => {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }
    res.json(rows);
  });
});

app.post("/api/products", (req, res) => {
  const { name, price, description } = req.body;
  if (!name || price == null) {
    return res.status(400).json({ error: "name and price are required" });
  }

  const stmt = db.prepare("INSERT INTO products (name, price, description) VALUES (?, ?, ?)");
  stmt.run(name, Number(price), description || "", function(err) {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({
      id: this.lastID,
      name,
      price: Number(price),
      description: description || ""
    });
  });
  stmt.finalize();
});

app.delete("/api/products/:id", (req, res) => {
  const id = Number(req.params.id);
  const stmt = db.prepare("DELETE FROM products WHERE id = ?");
  stmt.run(id, function(err) {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }
    if (this.changes === 0) {
      return res.status(404).json({ error: "Product not found" });
    }
    res.json({ id, message: "Product deleted" });
  });
  stmt.finalize();
});

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Shop server listening at http://localhost:${port}`);
});

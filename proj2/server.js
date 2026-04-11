const express = require("express");
const path = require("path");

const app = express();
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const products = [
  { id: 1, name: "Lord of The Rings", price: 60.99, description: "Amazing book about hobbits" },
  { id: 2, name: "Notebook", price: 6.5, description: "Cool notebook you can write in" }
];
let nextId = 3;

app.get("/api/products", (req, res) => {
  res.json(products);
});

app.post("/api/products", (req, res) => {
  const { name, price, description } = req.body;
  if (!name || price == null) {
    return res.status(400).json({ error: "name and price are required" });
  }

  const product = {
    id: nextId++,
    name,
    price: Number(price),
    description: description || ""
  };

  products.push(product);
  res.status(201).json(product);
});

app.delete("/api/products/:id", (req, res) => {
  const id = Number(req.params.id);
  const index = products.findIndex((product) => product.id === id);

  if (index === -1) {
    return res.status(404).json({ error: "Product not found" });
  }

  const [deletedProduct] = products.splice(index, 1);
  res.json(deletedProduct);
});

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Shop server listening at http://localhost:${port}`);
});

const { useState, useEffect } = React;

function App() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function loadProducts() {
      setLoading(true);
      setError(null);

      try {
        const response = await fetch("/api/products");
        if (!response.ok) {
          throw new Error(`API returned status ${response.status}`);
        }
        const data = await response.json();
        setProducts(data);
      } catch (err) {
        setError("Unable to load products.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    }

    loadProducts();
  }, []);

  return (
    <>
      <header>
        <h1>Mikolaj's Shop</h1>
        <p>Shop with many amazing things.</p>
      </header>

      <section className="products">
        <h2>Available products</h2>
        {loading ? (
          <div className="loading">Loading products...</div>
        ) : error ? (
          <div className="error">{error}</div>
        ) : products.length === 0 ? (
          <div className="empty">No products available.</div>
        ) : (
          <div className="product-list">
            {products.map((product) => (
              <article key={product.id} className="product-card">
                <h3>{product.name}</h3>
                <p className="description">{product.description}</p>
                <p className="price">Price: ${product.price.toFixed(2)}</p>
                <p className="product-id">ID: {product.id}</p>
              </article>
            ))}
          </div>
        )}
      </section>

      <section className="notes">
        <h2>Admin tools</h2>
        <p>Open these pages to manage shop products:</p>
        <ul>
          <li><a href="/admin/addProduct">Add Product</a></li>
          <li><a href="/admin/removeProduct">Remove Product</a></li>
        </ul>
      </section>
    </>
  );
}

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<App />);

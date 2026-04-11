const { useState } = React;

function AddProductApp() {
  const [name, setName] = useState("");
  const [price, setPrice] = useState("");
  const [description, setDescription] = useState("");
  const [message, setMessage] = useState(null);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(event) {
    event.preventDefault();
    setSubmitting(true);
    setError(null);
    setMessage(null);

    try {
      const response = await fetch("/api/products", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: name.trim(),
          price: Number(price),
          description: description.trim()
        })
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.error || "Failed to add product.");
      }

      const product = await response.json();
      setMessage(`Product added: ${product.name} (ID ${product.id})`);
      setName("");
      setPrice("");
      setDescription("");
    } catch (err) {
      setError(err.message || "Unable to add product.");
      console.error(err);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <>
      <header>
        <h1>Add Product</h1>
        <a className="back-link" href="/">← Back to shop</a>
      </header>

      <section className="form-card">
        <form onSubmit={handleSubmit}>
          <label>
            Name
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </label>

          <label>
            Price
            <input
              type="number"
              step="0.01"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
              required
            />
          </label>

          <label>
            Description
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </label>

          <button type="submit" disabled={submitting}>
            {submitting ? "Adding…" : "Add product"}
          </button>
        </form>

        {message && <div className="success">{message}</div>}
        {error && <div className="error">{error}</div>}
      </section>
    </>
  );
}

const addRoot = ReactDOM.createRoot(document.getElementById("root"));
addRoot.render(<AddProductApp />);

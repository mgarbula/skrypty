const { useState } = React;

function RemoveProductApp() {
  const [id, setId] = useState("");
  const [message, setMessage] = useState(null);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(event) {
    event.preventDefault();
    setSubmitting(true);
    setMessage(null);
    setError(null);

    try {
      const response = await fetch(`/api/products/${encodeURIComponent(id)}`, {
        method: "DELETE"
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.error || "Failed to delete product.");
      }

      const deleted = await response.json();
      setMessage(`Deleted product: ${deleted.name} (ID ${deleted.id})`);
      setId("");
    } catch (err) {
      setError(err.message || "Unable to delete product.");
      console.error(err);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <>
      <header>
        <h1>Remove Product</h1>
        <a className="back-link" href="/">← Back to shop</a>
      </header>

      <section className="form-card">
        <form onSubmit={handleSubmit}>
          <label>
            Product ID
            <input
              type="number"
              min="1"
              value={id}
              onChange={(e) => setId(e.target.value)}
              required
            />
          </label>

          <button type="submit" disabled={submitting}>
            {submitting ? "Removing…" : "Remove product"}
          </button>
        </form>

        {message && <div className="success">{message}</div>}
        {error && <div className="error">{error}</div>}
      </section>
    </>
  );
}

const removeRoot = ReactDOM.createRoot(document.getElementById("root"));
removeRoot.render(<RemoveProductApp />);

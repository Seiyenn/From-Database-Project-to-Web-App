import { useEffect, useState } from "react";
import { getApplications, deleteApplication } from "../api.js";
import SearchBar from "./SearchBar.jsx";
import ItemTable from "./ItemTable.jsx";

export default function ItemsPage() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [search, setSearch] = useState("");

  // Load the applications once, when the page first appears
  useEffect(() => {
    getApplications()
      .then((data) => setItems(data))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, []);

  // Delete on the server first; if that works, remove the row from state
  async function handleDelete(id) {
    try {
      await deleteApplication(id);
      // Notice we use application_id here instead of id
      setItems(items.filter((item) => item.application_id !== id));
    } catch (err) {
      setError(err.message);
    }
  }

  // Filter by student name
  const shown = items.filter((item) =>
    item.student_name.toLowerCase().includes(search.toLowerCase())
  );

  if (loading) return <p>Loading applications…</p>;
  if (error) return <p className="error">Something went wrong: {error}</p>;

  return (
    <main>
      <h1>Scholarship Applications</h1>
      <SearchBar value={search} onChange={setSearch} />
      <ItemTable items={shown} onDelete={handleDelete} />
    </main>
  );
}
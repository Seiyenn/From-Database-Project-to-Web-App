import ItemRow from "./ItemRow.jsx";

export default function ItemTable({ items, onDelete }) {
  if (items.length === 0) {
    return <p className="empty">No applications match. Try another search.</p>;
  }
  return (
    <div className="table-wrap">
      <table>
        <thead>
          <tr><th>Student</th><th>Status</th><th>Submission Date</th><th></th></tr>
        </thead>
        <tbody>
          {items.map((item) => (
            <ItemRow key={item.application_id} item={item} onDelete={onDelete} />
          ))}
        </tbody>
      </table>
    </div>
  );
}
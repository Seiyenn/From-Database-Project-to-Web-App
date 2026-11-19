// One table row. Receives one item object as a prop.
export default function ItemRow({ item, onDelete }) {
  function handleClick() {
    if (window.confirm(`Delete application for ${item.student_name}?`)) {
      onDelete(item.application_id); // Use application_id here
    }
  }

  return (
    <tr>
      <td>{item.student_name}</td>
      <td><span className={`badge ${item.current_status.toLowerCase().replace(" ", "-")}`}>{item.current_status}</span></td>
      <td>{item.submission_date}</td>
      <td><button type="button" onClick={handleClick}>Delete</button></td>
    </tr>
  );
}
// A search box. The parent owns the text; this component only shows it and reports changes.
export default function SearchBar({ value, onChange }) {
  return (
    <label className="search">
      Search
      <input
        type="search"
        value={value}
        placeholder="e.g. umbrella"
        onChange={(e) => onChange(e.target.value)}
      />
    </label>
  );
}
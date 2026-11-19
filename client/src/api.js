const API = "http://localhost:3000/api";

// fetch + check response.ok + read JSON, in one place
async function request(url, options) {
  const res = await fetch(url, options);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.status === 204 ? null : res.json(); // 204 has no body
}

export function getApplications() {
  return request(`${API}/applications`);
}

export function deleteApplication(id) {
  return request(`${API}/applications/${id}`, { method: "DELETE" });
}
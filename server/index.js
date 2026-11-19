import express from "express";
import cors from "cors";
import "dotenv/config";
import { pool } from "./db.js";
import { validateApplication, isValidId } from "./validate.js";

const app = express();
app.use(cors({ origin: "http://localhost:5173" }));
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Server is running");
});

app.get("/api/health", (req, res) => {
  res.json({ ok: true, time: new Date().toISOString() });
});

// GET /api/applications: every application, with student name
app.get("/api/applications", async (req, res) => {
  try {
    const [rows] = await pool.execute(
      `SELECT a.application_id, a.current_status, a.submission_date, 
              CONCAT(s.first_name, ' ', s.last_name) AS student_name
       FROM applications a
       JOIN students s ON s.student_id = a.student_id
       ORDER BY a.submission_date DESC`
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Could not load applications" });
  }
});

// GET /api/applications/:id: one application with full details
app.get("/api/applications/:id", async (req, res) => {
  try {
    const [rows] = await pool.execute(
      `SELECT a.*, CONCAT(s.first_name, ' ', s.last_name) AS student_name
       FROM applications a
       JOIN students s ON s.student_id = a.student_id
       WHERE a.application_id = ?`,
      [req.params.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: "Application not found" });
    }
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Could not load the application" });
  }
});

// GET /api/students: for dropdowns later
app.get("/api/students", async (req, res) => {
  try {
    const [rows] = await pool.execute("SELECT student_id, first_name, last_name FROM students ORDER BY last_name");
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Could not load students" });
  }
});

// POST /api/applications: add a new application
app.post("/api/applications", async (req, res) => {
  const errors = validateApplication(req.body);
  if (errors.length > 0) return res.status(400).json({ errors });

  const { student_id, scholarship_id, term_id, current_status } = req.body;
  const assigned_staff_id = req.body.assigned_staff_id ?? null;

  try {
    // We use NOW() in MySQL to automatically fill the submission_date
    const [result] = await pool.execute(
      `INSERT INTO applications (student_id, scholarship_id, term_id, assigned_staff_id, submission_date, current_status)
       VALUES (?, ?, ?, ?, NOW(), ?)`,
      [student_id, scholarship_id, term_id, assigned_staff_id, current_status]
    );
    res.status(201).json({ application_id: result.insertId, student_id, scholarship_id, term_id, current_status });
  } catch (err) {
    if (err.code === "ER_NO_REFERENCED_ROW_2") {
      return res.status(400).json({ errors: ["student_id, scholarship_id, or term_id does not exist"] });
    }
    console.error(err);
    res.status(500).json({ error: "Could not save the application" });
  }
});

// PUT /api/applications/:id: replace an application's details
app.put("/api/applications/:id", async (req, res) => {
  if (!isValidId(req.params.id)) return res.status(400).json({ errors: ["invalid id"] });
  const errors = validateApplication(req.body);
  if (errors.length > 0) return res.status(400).json({ errors });

  const { student_id, scholarship_id, term_id, current_status } = req.body;
  const assigned_staff_id = req.body.assigned_staff_id ?? null;

  try {
    const [result] = await pool.execute(
      `UPDATE applications
       SET student_id = ?, scholarship_id = ?, term_id = ?, assigned_staff_id = ?, current_status = ?
       WHERE application_id = ?`,
      [student_id, scholarship_id, term_id, assigned_staff_id, current_status, req.params.id]
    );
    if (result.affectedRows === 0) return res.status(404).json({ error: "Application not found" });
    res.json({ application_id: Number(req.params.id), student_id, scholarship_id, term_id, current_status });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Could not update the application" });
  }
});

// DELETE /api/applications/:id: remove an application
app.delete("/api/applications/:id", async (req, res) => {
  if (!isValidId(req.params.id)) return res.status(400).json({ errors: ["invalid id"] });
  try {
    const [result] = await pool.execute("DELETE FROM applications WHERE application_id = ?", [req.params.id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: "Application not found" });
    res.status(204).end();
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Could not delete the application" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API running at http://localhost:${PORT}`);
});
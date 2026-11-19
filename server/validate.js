const STATUSES = ["Pending", "Under Review", "Approved", "Rejected"];

// Checks an application from req.body. Returns an array of messages; [] means valid.
export function validateApplication(body) {
  const errors = [];
  
  const studentId = Number(body.student_id);
  const scholarshipId = Number(body.scholarship_id);
  const termId = Number(body.term_id);
  const staffId = body.assigned_staff_id ? Number(body.assigned_staff_id) : null;

  if (!Number.isInteger(studentId) || studentId < 1) errors.push("student_id must be a whole number");
  if (!Number.isInteger(scholarshipId) || scholarshipId < 1) errors.push("scholarship_id must be a whole number");
  if (!Number.isInteger(termId) || termId < 1) errors.push("term_id must be a whole number");
  
  if (staffId !== null && (!Number.isInteger(staffId) || staffId < 1)) {
    errors.push("assigned_staff_id must be a whole number if provided");
  }

  if (!STATUSES.includes(body.current_status)) {
    errors.push(`current_status must be one of: ${STATUSES.join(", ")}`);
  }

  return errors;
}

// True only for ids like "7". Rejects "7 OR 1=1", "-1", "abc".
export function isValidId(id) {
  return /^\d+$/.test(id);
}
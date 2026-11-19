CREATE DATABASE IF NOT EXISTS lost_and_found;
USE lost_and_found;

CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  status ENUM('lost', 'found', 'claimed') NOT NULL DEFAULT 'found',
  date_reported DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

INSERT INTO categories (name) VALUES
('Gadgets'), ('IDs and cards'), ('Bags'), ('Umbrellas');

INSERT INTO items (title, description, category_id, status, date_reported) VALUES
('Black umbrella', 'Left on the IIT lobby bench', 4, 'found', '2026-11-09'),
('School ID - J. Dela Cruz', 'Found near the canteen', 2, 'found', '2026-11-10'),
('Blue power bank', 'Lost in IIT-RM3 during WS1', 1, 'lost', '2026-11-12'),
('Green tote bag', 'Has a notebook inside', 3, 'claimed', '2026-11-05'),
('Wired earphones', 'White, in a small pouch', 1, 'found', '2026-11-13');
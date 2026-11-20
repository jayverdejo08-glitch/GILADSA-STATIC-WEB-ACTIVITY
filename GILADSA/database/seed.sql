-- =============================================================================
-- SEED DATA
-- =============================================================================
-- Project: Your App
-- Description: Sample initial dataset for local testing and development.
-- =============================================================================

-- Seed Users
INSERT INTO users (username, email, password_hash, role) VALUES
('alice_admin', 'alice@example.com', '$2b$12$e80yq9g6GkF7sU1O2uI4ee...', 'admin'),
('bob_editor', 'bob@example.com', '$2b$12$v9Xo3nF6wK0mK2eN4oQ1ee...', 'editor'),
('charlie_user', 'charlie@example.com', '$2b$12$p5Lm1qX8vR2tW9zY3aB5ee...', 'user');

-- Seed Categories
INSERT INTO categories (name, slug, description) VALUES
('Technology', 'technology', 'Hardware, software, gadgets, and programming tools.'),
('Design', 'design', 'UI/UX design systems, typography, and creative resources.'),
('Productivity', 'productivity', 'Workflows, project management, and productivity techniques.'),
('General', 'general', 'Uncategorized or miscellaneous items.');

-- Seed Items
INSERT INTO items (title, slug, description, status, price, category_id, user_id) VALUES
('Next-Gen Developer Workstation', 'next-gen-developer-workstation', 'High-performance workstation setup for software engineers.', 'published', 2499.00, 1, 1),
('Design System Starter Kit', 'design-system-starter-kit', 'Comprehensive Figma and CSS component library tokens.', 'published', 49.00, 2, 2),
('Focus Timer Desktop App', 'focus-timer-desktop-app', 'A minimalist Pomodoro application with analytics.', 'draft', 14.99, 3, 2),
('Ergonomic Mechanical Keyboard', 'ergonomic-mechanical-keyboard', 'Split wireless keyboard with hot-swappable switches.', 'published', 189.50, 1, 3),
('Team Sprint Retro Template', 'team-sprint-retro-template', 'Interactive template for agile team retrospectives.', 'archived', 0.00, 3, 1);


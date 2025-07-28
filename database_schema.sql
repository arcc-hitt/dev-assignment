-- Database schema for the dev-assignment application
-- This file contains the SQL to create the required tables

-- Create the prefix table
CREATE TABLE IF NOT EXISTS prefix (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    search_prefix VARCHAR(255) NOT NULL,
    gender VARCHAR(50),
    prefix_of VARCHAR(255)
);

-- Insert sample data
INSERT INTO prefix (search_prefix, gender, prefix_of) VALUES
('Mr.', 'Male', 'S/O,H/O,F/O'),
('Mrs.', 'Female', 'D/O,W/O,M/O'),
('Ms.', 'Female', 'D/O'),
('Master.', 'Male', 'S/O'),
('Baby boy of', 'Male', 'S/O'),
('Baby girl of', 'Female', 'D/O'),
('Mx.', 'Other', ''),
('Dr.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Prof.', '', 'S/O,H/O,F/O,D/O,W/O,M/O');

-- Create indexes for better performance
CREATE INDEX idx_prefix_search ON prefix(search_prefix);
CREATE INDEX idx_prefix_gender ON prefix(gender); 
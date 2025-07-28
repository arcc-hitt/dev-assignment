-- Create the prefix table
CREATE TABLE IF NOT EXISTS prefix (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    search_prefix VARCHAR(50) NOT NULL,
    gender VARCHAR(20),
    prefix_of VARCHAR(255),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_search_prefix (search_prefix),
    INDEX idx_gender (gender),
    INDEX idx_prefix_of (prefix_of)
    );

-- Insert comprehensive sample data for medical prefixes
INSERT INTO prefix (search_prefix, gender, prefix_of) VALUES
-- Basic honorifics
('Mr.', 'Male', 'S/O,H/O,F/O'),
('Mrs.', 'Female', 'D/O,W/O,M/O'),
('Ms.', 'Female', 'D/O'),
('Miss', 'Female', 'D/O'),
('Master', 'Male', 'S/O'),

-- Professional titles
('Dr.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Prof.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Prof. Dr.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),

-- Medical specific prefixes
('Baby boy of', 'Male', 'S/O'),
('Baby girl of', 'Female', 'D/O'),
('Infant', '', 'S/O,D/O'),
('Neonate', '', 'S/O,D/O'),
('Stillborn baby of', '', 'S/O,D/O'),

-- Age-specific prefixes
('Child', '', 'S/O,D/O'),
('Minor', '', 'S/O,D/O'),
('Juvenile', '', 'S/O,D/O'),

-- Gender-neutral and inclusive
('Mx.', 'Other', ''),
('Person', '', 'C/O'),
('Individual', '', 'C/O'),

-- Religious titles
('Rev.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Rev. Dr.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Rev. Fr.', 'Male', 'S/O'),
('Rev. Sr.', 'Female', 'D/O'),
('Swami', 'Male', 'S/O'),
('Sister', 'Female', 'D/O'),
('Brother', 'Male', 'S/O'),

-- Military ranks
('Col.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Maj.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Capt.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Lt.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Sgt.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),

-- Government titles
('Hon.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Rt. Hon.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('His Excellency', 'Male', 'S/O'),
('Her Excellency', 'Female', 'D/O'),

-- Academic titles
('Principal', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Vice Chancellor', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Dean', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Emeritus Prof.', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),

-- Business titles
('CEO', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('President', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Director', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Manager', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),

-- Legal titles
('Justice', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Judge', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Advocate', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Barrister', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),

-- Medical specializations
('Consultant', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Specialist', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Surgeon', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),
('Physician', '', 'S/O,H/O,F/O,D/O,W/O,M/O'),

-- International variants
('Herr', 'Male', 'S/O'),
('Frau', 'Female', 'D/O,W/O'),
('Fraulein', 'Female', 'D/O'),
('Monsieur', 'Male', 'S/O'),
('Madame', 'Female', 'D/O,W/O'),
('Mademoiselle', 'Female', 'D/O'),
('Senor', 'Male', 'S/O'),
('Senora', 'Female', 'D/O,W/O'),
('Senorita', 'Female', 'D/O');

-- Verify the data
SELECT COUNT(*) as total_prefixes FROM prefix;
SELECT gender, COUNT(*) as count FROM prefix GROUP BY gender ORDER BY count DESC;
SELECT
    CASE
        WHEN LENGTH(prefix_of) = 0 OR prefix_of IS NULL THEN 'No relationship specified'
        ELSE 'Has relationship'
        END as relationship_status,
    COUNT(*) as count
FROM prefix
GROUP BY
    CASE
    WHEN LENGTH(prefix_of) = 0 OR prefix_of IS NULL THEN 'No relationship specified'
    ELSE 'Has relationship'
END;
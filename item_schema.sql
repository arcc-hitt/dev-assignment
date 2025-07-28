-- Create the item_list table
CREATE TABLE IF NOT EXISTS item_list (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(10),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_created_on (created_on)
    );

-- Insert sample data for testing
INSERT INTO item_list (code, name, category, created_on) VALUES
                                                             ('ITM001', 'Medical Equipment - Stethoscope', 'A', NOW()),
                                                             ('ITM002', 'Pharmaceutical - Paracetamol 500mg', 'B', NOW()),
                                                             ('ITM003', 'Surgical Instrument - Forceps', 'A', NOW()),
                                                             ('ITM004', 'Laboratory - Blood Test Kit', 'C', NOW()),
                                                             ('ITM005', 'Pharmaceutical - Aspirin 100mg', 'B', NOW()),
                                                             ('ITM006', 'Medical Equipment - Thermometer', 'A', NOW()),
                                                             ('ITM007', 'Disposable - Surgical Gloves', 'D', NOW()),
                                                             ('ITM008', 'Laboratory - Urine Test Strip', 'C', NOW()),
                                                             ('ITM009', 'Medical Equipment - Blood Pressure Monitor', 'A', NOW()),
                                                             ('ITM010', 'Pharmaceutical - Amoxicillin 250mg', 'B', NOW()),
                                                             ('ITM011', 'Surgical Instrument - Scalpel', 'A', NOW()),
                                                             ('ITM012', 'Laboratory - Glucose Test Kit', 'C', NOW()),
                                                             ('ITM013', 'Disposable - Face Mask', 'D', NOW()),
                                                             ('ITM014', 'Pharmaceutical - Ibuprofen 400mg', 'B', NOW()),
                                                             ('ITM015', 'Medical Equipment - Pulse Oximeter', 'A', NOW()),
                                                             ('ITM016', 'Laboratory - Pregnancy Test Kit', 'C', NOW()),
                                                             ('ITM017', 'Disposable - Syringes 5ml', 'D', NOW()),
                                                             ('ITM018', 'Pharmaceutical - Metformin 500mg', 'B', NOW()),
                                                             ('ITM019', 'Medical Equipment - Otoscope', 'A', NOW()),
                                                             ('ITM020', 'Laboratory - Cholesterol Test Kit', 'C', NOW()),
                                                             ('ITM021', 'Disposable - Cotton Swabs', 'D', NOW()),
                                                             ('ITM022', 'Pharmaceutical - Omeprazole 20mg', 'B', NOW()),
                                                             ('ITM023', 'Medical Equipment - Nebulizer', 'A', NOW()),
                                                             ('ITM024', 'Laboratory - Hemoglobin Test Kit', 'C', NOW()),
                                                             ('ITM025', 'Disposable - Alcohol Wipes', 'D', NOW()),
                                                             ('ITM026', 'Pharmaceutical - Losartan 50mg', 'B', NOW()),
                                                             ('ITM027', 'Medical Equipment - ECG Machine', 'A', NOW()),
                                                             ('ITM028', 'Laboratory - Liver Function Test Kit', 'C', NOW()),
                                                             ('ITM029', 'Disposable - Bandages', 'D', NOW()),
                                                             ('ITM030', 'Pharmaceutical - Atorvastatin 20mg', 'B', NOW());

-- Create indexes for better performance
CREATE INDEX idx_item_search ON item_list (code, name);
CREATE INDEX idx_item_category_date ON item_list (category, created_on);

-- Verify the data
SELECT COUNT(*) as total_records FROM item_list;
SELECT category, COUNT(*) as count FROM item_list GROUP BY category ORDER BY category;
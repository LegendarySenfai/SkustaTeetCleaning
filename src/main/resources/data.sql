-- Insert dentists if they don't already exist (by name)
INSERT INTO dentists (name, specialization, bio)
SELECT 'Dr. Maria Santos','General Dentistry','Senior dentist' WHERE NOT EXISTS (SELECT 1 FROM dentists WHERE name='Dr. Maria Santos');

INSERT INTO dentists (name, specialization, bio)
SELECT 'Dr. Jose dela Cruz','Oral Surgery','Expert in extractions' WHERE NOT EXISTS (SELECT 1 FROM dentists WHERE name='Dr. Jose dela Cruz');

INSERT INTO dentists (name, specialization, bio)
SELECT 'Dr. Ana Reyes','Orthodontics','Braces specialist' WHERE NOT EXISTS (SELECT 1 FROM dentists WHERE name='Dr. Ana Reyes');

-- Insert services if they don't already exist (by name)
INSERT INTO services (name, description, duration_minutes, price)
SELECT 'Dental Check-ups & Cleaning','Routine cleaning and check-up',30,500.00 WHERE NOT EXISTS (SELECT 1 FROM services WHERE name='Dental Check-ups & Cleaning');

INSERT INTO services (name, description, duration_minutes, price)
SELECT 'Tooth Extraction','Extraction of single tooth',45,1500.00 WHERE NOT EXISTS (SELECT 1 FROM services WHERE name='Tooth Extraction');

INSERT INTO services (name, description, duration_minutes, price)
SELECT 'Tooth Fillings','Filling cavities',30,800.00 WHERE NOT EXISTS (SELECT 1 FROM services WHERE name='Tooth Fillings');

INSERT INTO services (name, description, duration_minutes, price)
SELECT 'Braces & Orthodontics','Orthodontic consultation & treatment',60,5000.00 WHERE NOT EXISTS (SELECT 1 FROM services WHERE name='Braces & Orthodontics');

INSERT INTO services (name, description, duration_minutes, price)
SELECT 'Teeth Whitening','Cosmetic whitening',45,2000.00 WHERE NOT EXISTS (SELECT 1 FROM services WHERE name='Teeth Whitening');

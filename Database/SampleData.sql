INSERT INTO patient_db.Sex
    (designation, code, active)
VALUES
    ('Männlich', 'M', 1),
    ('Weiblich', 'F', 1),
    ('Divers', 'D', 1);


INSERT INTO patient_db.Religion
    (designation, code, active)
VALUES
    ('Ohne Angabe', 'OA', 1),
    ('Nicht gläubig', 'NG', 1),
    ('Sonstige', 'SO', 1);


INSERT INTO patient_db.Patient
    (first_name, last_name, date_of_birth,
     sex_id, religion_id, created_at, updated_at)
VALUES
    ('Max', 'Mustermann', '1990-05-15',
     (SELECT sex_id FROM patient_db.Sex WHERE code = 'M'),
     (SELECT religion_id FROM patient_db.Religion WHERE code = 'OA'),
     NOW(), NOW());

SET @patient1 = LAST_INSERT_ID();

INSERT INTO patient_db.Address
    (patient_id, street, house_number,
     postal_code, city, country, created_at, updated_at)
VALUES
    (@patient1, 'Hauptstraße', '12',
     '9020', 'Klagenfurt', 'Österreich', NOW(), NOW());


INSERT INTO patient_db.Patient
    (first_name, last_name, date_of_birth,
     sex_id, religion_id, created_at, updated_at)
VALUES
    ('Anna', 'Beispiel', '1985-09-22',
     (SELECT sex_id FROM patient_db.Sex WHERE code = 'F'),
     (SELECT religion_id FROM patient_db.Religion WHERE code = 'OA'),
     NOW(), NOW());

SET @patient2 = LAST_INSERT_ID();

INSERT INTO patient_db.Address
    (patient_id, street, house_number,
     postal_code, city, country, created_at, updated_at)
VALUES
    (@patient2, 'Bahnhofstraße', '8',
     '8010', 'Graz', 'Österreich', NOW(), NOW());

INSERT INTO patient_db.UserRole
    (role_name, designation, active)
VALUES
    ('DOCTOR', 'Arzt', 1),
    ('ASSISTANT', 'Ordinationsassistenz', 1);


INSERT INTO patient_db.InsuranceProvider
    (name, active)
VALUES
    ('ÖGK', 1),
    ('BVAEB', 1),
    ('SVS', 1),
    ('PRIVAT', 1),
    ('AUSLAND', 1),
    ('SONSTIGE', 1);


INSERT INTO patient_db.ServiceCatalog
    (name, price, active)
VALUES
    ('Blutabnahme', 8.00, 1);


INSERT INTO medical_db.MedicalSpecialty
    (name, active)
VALUES
    ('Innere Medizin', 1),
    ('Kardiologie', 1),
    ('Dermatologie', 1),
    ('Neurologie', 1),
    ('Orthopädie', 1),
    ('Urologie', 1),
    ('Augenheilkunde', 1),
    ('Hals-Nasen-Ohren-Heilkunde', 1),
    ('Gynäkologie', 1),
    ('Radiologie', 1);
    
    INSERT INTO medical_db.LabParameter
    (name, unit, reference_range, price, active)
VALUES
    ('Erythrozyten (ERY)', 'T/l', '4.0-5.9', 2.00, 1),
    ('Leukozyten (LEU)', 'G/l', '4.0-10.0', 2.00, 1),
    ('Hämoglobin (Hb)', 'g/dl', '12.0-17.5', 2.00, 1),
    ('Hämatokrit (HKT)', '%', '36-52', 2.00, 1),
    ('Thrombozyten (THR)', 'G/l', '150-400', 2.00, 1),
    ('MCV', 'fl', '80-96', 1.50, 1),
    ('MCH', 'pg', '27-33', 1.50, 1),
    ('MCHC', 'g/dl', '32-36', 1.50, 1),
    ('Neutrophile Granulozyten', '%', '40-75', 2.00, 1),
    ('Lymphozyten', '%', '20-45', 2.00, 1),
    ('Monozyten', '%', '2-10', 2.00, 1),
    ('Eosinophile Granulozyten', '%', '0-5', 2.00, 1),
    ('Basophile Granulozyten', '%', '0-1', 2.00, 1),
    ('C-reaktives Protein (CRP)', 'mg/l', '<5', 5.00, 1),
    ('Glukose', 'mg/dl', '70-99', 3.00, 1),
    ('Gesamtcholesterin', 'mg/dl', '<200', 4.00, 1),
    ('HDL-Cholesterin', 'mg/dl', '>40', 4.00, 1),
    ('LDL-Cholesterin', 'mg/dl', '<116', 4.00, 1),
    ('Triglyzeride', 'mg/dl', '<150', 4.00, 1),
    ('Kreatinin', 'mg/dl', '0.6-1.3', 3.00, 1),
    ('TSH', 'mIU/l', '0.4-4.0', 8.00, 1),
    ('HbA1c', '%', '<5.7', 7.00, 1);


INSERT INTO medical_db.LabPanel
    (name, price, active)
VALUES
    ('Kleines Blutbild', 12.00, 1),
    ('Großes Blutbild', 20.00, 1);


INSERT INTO medical_db.LabPanelParameter
    (panel_id, parameter_id)
SELECT p.panel_id, lp.parameter_id
FROM medical_db.LabPanel p
CROSS JOIN medical_db.LabParameter lp
WHERE p.name = 'Kleines Blutbild'
AND lp.name IN (
    'Erythrozyten (ERY)',
    'Leukozyten (LEU)',
    'Hämoglobin (Hb)',
    'Hämatokrit (HKT)',
    'Thrombozyten (THR)',
    'MCV',
    'MCH',
    'MCHC'
);


INSERT INTO medical_db.LabPanelParameter
    (panel_id, parameter_id)
SELECT p.panel_id, lp.parameter_id
FROM medical_db.LabPanel p
CROSS JOIN medical_db.LabParameter lp
WHERE p.name = 'Großes Blutbild'
AND lp.name IN (
    'Erythrozyten (ERY)',
    'Leukozyten (LEU)',
    'Hämoglobin (Hb)',
    'Hämatokrit (HKT)',
    'Thrombozyten (THR)',
    'MCV',
    'MCH',
    'MCHC',
    'Neutrophile Granulozyten',
    'Lymphozyten',
    'Monozyten',
    'Eosinophile Granulozyten',
    'Basophile Granulozyten'
);

INSERT INTO patient_db.User
    (username, password_hash, title, first_name,
     last_name, role_id, active, created_at, updated_at)
VALUES
    ('doctor.test', 'DEMO_LOGIN_DISABLED', 'Dr. med.',
     'Thomas', 'Berger',
     (SELECT role_id FROM patient_db.UserRole
      WHERE role_name = 'DOCTOR'),
     1, NOW(), NOW()),

    ('assistant.test', 'DEMO_LOGIN_DISABLED', NULL,
     'Lisa', 'Wagner',
     (SELECT role_id FROM patient_db.UserRole
      WHERE role_name = 'ASSISTANT'),
     1, NOW(), NOW());
     
     INSERT INTO medical_db.Encounter
    (patient_id, doctor_user_id, created_by_user_id,
     encounter_date)
VALUES
    (
        (SELECT patient_id FROM patient_db.Patient
         WHERE first_name = 'Max' AND last_name = 'Mustermann'),
        (SELECT user_id FROM patient_db.User
         WHERE username = 'doctor.test'),
        (SELECT user_id FROM patient_db.User
         WHERE username = 'assistant.test'),
        '2026-11-23 09:00:00'
    ),
    (
        (SELECT patient_id FROM patient_db.Patient
         WHERE first_name = 'Anna' AND last_name = 'Beispiel'),
        (SELECT user_id FROM patient_db.User
         WHERE username = 'doctor.test'),
        (SELECT user_id FROM patient_db.User
         WHERE username = 'assistant.test'),
        '2026-11-24 10:30:00'
    );
    
    INSERT INTO medical_db.LabOrder
    (encounter_id, ordered_by_user_id, order_date)
SELECT
    e.encounter_id,
    e.doctor_user_id,
    DATE_ADD(sr.performed_at, INTERVAL 5 MINUTE)
FROM medical_db.Encounter e
JOIN patient_db.ServiceRecord sr
    ON e.encounter_id = sr.encounter_id
JOIN patient_db.ServiceCatalog sc
    ON sr.service_id = sc.service_id
WHERE sc.name = 'Blutabnahme';

INSERT INTO medical_db.LabOrderPanel
    (order_id, panel_id, unit_price)
SELECT
    lo.order_id,
    lp.panel_id,
    lp.price
FROM medical_db.LabOrder lo
JOIN medical_db.Encounter e
    ON lo.encounter_id = e.encounter_id
JOIN patient_db.Patient p
    ON e.patient_id = p.patient_id
CROSS JOIN medical_db.LabPanel lp
WHERE
    (p.first_name = 'Max'
     AND p.last_name = 'Mustermann'
     AND lp.name = 'Kleines Blutbild')
OR
    (p.first_name = 'Anna'
     AND p.last_name = 'Beispiel'
     AND lp.name = 'Großes Blutbild');


INSERT INTO medical_db.LabOrderParameter
    (order_id, parameter_id, unit_price)
SELECT
    lo.order_id,
    lp.parameter_id,
    lp.price
FROM medical_db.LabOrder lo
JOIN medical_db.Encounter e
    ON lo.encounter_id = e.encounter_id
JOIN patient_db.Patient p
    ON e.patient_id = p.patient_id
CROSS JOIN medical_db.LabParameter lp
WHERE
    (p.first_name = 'Max'
     AND p.last_name = 'Mustermann'
     AND lp.name IN (
         'C-reaktives Protein (CRP)',
         'Glukose'
     ))
OR
    (p.first_name = 'Anna'
     AND p.last_name = 'Beispiel'
     AND lp.name IN (
         'Glukose',
         'TSH'
     ));
     
     
     
     INSERT INTO medical_db.LabResult
    (order_id, parameter_id, value, unit,
     reference_range, entered_at, updated_at)
SELECT
    lo.order_id,
    lp.parameter_id,
    CASE lp.name
        WHEN 'Erythrozyten (ERY)' THEN 5.1
        WHEN 'Leukozyten (LEU)' THEN 11.2
        WHEN 'Hämoglobin (Hb)' THEN 15.2
        WHEN 'Hämatokrit (HKT)' THEN 45
        WHEN 'Thrombozyten (THR)' THEN 250
        WHEN 'MCV' THEN 88
        WHEN 'MCH' THEN 29.8
        WHEN 'MCHC' THEN 33.8
        WHEN 'C-reaktives Protein (CRP)' THEN 18.5
        WHEN 'Glukose' THEN 94
    END,
    lp.unit,
    lp.reference_range,
    DATE_ADD(lo.order_date, INTERVAL 1 DAY),
    DATE_ADD(lo.order_date, INTERVAL 1 DAY)
FROM medical_db.LabOrder lo
JOIN medical_db.Encounter e
    ON lo.encounter_id = e.encounter_id
JOIN patient_db.Patient p
    ON e.patient_id = p.patient_id
JOIN (
    SELECT lop.order_id, lpp.parameter_id
    FROM medical_db.LabOrderPanel lop
    JOIN medical_db.LabPanelParameter lpp
        ON lop.panel_id = lpp.panel_id
    UNION
    SELECT order_id, parameter_id
    FROM medical_db.LabOrderParameter
) selected
    ON lo.order_id = selected.order_id
JOIN medical_db.LabParameter lp
    ON selected.parameter_id = lp.parameter_id
WHERE p.first_name = 'Max'
AND p.last_name = 'Mustermann';


INSERT INTO medical_db.LabResult
    (order_id, parameter_id, value, unit,
     reference_range, entered_at, updated_at)
SELECT
    lo.order_id,
    lp.parameter_id,
    CASE lp.name
        WHEN 'Erythrozyten (ERY)' THEN 4.5
        WHEN 'Leukozyten (LEU)' THEN 6.8
        WHEN 'Hämoglobin (Hb)' THEN 13.5
        WHEN 'Hämatokrit (HKT)' THEN 40
        WHEN 'Thrombozyten (THR)' THEN 280
        WHEN 'MCV' THEN 89
        WHEN 'MCH' THEN 30
        WHEN 'MCHC' THEN 33.8
        WHEN 'Neutrophile Granulozyten' THEN 58
        WHEN 'Lymphozyten' THEN 32
        WHEN 'Monozyten' THEN 6
        WHEN 'Eosinophile Granulozyten' THEN 3
        WHEN 'Basophile Granulozyten' THEN 1
        WHEN 'Glukose' THEN 91
        WHEN 'TSH' THEN 5.8
    END,
    lp.unit,
    lp.reference_range,
    DATE_ADD(lo.order_date, INTERVAL 1 DAY),
    DATE_ADD(lo.order_date, INTERVAL 1 DAY)
FROM medical_db.LabOrder lo
JOIN medical_db.Encounter e
    ON lo.encounter_id = e.encounter_id
JOIN patient_db.Patient p
    ON e.patient_id = p.patient_id
JOIN (
    SELECT lop.order_id, lpp.parameter_id
    FROM medical_db.LabOrderPanel lop
    JOIN medical_db.LabPanelParameter lpp
        ON lop.panel_id = lpp.panel_id
    UNION
    SELECT order_id, parameter_id
    FROM medical_db.LabOrderParameter
) selected
    ON lo.order_id = selected.order_id
JOIN medical_db.LabParameter lp
    ON selected.parameter_id = lp.parameter_id
WHERE p.first_name = 'Anna'
AND p.last_name = 'Beispiel';





    
   
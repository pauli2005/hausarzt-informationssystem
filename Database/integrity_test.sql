-- Test 1: Foreign Key Constraint

START TRANSACTION;

INSERT INTO medical_db.Encounter
    (patient_id, doctor_user_id,
     created_by_user_id, encounter_date)
VALUES
    (999999, 1, 2, NOW());

ROLLBACK;

-- Test 2: Unique Constraint

START TRANSACTION;

INSERT INTO patient_db.UserRole
    (role_name, designation, active)
VALUES
    ('DOCTOR', 'Test Role', 1);

ROLLBACK;

-- Test 3: NOT NULL Constraint

START TRANSACTION;

UPDATE patient_db.Patient
SET first_name = NULL
WHERE patient_id = 1;

ROLLBACK;


-- Test 4: Primary Key Constraint

-- Test 4: Primary Key Constraint

START TRANSACTION;

INSERT INTO patient_db.Sex
    (sex_id, designation, code, active)
VALUES
    (1, 'Test', 'TEST', 1);

ROLLBACK;
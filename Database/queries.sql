-- Query 1: Display all patients

SELECT *
FROM patient_db.Patient;


-- Query 2: Search for a specific patient

SELECT *
FROM patient_db.Patient
WHERE last_name = 'Mustermann';


-- Query 3: Display patients with address and insurance

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    a.street,
    a.house_number,
    a.postal_code,
    a.city,
    COALESCE(ip.name, 'Selbstzahler') AS insurance
FROM patient_db.Patient p
JOIN patient_db.Address a
    ON p.patient_id = a.patient_id
LEFT JOIN patient_db.Insurance i
    ON p.patient_id = i.patient_id
LEFT JOIN patient_db.InsuranceProvider ip
    ON i.provider_id = ip.provider_id;


-- Query 4: Display patient encounters and doctors

SELECT
    e.encounter_id,
    p.first_name,
    p.last_name,
    e.encounter_date,
    CONCAT(u.title, ' ', u.first_name, ' ',
           u.last_name) AS doctor
FROM medical_db.Encounter e
JOIN patient_db.Patient p
    ON e.patient_id = p.patient_id
JOIN patient_db.User u
    ON e.doctor_user_id = u.user_id
ORDER BY e.encounter_date DESC;


-- Query 5: Display laboratory results for a patient

SELECT
    p.first_name,
    p.last_name,
    e.encounter_date,
    lp.name AS parameter,
    lr.value,
    lr.unit,
    lr.reference_range
FROM patient_db.Patient p
JOIN medical_db.Encounter e
    ON p.patient_id = e.patient_id
JOIN medical_db.LabOrder lo
    ON e.encounter_id = lo.encounter_id
JOIN medical_db.LabResult lr
    ON lo.order_id = lr.order_id
JOIN medical_db.LabParameter lp
    ON lr.parameter_id = lp.parameter_id
WHERE p.patient_id = 1
ORDER BY lp.name;


-- Query 6: Count encounters per patient

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(e.encounter_id) AS encounter_count
FROM patient_db.Patient p
LEFT JOIN medical_db.Encounter e
    ON p.patient_id = e.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name;


-- Query 7: Calculate total costs per encounter

SELECT
    e.encounter_id,
    p.first_name,
    p.last_name,
    COALESCE((
        SELECT SUM(sr.quantity * sr.unit_price)
        FROM patient_db.ServiceRecord sr
        WHERE sr.encounter_id = e.encounter_id
    ), 0) AS service_costs,
    COALESCE((
        SELECT SUM(lop.unit_price)
        FROM medical_db.LabOrderPanel lop
        WHERE lop.order_id = lo.order_id
    ), 0) AS panel_costs,
    COALESCE((
        SELECT SUM(lopar.unit_price)
        FROM medical_db.LabOrderParameter lopar
        WHERE lopar.order_id = lo.order_id
    ), 0) AS additional_lab_costs,
    (
        COALESCE((
            SELECT SUM(sr.quantity * sr.unit_price)
            FROM patient_db.ServiceRecord sr
            WHERE sr.encounter_id = e.encounter_id
        ), 0)
        +
        COALESCE((
            SELECT SUM(lop.unit_price)
            FROM medical_db.LabOrderPanel lop
            WHERE lop.order_id = lo.order_id
        ), 0)
        +
        COALESCE((
            SELECT SUM(lopar.unit_price)
            FROM medical_db.LabOrderParameter lopar
            WHERE lopar.order_id = lo.order_id
        ), 0)
    ) AS total_costs
FROM medical_db.Encounter e
JOIN patient_db.Patient p
    ON e.patient_id = p.patient_id
LEFT JOIN medical_db.LabOrder lo
    ON e.encounter_id = lo.encounter_id;
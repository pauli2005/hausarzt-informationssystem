# Hausarzt Informationssystem

## Project Overview

This project is part of the Medical Information Systems course. Its objective is to develop a medical information System.
The system supports patient management, medical encounters, laboratory orders, laboratory results, medical reports, referrals and medical service documentation.

## Lab1/Milestone 1 – From Domain Model to Relational Database

The first milestone focuses on domain modelling, relational database design, database implementation and validation.

### Implemented Features

- UML domain model
- Relational database model
- Two database schemas
- 21 relational database tables
- Primary and foreign keys
- Integrity constraints
- 117 representative sample records
- Seven meaningful SQL queries
- Five successful database integrity tests

## Technical Environment

- Raspberry Pi 4
- Debian 13
- Docker
- Oracle MySQL 8.4.13
- MySQL Workbench
- SQL
- GitHub

## Database Structure

The database is divided into two schemas:

### patient_db

Contains patient master data, addresses, insurance information, users, user roles, reference data and medical service records.

### medical_db

Contains medical encounters, laboratory orders, laboratory results, medical reports, referrals, medical specialties and laboratory examination catalogues.

Both schemas are connected through foreign keys.

## Clinical Workflow

1. Patient registration
2. Medical encounter creation
3. Blood collection documentation
4. Laboratory order creation
5. Laboratory examination selection
6. Laboratory result entry
7. Medical report creation
8. Referral creation, if required

## Repository Structure

### database/

- Hausarzt_Informationssystem.mwb
- Hausarzt_Informationssystem.sql
- Sample_data.sql
- queries.sql
- integrity_test.sql

### documentation/

- UML_Domain_Model.pdf
- Relational_Database_Model.pdf
- Project_Documentation.docx

## Installation and Execution

Requirements:

- MySQL Server 8.4
- MySQL Workbench 

Execution steps:

1. Connect to a MySQL server.
2. Execute Hausarzt_Informationssystem.sql to create both database schemas and all tables.
3. Execute Sample_data.sql once on the newly created, empty schemas.
4. Execute queries.sql to review the sample data and database functionality.
5. Execute the individual tests in integrity_test.sql.

The integrity tests intentionally produce SQL errors to demonstrate that invalid database operations are rejected. Execute ROLLBACK separately after each test.

The database operations have been tested on the Raspberry Pi. A complete installation from the submitted scripts on a separate empty database instance has not yet been verified.

## Database Queries

1. Display all patients.
2. Search for a specific patient.
3. Display patient addresses and insurance information.
4. Display medical encounters and responsible doctors.
5. Display laboratory results for a patient.
6. Count medical encounters per patient.
7. Calculate total medical service and laboratory costs.

## Data Integrity

The following integrity constraints were successfully tested:

| Constraint | MySQL Error Code |
|---|---|
| Foreign Key | 1452 |
| UNIQUE | 1062 |
| NOT NULL | 1048 |
| Primary Key | 1062 |
| ON UPDATE RESTRICT | 1451 |

## Future Development

The next development phase will focus on:

- Apache web server integration
- Python and Flask web application
- User authentication and role-based access control
- Patient management interface
- Medical encounter management
- Laboratory result visualisation
- Medical reports and referrals

## Project Status

Relational database implementation completed.


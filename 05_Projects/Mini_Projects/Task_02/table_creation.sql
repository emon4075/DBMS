CREATE DATABASE medical;

USE medical;

CREATE TABLE Companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Drugs (
    drug_id INT PRIMARY KEY AUTO_INCREMENT,
    drug_name VARCHAR(100) NOT NULL,
    drug_category VARCHAR(100),
    product_name VARCHAR(255),
    company_id INT,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

CREATE TABLE Diseases (
    disease_id INT PRIMARY KEY AUTO_INCREMENT,
    disease_name VARCHAR(255) NOT NULL,
    disease_category VARCHAR(100)
);

CREATE TABLE Side_Effects (
    side_effect_id INT PRIMARY KEY AUTO_INCREMENT,
    side_effect_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Clinical_Trials (
    trial_id INT PRIMARY KEY AUTO_INCREMENT,
    trial_name TEXT,
    start_date DATE,
    end_date DATE,
    participants INT,
    status VARCHAR(50),
    location VARCHAR(100)
);

CREATE TABLE Conditions (
    condition_id INT PRIMARY KEY AUTO_INCREMENT,
    condition_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Trial_Conditions (
    trial_id INT,
    condition_id INT,
    PRIMARY KEY (trial_id, condition_id),
    FOREIGN KEY (trial_id) REFERENCES Clinical_Trials(trial_id) ON DELETE CASCADE,
    FOREIGN KEY (condition_id) REFERENCES Conditions(condition_id) ON DELETE CASCADE
);

CREATE TABLE Drug_Disease (
    drug_id INT,
    disease_id INT,
    PRIMARY KEY (drug_id, disease_id),
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id) ON DELETE CASCADE,
    FOREIGN KEY (disease_id) REFERENCES Diseases(disease_id) ON DELETE CASCADE
);

CREATE TABLE Drug_Side_Effects (
    drug_id INT,
    side_effect_id INT,
    PRIMARY KEY (drug_id, side_effect_id),
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id) ON DELETE CASCADE,
    FOREIGN KEY (side_effect_id) REFERENCES Side_Effects(side_effect_id) ON DELETE CASCADE
);

CREATE TABLE Drug_Interactions (
    drug1_id INT,
    drug2_id INT,
    interaction_type VARCHAR(100),
    PRIMARY KEY (drug1_id, drug2_id),
    FOREIGN KEY (drug1_id) REFERENCES Drugs(drug_id) ON DELETE CASCADE,
    FOREIGN KEY (drug2_id) REFERENCES Drugs(drug_id) ON DELETE CASCADE
);

CREATE TABLE Drug_Trials (
    drug_id INT,
    trial_id INT,
    PRIMARY KEY (drug_id, trial_id),
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id) ON DELETE CASCADE,
    FOREIGN KEY (trial_id) REFERENCES Clinical_Trials(trial_id) ON DELETE CASCADE
);

CREATE TABLE Researchers (
    researcher_id INT PRIMARY KEY AUTO_INCREMENT,
    researcher_name VARCHAR(255) NOT NULL
);

CREATE TABLE Trial_Researchers (
    trial_id INT,
    researcher_id INT,
    role VARCHAR(100),
    PRIMARY KEY (trial_id, researcher_id),
    FOREIGN KEY (trial_id) REFERENCES Clinical_Trials(trial_id) ON DELETE CASCADE,
    FOREIGN KEY (researcher_id) REFERENCES Researchers(researcher_id) ON DELETE CASCADE
);
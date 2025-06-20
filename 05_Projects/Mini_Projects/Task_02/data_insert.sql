INSERT INTO companies (company_name)
SELECT DISTINCT company_name 
FROM tb.raw_csv_data 
WHERE company_name IS NOT NULL AND company_name != '';


INSERT INTO diseases (disease_name, disease_category)
SELECT DISTINCT disease_name, disease_category
FROM tb.raw_csv_data 
WHERE disease_name IS NOT NULL AND disease_name != '';


INSERT INTO side_Effects (side_effect_name)
SELECT DISTINCT side_effect
FROM (
    SELECT side_effect FROM tb.raw_csv_data WHERE side_effect IS NOT NULL AND side_effect != ''
    UNION
    SELECT side_effect_0 FROM tb.raw_csv_data WHERE side_effect_0 IS NOT NULL AND side_effect_0 != ''
    UNION  
    SELECT side_effect_1 FROM tb.raw_csv_data WHERE side_effect_1 IS NOT NULL AND side_effect_1 != ''
    UNION
    SELECT side_effect_2 FROM tb.raw_csv_data WHERE side_effect_2 IS NOT NULL AND side_effect_2 != ''
    UNION
    SELECT side_effect_3 FROM tb.raw_csv_data WHERE side_effect_3 IS NOT NULL AND side_effect_3 != ''
) AS all_side_effects;

INSERT INTO drugs (drug_name, drug_category, product_name, company_id)
SELECT DISTINCT 
    r.drug_name,
    r.drug_category,
    r.product_name,
    c.company_id
FROM tb.raw_csv_data r
JOIN companies c ON r.company_name = c.company_name
WHERE r.drug_name IS NOT NULL AND r.drug_name != '';


INSERT INTO clinical_trials (trial_name, start_date, end_date, participants, status, location, institution)
SELECT DISTINCT
    clinical_trial_title,
    STR_TO_DATE(clinical_trial_start_date, '%Y.%m.%d'),
    STR_TO_DATE(clinical_trial_completion_date, '%Y.%m.%d'),
    CAST(clinical_trial_participants AS UNSIGNED),
    clinical_trial_status,
    CONCAT_WS(', ', clinical_trial_address, clinical_trial_address_0),
    clinical_trial_institution
FROM tb.raw_csv_data 
WHERE clinical_trial_title IS NOT NULL AND clinical_trial_title != '';

INSERT INTO drug_disease (drug_id, disease_id)
SELECT DISTINCT d.drug_id, dis.disease_id
FROM tb.raw_csv_data r
JOIN Drugs d ON r.drug_name = d.drug_name
JOIN Diseases dis ON r.disease_name = dis.disease_name;

INSERT INTO drug_side_effects (drug_id, side_effect_id)
SELECT DISTINCT d.drug_id, se.side_effect_id
FROM tb.raw_csv_data r
JOIN Drugs d ON r.drug_name = d.drug_name
JOIN Side_Effects se ON (
    r.side_effect = se.side_effect_name OR
    r.side_effect_0 = se.side_effect_name OR  
    r.side_effect_1 = se.side_effect_name OR
    r.side_effect_2 = se.side_effect_name OR
    r.side_effect_3 = se.side_effect_name
);


--- Missing Drugs Insertion ----

INSERT INTO drugs (drug_name)
SELECT DISTINCT interacts_with
FROM tb.raw_csv_data
WHERE interacts_with IS NOT NULL AND interacts_with != ''
  AND interacts_with NOT IN (SELECT drug_name FROM drugs)
UNION
SELECT DISTINCT interacts_with_0
FROM tb.raw_csv_data
WHERE interacts_with_0 IS NOT NULL AND interacts_with_0 != ''
  AND interacts_with_0 NOT IN (SELECT drug_name FROM drugs)
UNION
SELECT DISTINCT interacts_with_1
FROM tb.raw_csv_data
WHERE interacts_with_1 IS NOT NULL AND interacts_with_1 != ''
  AND interacts_with_1 NOT IN (SELECT drug_name FROM drugs);

--------- Problem Solved ------------------
INSERT INTO drug_interactions (drug1_id, drug2_id, interaction_type)
SELECT DISTINCT
    LEAST(d1.drug_id, d2.drug_id),
    GREATEST(d1.drug_id, d2.drug_id),
    'interacts_with'
FROM tb.raw_csv_data r
JOIN drugs d1 ON r.drug_name = d1.drug_name
JOIN drugs d2 ON (
    r.interacts_with = d2.drug_name OR
    r.interacts_with_0 = d2.drug_name OR
    r.interacts_with_1 = d2.drug_name
)
WHERE d1.drug_id <> d2.drug_id
  AND NOT EXISTS (
      SELECT 1 FROM drug_interactions di
      WHERE di.drug1_id = LEAST(d1.drug_id, d2.drug_id)
        AND di.drug2_id = GREATEST(d1.drug_id, d2.drug_id)
  );
SELECT * FROM drug_interactions;


INSERT INTO conditions (condition_name)
SELECT DISTINCT cond
FROM (
    SELECT clinical_trial_condition AS cond FROM tb.raw_csv_data WHERE clinical_trial_condition IS NOT NULL AND clinical_trial_condition != ''
    UNION
    SELECT clinical_trial_condition_0 AS cond FROM tb.raw_csv_data WHERE clinical_trial_condition_0 IS NOT NULL AND clinical_trial_condition_0 != ''
    UNION
    SELECT clinical_trial_condition_1 AS cond FROM tb.raw_csv_data WHERE clinical_trial_condition_1 IS NOT NULL AND clinical_trial_condition_1 != ''
) AS all_conditions;


INSERT INTO trial_conditions (trial_id, condition_id)
SELECT DISTINCT ct.trial_id, c.condition_id
FROM tb.raw_csv_data r
JOIN clinical_trials ct ON r.clinical_trial_title = ct.trial_name
JOIN conditions c ON (
    r.clinical_trial_condition = c.condition_name OR
    r.clinical_trial_condition_0 = c.condition_name OR
    r.clinical_trial_condition_1 = c.condition_name
)
WHERE (r.clinical_trial_condition IS NOT NULL AND r.clinical_trial_condition != '') OR (r.clinical_trial_condition_0 IS NOT NULL AND r.clinical_trial_condition_0 != '') OR (r.clinical_trial_condition_1 IS NOT NULL AND r.clinical_trial_condition_1 != '');


INSERT INTO drug_trials (drug_id, trial_id)
SELECT DISTINCT d.drug_id, ct.trial_id
FROM tb.raw_csv_data r
JOIN drugs d ON r.drug_name = d.drug_name
JOIN clinical_trials ct ON r.clinical_trial_title = ct.trial_name
WHERE r.drug_name IS NOT NULL AND r.clinical_trial_title IS NOT NULL;

INSERT INTO medical.researchers (researcher_name)
SELECT DISTINCT clinical_trial_main_researcher
FROM tb.raw_csv_data
WHERE clinical_trial_main_researcher IS NOT NULL AND clinical_trial_main_researcher != '';


INSERT INTO medical.trial_researchers (trial_id, researcher_id)
SELECT DISTINCT ct.trial_id, res.researcher_id
FROM tb.raw_csv_data r
JOIN medical.clinical_trials ct ON r.clinical_trial_title = ct.trial_name
JOIN medical.researchers res ON r.clinical_trial_main_researcher = res.researcher_name
WHERE r.clinical_trial_main_researcher IS NOT NULL AND r.clinical_trial_title IS NOT NULL;
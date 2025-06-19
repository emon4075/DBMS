-- 1. Find the number of drugs that have nausea as a side effect?
SELECT COUNT(d.drug_id)
FROM drugs d
JOIN drug_side_effects dse ON d.drug_id = dse.drug_id
JOIN side_effects se ON dse.side_effect_id = se.side_effect_id
WHERE se.side_effect_name = 'nausea';


-- 2. Find the drugs that interacts with butabarbital?
SELECT DISTINCT d.drug_name
FROM drugs d
JOIN drug_interactions di ON (d.drug_id = di.drug1_id OR di.drug2_id = d.drug_id)
WHERE (di.drug1_id = (
    SELECT d1.drug_id
    FROM drugs d1
    WHERE d1.drug_name = 'butabarbital'
)
OR 
 di.drug2_id = (
    SELECT d2.drug_id
    FROM drugs d2
    WHERE d2.drug_name = 'butabarbital'
)) AND d.drug_name <> 'butabarbital'


-- 3. Find the drugs with side effects cough and headache?
SELECT d.drug_name
FROM drugs d
JOIN drug_side_effects dse1 ON dse1.drug_id = d.drug_id
JOIN side_effects se1 ON dse1.side_effect_id = se1.side_effect_id
WHERE se1.side_effect_name = 'cough'
INTERSECT
SELECT d.drug_name
FROM drugs d
JOIN drug_side_effects dse1 ON dse1.drug_id = d.drug_id
JOIN side_effects se1 ON dse1.side_effect_id = se1.side_effect_id
WHERE se1.side_effect_name = 'headache';


-- 4. Find the drugs that can be used to treat endocrine diseases?
SELECT DISTINCT(d.drug_name)
FROM drugs d
JOIN drug_disease dd ON d.drug_id = dd.drug_id
JOIN diseases dis ON dis.disease_id = dd.disease_id
WHERE dis.disease_category = 'Endocrine';


-- 5. Find the most common treatment for immunological diseases that have not been used for hematological diseases?
SELECT d2.drug_name, COUNT(DISTINCT(dis2.disease_id))
FROM drugs d2
JOIN drug_disease dd2 ON dd2.drug_id = d2.drug_id
JOIN diseases dis2 ON dis2.disease_id = dd2.disease_id
WHERE dis2.disease_category = 'Immunological' AND d2.drug_id NOT IN(
    SELECT d1.drug_id
    FROM drugs d1
    JOIN drug_disease dd1 ON dd1.drug_id = d1.drug_id
    JOIN diseases dis1 ON dis1.disease_id = dd1.disease_id
    WHERE disease_category = 'Hematological'
)
GROUP BY d2.drug_name;


-- 6. Find the diseases that can be treated with hydrocortisone but not with etanercept?
SELECT DISTINCT dis1.disease_name
FROM diseases dis1
JOIN drug_disease dd1 ON dis1.disease_id = dd1.disease_id
JOIN drugs d1 ON d1.drug_id = dd1.drug_id
WHERE d1.drug_name = 'hydrocortisone' AND dis1.disease_id NOT IN(
    SELECT DISTINCT dis2.disease_id 
    FROM diseases dis2
    JOIN drug_disease dd2 ON dis2.disease_id = dd2.disease_id
    JOIN drugs d2 ON d2.drug_id = dd2.drug_id
    WHERE d2.drug_name = 'etanercept'
);


-- 7. Find the top-10 side effects that drugs used to treat asthma related diseases have?
SELECT se.side_effect_name AS 'Side Effect', COUNT(se.side_effect_name) AS 'Frequency'
FROM diseases dis
JOIN drug_disease dd ON dd.disease_id = dis.disease_id
JOIN drug_side_effects dse ON dse.drug_id = dd.drug_id
JOIN side_effects se ON se.side_effect_id = dse.side_effect_id
WHERE dis.disease_name LIKE '%Asthma%'
GROUP BY se.side_effect_name
ORDER BY Frequency DESC
LIMIT 10;


-- 8. Find the drugs that have been studied in more than three clinical trials with more than 30 participants?
SELECT d.drug_name AS 'Drug Name', COUNT(DISTINCT dt.trial_id) AS Trials
FROM clinical_trials ct
JOIN drug_trials dt ON ct.trial_id = dt.trial_id
JOIN drugs d ON dt.drug_id = d.drug_id
WHERE ct.participants > 30
GROUP BY dt.drug_id, d.drug_name
HAVING COUNT(DISTINCT dt.trial_id) > 3;


-- 10. Find the main researchers that have conducted clinical trials that study drugs that can be used to treat both respiratory and cardiovascular diseases? 
SELECT DISTINCT r.researcher_name
FROM diseases dis 
JOIN drug_disease dd ON dis.disease_id = dd.disease_id
JOIN drug_trials dt ON dt.drug_id = dd.drug_id
JOIN trial_researchers tr ON tr.trial_id = dt.trial_id
JOIN researchers r ON r.researcher_id = tr.researcher_id
WHERE dis.disease_category = 'Respiratory' 
INTERSECT
SELECT DISTINCT r.researcher_name
FROM diseases dis 
JOIN drug_disease dd ON dis.disease_id = dd.disease_id
JOIN drug_trials dt ON dt.drug_id = dd.drug_id
JOIN trial_researchers tr ON tr.trial_id = dt.trial_id
JOIN researchers r ON r.researcher_id = tr.researcher_id
WHERE dis.disease_category = 'Cardiovascular';


-- 11. Find up to three researchers that have conducted the larger number of clinical trials that study drugs that can be used to treat both respiratory and cardiovascular diseases?
SELECT r.researcher_name, COUNT(DISTINCT tr.trial_id) AS 'T_Count'
FROM diseases dis
JOIN drug_disease dd ON dd.disease_id = dis.disease_id
JOIN drug_trials dt ON dt.drug_id = dd.drug_id
JOIN trial_researchers tr ON tr.trial_id = dt.trial_id
JOIN researchers r ON r.researcher_id = tr.researcher_id
WHERE dt.drug_id IN (
    SELECT d.drug_id
    FROM diseases ds
    JOIN drug_disease d ON d.disease_id = ds.disease_id
    WHERE ds.disease_category = 'Respiratory'
) AND dt.drug_id IN (
    SELECT d.drug_id
    FROM diseases ds
    JOIN drug_disease d ON d.disease_id = ds.disease_id
    WHERE ds.disease_category = 'Cardiovascular'
)
GROUP BY r.researcher_name
ORDER BY T_Count DESC
LIMIT 3;


-- 12. Find the categories of drugs that have been only studied in clinical trials based in United States?
SELECT DISTINCT d.drug_category
FROM  drugs d
JOIN drug_trials dt USING(drug_id)
JOIN clinical_trials ct USING(trial_id)
WHERE ct.location LIKE '%United States%'
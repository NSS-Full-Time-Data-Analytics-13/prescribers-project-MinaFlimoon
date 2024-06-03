SELECT  npi, 
	SUM (total_claim_count) AS total_claims
FROM prescription 
Group by npi;
---- 
SELECT nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, 
	npi, SUM (total_claim_count) AS total_claims
FROM prescription inner join prescriber using (npi)
group by npi,
	nppes_provider_first_name, 
	nppes_provider_last_org_name, 
	specialty_description;
--- 
SELECT nppes_provider_first_name,  nppes_provider_last_org_name, specialty_description, npi,total_claims
FROM prescriber as p INNER JOIN 
(SELECT npi, 
SUM(total_claim_count) AS total_claims
 FROM 
 prescription 
GROUP bY npi) AS c
using (npi);
----

WITH d AS (SELECT prescription.*, prescriber.specialty_description
    FROM prescriber
    INNEr JOIN prescription USING (npi)
)
SELECT specialty_description, SUM (total_claim_count) as total
FROM d
group by specialty_description
	ORder by total desc ;
---
WITH a AS (SELECT prescription.*, prescriber.specialty_description, drug.opioid_drug_flag
  FROM prescriber INNEr JOIN prescription USING (npi) inner join drug using (drug_name))

SELECT specialty_description, count (opioid_drug_flag) as b
from a
group by specialty_description
order by b desc;
	

----



	
SELECT d.drug_name,d.generic_name, max_cost
FROM drug as d
INNER JOIN (
    SELECT drug_name, MAX(total_drug_cost) AS max_cost
    FROM prescription as p
    GROUP BY drug_name
) p ON d.drug_name = p.drug_name
	ORDER BY max_cost desc;

-----


select drug_name,
case when opioid_drug_flag = 'Y' then 'opiod'
when antibiotic_drug_flag = 'Y' then 'antibiotic'
when antibiotic_drug_flag = 'N' then 'neither' END type
from drug;

-----

WITH A AS (SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' then 'antibiotic'
ELSE 'neither' END AS type
FROM drug)


SELECT TYPE, SUM(total_drug_cost) 
FROM prescription inner join A using (drug_name)
group by type;

---

WITH A AS (SELECT * from cbsa 
where cbsaname ilike '%TN%');

SELECT cbsaname, SUM (cbsa::numeric) as total
FROM 
cbsa
GROUP BY cbsaname 
ORDER  BY total DESC;

SELECT cbsaname, SUM (cbsa::numeric) as total
FROM 
cbsa
GROUP BY cbsaname 
ORDER  BY total;


---
SELECT drug_name, total_claim_count, opioid_drug_flag, nppes_provider_last_org_name, nppes_provider_first_name
	FROM prescription inner join drug using (drug_name) inner join prescriber using (npi)
	WHERE total_claim_count >= 3000;

-----

SELECT 
	npi,nppes_provider_city, specialty_description, drug_name, opioid_drug_flag
FROM prescription full join drug using (drug_name) full join prescriber using (npi)
WHERE nppes_provider_city = 'NASHVILLE' and specialty_description = 'Pain Management' and opioid_drug_flag = 'Y'
	group by npi, nppes_provider_city, specialty_description, drug_name, opioid_drug_flag

select * from prescriber 
SElect * from drug
select * from prescription


SELECT prescriber.npi, drug.drug_name, SUM(COALESCE(total_claim_count, 0)) as total_claims
FROM prescriber CROSS JOIN drug INNER JOIN prescription USING (npi)
WHERE specialty_description='Pain Management' AND nppes_provider_city='NASHVILLE' AND opioid_drug_flag='Y'
GROUP BY prescriber.npi, drug.drug_name
ORDER BY total_claims desc;



	
---First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) 
	in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your 
	query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.;


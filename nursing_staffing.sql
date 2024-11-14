SELECT * FROM pbj.staffing;
use pbj;

# Dashboard 1
# Overall stats - required and contract hours by Q1
Select 
round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as `Total required hours`,
round(avg(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as `Average required hours`,
round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Total contract hours`,
round(avg(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Average contract hours`
from staffing;


# Total percent contract hours by month
SELECT 
    MONTH(WorkDate) AS `Month`,
    round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide), 2) AS `Total hours`,
    round(avg(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Average contract hours`,
    CONCAT(
    ROUND((SUM(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr) / 
         SUM(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide)) * 100, 2
         ), '%'
    ) AS `Percent contract hours`
FROM staffing
GROUP BY MONTH(WorkDate);


# States and their contract hours percent
WITH total_hours AS (
    SELECT 
        SUM(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr) AS total_contract_hours
    FROM staffing
),
state_hours AS (
    SELECT 
        State,
        ROUND(SUM(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr), 2) AS state_total_hours
    FROM staffing
    GROUP BY State
)
SELECT 
    State,
    state_total_hours AS `Total contract hours`,
    CONCAT(
        ROUND((state_total_hours / (SELECT total_contract_hours FROM total_hours)) * 100, 2), '%'
    ) AS `Percentage of total contract hours`
FROM state_hours
ORDER BY `Total contract hours` DESC;


# Below average contract hours
select state, 
round(avg(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as Below_average_contract_hours
from staffing
group by state
having Below_average_contract_hours < (
select 
round(avg(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as total_avg
from staffing
)
order by 2 desc;

# Dashboard 2
# States with requirement hours vs contract hours percent
with CTE as(
select state, round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as `Total hours`,
round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Total contract hours`
from staffing
group by state
order by 2 desc 
)
select state, `Total hours`, `Total contract hours`, 
round((`Total contract hours`/`Total hours`) * 100,2) as `Percentage of contract hours`
from CTE;

# Top 5 counties within top 10 states 
WITH top_states AS (
    SELECT state, 
		   round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as Total_hours,
           ROW_NUMBER() OVER (ORDER BY sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide) DESC) as state_rank
    FROM staffing
    GROUP BY state
    ORDER BY Total_hours DESC 
    LIMIT 5
),
ranked_counties AS (
    SELECT state, county_name,
		   round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as Total_hours,
           round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr), 2) as Total_contract_hours,
           ROW_NUMBER() OVER (PARTITION BY state ORDER BY sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr) DESC) as rn
    FROM staffing
    WHERE state IN (SELECT state FROM top_states)
    GROUP BY state, county_name
)
SELECT rc.state, rc.county_name, rc.Total_hours, rc.Total_contract_hours, 
round((rc.Total_contract_hours/rc.Total_hours) * 100,2) as percent
FROM ranked_counties rc
JOIN top_states ts ON rc.state = ts.state
WHERE rc.rn <= 5
ORDER BY ts.state_rank, rc.Total_hours DESC;


# Average required and contract hours by nurses
SELECT 
    'RN director of nursing' AS `Nurse type`,
    ROUND(AVG(Hrs_RNDON), 2) AS `Average required Hours`,
    ROUND(AVG(Hrs_RNDON_ctr), 2) AS `Average contract hours`
FROM staffing
UNION ALL
SELECT 
    'RN with admin duties(RN)',
    ROUND(AVG(Hrs_RNadmin), 2),
    ROUND(AVG(Hrs_RNadmin_ctr), 2)
FROM staffing
UNION ALL
SELECT 
    'Registered nurse',
    ROUND(AVG(Hrs_RN), 2),
    ROUND(AVG(Hrs_RN_ctr), 2)
FROM staffing
UNION ALL
SELECT 
    'LPN with admin duties',
    ROUND(AVG(Hrs_LPNadmin), 2),
    ROUND(AVG(Hrs_LPNadmin_ctr), 2)
FROM staffing
UNION ALL
SELECT 
    'Licensed practical nurse(LPN)',
    ROUND(AVG(Hrs_LPN), 2),
    ROUND(AVG(Hrs_LPN_ctr), 2)
FROM staffing
UNION ALL
SELECT 
    'Certified nursing assistant',
    ROUND(AVG(Hrs_CNA), 2),
    ROUND(AVG(Hrs_CNA_ctr), 2)
FROM staffing
UNION ALL
SELECT 
    'Nurse aide in training',
    ROUND(AVG(Hrs_NAtrn), 2),
    ROUND(AVG(Hrs_NAtrn_ctr), 2)
FROM staffing
UNION ALL
SELECT 
    'Med Aide/Technician',
    ROUND(AVG(Hrs_MedAide), 2),
    ROUND(AVG(Hrs_MedAide_ctr), 2)
FROM staffing;


# Top 5 nursing homes with high requirement hours
select provname, county_name, State, round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as `Total hours`,
round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Total contract hours`
from staffing
group by provname, county_name, state
order by 4 desc limit 10;

# Top 5 nursing homes with high contract hours
select provname, county_name, State, round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as `Total hours`,
round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Total contract hours`
from staffing
group by provname, county_name, state
order by 5 desc limit 20;




















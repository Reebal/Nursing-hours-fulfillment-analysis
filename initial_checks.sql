use pbj;

# Removing columns related to employed hours and other unnecessary ones like MDcensus, county_fips
ALTER TABLE staffing
DROP COLUMN Hrs_RNDON_emp, 
DROP COLUMN Hrs_RNadmin_emp, 
DROP COLUMN Hrs_RN_emp, 
DROP COLUMN Hrs_LPNadmin_emp, 
DROP COLUMN Hrs_LPN_emp, 
DROP COLUMN Hrs_CNA_emp, 
DROP COLUMN Hrs_NAtrn_emp, 
DROP COLUMN Hrs_MedAide_emp, 
DROP COLUMN COUNTY_FIPS, 
DROP COLUMN MDScensus;
		
        
# Check for columns with null values
SELECT 
    CONCAT('COUNT(CASE WHEN ', COLUMN_NAME, ' IS NULL THEN 1 END) AS `Null_', COLUMN_NAME, '`') AS `Null_check`
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'staffing';

# Copy the result from the above query and paste them in the below query to find the count of nulls in each column
SELECT 
    COUNT(*) AS TotalRows,
	COUNT(CASE WHEN CITY IS NULL THEN 1 END) AS `Null_CITY`,
COUNT(CASE WHEN COUNTY_NAME IS NULL THEN 1 END) AS `Null_COUNTY_NAME`,
COUNT(CASE WHEN CY_Qtr IS NULL THEN 1 END) AS `Null_CY_Qtr`,
COUNT(CASE WHEN Hrs_CNA IS NULL THEN 1 END) AS `Null_Hrs_CNA`,
COUNT(CASE WHEN Hrs_CNA_ctr IS NULL THEN 1 END) AS `Null_Hrs_CNA_ctr`,
COUNT(CASE WHEN Hrs_LPN IS NULL THEN 1 END) AS `Null_Hrs_LPN`,
COUNT(CASE WHEN Hrs_LPN_ctr IS NULL THEN 1 END) AS `Null_Hrs_LPN_ctr`,
COUNT(CASE WHEN Hrs_LPNadmin IS NULL THEN 1 END) AS `Null_Hrs_LPNadmin`,
COUNT(CASE WHEN Hrs_LPNadmin_ctr IS NULL THEN 1 END) AS `Null_Hrs_LPNadmin_ctr`,
COUNT(CASE WHEN Hrs_MedAide IS NULL THEN 1 END) AS `Null_Hrs_MedAide`,
COUNT(CASE WHEN Hrs_MedAide_ctr IS NULL THEN 1 END) AS `Null_Hrs_MedAide_ctr`,
COUNT(CASE WHEN Hrs_NAtrn IS NULL THEN 1 END) AS `Null_Hrs_NAtrn`,
COUNT(CASE WHEN Hrs_NAtrn_ctr IS NULL THEN 1 END) AS `Null_Hrs_NAtrn_ctr`,
COUNT(CASE WHEN Hrs_RN IS NULL THEN 1 END) AS `Null_Hrs_RN`,
COUNT(CASE WHEN Hrs_RN_ctr IS NULL THEN 1 END) AS `Null_Hrs_RN_ctr`,
COUNT(CASE WHEN Hrs_RNadmin IS NULL THEN 1 END) AS `Null_Hrs_RNadmin`,
COUNT(CASE WHEN Hrs_RNadmin_ctr IS NULL THEN 1 END) AS `Null_Hrs_RNadmin_ctr`,
COUNT(CASE WHEN Hrs_RNDON IS NULL THEN 1 END) AS `Null_Hrs_RNDON`,
COUNT(CASE WHEN Hrs_RNDON_ctr IS NULL THEN 1 END) AS `Null_Hrs_RNDON_ctr`,
COUNT(CASE WHEN PROVNAME IS NULL THEN 1 END) AS `Null_PROVNAME`,
COUNT(CASE WHEN PROVNUM IS NULL THEN 1 END) AS `Null_PROVNUM`,
COUNT(CASE WHEN STATE IS NULL THEN 1 END) AS `Null_STATE`,
COUNT(CASE WHEN WorkDate IS NULL THEN 1 END) AS `Null_WorkDate`
FROM staffing;

# Standardize text columns
UPDATE staffing
SET PROVNAME = UPPER(PROVNAME),
	CITY = UPPER(CITY),
	STATE = UPPER(STATE),
    COUNTY_NAME = INITCAP(COUNTY_NAME);  -- Capitalize first letters
    
# Trim whitespaces
UPDATE staffing
SET PROVNAME = TRIM(PROVNAME),
    CITY = TRIM(CITY),
    STATE = TRIM(STATE),
    COUNTY_NAME = TRIM(COUNTY_NAME);
    
    
# Logical consistency - checking for negative values
SELECT
    SUM(Hrs_RNDON < 0) AS Negative_Hrs_RNDON,
    SUM(Hrs_CNA < 0) AS Negative_Hrs_CNA,
    SUM(Hrs_CNA_ctr < 0) AS Negative_Hrs_CNA_ctr,
    SUM(Hrs_LPN < 0) AS Negative_Hrs_LPN,
    SUM(Hrs_LPN_ctr < 0) AS Negative_Hrs_LPN_ctr,
    SUM(Hrs_LPNadmin < 0) AS Negative_Hrs_LPNadmin,
    SUM(Hrs_LPNadmin_ctr < 0) AS Negative_Hrs_LPNadmin_ctr,
    SUM(Hrs_MedAide < 0) AS Negative_Hrs_MedAide,
    SUM(Hrs_MedAide_ctr < 0) AS Negative_Hrs_MedAide_ctr,
    SUM(Hrs_NAtrn < 0) AS Negative_Hrs_NAtrn,
    SUM(Hrs_NAtrn_ctr < 0) AS Negative_Hrs_NAtrn_ctr,
    SUM(Hrs_RN < 0) AS Negative_Hrs_RN,
    SUM(Hrs_RN_ctr < 0) AS Negative_Hrs_RN_ctr,
    SUM(Hrs_RNadmin < 0) AS Negative_Hrs_RNadmin,
    SUM(Hrs_RNadmin_ctr < 0) AS Negative_Hrs_RNadmin_ctr,
    SUM(Hrs_RNDON < 0) AS Negative_Hrs_RNDON,
    SUM(Hrs_RNDON_ctr < 0) AS Negative_Hrs_RNDON_ctr
FROM staffing;









            


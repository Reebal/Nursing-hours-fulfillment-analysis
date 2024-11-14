# Project Background

I analyzed the Payroll-Based Journal (PBJ) data from the Centers for Medicare & Medicaid Services (CMS) to evaluate staffing patterns in U.S. nursing homes. The goal is to provide data-driven recommendations to XYZ's sales leadership team, focusing on optimizing contract nursing fulfillment across key facilities in the first quarter of 2024.

Guided by XYZ's core values of Efficiency and Growth, this analysis explores the alignment between the total nursing hours required by nursing home facilities and the percentage of contract hours fulfilled by XYZ across various states.

Insights and recommendations are presented in the following key areas:

1. Overall staffing efficiency during Q1 2024
2. Regional and location-specific staffing gaps
3. High-demand locations with strong and weak performance
4. Role-specific staffing distribution

The SQL queries used to inspect and clean the data for this analysis can be found here [link].
Targeted SQL queries regarding various business questions can be found here [link].
A Tableau dashboard reporting overall staffing efficiency and trends can be found here.
Another Tableau dashboard reporting the other insights (2, 3, 4) can be found here. 

# Data structure & Initial checks

The dataset contains over 1 million records with 33 variables tracking daily logged hours across U.S. nursing facilities. To focus on total required and fulfilled contract hours, we can remove employee-specific hours and unnecessary temporal details.




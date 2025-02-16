/*
Nulls in the cst_id column were managed in the preprocessing stage (Jupyter Notebook).
Check for duplicates.
*/
SELECT
*
FROM
	(SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM crm_cust_info) AS t
	WHERE flag_last = 1;

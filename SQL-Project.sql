-- Aayush Jain
DROP PROCEDURE IF EXISTS age_group;
DELIMITER //
Create Procedure age_group()
BEGIN
	DECLARE Native_Country_var VARCHAR(100); 
    DECLARE Race_var VARCHAR(100); 
    DECLARE Sex_var VARCHAR(50); 
    DECLARE avg_education_var DECIMAL(10,2); 
    DECLARE Marital_Status_var VARCHAR(100);
    DECLARE done INT DEFAULT FALSE;
 	DECLARE age_group_cursor CURSOR FOR
		SELECT a.Native_Country, b.Marital_Status, a.Race, a.Sex, ROUND( AVG(Education_Num)) as avg_education FROM citizen a 
        LEFT JOIN marital_status b ON a.Marital_Status_ID = b.Marital_Status_ID
        GROUP BY a.Native_Country, b.Marital_Status, a.Race, a.Sex
		ORDER BY avg_education ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	DROP TABLE IF EXISTS Age_Group;
    CREATE TABLE IF NOT EXISTS Age_Group
      (Native_Country_var VARCHAR(100),Race_var VARCHAR(100),Sex_var VARCHAR(50),Marital_Status_var VARCHAR(100), Average_Education_var DECIMAL(10,2));
    OPEN age_group_cursor;
	age_list : LOOP
		FETCH age_group_cursor INTO Native_Country_var,Marital_Status_var, Race_var,Sex_var,avg_education_var;
		IF done THEN
			LEAVE age_list;
		END IF;
		INSERT INTO Age_Group
		VALUES(Native_Country_var, Race_var,Sex_var,Marital_Status_var,avg_education_var);
	END loop age_list; 
	CLOSE age_group_cursor;
    SELECT  * FROM Age_Group;
END //
CALL age_group();
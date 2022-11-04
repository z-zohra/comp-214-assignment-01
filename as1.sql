--- ASSIGNMENT - 01 ADVANCED DATABASE CONCEPTS (214)

-- 1 List the name of each officer who has reported more than the average number of crimes officers have reported 
SELECT co.officer_id, o.last, o.first
FROM crime_officers co JOIN officers o
ON co.officer_id = o.officer_id
GROUP BY co.officer_id, o.last, o.first
HAVING COUNT(*) > (SELECT COUNT(*) / COUNT(DISTINCT officer_id) FROM crime_officers);
SELECT COUNT(*) / COUNT(DISTINCT officer_id) FROM crime_officers;
--2 List the criminal names for all criminals who have a less than average number of crimes and aren't listed as violent offenders                    
 
SELECT LAST, FIRST FROM criminals NATURAL JOIN 
(SELECT criminal_id FROM crimes GROUP BY criminal_id 
HAVING count(*) < (SELECT avg(count(*)) 
FROM crimes GROUP BY criminal_id)) WHERE v_status = 'N' ;

SELECT AVG(COUNT(*))
                    FROM crimes GROUP BY CRIMINAL_ID;
                    
--3 List appeal information for each appeal that has a less than average number of days between the filing and hearing dates.
SELECT *
FROM appeals
WHERE AVG((filing_date - hearing_date))
<ALL (SELECT AVG((filing_date - hearing_date));

SELECT appeal_id, crime_id, hearing_date, filing_date,
hearing_date - filing_date "NUMBER OF DAYS", status 
FROM appeals WHERE (hearing_date - filing_date < ( SELECT avg(hearing_date - filing_date) 
FROM appeals));

--4 List the names of probation officers who have had a less than average number of criminals assigned
SELECT PROB_ID,LAST, FIRST FROM prob_officers 
JOIN(SELECT prob_id FROM sentences GROUP BY prob_id 
HAVING count(*) < (SELECT AVG(COUNT(*)) 
FROM sentences GROUP BY prob_id HAVING prob_id IS NOT NULL)
AND prob_id IS NOT NULL)USING (prob_id);
                    
/*Question 5  List each crime that has had the highest number of appeals recorded */
SELECT crime_id 
FROM(SELECT crime_id, COUNT(*) AS appeal_count FROM Appeals GROUP BY crime_id) 
JOIN(SELECT MAX(appeal_count) AS max_appeal_count 
FROM(SELECT COUNT(*) AS appeal_count 
FROM Appeals GROUP BY crime_id))ON appeal_count = max_appeal_count;


/* Question 6 List the information on crime charges for each charge that has had a fine above average */
SELECT * FROM crime_charges 
WHERE fine_amount > (SELECT AVG(fine_amount) 
FROM crime_charges)AND amount_paid <(SELECT AVG(fine_amount) 
FROM crime_charges);

/* 7. List the names of all criminals who have had any of the crime code 
charges involved in crime ID 10089.*/
SELECT c.criminal_id, c.first, c.last, cr.crime_id
FROM criminals c 
JOIN crimes cr ON c.criminal_id =cr.criminal_id WHERE crime_id=10089;


--8 List the names of officers who have booked the highest number of crimes

select last,first from officers where officer_id in (
select officer_id from crime_officers group by officer_id
having count(crime_id) >= (select max (count(crime_id))from crime_officers group by officer_id)); 



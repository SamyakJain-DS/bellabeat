#--------CREATED TABLE USING TABLE DATA IMPORT WIZARD THEN TRUNCATED THE DATA TO REFINE THE DATA MANUALLY----------------------------------------------------------------------------------------------------------------------------#
select * 
from steps_and_activity;

truncate steps_and_activity;

select *
from daily_sleep;

truncate daily_sleep;

alter table steps_and_activity 
modify column ActivityDate date;              #There was a formatting problem while importing, which I fixed here.

alter table daily_sleep
modify column Date date;

#----------------------------------------------------LOADING DATA INTO SQL-----------------------------------------------------------------------------------------------------------------------------------------------------------#

SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE 'E:\\DA_Course\\CaseStudy_Bellabeat\\Dataset\\Fitabase Data 4.12.16-5.12.16\\dailyActivity_merged.csv'
INTO TABLE steps_and_activity
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'E:\\DA_Course\\CaseStudy_Bellabeat\\Dataset\\Fitabase Data 4.12.16-5.12.16\\sleepDay_merged.csv'
INTO TABLE daily_sleep
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

#-------------------------ANALYZING-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
select count(distinct(id)) from steps_and_activity;

select *
from steps_and_activity s
LEFT JOIN daily_sleep d ON s.Id = d.Id
UNION
 select *
from steps_and_activity s
RIGHT JOIN daily_sleep d ON s.Id = d.Id;   #FULL JOIN query in mySQL

#realises we dont need left join for our analysis

select * 
from steps_and_activity s, daily_sleep d
where s.Id=d.Id and s.ActivityDate=d.Date;

create table whole_data as
with whole_data as 
(select * 
from steps_and_activity s, daily_sleep d
where s.id_no=d.Id and s.ActivityDate=d.Date)
select * from whole_data;

select * from whole_data;

select id,
date,
(VeryActiveMinutes/60) as VeryActiveHours,
(FairlyActiveMinutes/60) as FairlyActiveHours,
(LightlyActiveMinutes/60) as LightlyActiveHours,
(SedentaryMinutes/60) as SedentaryHours,
Calories,
(TotalMinutesAsleep/60) as TotalHoursSlept
from whole_data;																				#data of our need

select RIGHT(id,4) as short_id,
date,
((VeryActiveMinutes+FairlyActiveMinutes)/60) as ActiveHours,
((LightlyActiveMinutes+SedentaryMinutes)/60) as MinimalActivityHours,
Calories,
(TotalMinutesAsleep/60) as TotalHoursSlept
from whole_data
where RIGHT(id,4) = 0366;
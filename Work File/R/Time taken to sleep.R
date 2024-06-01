install.packages("stringr")
#ADDING LIBRARIES AND DATASET
library(tidyverse)
library(ggplot2)
library(janitor)
library(dplyr)
library(lubridate)
library(stringr)
setwd('E:/DA_Course/CaseStudy_Bellabeat/Dataset/Fitabase Data 4.12.16-5.12.16')
daily_sleep <- read_csv("E:/DA_Course/CaseStudy_Bellabeat/Dataset/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")

#CLEANING DATA
daily_sleep<-clean_names(daily_sleep)

daily_sleep<-daily_sleep %>% separate(sleep_day,into= c("date","time","am/pm"), sep=" ")

daily_sleep$sleep_date_time <- paste(daily_sleep$date,daily_sleep$time,sep=" ")

daily_sleep <-daily_sleep %>%
  mutate(id=as.character(id),
         date=as.Date(date,format="%m/%d/%Y"),
         time=format(time,format="%H:%M:%S"),
         sleep_date_time=as.POSIXct(sleep_date_time,format="%m/%d/%Y %H:%M:%S"))

n_distinct(daily_sleep$id)    # 24 Unique Users, not 30 as mentioned in the case study. 

sum(duplicated(daily_sleep))

daily_sleep <- distinct(daily_sleep)

daily_sleep <- daily_sleep[, c(1,2,3,8,4,5,6,7)] #Rearranged columns

is.null(daily_sleep$id)                #Checking for nulls
is.null(daily_sleep$date)
is.null(daily_sleep$time)
is.null(daily_sleep$`am/pm`)
is.null(daily_sleep$total_sleep_records)
is.null(daily_sleep$total_minutes_asleep)
is.null(daily_sleep$sleep_date_time)

#ANALYZING DATA
daily_sleep$time_taken_to_sleep <- daily_sleep$total_time_in_bed - daily_sleep$total_minutes_asleep
avgtime<-daily_sleep %>%
  group_by(id) %>%
  summarise(average_time= mean(time_taken_to_sleep))

avgtime$average_time <- round(avgtime$average_time,digits = 2)

max(avgtime$average_time)
min(avgtime$average_time)

daily_sleep %>% filter(id=="1844505072")
avgtime %>%
  ggplot(aes(x=id,y=average_time))+ geom_col(fill="indianred") + theme_classic()

avgtime$short_id<-str_sub(avgtime$id,start=-4)   #IDS are not readable in the charts

avgtime$id <- as.character(avgtime$id)

sum(duplicated(avgtime$short_id))             #Making sure that the ids are unique

avgtime %>%
  ggplot(aes(x=short_id,y=average_time))+ geom_col(fill="indianred") +
  theme_classic() +
  labs(title="Average Time Taken To Sleep",x="ID",y="Time (In Minutes)") +
  geom_text(aes(label=average_time),vjust=-0.2,color="black",size=3)

write_csv(avgtime,file="E:/DA_Course/CaseStudy_Bellabeat/Work File/avg_time.csv")

# No of diabetes, heart and overall patients per month and gender wise

setwd('F:/final diabetes')

library(RODBC)

myconn = odbcConnect("suburban_data")

maydata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE, COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-05-01' and REG_DT < '2015-06-01' 
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                    'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                    'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                    'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                    'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                    'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                    'Pune Viman Nagar')
          group by REG_CENTRE_NAME, GENDER, AGE 
          order by REG_CENTRE_NAME, GENDER, AGE")

maydata$MONTH <- 5

View(maydata)

junedata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-06-01' and REG_DT < '2015-07-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                     'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                     'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                     'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                     'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                     'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                     'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

junedata$MONTH <- 6

julydata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-07-01' and REG_DT < '2015-08-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                     'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                     'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                     'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                     'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                     'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                     'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

julydata$MONTH <- 7

augustdata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-08-01' and REG_DT < '2015-09-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                       'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                       'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                       'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                       'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                       'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                       'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

augustdata$MONTH <- 8

septemberdata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-09-01' and REG_DT < '2015-10-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                          'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                          'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                          'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                          'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                          'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                          'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

septemberdata$MONTH <- 9

octoberdata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-10-01' and REG_DT < '2015-11-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                        'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                        'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                        'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                        'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                        'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                        'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

octoberdata$MONTH <- 10

novemberdata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-11-01' and REG_DT < '2015-12-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                         'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                         'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                         'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                         'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                         'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                         'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

novemberdata$MONTH <- 11

decemberdata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2015-12-01' and REG_DT < '2016-01-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                         'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                         'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                         'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                         'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                         'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                         'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

decemberdata$MONTH <- 12

jandata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2016-01-01' and REG_DT < '2016-02-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                    'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                    'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                    'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                    'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                    'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                    'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

jandata$MONTH <- 1

febdata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE, COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2016-02-01' and REG_DT < '2016-03-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
                    'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
                    'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
                    'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
                    'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
                    'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
                    'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

febdata$MONTH <- 2

marchdata <- sqlQuery(myconn, "select REG_CENTRE_NAME, GENDER, AGE,COUNT(DISTINCT(CID_NO)) as TOTAL_CID, count(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats 
          where REG_DT >= '2016-03-01' and REG_DT < '2016-04-01'
and REG_CENTRE_NAME NOT IN 
('Wani Diagnsotics',  'Bhakti Diagnostics - Latur', 'Goa Lab', 'Goa Navelim', 'Goa Panjim', 
'Goa Parvorim', 'Goa ponda', 'Goa-Margao', 'Pune Ankur Diagnostics','Pune Ask Pathology',
'Pune Aundh','Pune Bajirao Road', 'Pune Baner','Pune Cloudnine Hospital','Pune HSCC Nagar', 
'Pune Karve Nagar', 'Pune Kondhwa', 'Pune Kothrud','Pune Lab','Pune Life line',
'Pune Lulla Naga','Pune Model Colony','Pune Polaris Healthcare', 'Pune Satyam',
'Pune Sinhgad Road','Pune Swargate','Pune Thepade Diagnostics','Pune Usha Nursing', 
'Pune Viman Nagar')
                    group by REG_CENTRE_NAME, GENDER, AGE 
                    order by REG_CENTRE_NAME, GENDER, AGE")

marchdata$MONTH <- 3

All_Month_data <- rbind(jandata,febdata, marchdata, maydata, junedata, julydata, augustdata, 
                        septemberdata, octoberdata, novemberdata, decemberdata)


All_Month_data$MONTHS <- gsub("[^0-9]", "",All_Month_data$AGE)
All_Month_data$AGE_GROUP <- ifelse(All_Month_data$MONTHS <30, 'A', ifelse(All_Month_data$MONTHS <40,'B', 
                               ifelse(All_Month_data$MONTHS <50,'C', 
                               ifelse(All_Month_data$MONTHS <60,'D', 'E'  ))))

View(All_Month_data)
write.csv(All_Month_data, file="All_Month_data.csv")
library(sqldf)

AllData <- sqldf("select MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, SUM(TOTAL_CID), SUM(TOTAL_SID) from All_Month_data
                    group by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER 
                    order by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER ")

View(AllData)

names(AllData)[names(AllData) == 'MONTHS'] <- 'MONTH'
write.csv(AllData, file= "AllData.csv")


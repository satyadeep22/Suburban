setwd('C:/Users/Admin/Documents/heart')
library(RODBC)

myconn = odbcConnect("suburban_data")

suburbandata <- sqlQuery(myconn, "select RecordNo, REG_CENTRE_NAME, PROCESS_CENTRE_NAME, 
                         CID_NO, BAR_CODE, SID, AGE, GENDER, TEST_NAME, COMPONENT_NAME, RESULT_VALUE, 
                         [NORMAL_VALUE(B/W-RANGE)] as NORMAL_VALUE 
                         from dbo.Services_stats where TEST_NAME IN ('LIPID-P', 'GLYCO Hb (HbA1C)', 
                         'FBS (PLASMA)' , 'PPBS (PLASMA)') ")

suburbandataset <- na.omit(suburbandata)

All_Test <- read.csv("All_Test_Normal_Values.csv")
All_Test <- All_Test[(All_Test$TEST_NAME %in% c('LIPID-P', 'GLYCO Hb (HbA1c)', 'FBS (PLASMA)' , 'PPBS (PLASMA)')),]
All_Test <- na.omit(All_Test)
View(All_Test)
All_Test <- All_Test[1:32,]
All_Test <- All_Test[!All_Test$COMPONENT_NAME %in% c('CHOL / HDL CHOL RATIO','LDL CHOL / HDL CHOL RATIO', 'VLDL CHOLESTEROL', 'NON HDL CHOLESTEROL' ),]
View(All_Test)

library(plyr)
rename(suburbandata, c("NORMAL_VALUE" = "NORMAL_VALUE.B.W.RANGE."))
names(suburbandata)[names(suburbandata)=="NORMAL_VALUE"] <- "NORMAL_VALUE.B.W.RANGE."
merged_suburbandata <- merge(All_Test,suburbandata, by = c("TEST_NAME", "COMPONENT_NAME", "NORMAL_VALUE.B.W.RANGE." ))

merged_suburbandata <- subset(merged_suburbandata, select = -c(X,no_rows))

# Only Mumbai Data
merged_suburbandata <- merged_suburbandata[!merged_suburbandata$REG_CENTRE_NAME %in% c( 'Wani Diagnsotics', 
                                                                                        'Bhakti Diagnostics - Latur', 
                                                                                        'Goa Lab', 
                                                                                        'Goa Navelim', 
                                                                                        'Goa Panjim', 
                                                                                        'Goa Parvorim', 
                                                                                        'Goa ponda', 
                                                                                        'Goa-Margao', 
                                                                                        'Pune Ankur Diagnostics',
                                                                                        'Pune Ask Pathology',
                                                                                        'Pune Aundh',
                                                                                        'Pune Bajirao Road',
                                                                                        'Pune Baner',
                                                                                        'Pune Cloudnine Hospital',
                                                                                        'Pune HSCC Nagar',
                                                                                        'Pune Karve Nagar',
                                                                                        'Pune Kondhwa',
                                                                                        'Pune Kothrud',
                                                                                        'Pune Lab',
                                                                                        'Pune Life line',
                                                                                        'Pune Lulla Naga',
                                                                                        'Pune Model Colony',
                                                                                        'Pune Polaris Healthcare',
                                                                                        'Pune Satyam',
                                                                                        'Pune Sinhgad Road',
                                                                                        'Pune Swargate',
                                                                                        'Pune Thepade Diagnostics',
                                                                                        'Pune Usha Nursing', 
                                                                                        'Pune Viman Nagar'),]

View(merged_suburbandata)

merged_suburbandata$RESULT_VALUE <- as.numeric(as.character(merged_suburbandata$RESULT_VALUE))
merged_suburbandata$NORMAL_LOWER_VALUE <- as.numeric(as.character(merged_suburbandata$NORMAL_LOWER_VALUE))
merged_suburbandata$NORMAL_UPPER_VALUE <- as.numeric(as.character(merged_suburbandata$NORMAL_UPPER_VALUE))
View(merged_suburbandata)
merged_suburbandata$POSITIVITY <- ifelse(merged_suburbandata$RESULT_VALUE < merged_suburbandata$NORMAL_LOWER_VALUE, 1,
                                         ifelse(merged_suburbandata$RESULT_VALUE > merged_suburbandata$NORMAL_UPPER_VALUE,1,0))
View(merged_suburbandata)

write.csv(merged_suburbandata, file="merged_suburbandata.csv")

merged_suburbandata <- read.csv("merged_suburbandata.csv")

new_heart_data <- merged_suburbandata[which(merged_suburbandata$TEST_NAME == 'LIPID-P'),]
write.csv(new_heart_data, file="new_heart_data.csv")
new_heart_data <- write.csv(new_heart_data, file="new_heart_data.csv")

new_heart_data <- read.csv("new_heart_data.csv")
View(new_heart_data)

library(sqldf)

merged_heart_CID <- sqldf("select REG_CENTRE_NAME, COUNT(DISTINCT(CID_NO)) as TEST_CID from new_heart_data
                             group by REG_CENTRE_NAME order by REG_CENTRE_NAME")
merged_heart_SID <- sqldf("select REG_CENTRE_NAME, COUNT(DISTINCT(SID)) as TEST_SID from new_heart_data
                             group by REG_CENTRE_NAME order by REG_CENTRE_NAME")
View(merged_heart_SID)
View(merged_heart_CID)

merged_heart_reg <- sqldf("select * from new_heart_data where SID like '1%' ")
merged_heart_reg_pivot <- sqldf('select REG_CENTRE_NAME, SID, sum(POSITIVITY) as SUM_POSITIVITY from merged_heart_reg group by REG_CENTRE_NAME, SID order by REG_CENTRE_NAME ')
merged_heart_reg_pivot$heart_patient <- ifelse(merged_heart_reg_pivot$SUM_POSITIVITY >0 ,1,0)

merged_heart_sample <- sqldf("select * from new_heart_data where SID NOT like '1%' ")
merged_heart_sample_pivot <- sqldf('select REG_CENTRE_NAME, SID, sum(POSITIVITY) as SUM_POSITIVITY from merged_heart_sample group by REG_CENTRE_NAME, SID order by REG_CENTRE_NAME ')
merged_heart_sample_pivot$heart_patient <- ifelse(merged_heart_sample_pivot$SUM_POSITIVITY >0 ,1,0)

final_heart_reg <- sqldf("select REG_CENTRE_NAME, COUNT(heart_patient) as ADMITTED_REG_HEART, SUM(heart_patient) as POSITIVE_REG_HEART from merged_heart_reg_pivot group by REG_CENTRE_NAME order by REG_CENTRE_NAME")
final_heart_sample <- sqldf("select REG_CENTRE_NAME, COUNT(heart_patient) as ADMITTED_SAMPLE_HEART, SUM(heart_patient) as POSITIVE_SAMPLE_HEART from merged_heart_sample_pivot group by REG_CENTRE_NAME order by REG_CENTRE_NAME")

final_heart <- merge(final_heart_reg,final_heart_sample, by = c("REG_CENTRE_NAME" ), all = TRUE)
final_heart[is.na(final_heart)] <- 0
View(final_heart)

library(RODBC)
myconn <- odbcConnect("suburban_data")
Region_Wise_Test_CID <- sqlQuery(myconn, "select REG_CENTRE_NAME, COUNT(DISTINCT(CID_NO)) as TOTAL_CID from dbo.Services_stats
                                 group by REG_CENTRE_NAME order by REG_CENTRE_NAME")

Region_Wise_Test_SID <- sqlQuery(myconn, "select REG_CENTRE_NAME, COUNT(DISTINCT(SID)) as TOTAL_SID from dbo.Services_stats
                                 group by REG_CENTRE_NAME order by REG_CENTRE_NAME")

market_size_heart <- merge(final_heart, Region_Wise_Test_CID, by = c("REG_CENTRE_NAME"))
market_size_heart <- merge(market_size_heart, Region_Wise_Test_SID, by = c("REG_CENTRE_NAME"))
View(market_size_heart)
View(Region_Wise_Test_SID)

market_size_heart <- merge(market_size_heart, merged_heart_CID, by= "REG_CENTRE_NAME")
View(market_size_heart)
write.csv(market_size_heart, file="market_size_heart.csv")

wards <- read.csv("wards.csv")

market_size_heart <- merge(market_size_heart, wards, by = c("REG_CENTRE_NAME"))
write.csv(market_size_heart, file="market_size_heart.csv")

read.csv("market_size_heart.csv")
View(market_size_heart)
final_market_heart <- sqldf("select WARDS, SUM(TOTAL_CID) as TOTAL_CID,SUM(TOTAL_SID) as 
                               TOTAL_SID, SUM(TEST_CID) as TEST_CID,  
                               COUNT(REG_CENTRE_NAME) as REGISTRATION_CENTRE,
                               SUM(ADMITTED_REG_HEART) as REGISTERED_HEART_TEST,
                               SUM(POSITIVE_REG_HEART) as REGISTERED_HEART_TEST_POSITIVE, 
                               SUM(ADMITTED_SAMPLE_HEART) as SAMPLE_TAKEN_FOR_TEST,
                               SUM( POSITIVE_SAMPLE_HEART) as SAMPLE_TAKEN_FOR_TEST_POSITIVE
                               from market_size_heart group by WARDS order by WARDS")
ward_demographic <- read.csv("ward_demographic.csv")
View(ward_demographic)
final_market_size_heart <- merge(final_market_heart, ward_demographic, by = c("WARDS"))
View(final_market_size_heart)
write.csv(final_market_size_heart, file="final_market_size_heart.csv")

heart_market <- final_market_size_heart
heart_market$TOTAL_SID <- as.numeric(as.character(heart_market$TOTAL_SID))
heart_market$TOTAL_POPULATION <- as.numeric(as.character(heart_market$TOTAL_POPULATION))
heart_market$PERCENTAGE_PEOPLE_REGISTERED <- heart_market$TOTAL_SID/heart_market$TOTAL_POPULATION

heart_market$PERCENT_PEOPLE_TAKING_TEST <- 2*max(heart_market$PERCENTAGE_PEOPLE_REGISTERED)
heart_market$MARKET_SHARE_SUBURBAN <- heart_market$PERCENTAGE_PEOPLE_REGISTERED/heart_market$PERCENT_PEOPLE_TAKING_TEST

heart_market$TOTAL_PEOPLE_TAKING_TEST <- heart_market$PERCENT_PEOPLE_TAKING_TEST*heart_market$TOTAL_POPULATION
heart_market$PERCENT_PEOPLE_GETTING_HEART_TEST <- (heart_market$REGISTERED_HEART_TEST+heart_market$SAMPLE_TAKEN_FOR_TEST)/heart_market$TOTAL_SID
heart_market$TOTAL_HEART_TEST = heart_market$PERCENT_PEOPLE_GETTING_HEART_TEST * heart_market$TOTAL_PEOPLE_TAKING_TEST
heart_market$PERCENT_PEOPLE_GETTING_HEART_TEST_POSITIVIE <- (heart_market$REGISTERED_HEART_TEST_POSITIVE + heart_market$SAMPLE_TAKEN_FOR_TEST_POSITIVE)/ (heart_market$REGISTERED_HEART_TEST+heart_market$SAMPLE_TAKEN_FOR_TEST)
heart_market$TOTAL_HEART_TEST_POSITIVE = heart_market$PERCENT_PEOPLE_GETTING_HEART_TEST_POSITIVIE * heart_market$TOTAL_HEART_TEST

heart_market$TOTAL_TEST_A_YEAR = heart_market$TOTAL_PEOPLE_TAKING_TEST*12/8
heart_market$TOTAL_HEART_TEST_A_YEAR = heart_market$TOTAL_HEART_TEST *12/8
heart_market$TOTAL_HEART_POSITIVE_A_YEAR = heart_market$TOTAL_HEART_TEST_POSITIVE*12/8

heart_market$POSITIVITY_RATE = heart_market$TOTAL_HEART_POSITIVE_A_YEAR/heart_market$TOTAL_HEART_TEST_A_YEAR

heart_market$ORDER_PER_PATIENT_OVERALL = heart_market$TOTAL_CID/heart_market$TOTAL_SID
heart_market$ORDER_PER_PATIENT_DIABATIC = heart_market$TEST_CID/(heart_market$REGISTERED_HEART_TEST+heart_market$SAMPLE_TAKEN_FOR_TEST)


write.csv(heart_market, file="heart_market.csv")
heart_market <- read.csv("heart_market.csv")
head(heart_market)
View(heart_market)
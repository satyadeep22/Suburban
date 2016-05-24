setwd('F:/final diabetes')

library(RODBC)

myconn = odbcConnect("suburban_data")

suburbandata <- sqlQuery(myconn, "select RecordNo, REG_CENTRE_NAME, PROCESS_CENTRE_NAME, REG_DT,
                         CID_NO, BAR_CODE, SID, AGE, GENDER, TEST_NAME, COMPONENT_NAME, RESULT_VALUE, 
                         [NORMAL_VALUE(B/W-RANGE)] as NORMAL_VALUE 
                         from dbo.Services_stats 
                         where TEST_NAME IN ('LIPID-P', 'GLYCO Hb (HbA1C)', 'FBS (PLASMA)' , 'PPBS (PLASMA)') ")


All_Test <- read.csv("All_Test_Normal_Values.csv")
All_Test <- All_Test[(All_Test$TEST_NAME %in% c('LIPID-P', 'GLYCO Hb (HbA1c)', 'FBS (PLASMA)' , 'PPBS (PLASMA)')),]
All_Test <- na.omit(All_Test)

All_Test <- All_Test[which(All_Test$no_rows >100),]
All_Test <- All_Test[!All_Test$COMPONENT_NAME %in% c('CHOL / HDL CHOL RATIO','LDL CHOL / HDL CHOL RATIO', 'VLDL CHOLESTEROL', 'NON HDL CHOLESTEROL' ),]
View(All_Test)

library(plyr)
rename(suburbandata, c("NORMAL_VALUE" = "NORMAL_VALUE.B.W.RANGE."))
names(suburbandata)[names(suburbandata)=="NORMAL_VALUE"] <- "NORMAL_VALUE.B.W.RANGE."


merged_suburbandata <- merge(All_Test,suburbandata, by = c("TEST_NAME", "COMPONENT_NAME", "NORMAL_VALUE.B.W.RANGE." ))
merged_suburbandata <- subset(merged_suburbandata, select = -c(X,no_rows))

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

na.omit(merged_suburbandata)

merged_suburbandata$RESULT_VALUE <- as.numeric(as.character(merged_suburbandata$RESULT_VALUE))
merged_suburbandata$NORMAL_LOWER_VALUE <- as.numeric(as.character(merged_suburbandata$NORMAL_LOWER_VALUE))
merged_suburbandata$NORMAL_UPPER_VALUE <- as.numeric(as.character(merged_suburbandata$NORMAL_UPPER_VALUE))
View(merged_suburbandata)
merged_suburbandata$POSITIVITY <- ifelse(merged_suburbandata$RESULT_VALUE < merged_suburbandata$NORMAL_LOWER_VALUE, 1,
                                         ifelse(merged_suburbandata$RESULT_VALUE > merged_suburbandata$NORMAL_UPPER_VALUE,1,0))
View(merged_suburbandata)

write.csv(merged_suburbandata, file="cleaned_suburbandata.csv")

cleaned_suburbandata <- read.csv("cleaned_suburbandata.csv")

diabetes_data <- cleaned_suburbandata[-which(cleaned_suburbandata$TEST_NAME == 'LIPID-P'),]

diabetes_data$MONTH <- as.POSIXlt(diabetes_data$REG_DT)$mon + 1
diabetes_data$AGE <- gsub("[^0-9]", "",diabetes_data$AGE)

diabetes_data$AGE_GROUP <- ifelse(diabetes_data$AGE <30, 'A', 
                            ifelse(diabetes_data$AGE <40,'B', 
                              ifelse(diabetes_data$AGE <50,'C', 
                                ifelse(diabetes_data$AGE <60,'D', 'E'  
                                )
                              )
                            )
                           )
write.csv(diabetes_data, file="diabetes_data.csv")
View(diabetes_data)

library(sqldf)
diabetes_CID <- sqldf("select MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, COUNT(DISTINCT(CID_NO)) as TEST_CID from diabetes_data
                             group by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER
                             order by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER")

diabetes_reg <- sqldf("select * from diabetes_data where SID like '1%' ")
diabetes_reg_pivot <- sqldf('select MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, SID, SUM(POSITIVITY) as SUM_POSITIVITY from diabetes_reg
                                   group by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, SID 
                                   order by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, SID')
diabetes_reg_pivot$diabetes_patient <- ifelse(diabetes_reg_pivot$SUM_POSITIVITY >0 ,1,0)

View(diabetes_reg_pivot)
diabetes_sample <- sqldf("select * from diabetes_data where SID NOT like '1%' ")
diabetes_sample_pivot <- sqldf('select MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, SID, SUM(POSITIVITY) as SUM_POSITIVITY from diabetes_sample
                                      group by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, SID 
                                      order by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, SID')

diabetes_sample_pivot$diabetes_patient <- ifelse(diabetes_sample_pivot$SUM_POSITIVITY >0 ,1,0)


final_diabetes_reg <- sqldf("select MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, 
                             COUNT(diabetes_patient) as REGISTERED_DIABETES, 
                             SUM(diabetes_patient) as REGISTERED_POSITIVE_DIABETES 
                             from diabetes_reg_pivot 
                             group by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER 
                             order by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER")
final_diabetes_sample <- sqldf("select MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER, 
                                COUNT(diabetes_patient) as SAMPLE_TAKEN_DIABETES, 
                                SUM(diabetes_patient) as SAMPLE_POSITIVE_DIABETES 
                                from diabetes_sample_pivot 
                                group by MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER order by 
                                MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER")


final_diabetes <- merge(final_diabetes_reg,final_diabetes_sample, 
                        by = c("MONTH","REG_CENTRE_NAME", "AGE_GROUP", "GENDER" ), all = TRUE)
View(final_diabetes)
final_diabetes[is.na(final_diabetes)] <- 0
final_diabetes1 <- merge(final_diabetes,diabetes_CID, 
                         by = c("MONTH","REG_CENTRE_NAME", "AGE_GROUP", "GENDER" ), all = TRUE)

final_diabetes1[is.na(final_diabetes1)] <- 0

write.csv(final_diabetes1, file="final_diabetes1.csv")

View(final_diabetes1)
AllData <- read.csv("AllData.csv")

Overall_data <- merge(final_diabetes, AllData, by = c("MONTH","REG_CENTRE_NAME", "AGE_GROUP", "GENDER" ), all = TRUE)
Overall_data[is.na(Overall_data)] <- 0
Overall_data$X <- NULL
View(Overall_data)

Overall_data$DIABETES_TEST_TAKEN <-  Overall_data$REGISTERED_DIABETES+Overall_data$SAMPLE_TAKEN_DIABETES
Overall_data$DIABETES_POSITIVE <- Overall_data$REGISTERED_POSITIVE_DIABETES+Overall_data$SAMPLE_POSITIVE_DIABETES

Overall_data$MONTH <- ifelse(Overall_data$MONTH == 1, 'JANUARY',
                             ifelse(Overall_data$MONTH == 2, 'FEBRUARY',
                                    ifelse(Overall_data$MONTH == 3, 'MARCH',
                                           ifelse(Overall_data$MONTH == 5, 'MAY',
                                                  ifelse(Overall_data$MONTH == 6, 'JUNE',
                                                         ifelse(Overall_data$MONTH == 7, 'JULY',
                                                                ifelse(Overall_data$MONTH == 8, 'AUGUST',
                                                                       ifelse(Overall_data$MONTH == 9, 'SEPTEMBER',
                                                                              ifelse(Overall_data$MONTH == 10, 'OCTOBER',
                                                                                     ifelse(Overall_data$MONTH == 11, 'NOVEMBER','DECEMBER'
                                                                                            
                                                                                     ))))))))))


write.csv(Overall_data, file = "overall_data.csv")


names(Overall_data)[names(Overall_data) == 'SUM.TOTAL_SID.'] <- 'TOTAL_SID'          
names(Overall_data)[names(Overall_data) == 'SUM.TOTAL_CID.'] <- 'TOTAL_CID'          


Final_Diabetes_Report <- sqldf('select MONTH, REG_CENTRE_NAME, AGE_GROUP, GENDER,
                                TOTAL_CID, TOTAL_SID, REGISTERED_DIABETES, REGISTERED_POSITIVE_DIABETES,
                                SAMPLE_TAKEN_DIABETES, SAMPLE_POSITIVE_DIABETES, DIABETES_TEST_TAKEN, DIABETES_POSITIVE
                               from Overall_data')

View(Final_Diabetes_Report)

wards <- read.csv("wards.csv")

wards <- subset(wards, select = -c(X))
View(wards)

Overall_market <- merge(Final_Diabetes_Report, wards, by = c("REG_CENTRE_NAME"))
View(Overall_market)


write.csv(Overall_market, file= "Overall_market.csv")

Mumbai_Overall <- read.csv("Mumbai_Area_Overall.csv")
ward_demographics <- sqldf("select WARD, SUM(MALE) as TOTAL_MALE, SUM(FEMALE) as TOTAL_FEMALE, 
                           SUM(TOTAL_POPULATION) as TOTAL_POPULATION, SUM(AREA_SKM) as AREA_SKM 
                           from Mumbai_Overall group by WARD order by WARD")

View(ward_demographics)
newsample <- sqlQuery(myconn, "select RECORD_NO, REG_CENTRE_NAME, PROCESS_CENTRE_NAME, CID_NO, BAR_CODE, SID, AGE, GENDER, TEST_NAME, COMPONENT_NAME,
RESULT_VALUE, [NORMAL_VALUE(B/W-RANGE)] as NORMAL_VALUE.B.W.RANGE. from dbo.Services_stats where TEST_NAME IN ('LIPID-P', 'GLYCO Hb (HbA1C)', 'FBS (PLASMA)' , 'PPBS (PLASMA)') ")


RegCentre <- unique(newsample$REG_CENTRE_NAME)
View(RegCentre)

# Only Mumbai Data
newsample2 <- newsample[!newsample$REG_CENTRE_NAME %in% c('Pune Ankur Diagnostics', 'Pune Aundh'
                                                          ,'Pune Usha Nursing', 'Pune Ask Pathology',  'Pune Swargate',
                                                          'Pune Life line', 'Pune Lab', 'Pune Baner',
                                                          'Pune Kothrud',  'Pune Polaris Healthcare', 
                                                          'Pune Lulla Nagar', 'Pune Thepade Diagnostics', 'Pune Satyam', 'Pune Karve Nagar',
                                                          'Goa Panjim', 'Goa Parvorim', 'Pune Viman Nagar', 'Goa ponda', 'Pune Bajirao Road',
                                                          'Goa Lab', 'Pune Cloudnine Hospital', 'Pune HSCC Nagar', 'Pune Sinhgad Road', 'Goa-Margao',
                                                          'Bhakti Diagnostics - Latur','Pune Model Colony', 'Goa Navelim', 'Pune Kondhwa'),]




View(newsample2)
newsample2$NORMAL_VALUE.B.W.RANGE. <- as.character(newsample2$NORMAL_VALUE.B.W.RANGE.)
newsample2$NORMAL_LOWER_VALUE <- as.character(newsample2$NORMAL_LOWER_VALUE)
newsample2$NORMAL_UPPER_VALUE <- as.character(newsample2$NORMAL_UPPER_VALUE)
newsample2$NORMAL_VALUE.B.W.RANGE. <- ifelse(newsample2$NORMAL_VALUE.B.W.RANGE. == "", "DNP", newsample2$NORMAL_VALUE.B.W.RANGE. )
View(newsample2)
newsample2$NORMAL_LOWER_VALUE <- ifelse(newsample2$NORMAL_LOWER_VALUE == "", "DNP", newsample2$NORMAL_LOWER_VALUE )
newsample2$NORMAL_UPPER_VALUE <- ifelse(newsample2$NORMAL_UPPER_VALUE == "", "DNP", newsample2$NORMAL_UPPER_VALUE )



new_diabetes_data <- newsample2[-which(newsample2$TEST_NAME == 'LIPID-P'),]

new_heart_data <- newsample5[which(newsample5$TEST_NAME == 'LIPID-P'),]
new_heart_data <- new_heart_data[-which(new_heart_data$COMPONENT_NAME == 'NON HDL CHOLESTEROL'),]
new_heart_data <- new_heart_data[-which(new_heart_data$COMPONENT_NAME == 'LDL CHOL / HDL CHOL RATIO'),]
new_heart_data <- new_heart_data[-which(new_heart_data$COMPONENT_NAME == 'CHOL / HDL CHOL RATIO'),]
new_heart_data <- new_heart_data[-which(new_heart_data$COMPONENT_NAME == 'VLDL CHOLESTEROL'),]
write.csv(new_heart_data, file="new_heart_data.csv")

write.csv(new_diabetes_data, file="new_diabetes_data.csv")



All_Test <- read.csv("All_Test_Normal_Values.csv")
All_Test <- All_Test[(All_Test$TEST_NAME %in% c('LIPID-P', 'GLYCO-Hb (HbA1C)', 'FBS (PLASMA)' , 'PPBS (PLASMA)')),]
All_Test <- na.omit(All_Test)
View(All_Test)
All_Test$NORMAL_VALUE.B.W.RANGE. <- as.character(All_Test$NORMAL_VALUE.B.W.RANGE.)
All_Test$NORMAL_LOWER_VALUE <- as.character(All_Test$NORMAL_LOWER_VALUE)
All_Test$NORMAL_UPPER_VALUE <- as.character(All_Test$NORMAL_UPPER_VALUE)
All_Test$NORMAL_VALUE.B.W.RANGE. <- ifelse(All_Test$NORMAL_VALUE.B.W.RANGE. == "", "DNP", All_Test$NORMAL_VALUE.B.W.RANGE. )
View(All_Test)
All_Test$NORMAL_LOWER_VALUE <- ifelse(All_Test$NORMAL_LOWER_VALUE == "", "DNP", All_Test$NORMAL_LOWER_VALUE )
All_Test$NORMAL_UPPER_VALUE <- ifelse(All_Test$NORMAL_UPPER_VALUE == "", "DNP", All_Test$NORMAL_UPPER_VALUE )

merged_diabetes_data <- merge(new_diabetes_data, All_Test, by="REG_CENTRE_NAME")

merged_diabetes_data <- read.csv("merged_diabetes_data.csv")
merged_diabetes_data2 <- merged_diabetes_data
merged_diabetes_data2$RESULT_VALUE <- as.character(merged_diabetes_data2$RESULT_VALUE)
merged_diabetes_data2$NORMAL_LOWER_VALUE <- as.character(merged_diabetes_data2$NORMAL_LOWER_VALUE)
merged_diabetes_data2$NORMAL_UPPER_VALUE <- as.character(merged_diabetes_data2$NORMAL_UPPER_VALUE)
merged_diabetes_data2$POSITIVITY <- ifelse(merged_diabetes_data2$RESULT_VALUE < merged_diabetes_data2$NORMAL_LOWER_VALUE, 1,
                                           ifelse(merged_diabetes_data2$RESULT_VALUE > merged_diabetes_data2$NORMAL_UPPER_VALUE,1,0))
View(merged_diabetes_data2)
write.csv(merged_diabetes_data2, file="merged_diabetes_data2.csv")

merged_heart_data <- read.csv("merged_heart_data.csv")
merged_heart_data2 <- merged_heart_data
merged_heart_data2$RESULT_VALUE <- as.character(merged_heart_data2$RESULT_VALUE)
merged_heart_data2$NORMAL_LOWER_VALUE <- as.character(merged_heart_data2$NORMAL_LOWER_VALUE)
merged_heart_data2$NORMAL_UPPER_VALUE <- as.character(merged_heart_data2$NORMAL_UPPER_VALUE)
merged_heart_data2$POSITIVITY <- ifelse(merged_heart_data2$RESULT_VALUE >= merged_heart_data2$NORMAL_LOWER_VALUE, 0,
                                        ifelse(merged_heart_data2$RESULT_VALUE <= merged_heart_data2$NORMAL_UPPER_VALUE,0,1))
View(merged_heart_data2)
write.csv(merged_heart_data2, file="merged_heart_data2.csv")



merged_diabetes_data2 <- read.csv("merged_diabetes_data2.csv")
merged_diabetes_data2 <- merged_diabetes_data
merged_diabetes_data2$RESULT_VALUE <- as.character(merged_diabetes_data2$RESULT_VALUE)
merged_diabetes_data2$NORMAL_LOWER_VALUE <- as.character(merged_diabetes_data2$NORMAL_LOWER_VALUE)
merged_diabetes_data2$NORMAL_UPPER_VALUE <- as.character(merged_diabetes_data2$NORMAL_UPPER_VALUE)
merged_diabetes_data2$POSITIVITY <- ifelse(merged_diabetes_data2$RESULT_VALUE < merged_diabetes_data2$NORMAL_LOWER_VALUE, 1, ifelse(merged_diabetes_data2$RESULT_VALUE <= merged_diabetes_data2$NORMAL_UPPER_VALUE,1,0))
View(merged_diabetes_data2)
write.csv(merged_diabetes_data2, file="merged_diabetes_data2.csv")

library(sqldf)
merged_diabetes_reg <- sqldf("select * from merged_diabetes_data2 where SID like '1%' ")
merged_diabetes_reg_pivot <- sqldf('select REG_CENTRE_NAME, SID, sum(POSITIVITY) as SUM_POSITIVITY from merged_diabetes_reg group by REG_CENTRE_NAME, SID order by REG_CENTRE_NAME ')
merged_diabetes_reg_pivot$diabetes_patient <- ifelse(merged_diabetes_reg_pivot$SUM_POSITIVITY >0 ,1,0)

merged_diabetes_sample <- sqldf("select * from merged_diabetes_data2 where SID NOT like '1%' ")
View(merged_diabetes_sample)
merged_diabetes_sample_pivot <- sqldf('select REG_CENTRE_NAME, SID, sum(POSITIVITY) as SUM_POSITIVITY from merged_diabetes_sample group by REG_CENTRE_NAME, SID order by REG_CENTRE_NAME ')
merged_diabetes_sample_pivot$diabetes_patient <- ifelse(merged_diabetes_sample_pivot$SUM_POSITIVITY >0 ,1,0)


final_diabetes_reg <- sqldf("select REG_CENTRE_NAME, COUNT(diabetes_patient) as ADMITTED_REG_DIABETES, SUM(diabetes_patient) as POSITIVE_REG_DIABETES from merged_diabetes_reg_pivot group by REG_CENTRE_NAME order by REG_CENTRE_NAME")
final_diabetes_sample <- sqldf("select REG_CENTRE_NAME, COUNT(diabetes_patient) as ADMITTED_SAMPLE_DIABETES, SUM(diabetes_patient) as POSITIVE_SAMPLE_DIABETES from merged_diabetes_sample_pivot group by REG_CENTRE_NAME order by REG_CENTRE_NAME")
str(final_diabetes_reg)
str(final_diabetes_sample)

write.csv(final_diabetes_reg, file= "final_diabetes_reg.csv")
write.csv(final_diabetes_sample, file= "final_diabetes_sample.csv")

final_diabetes <- merge(final_diabetes_reg,final_diabetes_sample, by = c("REG_CENTRE_NAME" ), all = TRUE)
str(final_diabetes)
final_diabetes[is.na(final_diabetes)] <- 0

market_size_diabetes <- merge(final_diabetes, Region_Wise_Test_CID, by = c("REG_CENTRE_NAME"))
market_size_diabetes <- merge(market_size_diabetes, Region_Wise_Test_SID, by = c("REG_CENTRE_NAME"))
View(market_size_diabetes)
View(Region_Wise_Test_SID)

write.csv(market_size_diabetes, file="market_size_diabetes.csv")

wards <- read.csv("wards.csv")

market_size_diabetes <- merge(market_size_diabetes, wards, by = c("REG_CENTRE_NAME"))
write.csv(market_size_diabetes, file="market_size_diabetes.csv")

read.csv("market_size_diabetes.csv")
View(market_size_diabetes)
final_market_diabetes <- sqldf("select WARDS, SUM(TOTAL_CID),SUM(TOTAL_SID), COUNT(REG_CENTRE_NAME),SUM(ADMITTED_REG_DIABETES), SUM(POSITIVE_REG_DIABETES), SUM(ADMITTED_SAMPLE_DIABETES), SUM( POSITIVE_SAMPLE_DIABETES)  from market_size_diabetes group by WARDS order by WARDS")

ward_demographic <- read.csv("ward_demographic.csv")
View(ward_demographic)
final_market_size_diabetes <- merge(final_market_diabetes, ward_demographic, by = c("WARDS"))
View(final_market_size_diabetes)
write.csv(final_market_size_diabetes, file="final_market_size_diabetes.csv")
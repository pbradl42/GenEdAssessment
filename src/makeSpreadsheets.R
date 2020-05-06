## READ IN THE LIBRARIES THAT WE NEED
library(tidyverse)
library(readxl)
library(writexl)
library(rJava)
library(xlsx)
library(knitr)


## SET THE META-DATA FOR SHEET 1
Prompts <- c("Total possible points","Assignment description","Instructor reflections","","MARK ONE STANDARD MEASURE","1. Selected response exams","2. Constructed response exams","3. Pre- and post-tests","4. Standardized tests","5. Short written reports","6. Medium written reports","7. Long written reports","8. Student projects","9. Laboratory reports","10. Student portfolios","11. Capstone projects","12. Oral presentations","13. Student performances","14. Oral interviews","","MARK ONE PROPOSED ACTION","1. No changes; continue data collection","2. Alter the scope and sequence of instruction in the course","3. Alter the pedagogical approach used","4. Alter the assignment used","5. Alter the assessment method","6. Alter the learning outcome")
Responses <- NA
meta.data <- data.frame(Prompts,Responses)


## MAKE SURE THAT THE DATA DIRECTORIES EXIST
#--> COLL
if(!dir.exists("../output/workbooks/COLL"))
	dir.create("../output/workbooks/COLL")

#--> COMS
if(!dir.exists("../output/workbooks/COMS"))
	dir.create("../output/workbooks/COMS")

#--> COMW
if(!dir.exists("../output/workbooks/COMW"))
	dir.create("../output/workbooks/COMW")

#--> CULT
if(!dir.exists("../output/workbooks/CULT"))
	dir.create("../output/workbooks/CULT")

#--> DIVG
if(!dir.exists("../output/workbooks/DIVG"))
	dir.create("../output/workbooks/DIVG")

#--> DIVU
if(!dir.exists("../output/workbooks/DIVU"))
	dir.create("../output/workbooks/DIVU")

#--> NSCI
if(!dir.exists("../output/workbooks/NSCI"))
	dir.create("../output/workbooks/NSCI")

#--> PROB
if(!dir.exists("../output/workbooks/PROB"))
	dir.create("../output/workbooks/PROB")

#--> QUAN
if(!dir.exists("../output/workbooks/QUAN"))
	dir.create("../output/workbooks/QUAN")

#--> SSOC
if(!dir.exists("../output/workbooks/SSOC"))
	dir.create("../output/workbooks/SSOC")


## CREATE SPREADSHEETS BY COMPETENCY
#--> COLL
collData <- read_csv("../output/data/collData.csv")
listCRN <- NULL
listCRN <- unique(collData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- collData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/COLL/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",collVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(collVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
logFile <- tibble("Competency"="COLL","Number"=length(unique(collData$CRN)))

#--> COMS
comsData <- read_csv("../output/data/comsData.csv")
listCRN <- NULL
listCRN <- unique(comsData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- comsData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/COMS/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",comsVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(comsVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
comsLog <- c("COMS", length(unique(comsData$CRN)))
logFile <- rbind(logFile, comsLog)

#--> COMW
comwData <- read_csv("../output/data/comwData.csv")
listCRN <- NULL
listCRN <- unique(comwData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- comwData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/COMW/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",comwVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(comwVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
comwLog <- c("COMW", length(unique(comwData$CRN)))
logFile <- rbind(logFile, comwLog)

#--> CULT
cultData <- read_csv("../output/data/cultData.csv")
listCRN <- NULL
listCRN <- unique(cultData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- cultData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/CULT/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",cultVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(cultVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
cultLog <- c("CULT", length(unique(cultData$CRN)))
logFile <- rbind(logFile, cultLog)

#--> DIVG
divgData <- read_csv("../output/data/divgData.csv")
listCRN <- NULL
listCRN <- unique(divgData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- divgData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/DIVG/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",divgVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(divgVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
divgLog <- c("DIVG", length(unique(divgData$CRN)))
logFile <- rbind(logFile, divgLog)

#--> DIVU
divuData <- read_csv("../output/data/divuData.csv")
listCRN <- NULL
listCRN <- unique(divuData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- divuData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/DIVU/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",divuVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(divuVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
divuLog <- c("DIVU", length(unique(divuData$CRN)))
logFile <- rbind(logFile, divuLog)

#--> NSCI
nsciData <- read_csv("../output/data/nsciData.csv")
listCRN <- NULL
listCRN <- unique(nsciData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- nsciData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/NSCI/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",nsciVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(nsciVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
nsciLog <- c("NSCI", length(unique(nsciData$CRN)))
logFile <- rbind(logFile, nsciLog)

#--> PROB
probData <- read_csv("../output/data/probData.csv")
listCRN <- NULL
listCRN <- unique(probData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- probData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/PROB/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",probVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(probVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
probLog <- c("PROB", length(unique(probData$CRN)))
logFile <- rbind(logFile, probLog)

#--> QUAN
quanData <- read_csv("../output/data/quanData.csv")
listCRN <- NULL
listCRN <- unique(quanData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- quanData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/QUAN/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",quanVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(quanVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
quanLog <- c("QUAN", length(unique(quanData$CRN)))
logFile <- rbind(logFile, quanLog)

#--> SSOC
ssocData <- read_csv("../output/data/ssocData.csv")
listCRN <- NULL
listCRN <- unique(ssocData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- ssocData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/SSOC/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",ssocVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(ssocVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
ssocLog <- c("SSOC", length(unique(ssocData$CRN)))
logFile <- rbind(logFile, ssocLog)

write_csv(logFile,"../output/data/logFile.csv")

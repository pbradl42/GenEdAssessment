## READ IN THE LIBRARIES THAT WE NEED
library(tidyverse)
library(readxl)
library(writexl)
library(rJava)
library(xlsx)
library(knitr)


## SET THE VARIABLES FOR THE ASSESSMENT PERIOD HERE
password <- "gened_202001"
theYear <- "2020"
theSemester <- "Spring"
collVar <- "COL1"
comsVar <- "COMS1"
comwVar <- "COMW1"
cultVar <- "CUL1"
divgVar <- "DIVG1"
divuVar <- "DIVU1"
nsciVar <- "SCI1"
probVar <- "PRB1"
quanVar <- "QNT1"
ssocVar <- "SOC1"
##--> Set up the meta data worksheet dataframe
Prompts <- c("Total possible points","Assignment description","Instructor reflections","","MARK ONE STANDARD MEASURE","1. Selected response exams","2. Constructed response exams","3. Pre- and post-tests","4. Standardized tests","5. Short written reports","6. Medium written reports","7. Long written reports","8. Student projects","9. Laboratory reports","10. Student portfolios","11. Capstone projects","12. Oral presentations","13. Student performances","14. Oral interviews","","MARK ONE PROPOSED ACTION","1. No changes; continue data collection","2. Alter the scope and sequence of instruction in the course","3. Alter the pedagogical approach used","4. Alter the assignment used","5. Alter the assessment method","6. Alter the learning outcome")
Responses <- NA
meta.data <- data.frame(Prompts,Responses)


## READ IN THE DATA AND FORMAT IT
myData <- read_xlsx("./_data/202001-GenEd-Data.xlsx")
myData <- myData %>%  rename(Term=TERM,
							 CRN=CRN,
							 College=COURSE_COLL_CODE,
							 Prefix=SUBJ,
							 Number=CRSE_NUMB,
							 Section=SECTION,
							 ID=ID,
							 Name=STU_NAME,
							 Instructor=INSTR_NAME)

#--> Recoding the colleges
myData[myData$College=="AS","College"] <- "CAS"
myData[myData$College=="BU","College"] <- "COB"
myData[myData$College=="ED","College"] <- "COEHS"
myData[myData$College=="TE","College"] <- "CET"
myData[myData$College=="HP","College"] <- "CHP"
myData[myData$College=="UN","College"] <- "UNIV"

#--> Add new variables
myData$Course <- paste0(myData$Prefix,myData$Number)
myData <- myData %>% separate(Instructor,c("Instructor.Last","Instructor.First"), ",", remove=FALSE)


## SPLIT OUT DATA BY COMPETENCY
#--> COLL
collData <- myData %>%
	filter(COLL == 1)

#--> COMS
comsData <- myData %>%
	filter(COMS == 1)

#--> COMW
comwData <- myData %>%
	filter(COMW == 1)

#--> CULT
cultData <- myData %>%
	filter(!is.na(ACTC) | !is.na(CATC) | !is.na(CLTR))

#--> DIVG
divgData <- myData %>%
	filter(DIVG == 1)

#--> DIVU
divuData <- myData %>%
	filter(DIVU == 1)

#--> NSCI
nsciData <- myData %>%
	filter(NSCL == 1 | NSCI == 1)

#--> PROB
probData <- myData %>%
	filter(PROB == 1)

#--> QUAN
quanData <- myData %>%
	filter(QUAL == 1)

#--> SSOC
ssocData <- myData %>%
	filter(SSOC == 1 | SSOF == 1)


## MAKE SURE THAT THE DATA DIRECTORIES EXIST
#--> COLL
if(!dir.exists("COLL"))
	dir.create("COLL")

#--> COMS
if(!dir.exists("COMS"))
	dir.create("COMS")

#--> COMW
if(!dir.exists("COMW"))
	dir.create("COMW")

#--> CULT
if(!dir.exists("CULT"))
	dir.create("CULT")

#--> DIVG
if(!dir.exists("DIVG"))
	dir.create("DIVG")

#--> DIVU
if(!dir.exists("DIVU"))
	dir.create("DIVU")

#--> NSCI
if(!dir.exists("NSCI"))
	dir.create("NSCI")

#--> PROB
if(!dir.exists("PROB"))
	dir.create("PROB")

#--> QUAN
if(!dir.exists("QUAN"))
	dir.create("QUAN")

#--> SSOC
if(!dir.exists("SSOC"))
	dir.create("SSOC")


## CREATE SPREADSHEETS BY COMPETENCY
#--> COLL
listCRN <- NULL
listCRN <- unique(collData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- collData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./COLL/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",collVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(collVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> COMS
listCRN <- NULL
listCRN <- unique(comsData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- comsData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./COMS/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",comsVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(comsVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> COMW
listCRN <- NULL
listCRN <- unique(comwData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- comwData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./COMW/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",comwVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(comwVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> CULT
listCRN <- NULL
listCRN <- unique(cultData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- cultData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./CULT/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",cultVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(cultVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> DIVG
listCRN <- unique(divgData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- divgData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./DIVG/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",divgVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(divgVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> DIVU
listCRN <- unique(divuData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- divuData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./DIVU/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",divuVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(divuVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> NSCI
listCRN <- unique(nsciData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- nsciData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./NSCI/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",nsciVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(nsciVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> PROB
listCRN <- unique(probData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- probData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./PROB/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",probVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(probVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)

}

#--> QUAN
listCRN <- unique(quanData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- quanData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./QUAN/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",quanVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(quanVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

#--> SSOC
listCRN <- unique(ssocData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- ssocData %>% filter(CRN == listCRN[i])
	fileName <- paste0("./SSOC/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",ssocVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!(ssocVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}

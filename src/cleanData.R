## READ IN THE LIBRARIES THAT WE NEED
library(tidyverse)
library(readxl)
library(writexl)
library(rJava)
library(xlsx)
library(knitr)

## SET THE VARIABLES FOR THE ASSESSMENT PERIOD HERE (DATAFILE AND OUTCOME NUMBER)
rawData <- "../rawdata/202001_GenEd-Data_Rec-20200423.xlsx"
outcomeNumber <- "4"



## SET UP A TIBBLE WITH ALL GENERAL EDUCATION OUTOMES
coll <- c("COL1","COL2","COL3","COL4")
coms <- c("COMS1","COMS2","COMS3","COMS4")
comw <- c("COMW1","COMW2","COMW3","COMW4")
cult <- c("CUL1","CUL2","CUL3","CUL4")
divg <- c("DIVG1","DIVG2","DIVG3","DIVG4")
divu <- c("DIVU1","DIVU2","DIVU3","DIVU4")
nsci <- c("SCI1","SCI2","SCI3","SCI4")
prob <- c("PRB1","PRB2","PRB3","PRB4")
quan <- c("QNT1","QNT2","QNT3","QNT4")
ssoc <- c("SOC1","SOC2","SOC3","SOC4")
Outcomes <- tibble(COL=coll,COMS=coms,COMW=comw,CUL=cult,DIVG=divg,DIVU=divu,SCI=nsci,PRB=prob,QNT=quan,SOC=ssoc)

## PICK THE CURRENT OUTCOMES
collVar <- Outcomes[outcomeNumber,"COL"]
comsVar <- Outcomes[outcomeNumber,"COMS"]
comwVar <- Outcomes[outcomeNumber,"COMW"]
cultVar <- Outcomes[outcomeNumber,"CUL"]
divgVar <- Outcomes[outcomeNumber,"DIVG"]
divuVar <- Outcomes[outcomeNumber,"DIVU"]
nsciVar <- Outcomes[outcomeNumber,"SCI"]
probVar <- Outcomes[outcomeNumber,"PRB"]
quanVar <- Outcomes[outcomeNumber,"QNT"]
ssocVar <- Outcomes[outcomeNumber,"SOC"]


## READ IN THE DATA AND FORMAT IT
myData <- read_xlsx(rawData, col_types = "text")

#--> Recode the mappings
myData$ACTC <- recode(myData$ACTC, X=1)
myData$CATC <- recode(myData$CATC, X=1)
myData$CLTR <- recode(myData$CLTR, X=1)
myData$COMS <- recode(myData$COMS, X=1)
myData$COMW <- recode(myData$COMW, X=1)
myData$COLL <- recode(myData$COLL, X=1)
myData$DIVG <- recode(myData$DIVG, X=1)
myData$DIVU <- recode(myData$DIVU, X=1)
myData$NSCI <- recode(myData$NSCI, X=1)
myData$NSCL <- recode(myData$NSCL, X=1)
myData$PROB <- recode(myData$PROB, X=1)
myData$QUAL <- recode(myData$QUAL, X=1)
myData$SSOC <- recode(myData$SSOC, X=1)
myData$SSOF <- recode(myData$SSOF, X=1)

#--> Rename the variables
myData <- myData %>%  rename(Term=TERM,
							 CRN=CRN,
							 College=COURSE_COLL_CODE,
							 Prefix=SUBJ,
							 Number=CRSE_NUMB,
							 Section=SECTION,
							 ID=ID,
							 Name=STU_NAME,
							 Instructor=INSTR_NAME,
							 Email=INSTR_EMAIL)

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
myData <- myData %>% separate(Term,c("Year","Semester"), 4, remove=FALSE)
myData$Semester <- recode(myData$Semester, "01" = "Spring", "06" = "Summer", "08" = "Fall")
write_csv(myData, "../output/data/cleanData.csv")

## SPLIT OUT DATA BY COMPETENCY
#--> COLL
collData <- myData %>%
	filter(COLL == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(collVar))
write_csv(collData, "../output/data/collData.csv")

#--> COMS
comsData <- myData %>%
	filter(COMS == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(comsVar))
write_csv(comsData, "../output/data/comsData.csv")

#--> COMW
comwData <- myData %>%
	filter(COMW == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(comwVar))
write_csv(comwData, "../output/data/comwData.csv")

#--> CULT
cultData <- myData %>%
	filter(!is.na(ACTC) | !is.na(CATC) | !is.na(CLTR)) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(cultVar))
write_csv(cultData, "../output/data/cultData.csv")

#--> DIVG
divgData <- myData %>%
	filter(DIVG == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(divgVar))
write_csv(divgData, "../output/data/divgData.csv")

#--> DIVU
divuData <- myData %>%
	filter(DIVU == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(divuVar))
write_csv(divuData, "../output/data/divuData.csv")

#--> NSCI
nsciData <- myData %>%
	filter(NSCL == 1 | NSCI == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(nsciVar))
write_csv(nsciData, "../output/data/nsciData.csv")

#--> PROB
probData <- myData %>%
	filter(PROB == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(probVar))
write_csv(probData, "../output/data/probData.csv")

#--> QUAN
quanData <- myData %>%
	filter(QUAL == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(quanVar))
write_csv(quanData, "../output/data/quanData.csv")

#--> SSOC
ssocData <- myData %>%
	filter(SSOC == 1 | SSOF == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(ssocVar))
write_csv(ssocData, "../output/data/ssocData.csv")

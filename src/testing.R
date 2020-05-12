## READ IN THE LIBRARIES THAT WE NEED
library(tidyverse)
library(readxl)
library(writexl)
library(rJava)
library(xlsx)
library(knitr)
library(gmailr)

## SET THE VARIABLES FOR THE ASSESSMENT PERIOD HERE (DATAFILE AND OUTCOME NUMBER)
rawData <- "../rawdata/Test_Dataset.xlsx"
outcomeNumber <- "4"
dueDate <- "September 3, 2020"


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
test <- c("TST1","TST2","TST3","TST4")
Outcomes <- tibble(COL=coll,COMS=coms,COMW=comw,CUL=cult,DIVG=divg,DIVU=divu,SCI=nsci,PRB=prob,QNT=quan,SOC=ssoc,TST=test)

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
testVar <- Outcomes[outcomeNumber,"TST"]


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
myData$TEST <- recode(myData$TEST, X=1)

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
testData <- myData %>%
	filter(TEST == 1) %>%
	select(Semester, Year, CRN, College, Course, Section, Instructor, Instructor.First, Instructor.Last, Email, ID, Name) %>%
	mutate(Outcome=as.character(testVar))
write_csv(testData, "../output/data/testData.csv")


## MAKE SUBDIRECTORY
#--> TEST
if(!dir.exists("../output/workbooks/TEST"))
	dir.create("../output/workbooks/TEST")


## CREATE SPREADSHEETS
listCRN <- NULL
listCRN <- unique(testData$CRN)
files <- NULL
for (i in 1:as.numeric(length(listCRN))){
	dataCRN <- testData %>% filter(CRN == listCRN[i])
	fileName <- paste0("../output/workbooks/TEST/",dataCRN$Instructor.Last,"-",dataCRN$College,"-",dataCRN$Course,"-",dataCRN$Section,"-",testVar,".xlsx")
	courseData <- tibble(Student.Name=dataCRN$Name,Student.ID=dataCRN$ID,!!as.character(testVar):=NA)
	courseData <- arrange(courseData,Student.Name)
	write_xlsx(x=list(meta.data,courseData),path=fileName)
}
testLog <- c("TEST", length(unique(testData$CRN)))
logFile <- tibble(Outcome="TEST",Workbooks=length(list.files("../output/workbooks/TEST")))
write_csv(logFile,"../output/data/logFile.csv")


## SET THE META-DATA FOR SHEET 1
Prompts <- c("Total possible points","Assignment description","Instructor reflections","","MARK ONE STANDARD MEASURE","1. Selected response exams","2. Constructed response exams","3. Pre- and post-tests","4. Standardized tests","5. Short written reports","6. Medium written reports","7. Long written reports","8. Student projects","9. Laboratory reports","10. Student portfolios","11. Capstone projects","12. Oral presentations","13. Student performances","14. Oral interviews","","MARK ONE STANDARD PEDAGOGY","1. Face-to-face delivery","2. Blended delivery","3. Completely online delivery","4. Laboratory experience","5. Field experience","6. Internship or fellowship","","MARK ONE PROPOSED ACTION","1. No changes; continue data collection","2. Alter the scope and sequence of instruction in the course","3. Alter the pedagogical approach used","4. Alter the assignment used","5. Alter the assessment method","6. Alter the learning outcome")
Responses <- NA
meta.data <- data.frame(Prompts,Responses)

## MAKE LISTS OF RECIPIENTS FOR THE COMPETENCY
## --> TEST
testList <- testData %>%
	select(-Name, -ID) %>%
	unique()
testList$Attachment <- paste0("../output/workbooks/TEST/",testList$Instructor.Last,"-",testList$College,"-",testList$Course,"-",testList$Section,"-",testVar,".xlsx")
testList$Full.Name <- paste(testList$Instructor.First,testList$Instrutor.Last)


## EMAIL FILES
gm_auth_configure(path="../rawdata/SendMailProject.json")

## SET UP AND SEND EMAILS BY COMPETENCY
##--> Set up composed emails in a dataframe
this_hw <- "Testing"
email_sender <- 'Clifton Franklund <cliftonfranklund@ferris.edu>'
body <- "<p>Greetings,</p>

<p>It is once again time to submit General Education assessment data. This semester, we are using a new streamlined process to simplify your reporting experience. You will get one of these emails for every combination of General Education course section and competency that you teach. Sorry for all the emails; it is easier to keep track of everything this way.</p>

<p>Attached, you will find a simple Excel workbook to report your assessment data. Everything that you need to know about this process is described on our General Education Data SharePoint site.</p>

<p>https://ferrisstateuniversity.sharepoint.com/sites/GeneralEducationData</p>

<p>The site includes two short video tutorials are available that explain how to use it (or you can read the short instructions below).</p>
<ul>
	<li><strong>Video 1:</strong> How to complete your Excel workbook</li>
    <li><strong>Video 2:</strong> How to submit your completed Excel workbook</li>
</ul>

<strong>Completed workbooks should be submitted to the SharePoint site by: %s.</strong>

<hr>

<p><strong>INSTRUCTIONS</strong></p>

<p>Select an assignment from your course that you think best addresses this semester’s outcome. This ought to be a substantial work (not just a five-point quiz) and may also represent just a portion (sub-score) of one assignment or an aggregated measure of several related assignments.<p>
<ol type='1'>
	<li>Completing “Sheet 1”</li>
	<ol type='A'>
    	<li>Indicate the total number of possible points for your assignment. If you are using 0 to 4 rubric scores to report, just put “rubric” here.</li>
    	<li>Provide a one or two sentence description of your assignment.</li>
    	<li>Provide a one or two sentence reflection upon your students’ performance on the assignment. Were the scores unusually high or low? Were the results typical?</li>
    	<li>Put an X next to the standard measure that best describes your assignment. Definitions of these can be found at https://www.ferris.edu/HTMLS/academics/general-education/evidence/measures.htm</li>
    	<li>Put an X next to the action that best describes your intention moving forward in this course.</li>
    </ol>
  	<li>Completing “Sheet 2”</li>
    <ol type='A'>
    	<li>Enter scores for each student in your course section in the outcome column. These can either be points on the assignment or a rubric score from 0 to 4 (whole numbers only for rubric scores).</li>
    	<li>If a student dropped or withdrew from the class, leave that cell blank.</li>
    	<li>If a student earned a 0 for any reason, enter the score as 0.</li>
    </ol>
  	<li>Submitting your completed workbook</li>
  	<ol type='A'>
  		<li>Log into General Education Data SharePoint site using the link given above.</li>
    	<li>In “Documents” open the folder for the correct academic term.</li>
    	<li>Open the folder for the core competency that you assessed.</li>
    	<li>Drag and drop your file into that folder</li>
    </ol>
</ol>

<p><strong><em>You are all done!</em></strong> Please do not alter student ID numbers, change column headings, or rename your workbook. Doing so may make it impossible to analyze your results later. Thank you.</p>
<p>Clifton Franklund<br />
General Education Assessement Coordinator<br />
CliftonFranklund@ferris.edu</p>"

##--> Defining an email function (only way I can get a file attached)
prepare_and_send <- function(sender, recepient,
							 title, text,
							 attachment) {
	email <- gm_mime() %>%
		gm_to(sender) %>%
		gm_from(recepient) %>%
		gm_subject(title) %>%
		gm_html_body(text) %>%
		gm_attach_file(attachment, type = "html") %>%
		gm_send_message()
}

##--> Send a single test email
#prepare_and_send("franklc@ferris.edu","frankc@ferris.edu","Test","This is a test.","./TEST/Franklund-CAS-FAKE101-001-TEST1.xlsx")

##--> Send a small batch of test emails
composedEmails <- testList %>%
	mutate(
		To = sprintf('%s <%s>', Full.Name, Email),
		From = email_sender,
		Subject = sprintf('Reporting General Education %s assessment results for %s section %s, %s %s', Outcome, Course, Section, Semester, Year),
		Body = sprintf(body,dueDate),
		Attachment = Attachment) %>%
	select(To, From, Subject, Body, Attachment)
write_csv(composedEmails, "../output/data/composed_emails.csv")

sent_mail <- composedEmails %>%
	mutate(x = pmap(list(To, From, Subject, Body, Attachment),safely(prepare_and_send)))

saveRDS(sent_mail,
		paste0("../output/data/",gsub("\\s+", "_", this_hw), "-sent-emails.rds"))

errors <- sent_mail$x %>%
	transpose() %>%
	.$error %>%
	map_lgl(Negate(is.null))

print(paste0("A total of ",length(errors)," emails were processed with ",sum(errors)," errors."))



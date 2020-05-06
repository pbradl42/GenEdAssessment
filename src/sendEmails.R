## READ IN THE LIBRARIES THAT WE NEED
library(tidyverse)
library(readxl)
library(writexl)
library(knitr)
library(gmailr)
library(purr)
library(readr)

gm_auth_configure(path="_data/SendMailProject.json")
##--> Prime the pump
#prime <- gm_mime() %>%
#	gm_to("cliftonfranklund@ferris.edu") %>%
#	gm_from("cliftonfranklund@ferris.edu") %>%
#	gm_subject("Test email subject") %>%
#	gm_text_body("Test email body")
#gm_send_message(prime)

## SET THE VARIABLES FOR THE ASSESSMENT PERIOD HERE
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


## READ IN THE DATA AND FORMAT IT
myData <- read_xlsx("./_data/202001-GenEd-Data.xlsx")

##---> Rename variables
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

##--> Recode colleges
myData[myData$College=="AS","College"] <- "CAS"
myData[myData$College=="BU","College"] <- "COB"
myData[myData$College=="ED","College"] <- "COEHS"
myData[myData$College=="TE","College"] <- "CET"
myData[myData$College=="HP","College"] <- "CHP"
myData[myData$College=="UN","College"] <- "UNIV"

##--> Add variables
myData$Course <- paste0(myData$Prefix,myData$Number)
myData <- myData %>% separate(Instructor,c("Instructor.Last","Instructor.First"), ",", remove=FALSE)
myData$Full.Name <- paste(myData$Instructor.First,myData$Instructor.Last)


## SPLIT OUT DATA BY COMPETENCY
##--> COLL
collData <- myData %>%
	filter(COLL == 1)

##--> COMS
comsData <- myData %>%
	filter(COMS == 1)

##--> COMW
comwData <- myData %>%
	filter(COMW == 1)

##--> CULT
cultData <- myData %>%
	filter(!is.na(ACTC) | !is.na(CATC) | !is.na(CLTR))

##--> DIVG
divgData <- myData %>%
	filter(DIVG == 1)

##--> DIVU
divuData <- myData %>%
	filter(DIVU == 1)

##--> NSCI
nsciData <- myData %>%
	filter(NSCL == 1 | NSCI == 1)

##--> PROB
probData <- myData %>%
	filter(PROB == 1)

##--> QUAN
quanData <- myData %>%
	filter(QUAL == 1)

##--> SSOC
ssocData <- myData %>%
	filter(SSOC == 1 | SSOF == 1)


## MAKE LISTS OF RECIPIENTS FOR EACH COMPETENCY
## --> COLL
collList <- collData %>%
	select(-Name, -ID) %>%
	unique()
collList$Attachment <- paste0("./COLL/",collList$Instructor.Last,"-",collList$College,"-",collList$Course,"-",collList$Section,"-",collVar,".xlsx")

## --> COMS
comsList <- comsData %>%
	select(-Name, -ID) %>%
	unique()
comsList$Attachment <- paste0("./COMS/",comsList$Instructor.Last,"-",comsList$College,"-",comsList$Course,"-",comsList$Section,"-",comsVar,".xlsx")

## --> COMW
comwList <- comwData %>%
	select(-Name, -ID) %>%
	unique()
comwList$Attachment <- paste0("./COMW/",comwList$Instructor.Last,"-",comwList$College,"-",comwList$Course,"-",comwList$Section,"-",comwVar,".xlsx")

## --> CULT
cultList <- cultData %>%
	select(-Name, -ID) %>%
	unique()
cultList$Attachment <- paste0("./CULT/",cultList$Instructor.Last,"-",cultList$College,"-",cultList$Course,"-",cultList$Section,"-",cultVar,".xlsx")

## --> DIVG
divgList <- divgData %>%
	select(-Name, -ID) %>%
	unique()
divgList$Attachment <- paste0("./DIVG/",divgList$Instructor.Last,"-",divgList$College,"-",divgList$Course,"-",divgList$Section,"-",divgVar,".xlsx")

## --> DIVU
divuList <- divuData %>%
	select(-Name, -ID) %>%
	unique()
divuList$Attachment <- paste0("./DIVU/",divuList$Instructor.Last,"-",divuList$College,"-",divuList$Course,"-",divuList$Section,"-",divuVar,".xlsx")

## --> NSCI
nsciList <- nsciData %>%
	select(-Name, -ID) %>%
	unique()
nsciList$Attachment <- paste0("./NSCI/",nsciList$Instructor.Last,"-",nsciList$College,"-",nsciList$Course,"-",nsciList$Section,"-",nsciVar,".xlsx")

## --> PROB
probList <- probData %>%
	select(-Name, -ID) %>%
	unique()
probList$Attachment <- paste0("./PROB/",probList$Instructor.Last,"-",probList$College,"-",probList$Course,"-",probList$Section,"-",probVar,".xlsx")

## --> QUAN
quanList <- quanData %>%
	select(-Name, -ID) %>%
	unique()
quanList$Attachment <- paste0("./QUAN/",quanList$Instructor.Last,"-",quanList$College,"-",quanList$Course,"-",quanList$Section,"-",quanVar,".xlsx")

## --> SSOC
ssocList <- ssocData %>%
	select(-Name, -ID) %>%
	unique()
ssocList$Attachment <- paste0("./SSOC/",ssocList$Instructor.Last,"-",ssocList$College,"-",ssocList$Course,"-",ssocList$Section,"-",ssocVar,".xlsx")


## SET UP AND SEND EMAILS BY COMPETENCY
##--> Set up composed emails in a dataframe
testList <- read_xlsx("_data/testList2.xlsx")
this_hw <- "Demonstration"
email_sender <- 'Clifton Franklund <cliftonfranklund@ferris.edu>'
body <- "<p>Greetings,</p>
<p>This email was generated as a demonstration of the R script's function during our University General Education meeting. <strong>You may disregard this message.</strong><p>

<p>It is once again time to submit General Education assessment data. This semester, we are using a new streamlined process to simplify your reporting experience. You will get one of these emails for every combination of General Education course section and competency that you teach. Sorry for all the emails; it is easier to keep track of everything this way.</p>

<p>Attached, you will find a simple Excel workbook to report your assessment data. Everything that you need to know about this process is described on our General Education Data SharePoint site.</p>

<p>https://ferrisstateuniversity.sharepoint.com/sites/GeneralEducationData</p>

<p>The site includes two short video tutorials are available that explain how to use it (or you can read the short instructions below).</p>
<ul>
	<li><strong>Video 1:</strong> How to complete your Excel workbook</li>
    <li><strong>Video 2:</strong> How to submit your completed Excel workbook</li>
</ul>

<strong>Completed workbooks should be submitted to the SharePoint site by: DUE DATE HERE.</strong>

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
		Subject = sprintf('Reporting General Education TST1 assessment results for %s section %s, %s %s', Course, Section, theSemester, theYear),
		Body = sprintf(body),
		Attachment = Attachment) %>%
	select(To, From, Subject, Body, Attachment)
write_csv(composedEmails, "_data/composed_emails.csv")

sent_mail <- composedEmails %>%
	mutate(x = pmap(list(To, From, Subject, Body, Attachment),safely(prepare_and_send)))

saveRDS(sent_mail,
		paste0("_data/",gsub("\\s+", "_", this_hw), "-sent-emails.rds"))

errors <- sent_mail$x %>%
	transpose() %>%
	.$error %>%
	map_lgl(Negate(is.null))

print(paste0("A total of ",length(errors)," emails were processed with ",sum(errors)," errors."))

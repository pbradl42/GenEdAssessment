## READ IN THE LIBRARIES THAT WE NEED
library(tidyverse)
library(readxl)
library(writexl)
library(knitr)
library(gmailr)
library(purrr)
library(readr)

## SET UP GMAIL API 0AUTH CREDENTIALS
gm_auth_configure(path="../rawdata/SendMailProject.json")

## ASSIGNMENT DUE DATE
dueDate <- "September 3, 2020"

## READ IN THE CLEANED COMPETENCY DATA
collData <- read_csv("../output/data/collData.csv")
comsData <- read_csv("../output/data/comsData.csv")
comwData <- read_csv("../output/data/comwData.csv")
cultData <- read_csv("../output/data/cultData.csv")
divgData <- read_csv("../output/data/divgData.csv")
divuData <- read_csv("../output/data/divuData.csv")
nsciData <- read_csv("../output/data/nsciData.csv")
probData <- read_csv("../output/data/probData.csv")
quanData <- read_csv("../output/data/quanData.csv")
ssocData <- read_csv("../output/data/ssocData.csv")


## MAKE LISTS OF RECIPIENTS FOR EACH COMPETENCY
## --> COLL
collList <- collData %>%
	select(-Name, -ID) %>%
	unique()
collList$Attachment <- paste0("../output/workbooks/COLL/",collList$Semester,"-",collList$Year,"-",collList$Instructor.Last,"-",collList$College,"-",collList$Course,"-",collList$Section,"-",collVar,".xlsx")
collList$Full.Name <- paste(collList$Instructor.First,collList$Instructor.Last)

## --> COMS
comsList <- comsData %>%
	select(-Name, -ID) %>%
	unique()
comsList$Attachment <- paste0("../output/workbooks/COMS/",comsList$Semester,"-",comsList$Year,"-",comsList$Instructor.Last,"-",comsList$College,"-",comsList$Course,"-",comsList$Section,"-",comsVar,".xlsx")
comsList$Full.Name <- paste(comsList$Instructor.First,comsList$Instructor.Last)

## --> COMW
comwList <- comwData %>%
	select(-Name, -ID) %>%
	unique()
comwList$Attachment <- paste0("../output/workbooks/COMW/",comwList$Semester,"-",comwList$Year,"-",comwList$Instructor.Last,"-",comwList$College,"-",comwList$Course,"-",comwList$Section,"-",comwVar,".xlsx")
comwList$Full.Name <- paste(comwList$Instructor.First,comwList$Instructor.Last)

## --> CULT
cultList <- cultData %>%
	select(-Name, -ID) %>%
	unique()
cultList$Attachment <- paste0("../output/workbooks/CULT/",cultList$Semester,"-",cultList$Year,"-",cultList$Instructor.Last,"-",cultList$College,"-",cultList$Course,"-",cultList$Section,"-",cultVar,".xlsx")
cultList$Full.Name <- paste(cultList$Instructor.First,cultList$Instructor.Last)

## --> DIVG
divgList <- divgData %>%
	select(-Name, -ID) %>%
	unique()
divgList$Attachment <- paste0("../output/workbooks/DIVG/",divgList$Semester,"-",divgList$Year,"-",divgList$Instructor.Last,"-",divgList$College,"-",divgList$Course,"-",divgList$Section,"-",divgVar,".xlsx")
divgList$Full.Name <- paste(divgList$Instructor.First,divgList$Instructor.Last)

## --> DIVU
divuList <- divuData %>%
	select(-Name, -ID) %>%
	unique()
divuList$Attachment <- paste0("../output/workbooks/DIVU/",divuList$Semester,"-",divuList$Year,"-",divuList$Instructor.Last,"-",divuList$College,"-",divuList$Course,"-",divuList$Section,"-",divuVar,".xlsx")
divuList$Full.Name <- paste(divuList$Instructor.First,divuList$Instructor.Last)

## --> NSCI
nsciList <- nsciData %>%
	select(-Name, -ID) %>%
	unique()
nsciList$Attachment <- paste0("../output/workbooks/NSCI/",nsciList$Semester,"-",nsciList$Year,"-",nsciList$Instructor.Last,"-",nsciList$College,"-",nsciList$Course,"-",nsciList$Section,"-",nsciVar,".xlsx")
nsciList$Full.Name <- paste(nsciList$Instructor.First,nsciList$Instructor.Last)

## --> PROB
probList <- probData %>%
	select(-Name, -ID) %>%
	unique()
probList$Attachment <- paste0("../output/workbooks/PROB/",probList$Semester,"-",probList$Year,"-",probList$Instructor.Last,"-",probList$College,"-",probList$Course,"-",probList$Section,"-",probVar,".xlsx")
probList$Full.Name <- paste(probList$Instructor.First,probList$Instructor.Last)

## --> QUAN
quanList <- quanData %>%
	select(-Name, -ID) %>%
	unique()
quanList$Attachment <- paste0("../output/workbooks/QUAN/",quanList$Semester,"-",quanList$Year,"-",quanList$Instructor.Last,"-",quanList$College,"-",quanList$Course,"-",quanList$Section,"-",quanVar,".xlsx")
quanList$Full.Name <- paste(quanList$Instructor.First,quanList$Instructor.Last)

## --> SSOC
ssocList <- ssocData %>%
	select(-Name, -ID) %>%
	unique()
ssocList$Attachment <- paste0("../output/workbooks/SSOC/",ssocList$Semester,"-",ssocList$Year,"-",ssocList$Instructor.Last,"-",ssocList$College,"-",ssocList$Course,"-",ssocList$Section,"-",ssocVar,".xlsx")
ssocList$Full.Name <- paste(ssocList$Instructor.First,ssocList$Instructor.Last)

emailList <- rbind(collList, comsList, comwList, cultList, divgList, divuList, nsciList, probList, quanList, ssocList)
write_csv(emailList, "../output/data/emailListData.csv")

## SET UP AND SEND EMAILS BY COMPETENCY
##--> Set up composed emails in a dataframe
testList <- read_xlsx("../rawdata/Test_Dataset.xlsx")
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

##--> Send a small batch of test emails
composedEmails <- emailList %>%
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

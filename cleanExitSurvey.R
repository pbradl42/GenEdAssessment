library(foreach)
library(tidyverse)
library(data.table)

homeDir <- "/Users/peterbradley/Documents/GitHub/GenEdAssessment"
dataDir <- "rawdata/GraduateExitSurvey"

dataFiles <- list.files(paste(homeDir, dataDir, sep="/"), pattern="2*.csv")

satisfiedLikert <- c("Very Satisfied", "Somewhat Satisfied", "Somewhat Dissatisfied", "Very Dissatisfied")

cleanColNames <- function(name) {
	if(!is.na(name)) {
		gsub("\\.", "_", name)
	} else {
		return("")
	}
}
cleanRow2Names <- function(column) {
	toReturn <- unique(column)
	toReturn <- toReturn[toReturn != ""]
	toReturn <- gsub("[[:space:]]", "_", toReturn[1])
	return(toReturn)
}
collectData <- function(myFile) {
	read.csv(paste(homeDir, dataDir, myFile, sep="/")) -> mydf
	year <- str_sub(myFile, 0, 4)
#	mydf <- filter(mydf, rowSums(is.na(mydf)) != ncol(mydf))
	origQuestions <- paste(colnames(mydf), sapply(mydf[1,], cleanColNames), sep="")
	newCols <- gsub("\\.", "_", colnames(mydf))
	newCols <- gsub("\\:", "", origQuestions)
	newCols <- gsub("\\.\\.\\.", "", newCols)
	if(year == "2020") {
		newCols[[45]] <- "GoodValue"
		newCols[[49]] <- "ImmediatePlans"
		newCols[[58]] <- "Experienceship"
		newCols[[60]] <- "StudentLife"
		newCols[[88]] <- "RSO"
		newCols[[93]] <- "Career"
		newCols[[95]] <- "Recommend"
		newCols[[99]] <- "Proud"
		newCols[[104]] <- "College"
		newCols[[113]] <- "Best"
		newCols[[114]] <- "Change"
		newCols[[115]] <- "AdditionalComments"
		newCols[5:44] <- paste("GenEd-", apply(mydf[,c(5:44)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[45:48] <- paste("GoodValue-", apply(mydf[,c(45:48)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[49:57] <- paste("ImmediatePlans-", apply(mydf[,c(49:57)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[58:59] <- paste("Experienceship-", apply(mydf[,c(58:59)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[60:87] <- paste("StudentLife-", apply(mydf[,c(60:87)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[88:92] <- paste("RSO-", apply(mydf[,c(88:92)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[93:94] <- paste("Career-", apply(mydf[,c(93:94)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[95:98] <- paste("Recommend-", apply(mydf[,c(95:98)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[99:103] <- paste("Proud-", apply(mydf[,c(99:103)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[104:112] <- paste("College-", apply(mydf[,c(104:112)], 2, cleanRow2Names, simplify=TRUE), sep="")
	} else if (year == "2019") {
		newCols[5:14] <- paste("GenEd-", apply(mydf[,c(5:14)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[15] <- "GoodValue"
		newCols[16] <- "ImmediatePlans"
		newCols[17] <- "Experienceship"
		newCols[18:24] <- paste("StudentLife-", apply(mydf[,c(18:24)], 2, cleanRow2Names, simplify=TRUE), sep="")
		newCols[[25]] <- "RSO"
		newCols[[26]] <- "Career"
		newCols[[27]] <- "Recommend"
		newCols[[29]] <- "Proud"
		newCols[31:39] <- paste("College-", apply(mydf[,c(31:39)], 2, cleanRow2Names, simplify=TRUE), sep="")


	}
	colnames(mydf) <- newCols
	write_csv(data.frame("original"=origQuestions,"new"=newCols), file=paste(homeDir, "/CodeBook-", myFile, sep=""))
	mydf <- mydf %>%
		filter(!is.na(Respondent.ID)) %>%
		mutate(survey_year = year)
	mydf
}

tidy_gened <- function(colnamestart, mydf) {
	if(str_sub(colnamestart, -1, -1) == "_") {
		newColname = str_sub(colnamestart, 0, -2)
	} else {
		newColname = colnamestart
	}
	if(mydf$survey_year == "2020") {
		mydf <- mydf %>%
			select(Respondent.ID, survey_year, starts_with(colnamestart)) %>%
			pivot_longer(starts_with(colnamestart), values_to="values") %>%
			filter(values != "") %>%
			select(Respondent.ID, survey_year, values)
	} else if (mydf$survey_year == "2019") {
		mydf <- mydf %>%
			select(Respondent.ID, survey_year, starts_with(colnamestart))
		colnames(mydf) <- c("Respondent.ID", "survey_year", "values")
	}
	mydf <- mydf %>%
		mutate(values = factor(values)) %>%
		rename(!!newColname := "values")
	return(mydf)
}

lapply(dataFiles, collectData) -> fullList
#rbindlist(fullList) -> exitSurvey

## What we have is 1 column PER value on likert.
# That column contains only the values of that item
# So we need to pull all these together into a single column - like 'gather' or 'pivot_longer'.
# These columns are named with the value of the likert attached to a 'root'
# Get the root, and pass that to the function to do the tidying
##
tidyList <- function(exitSurvey) {
	toTidy <- colnames(exitSurvey)[grepl("GenEd.*", colnames(exitSurvey))]
	toTidy <- gsub("-_.*$", "", toTidy)
	lapply(unique(toTidy), tidy_gened, exitSurvey) -> genEdRows

	for(myN in c(1:length(genEdRows))) {
		if(myN==1) {
			GenEd = genEdRows[[myN]]
		} else {
			GenEd = full_join(GenEd, genEdRows[[myN]], by=c("Respondent.ID", "survey_year"))
		}
	}
	rm("genEdRows", "toTidy")
	return(GenEd)
}

lapply(fullList, tidyList) -> GenEdList
#rm("fullList")
GenEd <- rbindlist(GenEdList)
GenEdTidy <- GenEd %>%
	pivot_longer(starts_with("GenEd"), names_to="Q", values_to="Response")
## Big Chart
p <- GenEdTidy %>%
	ggplot(aes(x=Q, fill=Response))
p <- p + geom_bar(stat="count", position="fill") + coord_flip()
p <- p + facet_grid(rows="survey_year")
p <- p + geom_text(stat='count', aes(label=..count..), position="fill", vjust=-1)

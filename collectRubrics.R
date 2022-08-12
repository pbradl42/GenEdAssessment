library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(pdftools)
#homeDir <- "/Users/pbradley/Documents/Documents - College Deliberately MacBook Air/GitHub/GenEdAssessment"
homeDir <- "/Users/peterbradley/Documents/GitHub/GenEdAssessment"
sharepoint <- "/Users/peterbradley/Ferris State University/General Education Assessment redesign - Documents/General"
format_pdf_table <- function(myN, text_lines) {
	target <- myN
	end <- myN - 1
	startLine <- which(grepl(paste(target, "[[:space:]]", sep=""), text_lines) == TRUE)
	endLine <- which(grepl(paste(end, "[[:space:]]", sep=""), text_lines) == TRUE)-1
	if(length(endLine) == 0) {
		endLine <- length(text_lines)
	}
	return(text_lines[c(startLine:endLine)])
}


rubric_split <- function(myLine) {
	if(all(c(1:10) %in% str_locate_all(myLine, "[[:space:]]")[[1]][,1])) {
		myLine <- paste("_", myLine, sep="")
	} else {
		myLine <- str_trim(myLine, side="left")
	}
	mystrings <- str_split_fixed(myLine, "  ", 2) %>%
		str_trim()
	if(length(mystrings) == 1) {
		mystrings[[2]] <- ""
	}
	gsub("_", " ", mystrings[[1]]) -> mystrings[[1]]
	toReturn <- data.frame(level = mystrings[[1]], desc = mystrings[[2]])
	return(toReturn)
}

rubric_compile <- function(myRubric) {
	split_rubrics <- lapply(myRubric, rubric_split) %>%
		rbindlist()
	rubric_value <- split_rubrics[1,]$level
	definition <- paste(split_rubrics[2:nrow(split_rubrics),]$level, collapse=" ")
	characteristics <- paste(split_rubrics[2:nrow(split_rubrics),]$desc, collapse=" ")
	toReturn <- data.frame(rubric_value, definition, characteristics)
	return(toReturn)
}

rubric_reconstruct <- function(rubric) {
	myRubric <- lapply(rubric, rubric_compile) %>%
	rbindlist()
	return(myRubric)
}

rubric_read <- function(myN, myCompetency) {
	filename <- paste(myCompetency, "_Rubrics-", myN, ".pdf", sep="")
	myFile <- paste(homeDir, "rubrics", filename, sep="/")
	if(!file.exists(myFile)) {
		stop("No file found: ", myFile)
	}
	raw_text <- pdf_text(myFile) %>%
		readr::read_lines()
	myRubric <- lapply(c(4:0), format_pdf_table, raw_text) %>%
		rubric_reconstruct()
	myRubric$description <- paste(raw_text[3:6], collapse=" ")
	myRubric <- myRubric %>%
		mutate(description = gsub("Evaluated.*\\.", "", description)) %>%
		mutate(description = gsub("\\&", "and", description)) %>%
		mutate(characteristics = gsub("\\&", "and", characteristics))
	myRubric$Competency <- myCompetency
	myRubric$FLO <- myN
	return(myRubric)
}
wrap_rubric_read <- function(myCompetency) {
	out <- lapply(c(1:4), rubric_read, myCompetency) %>%
		rbindlist()
	return(out)
}

CompetencyDescriptions <- c("Collaboration occurs when students participate in a cooperative endeavor that involves common goals, coordinated efforts, and outcomes or products for which they and their teammates share responsibility and credit.",
							"Students apply a variety of communication strategies to effectively adapt their writing, oral, and non-verbal communication to meet the needs of diverse audiences and situations.",
							"Students apply a variety of communication strategies to effectively adapt their writing, oral, and non-verbal communication to meet the needs of diverse audiences and situations.",
							"Culture is the system of shared beliefs, values, practices, and artifacts that group members use to understand, cope with, and interact with one another and their environment, and is transmitted from generation to generation through participation and learning.",
							"Students will articulate knowledge and understanding of local, regional, national, and global issues and the interconnectedness and interdependency of human populations.",
							"Students will articulate knowledge of the concepts of race, ethnicity, and/or gender and their impact and relevance in social issues.",
							"Natural sciences are academic disciplines that collectively use empirical evidence to comprehend and explain the physical world. At Ferris State University, these disciplines include Biology, Chemistry, Earth Sciences, Geology, and Physics.",
							"Problem solving is the process of designing, evaluating and implementing a strategy to answer an open-ended question or achieve a desired goal.",
							"Quantitative Literacy represents the ability to interpret numerical information and apply it when solving real world problems.",
							"Social/behavioral science methods, theories, principles, and application should make up at least 80% of the course content of Self and Society courses.")

Hallmark <- c("Ferris graduates skillfully and productively work with others.",
			  "Ferris graduates communicate effectively with others in a variety of different settings.",
			  "Ferris graduates communicate effectively with others in a variety of different settings.",
			  "Ferris graduates interpret and explain cultural works in the context of experiences and histories of their own culture or that of others.",
			  "Ferris graduates apply an understanding of the consequences of the growing global interdependence of diverse societies in their personal and professional lives.",
			  "Ferris graduates apply an understanding of the consequences of the growing global interdependence of diverse societies in their personal and professional lives.",
			  "Ferris graduates use empirical evidence to make informed decisions about scientific issues.",
			  "Ferris graduates integrate knowledge from a variety of sources to find creative explanations or solutions to practical issues.",
			  "Ferris graduates interpret and use quantitative data to understand and effectively solve real-life problems.",
			  "Ferris graduates actively engage in their society and recognize how they are shaped by the society and place in which they live."			  )
CoreCompetencies <- data.frame(name=c("Collaboration",
									  "Communication-Speech",
									  "Communication-Writing",
									  "Culture",
									  "Diversity-Global",
									  "Diversity-Domestic",
									  "Natural Science",
									  "Problem Solving",
									"Quantiative Literacy",
									"Self and Society"), Competency=c("COLL", "COMS", "COMW", "CULT", "DIVG", "DIVU", "NSCI", "PROB", "QNT", "SSOC"),
									CoreDescription=CompetencyDescriptions, hallmark=Hallmark, stringsAsFactors = FALSE)


getTextValue <- function(rubric_value) {
	values <- strsplit(rubric_value, "–")
	trimws(values[[1]][2])
}

split_desc_for_title <- function(myStr) {
	str_split(myStr, " – ", simplify = TRUE) -> separated
	if(length(separated) > 1) {
		return(separated[[2]])
	} else {
		return("Title not found")
	}
}
build_rubric <- function(myCompetency) {
	Rubrics <- lapply(myCompetency, wrap_rubric_read) %>%
		rbindlist() %>%
		mutate(rubric_value = ifelse(grepl("Progressing", rubric_value), "2 – Progressing", rubric_value)) %>%
		mutate(rubric_value = ifelse(grepl("Beginning", rubric_value), "1 – Beginning", rubric_value)) %>%
		dplyr::select("Competency", "FLO", "rubric_value", "description", "definition", "characteristics")

	Rubrics$title <- sapply(Rubrics$description, split_desc_for_title)
	## Build Improve importable list of outcomes
	## Need to figure out how to do this with mutate
	sapply(Rubrics$rubric_value, getTextValue) -> Rubrics$str_value
	forImport <- Rubrics %>%
		mutate(characteristics = trimws(characteristics)) %>%
		mutate(characteristics = paste(str_value, characteristics, sep=": ")) %>%
		pivot_wider(id_cols=c("Competency", "FLO", "title", "description"), names_from="rubric_value", values_from="characteristics") %>%
		left_join(CoreCompetencies, by="Competency") %>%
		mutate(object_type = 'outcome') %>%
		mutate(workflow_state = 'active') %>%
		mutate(vendor_guid = paste("Ferris", Competency, FLO, sep="")) %>%
		mutate(display_name = paste(Competency, FLO, sep = "")) %>%
		mutate(parent_guids = paste("Ferris", Competency, sep="")) %>%
	#	mutate(name = split_desc_for_title(description)) %>%
	#	mutate(Competency = paste(Competency, FLO, sep = " - ")) %>%
		mutate(calculation_method = 'highest') %>%
		mutate(calculation_int='') %>%
		mutate(mastery_points = 3) %>%
		mutate(ratings4 = 4, ratings3=3, ratings2=2, ratings1=1, ratings0=0) %>%
		rename("value4"=`4 – Advanced`, "value3"= `3 – Proficient`, "value2"= `2 – Progressing`, "value1"=`1 – Beginning`, value0=`0 – Unsatisfactory`  ) %>%
		dplyr::select(vendor_guid, object_type, title, name, CoreDescription, description, display_name, calculation_method, calculation_int, parent_guids, workflow_state, mastery_points, ratings4, value4, ratings3, value3, ratings2, value2, ratings1, value1, ratings0, value0)
	group_row <- list(vendor_guid=paste("Ferris", unique(Rubrics$Competency), sep=""), object_type="group", title=unique(forImport$name), description=unique(forImport$CoreDescription), display_name=unique(Rubrics$Competency),calculation_method="", calculation_int="", parent_guids="", workflow_state="active")
	forImport <- forImport %>%
		dplyr::select(!c(name, CoreDescription))
	forImport <- rbindlist(list(group_row, forImport), fill=TRUE)
	return(forImport)
}


lapply(CoreCompetencies$Competency, build_rubric) -> allRubricsList
names(allRubricsList) <- CoreCompetencies$Competency

rbindlist(allRubricsList) -> forImportWhole
forImportWhole -> forImport
start <- ncol(forImportWhole)-9
end <- ncol(forImportWhole)
colnames(forImportWhole)[start:end] <- ""
colnames(forImportWhole)[start] <- "ratings"

forImportWhole <- rbind(as.list(colnames(forImportWhole)), forImportWhole)

forImportWhole[is.na(forImportWhole)] <- ""
write_csv(forImportWhole, file=paste(sharepoint, "importToCanvas.csv", sep="/"), col_names=FALSE)

write_each <- function(myN, myDF) {
	myDF[myN,] -> myDF
	myDF <- myDF %>% dplyr::select(!c(parent_guids))
	myFile <- paste(sharepoint, "/rubrics/", myDF$vendor_guid, ".csv", sep="")
	start <- ncol(myDF)-9
	end <- ncol(myDF)
	firstRow <- as.list(colnames(myDF))
	colnames(myDF)[start:end] <- ""
	colnames(myDF)[start] <- "ratings"
	myDF <- rbind(firstRow, myDF)
	write_csv(myDF, file=myFile, col_names=FALSE)
}
lapply(c(1:nrow(forImport)), write_each, forImport)

write_pdf_rubric <- function(myN, abbr_comp) {
	saveRDS(myN, file="myN.RDS")
	rmarkdown::render("createPDFRubric.Rmd", output_format="pdf_document", output_file=paste(paste("NEW", abbr_comp, "Rubrics", myN, sep="-"), "pdf", sep="."), output_dir = "rubrics")
	rmarkdown::render("createPDFRubric.Rmd", output_format="html_document", output_file=paste(paste("NEW", abbr_comp, "Rubrics", myN, sep="-"), "html", sep="."), output_dir = "rubrics")
}
setup_pdf_rubric <- function(abbr_comp, CoreCompetencies, allRubricsList) {
	myCompetency <- CoreCompetencies %>%
		filter(Competency == abbr_comp)
	myCompetencyDF <- allRubricsList[[abbr_comp]]
	myCompetencyDF <- myCompetencyDF[c(2:5),]
	saveRDS(myCompetency, file="myCompetency.RDS")
	saveRDS(myCompetencyDF, file="myCompetencyDF.RDS")
	lapply(c(1:4), write_pdf_rubric, abbr_comp) -> out
}


lapply(CoreCompetencies$Competency, setup_pdf_rubric, CoreCompetencies, allRubricsList)


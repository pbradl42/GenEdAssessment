homeDir <- "/Users/pbradley/Documents/Documents - College Deliberately MacBook Air/GitHub/GenEdAssessment"

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
	myRubric$Competency <- myCompetency
	myRubric$FLO <- myN
	return(myRubric)
}
wrap_rubric_read <- function(myCompetency) {
	out <- lapply(c(1:4), rubric_read, myCompetency) %>%
		rbindlist()
	return(out)
}

CoreCompetencies <- data.frame(name=c("Collaboration", "Communication-Speech", "Communication-Writing", "Culture", "Diversity-Global", "Diversity-Domestic", "Natural Science", "Problem Solving",
								 "Quantiative Literacy", "Self and Society"), shortname=c("COLL", "COMS", "COMW", "CULT", "DIVG", "DIVU", "NSCI", "PROB", "QNT", "SSOC"), stringsAsFactors = FALSE)

Rubrics <- lapply(CoreCompetencies$shortname, wrap_rubric_read) %>%
	rbindlist() %>%
	dplyr::select("Competency", "FLO", "rubric_value", "definition", "characteristics")
write_csv(Rubrics, file="fullRubrics.csv")

#####################################################################
##    Makefile for General Education assessment data collection    ##
##    Last modified: April 30, 2020                                ##
##    Dr. Clifton Franklund                                        ##
##    General Education Assessment Coordinator                     ##
##    Ferris State University                                      ##
#####################################################################

.DELETE_ON_ERROR:

## Setting variables for the Makefile
RAW = rawdata
DAT = output/data
REP = output/documents
WKB = output/workbooks
SRC = src

help: $(REP)/help.html
	@open $(REP)/help.html

$(REP)/help.html: $(SRC)/makeHelp.Rmd
	@cd $(SRC); Rscript -e "rmarkdown::render('makeHelp.Rmd', quiet = TRUE, output_file = '../$(REP)/help.html')"

reports: $(REP)/report.html $(REP)/report.docx $(REP)/report.pdf $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@open $(REP)/report.html
	@open $(REP)/report.docx
	@open $(REP)/report.pdf

$(REP)/report.html: $(SRC)/makeReport.Rmd $(DAT)/cleanData.csv $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); Rscript -e "rmarkdown::render('makeReport.Rmd', quiet = TRUE, output_file = '../$(REP)/report.html')" > /dev/null 2>&1

$(REP)/report.pdf: $(SRC)/makeReport.Rmd $(DAT)/cleanData.csv $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); Rscript -e "rmarkdown::render('makeReport.Rmd', output_format = c('pdf_document'), quiet = TRUE, output_file = '../$(REP)/report.pdf')" > /dev/null 2>&1

$(REP)/report.docx: $(SRC)/makeReport.Rmd $(DAT)/cleanData.csv $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); Rscript -e "rmarkdown::render('makeReport.Rmd', output_format = c('word_document'), quiet = TRUE, output_file = '../$(REP)/report.docx')" > /dev/null 2>&1

emails:
	Rscript

$(DAT)/logFile.csv: $(SRC)/makeSpreadsheets.R $(DAT)/cleanData.csv
	@cd $(SRC); R CMD BATCH makeSpreadsheets.R

workbooks: $(DAT)/logFile.csv

$(DAT)/cleanData.csv: $(SRC)/cleanData.R $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); R CMD BATCH cleanData.R

test:
	@cd $(SRC); R CMD BATCH testing.R

clean:
	@rm -f $(REP)/report.*
	@rm -f $(REP)/help.html
	@rm -f $(SRC)/*.Rout
	@rm -f $(DAT)/*.csv
	@rm -rf $(WKB)/*



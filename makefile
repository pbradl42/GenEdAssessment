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
REP = output/summary
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

$(REP)/report.html: $(SRC)/makeReport.Rmd $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); Rscript -e "rmarkdown::render('makeReport.Rmd', quiet = TRUE, output_file = '../$(REP)/report.html')"

$(REP)/report.pdf: $(SRC)/makeReport.Rmd $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); Rscript -e "rmarkdown::render('makeReport.Rmd', output_format = c('pdf_document'), quiet = TRUE, output_file = '../$(REP)/report.pdf')"

$(REP)/report.docx: $(SRC)/makeReport.Rmd $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); Rscript -e "rmarkdown::render('makeReport.Rmd', output_format = c('word_document'), quiet = TRUE, output_file = '../$(REP)/report.docx')"

emails:
	Rscript

workbooks:
	Rscript

$(DAT)/cleanData.csv: $(SRC)/cleanData.R $(RAW)/202001_Gen_Ed_Attribute_Courses_and_Rosters-with_Course_Coll_Codes-20200423.xlsx
	@cd $(SRC); R CMD BATCH cleanData.R

clean:
	rm -f $(REP)/report.*
	rm -f $(DAT)/*.csv



### Background  
This project was created to facilitate a new assessment process for the General Education program at Ferris State University. Using a raw data file produced by the Registrar and Institutional Research, these `R` scripts create Excel workbooks and emails them to the instructors of each unique CRN. This can amount to around 1,200 files each semester.

8/12/22 - Added script ('collectRubrics.R' and 'createPDFRubric.Rmd') to recreate the Rubric files in PDF and HTML form. This reads from the 'old' rubrics stored in '/rubrics' and writes out the new format to the same directory. -PB

### Configuration  
To ensure maximal reproducibility, the amount of manual configuration needed between different data runs has been minimized. There are really only a few things that you need to do.  

1. Place the new raw data file in the `rawdata` directory.  
1. Add instructor information to `Test_Dataset.xlsx` and place the file in `rawdata`
1. Set up 0auth for the Gmail API - instructions here: https://blog.mailtrap.io/send-emails-with-gmail-api/
1. Store credentials json file in `rawdata`.
1. Open makefile in an editor and change `RAWDATA` to your file's name.
1. Open `src/cleanData.R` in an editor of your choice (I use the RStudio IDE).  
1. Change the name of the rawdata file read to the name of the file from step 1 (look for `rawdata <- ""`).
1. Indicate which outcome is to be assessed for the current semester - 1, 2, 3, or 4 - (look for `outcomeNumber <- ""`).  
1. Open `src/testing.R` and change hange the name of the rawdata file read to the name of your test file.
1. Indicate which outcome is to be assessed for the testing run - 1, 2, 3, or 4 - in `src/testing.R`.
1. Open `src/sendEmails.R` and change the due date (look for `dueDate <-`).
1. Change `gm_auth_configure` to point to your credential file.
1. Save - that is all!! You are now ready to proceed. Try running `make reports` and `make test` first. With those sorted out, you should be able to `make clean` and then `make workbooks` and `make emails` with your main raw data.

### Running makefile Commands  
To further simplify and automate this process, the assessment workbooks are generated and emailed using a Gnu makefile. Makefiles only run scripts when they are needed (i.e. after one or more of their dependencies have been altered). The make file for this project currently has six targets. You can run them from the command line (within the `GenEdAssessment` directory) using the following commands.

**`make`** - Just typing `make` will execute the recipe for the default target. In this project, the default target generates this help file as an html document (`output/documents/help.html`) and opens it in the default web browser.  

**`make help`** - This explicitly calls the default target recipe (same as just `make`).  

**`make reports`** - This target calls `src/makeReports.R` and creates summary reports for the raw data file. These reports (`output/documents/report.html`, `output/documents/report.pdf`, and `output/documents/report.docx`) are each opened in their default applications.  

**`make workbooks`** -   This target calls `src/cleanData.R` and `src/makeSpreadsheets.R` to create all of the Excel data workbooks. These are stored in subdirectories by core competency under `output/workbooks/`.  

**`make emails`** - This target calls `src/cleanData.R` and `src/sendEmails.R` to compose and send emails (one per each unique CRN) to instructors. The workbooks generated above are included as attachments. This process uses the Google Gmail API for bulk emailing via `R`.  

**`make test`** - This target generates workbooks and sends emails using a small test dataset. This is for troubleshooting and test purposes only.  

**`make clean`** - This target erases _all_ of the contents of the temporary directories (`output/data`, `output/documents`, and `output/workbooks`). That allows you to generate new files again by using the commands above.  

### File Structure  
```R
.
├── GenEdAssessment.Rproj   =  RStudio project file
├── LICENSE                 =  Project license (MIT)
├── README.md               =  Description file for GitHub
├── makefile                =  Gnu makefile to build the project
├── output                  =  All generated files (contents deleted by cleaning)
│   ├── data                =  Generated intermediate data files
│   ├── documents           =  All reports
│   └── workbooks           =  The generated Excel workbooks
├── rawdata                 =  The raw data (DO NOT MODIFY DIRECTLY)
├── src                     =  R scripts
│   ├── cleanData.R         =  Reads raw data and clean it up
│   ├── makeHelp.Rmd        =  Generates this file
│   ├── makeReport.Rmd      =  Creates summary reports
│   ├── makeSpreadsheets.R  =  Makes all of the data collection workbooks
│   ├── sendEmails.R        =  Sends the workbooks as attachments with a message to instructors
│   └── testing.R           =  Runs complete process using a test dataset for troubleshooting
└── Test_Dataset.xlsx       =  Dataset for testing purposes. Add instructor info and put in rawdata
```

### The R Scripts  

**`makeHelp.Rmd`** - When run through `knitr`, this script generates the help document (`help.html`) that you are currently reading. This help file is stored in `output/documents/`.  

**`makeReport.Rmd`** - When run through `knitr`, this script produces brief executive summaries of the rawdata file contents. These reports are generated as Word (`report.docx`), PDF (`report.pdf`), and HTML (`report.html`) formats and are also stored in `output/documents/`.  
  
**`cleanData.R`** - This script does a lot of the initial heavy lifting. It reads the raw data file in and cleans it up for future processes. The columns (variables) are renamed and a few new variables are created. The modified data is then sliced into chunks corresponding to the different General Education core competencies. These data files are stored as comma-separated value (`*.csv`) files in `output/data`.

**`makeSpreadsheets.R`** - This script reads in the `*.csv` data files that were generated by `cleanData.R` and creates Excel workbooks for each unique CRN. Folders for each core competency are created in `output/workbooks` and each of the generated spreadsheets are stored in the correct location.  

**`sendEmails`** - This script also reads in the `*.csv` data files that were generated by `cleanData.R` and generates an email message to the instructor of each unique CRN. The workbooks created by `makeSpreadsheets.R` are automatically included as email attachments.  

**`testing.R`** - This script reads `Test_Dataset.xlsx` when placed in the `rawdata` directory. It cleans the data, creates spreadsheets, and emails information for five fake courses. This is used to troubleshoot problems with mail configuration and data processing. 

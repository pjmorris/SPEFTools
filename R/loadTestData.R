# Load project data from its various sources to enable generating the figures
load_project <- function(listOfParms) {

# context factors

projCLOC <- load_original_sloc("sql2_cloc_db")
projCLOC <- rbind(projCLOC,load_original_sloc("sql3_cloc_db"))
projCLOC <- rbind(projCLOC,load_original_sloc("sql4_cloc_db"))

projVulns <- data.frame(ProjectMonth=projectdate(as.Date("2013-01-01")),Factor="Vulns",Value=0)

 spdf <- build_spdf_homebrew(projCLOC,projVulns,"commits_noace.txt")


# Likert plots
ease_label <- 'This practice is easy to use'
effe_label <- 'This practice assists in preventing and/or removing security vulnerabilities on our project'
trai_label <- 'I have been trained in the use of this practice'
freq_label <- 'How Often Do You Engage in the Following Activities?'

pl <- parse_surveyjs("/Users/admin/Dropbox/NCSU/DissertationResearch/paper_surveying-security-practices/survey09042015 copy.csv")

# Remove column names from likert scale questions for plotting
easedf <- as.data.frame(unclass(pl))[c(3)]
colnames(easedf)[1] <- " "
effedf <- as.data.frame(unclass(pl))[c(4)]
colnames(effedf)[1] <- " "
traidf <- as.data.frame(unclass(pl))[c(6)]
colnames(traidf)[1] <- " "
freqdf <- as.data.frame(unclass(pl))[c(5)]
colnames(freqdf)[1] <- " "

# adherence
projIssues <- read.csv("/Users/admin/github/SPEFTools.rb/pma/has_issues.csv",header=TRUE,row.names=NULL)
projEmails <- read.csv("/Users/admin/github/SPEFTools.rb/pma/has_emails.csv",header=TRUE,row.names=NULL)
# Don’t forget about commit messages

}
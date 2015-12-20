# SPEFTools.R main file… for now

# Constants

# lifted from preload.js
#        "optionsFor":  {
#                "role": ["de", "qa", "pm", "re", "ux", "id", "da", "ba", "se", "ot"],

likert_levels = c("na","sd","di","ne","ag","sa")
likert_labels=c("Not Applicable","Strongly Disagree","Disagree", "Neutral", "Agree", "Strongly Agree")

freq_levels <- c("na", "la", "an", "qu", "mo", "we", "da")
freq_labels <- c("Not Applicable", "Less than Annually", "Annually", "Quarterly", "Monthly", "Weekly", "Daily")

practice_levels <- rev(c("p0","p1","p2","p3","p4","p5","p6","p7","p8","p9","p10","p11","p12"))
practice_labels <- rev(c("Apply Data Classification Scheme", "Apply Security Requirements", "Apply Threat Modeling", "Document Technical Stack", "Apply Secure Coding Standards", "Apply Security Tooling", "Perform Security Testing", "Perform Penetration Testing", "Perform Security Review", "Publish Operations Guide", "Track Vulnerabilities", "Improve Development Process","Perform Security Training"))

role_levels <- c("de", "qa", "pm", "re", "ux", "id", "da", "ba", "se", "ot")
# todo: get role labels, update here
role_labels <- c("Developer", "Tester", "Manager", "Requirements Engineer", "Designer", "Name This", "Name That", "Name 3", "Name 4", "Other")

# and compute the mode (most commonly occurring value).
Mode <- function(x) {
ux <- unique(x)
ux[which.max(tabulate(match(x, ux)))]
}

projectdate <- function(date) { floor_date(date,"month") + months(1) }


# e.g. spdf<- build_spdf(conn <- src_mysql("phpmyadmin_cvsa",user="spef",password="spefftw2015"))

build_spdf <- function(conn) {

# pull the data

# VDensity 
# Churn
churn <- collect(tbl(conn,sql("select s.repository_id, s.date, cfl.commit, sum(cfl.added) added ,sum(cfl.removed) removed, sum(cfl.added+cfl.removed) churn from scmlog s, commits_files_lines cfl where s.id=cfl.commit group by commit")))

churn$ProjectMonth <- NA
churn$ProjectMonth <- projectdate(as.Date(churn$date))

churned <- churn %>% group_by(ProjectMonth) %>% summarise(Value = sum(added+removed),Factor='Churn') 

# Commits
# expensive, but effective… see later about pulling just the columns you need
commits <- collect(tbl(conn,sql("SELECT * FROM scmlog s")))
commits$ProjectMonth <- NA
commits$ProjectMonth <- projectdate(as.Date(commits$date))

# Devs
devs <- commits %>% group_by(ProjectMonth) %>% summarise(Value=length(unique(author_id)),Factor='Devs')

# commits <- collect(tbl(conn,sql("SELECT s.date, 'Commits' Factor, s.id Value FROM scmlog s")))

committed <- commits %>% group_by(ProjectMonth) %>% summarise(Value = n(),Factor='Commits')
# SLOC
evo <- collect(tbl(conn,sql("SELECT * from metrics_evo")))
evo$ProjectMonth <- NA
evo$ProjectMonth <- projectdate(as.Date(evo$date))

slocs <- evo %>% group_by(ProjectMonth) %>% summarise(Value = sum(sloc),Factor='altSLOC') 
locs <- evo %>% group_by(ProjectMonth) %>% summarise(Value = sum(loc),Factor='SLOC')
files <- evo %>% group_by(ProjectMonth) %>% summarise(Value = sum(files),Factor='Files')

# Building up spdf…
spdf <- committed
spdf <- rbind(spdf,churned)

spdf <- rbind(spdf,slocs)
spdf <- rbind(spdf,locs)
spdf <- rbind(spdf,files)
spdf <- rbind(spdf,devs)
return(spdf)
}

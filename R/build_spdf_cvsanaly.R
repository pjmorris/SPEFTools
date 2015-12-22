

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

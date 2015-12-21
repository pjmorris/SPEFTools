# database support routines


# latest extract_sloc
load_cloc <- function(dbname)
{
    clocdb <- src_sqlite(dbname)
    cloct<- tbl(clocdb, sql("SELECT * FROM t where Language in ('Java','Javascript,','Ruby','YAML','Bourne Shell','Bourne Again Shell') "))
    tdf <- as.data.frame(cloct,n=-1)

    # split column from cloc input into project name, project month
    matchPoint <- regexpr("*___",tdf[1,]$Project)-1
    tdf$ProjectMonth <- projectdate(as.Date(substr(tdf$Project,matchPoint+4,matchPoint+14)))
    tdf$Project <- substr(tdf$Project,1,matchPoint)
    return(tdf)
}

load_original_sloc <- function(dbname)
{
    clocdb <- src_sqlite(dbname)
    cloct<- tbl(clocdb, sql("SELECT * FROM t where Language in ('Java','Javascript,','Ruby','YAML','Bourne Shell','Bourne Again Shell') "))
    tdf <- as.data.frame(cloct,n=-1)

    # split column from cloc input into project name, project month
matchPoint <- regexpr("*_2",tdf[1,]$Project)+1
tdf$ProjectMonth <- projectdate(as.Date(paste(sub("_","-",substr(tdf$Project,matchPoint,matchPoint+7)),"-01",sep="")))
tdf$Project <- substr(tdf$Project,1,matchPoint-2)
    return(tdf)
}

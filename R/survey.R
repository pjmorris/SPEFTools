# Code to translate from surveyjs export to format suitable for plotting 
parse_surveyjs <- function(path) {

# read team data - point path to your local copy of the survey data csv file to be analyzed
ssp0 = read.csv(path)

# reshape for easy munging
ssp0m <- melt(ssp0,id=c("id")) # row per subject-variable-value
# create columns for practice, measured variable (ease, etc…)
ssp0mm <- cbind(ssp0m,colsplit(ssp0m$variable,split="_",names=c("practice","measure"))) 
# extract practice responses from complete set of responses
pmin <- ssp0mm[ssp0mm$practice %in% practice_levels,c("id","practice","measure","value")]

pl <- cast(pmin,id + practice ~ measure)
# Including the following line drops the NA responses
pl <- pl[pl$ease!="na" & pl$effe!="na" & pl$trai!="na" & pl$freq!="na",]
pl$practice <- factor(pl$practice,levels=practice_levels,labels=practice_labels,ordered=TRUE)

# set likert scale factors
pl[c(3,4,6)] <- lapply(pl[c(3,4,6)], factor, levels=likert_levels, labels=likert_labels,ordered=TRUE)
# pl[c(3)] <- factor(pl[c(3)]$value,likert_levels,likert_levels,ordered=TRUE)

# set frequency factor - plot looks cool, but frequency isn’t a likert scale - no middle
pl[c(5)] <- lapply(pl[c(5)], factor, levels=freq_levels,labels=freq_labels,ordered=TRUE)
return(pl)
}


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
	
# Respondent demographic data
demog <- subset(ssp0mm, measure %in% c("yearsworked","yearsrole","hoursweek"))
demog$measure <- factor(demog$measure,levels=c("yearsworked","yearsrole","hoursweek"),labels=c("Years Worked","Years in Role","Hours per Week"),ordered=TRUE)
demog$value <- as.numeric(demog$value)
	
# Role data
roles <- subset(ssp0mm, measure %in% c("role"))
roles$value <- factor(roles$value,levels=role_levels,labels=role_labels,ordered=TRUE)
colnames(roles)[3] <- "role"

# pl... Likert responses data
pl <- cast(pmin,id + practice ~ measure)
# Including the following line drops the NA responses
pl <- pl[pl$ease!="na" & pl$effe!="na" & pl$trai!="na" & pl$freq!="na",]
pl$practice <- factor(pl$practice,levels=practice_levels,labels=practice_labels,ordered=TRUE)
	

# set likert scale factors
pl[c(3,4,6)] <- lapply(pl[c(3,4,6)], factor, levels=likert_levels, labels=likert_labels,ordered=TRUE)
# pl[c(3)] <- factor(pl[c(3)]$value,likert_levels,likert_levels,ordered=TRUE)

# set frequency factor - plot looks cool, but frequency isn’t a likert scale - no middle
pl[c(5)] <- lapply(pl[c(5)], factor, levels=freq_levels,labels=freq_labels,ordered=TRUE)
	
# SPEF Survey Results class - collects various data elements
	SPEFSurveyResults <- function(pMin,pPl, pDemog, pRoles)
	{
		this <- list(pmin=pMin,pl=pPl,
					 demog = pDemog,
					 roles=pRoles
					 )
		class(this) <- append(class(this),"SPEFSurveyResults")
		return(this)
	}
	
#return(pl)
return(SPEFSurveyResults(pmin,pl, demog, roles))
}

# label practices on likert plot, include # responses/total respondents
resp_label <- function(responses,respondents) {
	nresponses <- sum(ifelse(!is.na(responses),1,0))
	label <- paste(" (",as.character(nresponses),"/",as.character(respondents),")",sep="")
	return(label)
}

likert_dfl <- function(qn,pmin,levels,labels) {
	edf <- as.data.frame(cast(pmin[pmin$measure==qn & pmin$value!="na",],id ~ practice))[,-1]
	nrespondents <- length(unique(pmin$id))
	
	edf$p0 <- factor(edf$p0,levels=levels,labels=labels,ordered=TRUE)
	edf$p1 <- factor(edf$p1,levels=levels,labels=labels,ordered=TRUE)
	edf$p2 <- factor(edf$p2,levels=levels,labels=labels,ordered=TRUE)
	edf$p3 <- factor(edf$p3,levels=levels,labels=labels,ordered=TRUE)
	edf$p4 <- factor(edf$p4,levels=levels,labels=labels,ordered=TRUE)
	edf$p5 <- factor(edf$p5,levels=levels,labels=labels,ordered=TRUE)
	edf$p6 <- factor(edf$p6,levels=levels,labels=labels,ordered=TRUE)
	edf$p7 <- factor(edf$p7,levels=levels,labels=labels,ordered=TRUE)
	edf$p8 <- factor(edf$p8,levels=levels,labels=labels,ordered=TRUE)
	edf$p9 <- factor(edf$p9,levels=levels,labels=labels,ordered=TRUE)
	edf$p10 <- factor(edf$p10,levels=levels,labels=labels,ordered=TRUE)
	edf$p11 <- factor(edf$p11,levels=levels,labels=labels,ordered=TRUE)
	
	edf <- rename(edf, c(
						 p0= paste("Apply Data Classification Scheme",resp_label(edf$p0,nrespondents)),
						 p1= paste("Apply Security Requirements",resp_label(edf$p1,nrespondents)),
						 p2= paste("Apply Threat Modeling",resp_label(edf$p2,nrespondents)),
						 p3= paste("Document Technical Stack",resp_label(edf$p3,nrespondents)),
						 p4= paste("Apply Secure Coding Standards",resp_label(edf$p4,nrespondents)),
						 p5= paste("Apply Security Tooling",resp_label(edf$p5,nrespondents)),
						 p6= paste("Perform Security Testing",resp_label(edf$p6,nrespondents)),
						 p7= paste("Perform Penetration Testing",resp_label(edf$p7,nrespondents)),
						 p8= paste("Perform Security Review",resp_label(edf$p8,nrespondents)),
						 p9= paste("Publish Operations Guide",resp_label(edf$p9,nrespondents)),	
						 p10= paste("Track Vulnerabilities",resp_label(edf$p10,nrespondents)),
						 p11= paste("Improve Development Process",resp_label(edf$p11,nrespondents))))
	return(edf)
}



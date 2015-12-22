# SPEF Project class - collects various data elements for SPEF
SPEFProject <- function(pSloc,pCommits,pChurn,pFiles,pDevs,pVulns,pIssues,pEmails,pAdoption,pTimeline)
{
	this <- list(SLOC=pSloc,
		Commits=pCommits,
		Churn=pChurn,
		Files=pFiles,
		Devs=pDevs,
		Vulns=pVulns,
		Issues = pIssues,
		Emails=pEmails,
		Adoption=pAdoption,
		Timeline=pTimeline
	)
	class(this) <- append(class(this),"SPEFProject")
	return(this)
}

# SPEF DataFrame class - collects various data elements for SPEF
SPEFDataFrame <- function(pSpdf,pIssues,pEmails,pAdoption,pTimeline)
{
	this <- list(spdf=pSpdf,
		Issues = pIssues,
		Emails=pEmails,
		Adoption=pAdoption,
		Timeline=pTimeline
	)
	class(this) <- append(class(this),"SPEFDataFrame")
	return(this)
}
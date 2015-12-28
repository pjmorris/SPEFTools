alignPoints <- function(pPointList, pGroupBy, pTimeline,pFactor)
{
# build per-month totals
monthly <- data.frame(ProjectMonth=projectdate(as.Date(min(pTimeline$ProjectMonth))),Factor=pFactor,Value=0)
pPointList$N <- 1

monthly <- rbind(monthly,summarise(pGroupBy,Factor=pFactor,Value=sum(N)))
monthly$ProjectMonth <- as.Date(monthly$ProjectMonth)

# align by month totals from projVulns2 into projV2
aligned <- merge(pTimeline,monthly,all.x=TRUE)
aligned$Value <- ifelse(is.na(aligned$Value), 0, aligned$Value)
aligned$Factor <- ifelse(is.na(aligned$Factor), pFactor, aligned$Factor)
aligned$ProjectMonth <- as.Date(aligned$ProjectMonth)

# add accumulation field, yielding projVC
cumulative <- aligned
cumulative$Factor <- paste("Total",pFactor,sep="")
cumulative$Value <- cumsum(cumulative$Value)
cumulative$ProjectMonth <- as.Date(cumulative$ProjectMonth)
return(cumulative)
}


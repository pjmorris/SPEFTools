makeRatio <- function(series1,series2,pFactor) {
    series1 <- series1[,c("ProjectMonth","Value")]
    series1$ProjectMonth <- as.Date(series1$ProjectMonth)
    series1 <- rename(series1, Num=Value)
    series2 <- series2[,c("ProjectMonth","Value")]
    series2$ProjectMonth <- as.Date(series2$ProjectMonth)
    series2 <- rename(series2, Denom=Value)
    ratio <- merge(series1,series2)
    ratio$Value <-ratio$Num/(ratio$Denom)
    ratio$Factor <- pFactor
    ratio <- ratio[c("ProjectMonth","Factor","Value")]
    return(ratio)
}


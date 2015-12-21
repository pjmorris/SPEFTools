# SPEF Keywords - generic list of keywords associated with security practices
# classified <- classify(issues)


# Practices
#	$Practice
#	$Keywords
# Keywords (implemented as regexps) for SPEF Practices

williams_security_terms <- "crash|denial of service|access level|sizing issues|resource consumption|data loss|flood|integrity|overflow|null problem|overload|protection|leak"
gegick_security_terms <- "security|vulnerability|vulnerable|hole|exploit|attack|bypass|backdoor|threat|expose|breach|violate|fatal|blacklist|overrun|insecure"

   ADCS <- "street address|credit card number|data classification|data inventory|Personally Identifiable Information (PII)|user data|privacy"
   ASR <- "authentication|authorization|requirement|use case|scenario|specification|confidentiality|availability|integrity|non-repudiation|user role|regulations|contractual agreements|obligations|risk assessment|FFIEC|GLBA|OCC|PCI DSS|SOX|HIPAA" 
   PTM <- "threats|attackers|attacks|attack pattern|attack surface|vulnerability|exploit|misuse case|abuse case" 
   DTS <- "stack|operating system|database|application server|runtime environment|language|library|component|patch|framework|sandbox|environment|network|tool|compiler|service|version" 

   ASCS <-	"avoid|banned|buffer overflow|checklist|code|code review|code review checklist|coding technique|commit checklist|dependency|design pattern|do not use|enforce function|firewall|grant|input validation|integer overflow|logging|memory allocation|methodology|policy|port|security features|security principle|session|software quality|source code|standard|string concatenation|string handling function|SQL Injection|unsafe functions|validate|XML parser" 

   AST <- "automate|automated|automating|code analysis|coverage analysis|dynamic analysis|false positive|fuzz test|fuzzer|fuzzing|malicious code detection|scanner|static analysis|tool" 
   PST <- "boundary value|boundary condition|edge case|entry point|input validation|interface|output validation|replay testing|security tests|test|tests|test plan|test suite|validate input|validation testing|regression test" 
   PPT <- "penetration" 
   PSR <- "architecture analysis|attack surface|bug bar|code review|denial of service|design review|elevation of privilege|information disclosure|quality gate|release gate|repudiation|review|security design review|security risk assessment|spoofing|tampering|STRIDE" 

   POG <- "administrator|alert|configuration|deployment|error message|guidance|installation guide|misuse case|operational security guide|operator|security documentation|user|warning" 
   TV <- "bug|bug bounty|bug database|bug tracker|defect|defect tracking|incident|incident response|severity|top bug list|vulnerability|vulnerability tracking" 
   IDP <- "architecture analysis|code review|design review|development phase,gate|root cause analysis|software development lifecycle|software process" 
   PSTR <- "awareness program|class|conference|course|curriculum|education|hiring|refresher|mentor|new developer|new hire|on boarding|teacher|training" 

    Practices <- NULL
    Practices <- rbind(Practices,data.frame( Practice =  "Security Advisory", Keywords =  "PSIRT" ))
    Practices <- rbind(Practices,data.frame( Practice =  "Security Related", Keywords =  williams_security_terms ))
    Practices <- rbind(Practices,data.frame( Practice =  "Security Related", Keywords =  gegick_security_terms ))
    Practices <- rbind(Practices,data.frame( Practice =  "Apply Data Classification Scheme", Keywords =  ADCS ))
    Practices <- rbind(Practices,data.frame( Practice =  'Apply Security Requirements', Keywords =  ASR ))
    Practices <- rbind(Practices,data.frame( Practice =  'Perform Threat Modeling', Keywords =  PTM ))
    Practices <- rbind(Practices,data.frame( Practice =  'Document Technical Stack', Keywords =  DTS ))
    Practices <- rbind(Practices,data.frame( Practice =  'Apply Secure Coding Standards', Keywords =  ASCS ))
    Practices <- rbind(Practices,data.frame( Practice =  'Apply Security Tooling', Keywords = 	AST ))
    Practices <- rbind(Practices,data.frame( Practice =  'Perform Security Testing', Keywords = 	PST ))
    Practices <- rbind(Practices,data.frame( Practice =  'Perform Penetration Testing', Keywords =  	PPT ))
    Practices <- rbind(Practices,data.frame( Practice =  'Perform Security Review', Keywords =  PSR ))
    Practices <- rbind(Practices,data.frame( Practice =  'Publish Operations Guide', Keywords =  POG ))
    Practices <- rbind(Practices,data.frame( Practice =  'Track Vulnerabilities', Keywords =  TV ))	
    Practices <- rbind(Practices,data.frame( Practice =  'Improve Development Process', Keywords =  IDP ))
    Practices <- rbind(Practices,data.frame( Practice =  'Provide Security Training', Keywords = 	PSTR ))


# print "ProjectMonth,EventDate,Project,Practice,Source,DocId,creator,assignee,\n"
# classify - generate line with project, date, source, creator, issue #, reporter, keywords, topic
# figure out ‘argument is of length zero’
# rewrite in terms of apply
classify <- function(d,Practices)
{
    Classified <- NULL
	for (j in 1:length(Practices$Practice))
	{
			for (i in grep(tolower(Practices[j,]$Keywords),tolower(d$Content)))
			{
				Classified <- rbind(Classified,data.frame(ProjectMonth=d[i,]$ProjectMonth,EventDate=d[i,]$EventDate,Project=d[i,]$Project,Practice=Practices[j,]$Practice,Source=d[i,]$Source,DocId=d[i,]$DocId,Creator=d[i,]$Creator,Assignee=d[i,]$Assignee))
			}
	}
    return(Classified)
}


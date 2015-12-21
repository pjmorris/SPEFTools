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

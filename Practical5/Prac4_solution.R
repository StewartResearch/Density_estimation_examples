## ----setup, include=FALSE----------------------------------------
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)


## ---- echo=T, eval=T---------------------------------------------
library(Distance)
data("Systematic_variance_2")
conversion.factor <- convert_units("metre", "kilometre", "square kilometre")
# Fit a simple model
sysvar2.hn <- ds(data=Systematic_variance_2, key="hn", adjustment="cos",
                 convert_units=conversion.factor)
sysvar2.hn$dht$individuals$D
sysvar2.hn$dht$individuals$N


## ---- quiet=T, suppress_messages=T, message=F, results=F---------
est.boot <- bootdht(model=sysvar2.hn, flatfile=Systematic_variance_2,
                    summary_fun=bootdht_Nhat_summarize, 
                    convert_units=conversion.factor, nboot=50)


## ---- eval=T-----------------------------------------------------
summary(est.boot)


## ---- echo=T, eval=T---------------------------------------------
## Post-stratification by O2 estimator
# ensure that Sample.Labels are numeric, for O2 ordering
Systematic_variance_2$Sample.Label <- as.numeric(Systematic_variance_2$Sample.Label)
# Using the Fewster et al 2009, "O2" estimator 
est.O2 <- dht2(sysvar2.hn, flatfile=Systematic_variance_2,   strat_formula=~1, convert_units=conversion.factor, er_est="O2")
print(est.O2, report="density")


## ---- echo=T, eval=T---------------------------------------------
# Access the data
data("Systematic_variance_1")
# Ensure that Sample.Labels are numeric, for O2 ordering
Systematic_variance_1$Sample.Label <- as.numeric(Systematic_variance_1$Sample.Label)
# First fit a simple model
sysvar1.hn <- ds(Systematic_variance_1, key="hn", adjustment=NULL, 
                 convert_units=conversion.factor)
# Obtain default estimates for comparison
sysvar1.hn$dht$individuals$D
sysvar1.hn$dht$individuals$N
# Now use Fewster et al 2009, "O2" estimator 
est2.O2 <- dht2(sysvar1.hn, flatfile=Systematic_variance_1, strat_formula=~1,
                convert_units=conversion.factor, er_est="O2")
print(est2.O2, report="density")


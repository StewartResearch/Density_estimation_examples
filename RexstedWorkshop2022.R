#######################################
# Eric Rexstad Distance Sampling workshop materials from April 2022
# Charlotte Rentmeister took this workshop
# All information can be found on the StewartLab GoogleDrive folder, under Workshops -> Distance Workshop
# Code below is me brining together the practicals into one repository
########################################
# Good resources:
## Course website: http://distancelive.xyz 
########################################
# Started May 2022
########################################
# F. Stewart
########################################

(WD <- getwd())
if (!is.null(WD)) setwd(WD)

install.packages("Distance")
library(Distance)
#or, to make sure you have the most up to date remote version of the package (CRAN might not have the latest updates)
install.packages("remotes")
library(remotes)
remotes::install_github("DistanceDevelopment/Distance")

#fitting the detection function g(x)
?ds() 
# options here are hn, hr, and unif (key = )
# adjustment terms help make the detection function more robust (ie. applicable to more models), e.g. adjust = 

##### Exercise 2 Practical ##########
# See Practical2-Distance Sampling folder

# First, access the duck nest data that come as part of the distance package
data(ducknest)
head(ducknest)
nrow(ducknest)

#create a numerical summary of the distances, then plot a histogram
summary(ducknest$distance) # most nests were viewed just over 1.1m away
hist(ducknest$distance, xlab ="Distance(m)")

#fit a simple detection function wtih ds()
# need to make sure units are correct
conversion.factor<-convert_units("meter", "kilometer", "square kilometer")

# fit a half normal detection function, no adjustment terms
nest.hn<-ds(data=ducknest, key = "hn", adjustment = NULL, convert_units = conversion.factor)
# AIC = 928.134
summary(nest.hn)
#density estimate is 49.69 +/- 1.94 duck nests/km^2

#view the fitted detection function
plot(nest.hn)
# no bad

# change the bins in the histogram by
plot(nest.hn, nc=8)

# make sure to check the goodness of fit for this model
gof_ds(nest.hn, nc=8)
# pretty good!

# can also try fitting different detection function forms and shapes by changing the key and ajustment parameters.
# then compete models using AIC
# for example

nest.unif<-ds(data=ducknest, key = "unif", adjustment = "cos", convert_units = conversion.factor)
# provides 1 and 2 adjustments - AIC differes only slightly between these (928.48 and 929.383)
summary(nest.unif)
# slightly higher density estimate: 51.04
# BUT AIC is also higher than nest.hn...so we wont use this model
plot(nest.unif)
gof_ds(nest.unif)
# they are essentially the same model...
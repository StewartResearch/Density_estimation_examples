#######################################3
# Examples to walk students through Kernel Hensity Estimation in R
########################################
# F. sTEwart
########################################

#######################3
# Some good resources
########################

# https://www.youtube.com/watch?v=xsDp6KxRGxc
# https://cran.r-project.org/web/packages/kdensity/vignettes/tutorial.html 
# https://egallic.fr/R/sKDE/smooth-maps/kde.html

##################################
# NON-SPATIAL ANALYSES
#################################

# Histogram
 hist(mtcars$mpg)
?mtcars # dataset that comes with R

#kernel Density function
d <-density(mtcars$mpg)
?density # this is all from base R, so no need to install a library/package, up add a data set using read.csv
plot(d)

# filling in the plot
# the area under the curve will always be = 1
plot(d, main = "Kernel Density")
polygon(d, col = "red", border = "black")

# dedicated R package that we can instead use is 'kdensity'. This package provides both parametric and non- parametric analyses
install.packages('kdensity')
library(kdensity) # lots more flexibilty here in terms of smoothing parameters etc. 

kde = kdensity(mtcars$mpg, start = "gumbel", kernel = "gaussian")
kde
#plot this non-parametric default
plot(kde) # can alter this plot in the same was as above, so that we have a better title

# no plot the parametric equivalent
plot(kde)
lines(kde, plot_start = TRUE, col = "red") # add the parametric estimation line
?lines
rug(mtcars$mpg) # add frequency on the X axis

# what if we know this is not a normally distributed data set?
hist(mtcars$mpg) # this seems to be, but what if it was not?
# we can add a kernel function specification to kde
# for example
kde2 = kdensity(mtcars$mpg, start = "gumbel", kernel = "gamma")
plot(kde2)

#now compare the two plots
par(mfrow = c(2,1))
plot(kde)
plot(kde2)

### So the above is for 1 dimensional data - we were investigating a histogram of the number of cars that use each category of miles/gallon
## what if our data is spatial (i.e. 2D?)
## we need to be able to spatially reference each data point so that we can plot our kernel density function on a map




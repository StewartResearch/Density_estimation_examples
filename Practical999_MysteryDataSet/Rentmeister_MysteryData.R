library(Distance)
conversion <- convert_units("meter", "kilometer", "square kilometer")
mydata<-read.csv("mystery.csv")
head(mydata)
hist(mydata$distance)


mystery.hn<- ds(data=mydata, key="hn", adjustment=NULL,
      convert_units=conversion)
summary(mystery.hn)
plot(mystery.hn)
gof_ds(mystery.hn)

mystery.hr <-ds(data=mydata, key="hr", adjustment=NULL,
                   convert_units=conversion)
summary(mystery.hr)
plot(mystery.hr)
gof_ds(mystery.hr)

mystery.hn.cos<- ds(data=mydata, key="hn", adjustment="cos",
                convert_units=conversion)
summary(mystery.hn.cos)
plot(mystery.hn.cos)
gof_ds(mystery.hn.cos)


mystery.hr.cos <-ds(data=mydata, key="hr", adjustment="cos",
                convert_units=conversion)

summary(mystery.hr.cos)
plot(mystery.hr.cos)
gof_ds(mystery.hr.cos)

mystery.uni.cos<- ds(data=mydata, key="unif", adjustment="cos",
                 convert_units=conversion)


summary(mystery.uni.cos)
plot(mystery.uni.cos)
gof_ds(mystery.uni.cos)

mystery.uni<- ds(data=mydata, key="unif", adjustment=NULL,
                     convert_units=conversion)


summary(mystery.uni)
plot(mystery.uni)
gof_ds(mystery.uni)


AIC(mystery.hn, mystery.hn.cos, mystery.hr, mystery.hr.cos, mystery.uni, mystery.uni.cos)

par(mfrow=c(2,2))
gof_ds(mystery.hn)
gof_ds(mystery.uni)

#df      AIC
#mystery.hn       1 353.0763
#mystery.hn.cos   1 353.0763
#mystery.hr       2 354.5133
#mystery.hr.cos   2 354.5133
#mystery.uni      2 352.0885
#mystery.uni.cos  2 352.0885


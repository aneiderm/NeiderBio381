#April 24, 2018
# Metafor for meta-analyses

install.packages("metafor")
library(metafor)
dat <- dat.normand1999
dat

#SMD is the standarized mean difference
SMDdat <- escalc(measure = "SMD", m1i = m1i,sd1i = sd1i,n1i = n1i,m2i =m2i, sd2i=sd2i,n2i=n2i, data = dat)
SMDdat

#rma is the random effects model
myModel <- rma(yi,vi,data = SMDdat)
print(myModel)

# you want I^2 to be as close to 100% as possible
# test for heterogeneity

dat <- dat.curtis1998
head(dat)

#continuous variables
dat <- dat.mcdaniel1994
Zdat <- escalc(measure = "ZCOR",ri=ri,ni=ni, data = dat)
head(Zdat)

myModel <- rma(yi,vi,data = Zdat)
print(myModel)

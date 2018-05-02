# Diana Hackenburg

install.packages("devtools")
library(devtools)
devtools::install_github("daattali/timevis")
library(timevis)
install.packages("shiny")
library(shiny)
install.packages("shinythemes")
library(shinythemes)


simpleTL <- data.frame(id=1:4,content=c("Randomization Tests","ggplots","Homework 12","Presentations 1"), start=c("2018-04-03","2018-04-05","2018-04-11","2018-04-24 14:50:00"), end=c(NA,"2018-04-17",NA,NA))
simpleTL

timevis(simpleTL)
# add groups
#create a dataframe to define groups
groups <- 
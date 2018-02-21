library(ggplot2)
p1 <- qplot(runif(100))
p2 <- qplot(rnorm(100))
library(patchwork)
p1+p2

install.packages("devtools")
library(devtools)
install_github("thomas85/patchwork")
library(patchwork)

?rnorm

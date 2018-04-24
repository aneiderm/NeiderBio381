# made4

install.packages("made4")
source("https://bioconductor.org/biocLite.R")
biocLite("made4")
biocLite("BiocUpgrade")
library(made4)

res_mat <- read.csv("Class demos/made4 demo/res_mat_abun.csv")
bac_mat <- read.csv("Class demos/made4 demo/bac_mat_abun.csv")
vf_mat <- read.csv("Class demos/made4 demo/vf_mat_abun.csv")

str(res_mat)
res_mat_all <- res_mat[ ,-c(1)]
res_mat_all[] <- lapply(res_mat_all[],as.numeric)
rownames(res_mat_all) <- res_mat$Name

none <- lapply(res_mat_all, function(x) all(x==0))
which(none=="TRUE")
# remove those 6 columns
res_mat2 <- res_mat_all[,-c(4,10,11,15,21,24)]
head(res_mat2)



# repeat for other two files ----------------------------------------------
bac_mat_all <- bac_mat[,-c(1)]
bac_mat_all[] <- lapply(bac_mat_all[], as.numeric)

# ....


# Using made4 -------------------------------------------------------------

browseVignettes("made4")

overview(res_mat2)

res_coa <- ord(res_mat2,type = "coa")
summary(res_coa$ord)
plot(res_coa)
heatplot(res_mat2)

plotgenes(res_coa,nlab = 1)
plotarrays(res_coa,graph = "groups")

do3d(res_coa$ord$li)

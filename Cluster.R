# Cluster

library(cluster)
library(factoextra)
library(NbClust)
library(ggplot2)

iris.scaled <- scale(iris[,-5])
head(iris.scaled)

# Step 1: Do clusters exist?

Hopkins <- get_clust_tendency(iris.scaled,
                              n=nrow(iris.scaled)-1,
                              seed = 123)
Hopkins$hopkins_stat


# step 2: Calculate Distance
distgower <- daisy(iris.scaled,
                   metric = "gower",
                   stand = TRUE)
DistanceMap <- fviz_dist(dist.obj=distgower,
                         show_labels=TRUE,
                         lab_size=4)
DistanceMap

# Step 3: Cluster Using K-Means

set.seed(123)
km.res <- kmeans(iris.scaled,
                 centers=6,
                 iter.max = 250,
                 nstart = 25)
head(km.res)
fviz_cluster(km.res,
             data = iris,
             choose.var=c("Sepal.Length","Petal.Width"),
             stand = TRUE)
# What is the right number of clusters?

# Method 1: Elbow Method
fviz_nbclust(iris.scaled,
             FUNcluster = kmeans,
             method = "wss")
# Method 2: Silhouette Method
fviz_nbclust(iris.scaled,
             kmeans,
             method = "silhouette")+theme_classic()

#Method 3: GAP STAT
fviz_nbclust(iris.scaled,
             kmeans,
             nstart=25,
             method = "gap_stat",
             nboot=500)
# Method 4: Test all
nb <- NbClust(iris.scaled,
              distance = "euclidean",
              min.nc = 2,
              max.nc = 10,
              method= "kmeans")

##### Validating our results

km.res <- eclust(iris.scaled,
                 stand = FALSE,
                 "kmeans",
                 hc_metric = "manhattan",
                 k=6)
fviz_silhouette(km.res,palette="jco")

km.res <- eclust(iris.scaled,
                 stand = FALSE,
                 "kmeans",
                 hc_metric = "manhattan",
                 k=2)
fviz_silhouette(km.res,palette="jco")

#### Approach 2: Hierarchical cluster

res.agnes <- agnes(x=distgower,
                   diss = TRUE,
                   stand = TRUE,
                   metric = "euclidean",
                   method= "ward")
 fviz_dend(res.agnes,
           cex = 0.6)                  
 
 nb <- NbClust(iris.scaled,
               distance = "euclidean",
               min.nc=2,
               max.nc = 10,
               method = "ward.D2")
 
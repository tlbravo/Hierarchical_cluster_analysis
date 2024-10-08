#install packages
install.packages("tidyverse")
install.packages("cluster")
install.packages("fpc")
install.packages("factoextra")
install.packages("janitor")
install.packages("klaR")
install.packages("ggplot2")

#load libraries
library(tidyverse)
library(cluster)
library(fpc)
library(factoextra)
library(janitor)
library(klaR)
library(ggplot2)


#reading data from github
cheeses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-06-04/cheeses.csv')
View(cheeses)

#selecting categorical columns: cheese, milk, country, type, flavor
cheesedf<-cheeses[c(1,3,4,7, 13)]
View(cheesedf)

install.packages("VIM")
library(VIM)

#using k nearest neighbors to impute data into cells with missing values
cheesedf_clean <- kNN(cheesedf, imp_var = FALSE)
cheesedf_clean$milk <- as.character(cheesedf_clean$milk)
cheesedf_clean$milk <- sapply(strsplit(cheesedf_clean$milk, ","), function(x) trimws(x[1]))
View(cheesedf_clean)

# Perform k-modes clustering
cheese_kmodes <- kmodes(cheesedf_clean, modes = 3, iter.max = 10, weighted = FALSE)

cheese_kmodes$cluster #view cluster assignment
cheese_kmodes$modes # mode values aka cluster centroids 

# Add cluster labels to the dataset
cheesedf_clean$cluster <- cheese_kmodes$cluster

# Convert character columns to factors
cheesedf_clean <- data.frame(lapply(cheesedf_clean, function(x) {
  if (is.character(x)) {
    as.factor(x)
  } else {
    x
  }}))

str(cheesedf_clean)

# Compute Gower's distance for categorical data
gower_dist <- daisy(cheesedf_clean, metric = "gower")

# Calculate silhouette scores
silhouette_score <- silhouette(cheese_kmodes$cluster, gower_dist)

# Visualize silhouette plot
fviz_silhouette(silhouette_score)

#write data frame to CSV file to analyze in Excel
write.csv(cheesedf_clean, "cheese_clusters.csv")

#display number of observations in each cluster
cheesedf_clean %>%
  group_by(cluster) %>%
  summarize(n())
# 1: 487
# 2: 272
# 3: 428
# somewhat evenly distributed

cheesedf_clean %>%
  group_by(cluster, milk) %>%
  summarize(count = n(), .groups = "drop") %>%
  mutate(percentage = count / sum(count) * 100)


cheesedf_clean %>%
  group_by(cluster, country) %>%
  summarize(count = n(), .groups = "drop") %>%
  mutate(percentage = count / sum(count) * 100)

cheesedf_clean %>%
  group_by(type) %>%
  summarize(count = n(), .groups = "drop") %>%
  mutate(percentage = count / sum(count) * 100)
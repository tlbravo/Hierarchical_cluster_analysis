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

##parallel set plots 
install.packages("ggalluvial")
library(ggalluvial)

cheesedf_clean$milk <- as.factor(cheesedf_clean$milk)
cheesedf_clean$cluster <- as.factor(cheesedf_clean$cluster)
#top_5_milk <- names(sort(table(cheesedf_clean$milk), decreasing = TRUE)[1:5])
#cheesedf_clean$milk <- ifelse(cheesedf_clean$milk %in% top_5_milk, cheesedf_clean$milk, "Other")


ggplot(cheesedf_clean,
       aes(axis1 = milk, axis2 = cluster)) +
  geom_alluvium(aes(fill = cluster)) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  scale_x_discrete(limits = c("Milk Type", "Cluster"), expand = c(0.1, 0.1)) +
  labs(title = "Parallel Sets Plot for Milk Type and Clusters") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 12)) +  # Increase label size
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))

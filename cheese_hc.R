#install packages
install.packages("tidyverse")
install.packages("cluster")
install.packages("fpc")
install.packages("factoextra")
install.packages("janitor")
install.packages("klaR")

#load libraries
library(tidyverse)
library(cluster)
library(fpc)
library(factoextra)
library(janitor)
library(klaR)


#reading data from github
cheeses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-06-04/cheeses.csv')
View(cheeses)

#selecting categorical columns 
cheesedf<-cheeses[c(1,3,4,7, 13)]
View(cheesedf)

#using k-modes method 
kmodes <- kmodes(cheesedf, modes = 3, iter.max = 10, weighted = FALSE)

#adding cluster assignments
kmodes$cluster  
kmodes$modes 

#adding to dataset
cheesedf$cluster <- kmodes$cluster

#install packages
install.packages("tidyverse")
install.packages("cluster")
install.packages("fpc")
install.packages("factoextra")
install.packages("janitor")
install.packages("here")
install.packages("fs")
install.packages("here")
install.packages("rvest")
install.packages("polite")
install.packages("glue")

#load libraries
library(tidyverse)
library(cluster)
library(fpc)
library(factoextra)
library(janitor)
library(here)
library(fs)
library(rvest)
library(polite)
library(glue)

#reading data from github
cheeses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-06-04/cheeses.csv')
View(cheeses)

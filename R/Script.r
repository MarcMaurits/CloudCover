#Script used to generate example plots

#Loading dependencies
library(magick)
library(ggplot2)
library(gridExtra)
library(colorRamps)

#Reading functions
source("Functions.r")

#Creating example data
dat <- data.frame(word = c("Pizza", "Spons", "Gozer", "Krimp", "Joker"), freq = c(15, 30, 60, 120, 240))

#Generating font size example
plotCloudST(tmp, cap = "all", order = T, party = T, font = 2)

#Generating surface area example
plotCloudSA(tmp, cap = "all", order = T, party = T, font = 2)
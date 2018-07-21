#Load libraries
library(Seurat)
library(monocle)
library(dplyr)
library(Matrix)
library(stringr)
library(shiny)
library(shinydashboard)

#Load dataset
load('Negative_Low_High_filtering_h_060818.Robj')
load('HSMM_for_shiny_app.Robj') 
load('pbmc_markers_for_Shiny_app.Robj') 

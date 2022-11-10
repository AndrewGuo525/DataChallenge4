#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(medicaldata)
library(plotly)
library(markdown)
library(janitor)


gender <- c("Male", "Female")
# Define UI for application that draw several plots
shinyUI(
  ## Add the name of the whole program
  navbarPage("Data Challenge 4",
             ## Design the first panel with name
             tabPanel("Plot1",
                      ## Generate a row with a sidebar
                      sidebarLayout(
                        ## Define the sidebar
                        sidebarPanel(
                          ## Set up the panel to choose 
                          selectInput("variable1", "Variable:", 
                                      choices = c("Critically	Ill	Trama	Patient", 
                                                  "Healthy Volunteer")
                          ),
                          ## Set up the sidebar panel to display the text
                          textOutput("text")
                        ),
                        ## Define the main panel to show the plot and discription
                        mainPanel(
                          plotlyOutput("plot1"),
                          textOutput("text1")
                        )
                      )
             ),
             tabPanel("Plot2",
                      ## Generate a row with a sidebar
                      sidebarLayout(
                        ## Define the sidebar
                        sidebarPanel(
                          ## Set up the sidebar panel to choose 
                          selectInput("variable2", "Variable:", 
                                      choices = c("Stomach_mean_pH", 
                                                  "Small_Bowel_mean_pH",
                                                  "Colon_mean_pH")
                          )
                        ),
                        ## Define the main panel to show the plot and discription
                        mainPanel(
                          plotlyOutput("plot2"),
                          textOutput("text2")
                        )
                      )
             ),
             tabPanel("Plot3",
                      ## Generate a row with a sidebar
                      sidebarLayout(
                        ## Define the sidebar
                        sidebarPanel(
                          ## Set up the sidebar panel to choose 
                          checkboxGroupInput("variable3a", "Variable:",
                                             gender,
                                             selected = "Male"),
                          selectInput("variable3b", "Variable:", 
                                      choices = c("Gastric_Emptying_Time", 
                                                  "Small_Bowel_Transit_Time")
                          )
                        ),
                        ## Define the main panel to show the plot and discription
                        mainPanel(
                          plotlyOutput("plot3"),
                          textOutput("text3")
                        )
                      )
             )
             
  )
)
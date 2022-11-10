#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## Import necessary package
library(medicaldata)
library(shiny)
library(plotly)
library(tidyverse)
library(rsconnect)
library(janitor)

## Clean the dataset and rename used variables
dataSet <- smartpill %>% 
  mutate(Group = case_when(Group == 0 ~ "Critically	Ill	Trama	Patient",
                           Group == 1 ~ "Healthy Volunteer"),
         Gender = case_when(Gender == 0 ~ "Female",
                            Gender == 1 ~ "Male"),
         Race = case_when(Race == 1 ~ "White",
                          Race == 2 ~ "Black",
                          Race == 3 ~ "Asian/Pacific Islander",
                          Race == 4 ~ "Hispanic",
                          Race == 5 ~ "Other"),
         Period = case_when(Age < 30 ~ "Younger",
                            Age >= 30 & Age < 50 ~ "Mature",
                            Age >= 50 ~ "Elder")) %>%
  rename("Gastric_Emptying_Time" = GE.Time,
         "Small_Bowel_Transit_Time" = SB.Time,
         "Stomach_mean_pH" = S.Mean.pH,
         "Small_Bowel_mean_pH" = SB.Mean.pH,
         "Colon_mean_pH" = C.Mean.pH,
         "Whole_Gut_Time" = WG.Time)

# Define server logic required to draw a plot and add text
function(input, output) {
  ## When ui called text, it will display the introduction of the whole dataset
  output$text <- renderText({
    "The dataset enrolled 8 critically ill patients. Each patient was enrolled within 36 hours of ICU admission. 
       All had major trauma and had an intracranial hemorrhage. Positioning of the motility capsule 
       (SmartPill GI Monitoring Capsule; SmartPill, Inc, Buffalo, NY) was coupled with the medically necessary 
       feeding tube placement 2 days after patients were admitted to an ICU. The capsule was deployed into the stomach, 
       and its position was confirmed radiographically. Data were transmitted to a recorderattached to the patient 
       over a 5-day period. The control group consisted of 87 healthy volunteers with no history of major abdominal surgery."
  })
  
  
  ## When ui called text1, it will display how to use the sidebar in the first panel, and some analysis based on the plot
  output$text1 <- renderText({
    "The panel mainly compares the value of whole gut time in different experiment groups with different period of ages.
       It is clearly to see that comparing with healthy volunteer, the group of patients has a relatively higher value of 
       whole gut time. However, we can also found that whatever in which groups, younger people normally have a higher value
       of whole gut time then elder people. In the sidebar, the user could control to take a look to compare differences 
       between patients and volunteers."
  })
  
  ## When ui called plot1, it will display the first histogram plot
  output$plot1 <- renderPlotly({
    ## Make a histogram plot 
    plot1 <- dataSet %>% filter(Group %in% input$variable1) %>%
      ## Group by period
      group_by(Period, na.rm = TRUE) %>%
      ggplot(aes(y = Whole_Gut_Time, fill = Period)) + 
      geom_histogram(color = "black", bins = 20, na.rm = TRUE) +
      ## Add x-y label and title for the plot
      labs(x = "Frequency",
           y = "Whole	Gut	Time",
           title = "Comparing between whole gut time and its \n frequency for people with different periods of age") +
      ## Center the plot title with bold type
      theme(plot.title = element_text(hjust = 0.5, face="bold"))
    ## Make a interactive plot
    ggplotly(plot1)
  })
  
  
  ## When ui called text2, it will display how to use the sidebar in the second panel, and some analysis based on the plot
  output$text2 <- renderText({
    "The panel mainly compares the value of pH from stomach, small bowel and colon with different races. We can clearly
       see small bowel and colon have relatively higher values of pH than stomach. Also, people from Asian have a 
       relativelely higher value of pH overall and black people have a relatively lower value of pH overall. In the sidebar, 
       the user could make a choice to decide which pH value barplot is preferred to show, and compare with people who have
       different races."
  })
  
  ## When ui called plot2, it will display the second box plot
  output$plot2 <- renderPlotly({
    ## Make a box plot 
    plot2 <- dataSet %>% filter(!is.na(Race)) %>% 
      ## Remove NA value from specific columns
      filter(!is.na(Stomach_mean_pH)) %>% 
      filter(!is.na(Small_Bowel_mean_pH)) %>% 
      filter(!is.na(Colon_mean_pH)) %>% 
      ## Group by race
      group_by(Race) %>%
      ggplot(aes(x = factor(Race), y = get(input$variable2), fill = Race)) + 
      geom_boxplot() +
      ## Add x-y label and title for the plot
      labs(x = "Race",
           y = input$variable2,
           title = paste(input$variable2, "values in difference races")) +
      ## Center the plot title with bold type
      theme(plot.title = element_text(hjust = 0.5, face="bold"))
    ## Make a interactive plot
    ggplotly(plot2)
  })
  
  
  ## When ui called text3, it will display how to use the sidebar in the third panel, and some analysis based on the plot
  output$text3 <- renderText({
    "The panel mainly compares the gastric emptying time and small bowel transit time with different ages and different 
       genders. It is clearly to see that patients have a relatively higher value of gastric emptying time, but for small
       bowel transit time, patients have no significant difference with healthy volunteers. Also, gender and age
       doesn't seem as factors to influence gastric emptying time and small bowel transit time. In the sidebar, the user will
       can choose to display the data from male, female or even both to compare the gastric emptying time and small bowel 
       transit time based on their choice."
  })
  
  ## When ui called plot3, it will display the third scatter plot
  output$plot3 <- renderPlotly({
    ## Remove some NA values in specific columns and filter by gender
    dataSet2 <- dataSet %>% filter(!is.na(Gastric_Emptying_Time)) %>% 
      filter(!is.na(Small_Bowel_Transit_Time)) %>% 
      filter(Gender %in% input$variable3a)
    ## Make a scatter plot 
    plot3 <- ggplot(dataSet2) + 
      geom_point(aes(x = Age, y = get(input$variable3b), color = Group)) +
      ## Add x-y label and title for the plot
      labs(x = "Age",
           y = input$variable3b,
           title = paste(input$variable3b, "with different ages")) +
      ## Center the plot title with bold type
      theme(plot.title = element_text(hjust = 0.5, face="bold"))
    ## Make a interactive plot
    ggplotly(plot3)
  })
}


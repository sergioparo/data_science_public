#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)

tagList(
  navbarPage(
      theme = "simplex",
      "World Airports Finder",
      tabPanel("Main",
               sidebarPanel(
                 uiOutput("country_choice"),
                 uiOutput("airport_type_choice"),
                 uiOutput("min_runaway_lght"),
                 width = 3
               ),
               mainPanel(
                 leafletOutput("airport_map", width = "100%", height = 800),
               )
      ),
      
      tabPanel("Help", 
               h4("How to use World Airports Finder"),
               hr(),
               p("This is a simple Shiny application to find airports around the world and display them in a interactive map."),
               p("You can use the following filters:"),
               tags$ul(
                 tags$li("Country ISO code: select the Country ISO code from the drop box that you want to see that country's airports"),
                 tags$li("Airport Type: select the airport types that will displayed in the map. Each type will be displayed in a different color"),
                 tags$li("Minimum Runaway Length (in ft): filters airports based on the length of the runaway.")
               ),
               p("Then the airports will be plotted in the map, the circle size represents the runaway length."), 
               p("Once you select an airport, additional information about it will be show."),
               hr(),
               p(em("Data set used in this application: https://www.kaggle.com/datasets/mexwell/world-airports"))
      )
  )
)
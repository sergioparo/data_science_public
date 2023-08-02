#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)

# Define server logic required to draw a map
function(input, output, session) {
  
  df <- read.csv("World_Airports.csv")
  
  df$type <- as.factor(df$type)
  
  #distinct airport countries
  df_countries <- df %>% select(iso_country)  %>% distinct() %>% arrange(iso_country)
  #distinct airport types
  df_types <- df %>% select(type)  %>% distinct() %>% arrange(type)
  #max runway_lenght
  df_max_runaway_lght <- max(df$runway_length_ft, na.rm = TRUE)
  
  # create country iso code dropbox and select "BR" as default
  output$country_choice <- renderUI({
    selectInput("country_choice", "Country ISO Code:", df_countries$iso_country, selected = "BR", width="300px")
  })
  
  # create airport type options
  output$airport_type_choice <- renderUI({
    checkboxGroupInput("airport_type_choice", "Airport Type:", df_types$type, selected = list("large_airport", "medium_airport", "small_airport"))
  })
  
  # create slider for runway minimun lenght
  output$min_runaway_lght <- renderUI({
    sliderInput("min_runaway_lght", "Minimun Runaway Length (in ft):", 0, df_max_runaway_lght, 0, width="300px")
  })
  
  output$airport_map <- renderLeaflet({
    
    # create a data frame with just filtered and required data
    df_chart <- df %>% select(iso_country, longitude_deg, type, latitude_deg, name, municipality, iata_code, runway_length_ft) %>%
      filter(iso_country==input$country_choice & runway_length_ft > input$min_runaway_lght & type %in% input$airport_type_choice)
    
    # create color pallete
    factpal <- colorFactor(topo.colors(7), df_chart$type)
    
    # configure the map with circles and markers
    m <- leaflet(df_chart) %>% addTiles() %>%
      addCircles(lng = ~longitude_deg, lat = ~latitude_deg, weight = 2, radius = ~runway_length_ft, opacity = 0.9, color = ~factpal(type)) %>%
      addMarkers(lng = ~longitude_deg, lat = ~latitude_deg,
                 popup = paste("<b>", df_chart$name, "</b><br>",
                               "Municipality:", df_chart$municipality, "<br>",
                               "IATA Code:", df_chart$iata_code, "<br>",
                               "Type:", df_chart$type, "<br>",
                               "Runway Length(ft): ", df_chart$runway_length_ft), clusterOptions = markerClusterOptions())

    m
  })
  }

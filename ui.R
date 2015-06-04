library(shiny)
library(choroplethrCaCensusTract)
library(choroplethrMaps)

data(county.regions)
ca.counties = county.regions[county.regions$state.name == "california", c("region", "county.name")]

counties = ca.counties$region
names(counties) = ca.counties$county.name

data(df_ca_tract_demographics)
demographics = colnames(df_ca_tract_demographics)[2:9]

bay.area.county.fips = c(
  6075, # san francisco
#  6013, # contra costa
  6041, # marin
#  6055, # napa
  6001, # alameda
#  6069, # san benito
  6081#, # san mateo
#  6085, # santa clara
#  6087, # santa cruz
#  6097  # sonoma
)

shinyUI(fluidPage(

  titlePanel("2012 Census Tract Explorer for California"),

  sidebarLayout(
    sidebarPanel(
      selectInput("counties", 
                  "Counties", 
                  counties,
                  selected=bay.area.county.fips,
                  multiple=TRUE),
      selectInput("value",
                  "value",
                  demographics,
                  selected="per_capita_income")                
    ),

    mainPanel(
      plotOutput("map"),
      plotOutput("boxplot")
    )
  )
))

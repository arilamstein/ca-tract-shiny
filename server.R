list.of.packages <- c("choroplethr", "devtools", "shiny", "R6", "mapproj")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(R6)
library(shiny)
library(devtools)
library(choroplethr)
library(ggplot2)
library(mapproj)

if (!"choroplethrCaCensusTract" %in% installed.packages()[, "Package"]) {
  install_github('arilamstein/choroplethrCaCensusTract')
}
library(choroplethrCaCensusTract)

CaTractChoroplethNoBorder = R6Class("CaTractChoroplethNoBorder",
  inherit = choroplethrCaCensusTract::CaTractChoropleth,
  public = list(
    
    render = function() 
    {
      self$prepare_map()
      
      ggplot(self$choropleth.df, aes(long, lat, group = group)) +
        geom_polygon(aes(fill = value), color = NA) + 
        self$get_scale() +
        self$theme_clean() + 
        ggtitle(self$title) + 
        self$projection
    }    
  )
)

ca_tract_choropleth_no_border = function(df, title="", legend="", num_colors=7, tract_zoom=NULL, county_zoom=NULL)
{
  c = CaTractChoroplethNoBorder$new(df)
  c$title  = title
  c$legend = legend
  c$set_zoom_tract(tract_zoom=tract_zoom, county_zoom=county_zoom)
  c$set_num_colors(num_colors)
  c$render()
}
shinyServer(function(input, output) {
  
  data(df_ca_tract_demographics)
  df_ca_tract_demographics$value = df_ca_tract_demographics$percent_asian
  
  output$map = renderPlot({
    df_ca_tract_demographics$value = df_ca_tract_demographics[, input$value]
    num_colors = as.numeric(input$num_colors)
    ca_tract_choropleth_no_border(df_ca_tract_demographics, 
                        num_colors=num_colors,
                        county_zoom=input$counties) + coord_map()
  })
  
  output$boxplot = renderPlot({
    df_ca_tract_demographics$value = df_ca_tract_demographics[, input$value]
    boxplot(df_ca_tract_demographics$value)
  })
})

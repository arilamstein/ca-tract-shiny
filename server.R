library(shiny)

shinyServer(function(input, output) {
  
  data(df_ca_tract_demographics)
  df_ca_tract_demographics$value = df_ca_tract_demographics$percent_asian
  
  output$map = renderPlot({
    df_ca_tract_demographics$value = df_ca_tract_demographics[, input$value]
    ca_tract_choropleth(df_ca_tract_demographics, county_zoom=input$counties)
  })
})

library(shiny)

shinyServer(function(input, output) {
  
  data(df_ca_tract_demographics)
  df_ca_tract_demographics$value = df_ca_tract_demographics$percent_asian
  
  output$map = renderPlot({
    df_ca_tract_demographics$value = df_ca_tract_demographics[, input$value]
    num_colors = as.numeric(input$num_colors)
    ca_tract_choropleth(df_ca_tract_demographics, 
                        num_colors=num_colors,
                        county_zoom=input$counties)
  })
  
  output$boxplot = renderPlot({
    df_ca_tract_demographics$value = df_ca_tract_demographics[, input$value]
    boxplot(df_ca_tract_demographics$value)
  })
})

library(shiny)
library(visNetwork)
library(shinycssloaders)

fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background-color: #f0f8ff;
        color: #333;
        font-family: 'Arial', sans-serif;
      }
      .title-panel {
        background-color: #0073e6;
        color: white;
        padding: 15px;
        border-radius: 10px;
        text-align: center;
        margin-bottom: 20px;
      }
      .main-panel {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
      }
      h3 {
        color: #0073e6;
        text-align: center;
      }
      hr {
        border: 1px solid #0073e6;
        margin: 20px 0;
      }
      .summary-text {
        text-align: left;
        color: #333;
      }
      a {
        color: #0073e6;
        text-decoration: none;
      }
      a:hover {
        text-decoration: underline;
      }
    "))
  ),
  div(class = "title-panel",
      titlePanel("Visualización Interactiva de Relaciones con Sentimientos")
  ),
  div(class = "main-panel",
      withSpinner(visNetworkOutput("grafoPlot"), type = 7, color = "#0073e6"),
      hr(),
      h3("Resumen del Grafo"),
      div(class = "summary-text", uiOutput("summary"))
  )
)

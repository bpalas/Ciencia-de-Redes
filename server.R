library(shiny)
library(igraph)
library(visNetwork)

# Ruta al archivo CSV
csv_path <- "data/dataframe_2023.csv"

# Definir el servidor
function(input, output) {
  # Cargar y procesar el archivo CSV
  data <- reactive({
    df <- read.csv(csv_path, header = TRUE, sep = ",")
    df <- subset(df, select = c("Persona.1", "Persona.2", "Tipo"))
    colnames(df) <- c("from", "to", "sentiment")
    df
  })
  
  grafo <- reactive({
    df <- data()
    g <- graph_from_data_frame(df, directed = TRUE, vertices = NULL)
    grados <- degree(g)
    tam_nodos <- ((grados - min(grados)) / (max(grados) - min(grados)) * (20)) + 2
    colores <- c(negativo = "#e74c3c", neutral = "#95a5a6", positivo = "#2ecc71")
    
    nodes <- data.frame(id = V(g)$name, 
                        label = V(g)$name, 
                        value = tam_nodos, 
                        color = "#3498db",
                        title = V(g)$name)
    
    edges <- data.frame(from = as.character(df$from), 
                        to = as.character(df$to), 
                        color = colores[df$sentiment],
                        width = ifelse(df$sentiment == "neutral", 1, 3))
    
    list(nodes = nodes, edges = edges)
  })
  
  output$grafoPlot <- renderVisNetwork({
    g <- grafo()
    visNetwork(nodes = g$nodes, edges = g$edges) %>%
      visNodes(font = list(size = 0)) %>%
      visEdges(smooth = FALSE) %>%
      visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
      visInteraction(dragNodes = TRUE, dragView = TRUE, zoomView = TRUE)
  })
  
  output$summary <- renderUI({
    HTML("
    <div style='text-align: left;'>
      <h1>Trabajo final \"Medios sociales y ciencia de redes\" (2023)</h1>

      <h2>Cuadernos (Update 2024):</h2>
      <p>
        <a href='https://colab.research.google.com/drive/1LXTd_j87bndZaqem-HhGEznpK9BuuckM?usp=sharing' target='_blank'>
          <img src='https://colab.research.google.com/assets/colab-badge.svg' alt='Abrir en Colab'> - R (Webscrapping & Igraph)
        </a>
        <br>
        <a href='https://colab.research.google.com/drive/1Jq16NaAkYRxg6OWoiHWKpvqar1ECvdFM?usp=sharing' target='_blank'>
          <img src='https://colab.research.google.com/assets/colab-badge.svg' alt='Abrir en Colab'> - Python (Nlp & LLm)
        </a>
      </p>

      <h2>Text2Graph</h2>
      <h3>Input:</h3>
<img src='assets/red_3.jpeg' alt='Imagen de ejemplo' style='width: 100%; max-width: 500px; display: block; margin: auto;'>

       <h3>Output:</h3>
      <table border='1'>
        <tr>
          <th>Persona 1</th>
          <th>Persona 2</th>
          <th>Label</th>
          <th>Sentiment</th>
        </tr>
        <tr>
          <td>Javier Macaya</td>
          <td>Gabriel Boric</td>
          <td>Critized</td>
          <td>Negative</td>
        </tr>
      </table>

      <h2>Medidas de Centralidad:</h2>

      <h4>Centralidad:</h4>
      <p>Los 5 individuos con mayor centralidad son: Gabriel Boric, Giorgio Jackson, Sebastián Piñera, Camila Vallejo, Matías Meza-Lopenhandía. La centralidad es una medida general de la importancia de un nodo en la red. Los individuos mencionados tienen los mayores valores de centralidad.</p>
      
      <h4>PageRank:</h4>
      <p>Los 5 individuos con mayor PageRank son: Gabriel Boric, Sebastián Piñera, Giorgio Jackson, Matías Meza-Lopenhandía, Miguel Crispi. PageRank es un algoritmo que mide la importancia de un nodo en una red. En este caso, los individuos mencionados tienen la mayor importancia según este algoritmo.</p>
      
      <h4>Betweenness Centrality:</h4>
      <p>Los 5 individuos con mayor Betweenness Centrality son: Gabriel Boric, Giorgio Jackson, Camila Vallejo, Sebastián Piñera, Miguel Crispi. Esta métrica mide cuánto controla un nodo el flujo de información en la red. Cuanto mayor sea este valor, más centralidad de intermediación tiene el nodo en términos de control de información.</p>
      
      <h2>Conclusiones:</h2>
      <p><strong>Identificación de Líderes Estratégicos:</strong> Gabriel Boric, Giorgio Jackson y Sebastián Piñera son consistentemente identificados como líderes estratégicos según las métricas de centralidad, PageRank y Betweenness Centrality.</p>
      
      <p><strong>Importancia de Actores Específicos:</strong> Los nodos Gabriel Boric, Giorgio Jackson y Sebastián Piñera son críticos en la red política chilena según las tres métricas, sugiriendo que desempeñan roles significativos en términos de influencia, liderazgo y control de la información.</p>
      
      <p><strong>Dinámicas Internas y Cohesión:</strong> La presencia de actores comunes en las tres listas (por ejemplo, Gabriel Boric y Giorgio Jackson) indica la cohesión y el acuerdo en la élite política, mientras que diferencias (por ejemplo, Camila Vallejo en Betweenness Centrality) pueden señalar tensiones o roles específicos.</p>
  
      <p><strong>Perspectiva Temporal y Futura Influencia (Falta Análisis Temporal):</strong> El seguimiento de nodos que ganan centralidad y PageRank puede proporcionar información valiosa sobre la evolución y la futura influencia de actores políticos. Por ejemplo, observar la dinámica de Matías Meza-Lopenhandía y Miguel Crispi.</p>
    </div>
    ")
  })
}

shinyUI(dashboardPage(
  
  dashboardHeader(title="NSC Signature"),

  dashboardSidebar(
    sidebarUserPanel("Elsa Vera"),
    
    sidebarMenu(
      menuItem("Intro", tabName = "intro", icon = icon("gears")),
      menuItem("Who is who", tabName = "tSNE", icon = icon("barcode")),
      menuItem("Developmental time", tabName = "pseudotime", icon = icon("hourglass")), 
      menuItem("Heatmaps", tabName = "heatmaps", icon = icon("sitemap"))
      ),
   
    selectizeInput(inputId = "gene",
                   label = "Select gene",
                   multiple = TRUE,
                   selected=c("Id4","Gfap"),
                   options = list(maxOptions=30000),
                   choices = pbmc@var.genes),
    
    selectizeInput(inputId = "focus.clusters",
                   label = "Select cell type",
                   multiple = TRUE,
                   selected=c("RGL-1", "RGL-2", "NPC", "neuroblast"),
                   options = list(maxOptions=30000),
                   choices = sort(pbmc.markers$cluster))
    
    ),
  
  dashboardBody(
    
    tags$head(
      tags$style(HTML("
                      .shiny-output-error-myClass {
                      color: green; 
                      }
                      "))
      ),
    
    tabItems(
      tabItem(tabName = "intro",
        fluidRow(
          img(src="Shiny_app_cover.pdf", width="80%")
          )
                    
      ),
      tabItem(tabName = "tSNE",
        h1("Which clusters are stem cells?"),
        fluidRow(
          
          valueBox(width=4, dim(pbmc@data)[2], "Cells", icon = icon("comment")),
          valueBox(width=4, round(mean(pbmc@meta.data$nGene)), "Genes/cell", icon = icon("comment")),
          valueBox(width=4, round(mean(pbmc@meta.data$nUMI)), "RNA transcript/cell", icon = icon("comment"))
        ),
        
        
        fluidRow(column(4, plotOutput("ClusterPlot")),
                column(4, plotOutput("dotPlot")),
                column(4, plotOutput("tSNEPlot")))

      ),
      
      tabItem(tabName = "pseudotime",
              h1("When are stem cell marker genes expressed?"),
              
        fluidRow(column(5, plotOutput("pseudoPlot")), 
                column(7, plotOutput("pseudoGenePlot")))
      ),
      
      tabItem(tabName = "heatmaps",
              h1("Cell type-specific signatures. What genes are expressed by each cell type?"),
              fluidRow(column(6, plotOutput("HeatMapPlot")))
      )
    )
  )
))



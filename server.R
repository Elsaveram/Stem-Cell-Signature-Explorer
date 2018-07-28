
#Shiny Server

shinyServer(function(input, output, session) {
  
  # A reactive function to catch the errors due to unselected input in some of the render plots below
  catch_errors <- reactive({
    validate(
      need(input$gene != "", "Please select a gene"),
      errorClass = "myClass"
    )
    
  })
  
  # Interactive tSNE plot output showing the clustering analysis on the cells
  output$tSNEPlot <- renderPlot({
  TSNEPlot(object = pbmc, do.label=TRUE, no.axes=TRUE, pt.size = 0.2, label.size=4)
  })
  
  output$ClusterPlot <- renderPlot({
    catch_errors()
  
    FeaturePlot(object = pbmc, features.plot = input$gene, cols.use = c("grey", "blue"), reduction.use = "tsne", no.axes = TRUE)
  })
  
  # Dot plot output showing the mean expression levels of each gene in each cluster
  output$dotPlot <- renderPlot({
    catch_errors()
    
    DotPlot(pbmc,genes.plot = input$gene, x.lab.rot = T, dot.scale = 8, plot.legend=T, col.min = 0)
  })
  
  # Static plot output showing the developmental trajectory of expression changes from primitive stem cell to differentiated neuroblast
  output$pseudoPlot <- renderPlot({
    plot_cell_trajectory(HSMM, color_by = "Clusters") + theme(legend.position = "right") 
    
  })
  
  # Interatcive plot output that shows the expression of specific genes in developmental pseudotime
  output$pseudoGenePlot <- renderPlot({
    catch_errors()
    
    #Function for PseudoPlot
    generate.pseudo.plot <- function( genes ) {
      
      to_be_tested <- row.names(subset(fData(HSMM), gene_short_name %in% genes ))
      cds_subset <- HSMM[to_be_tested,]
      diff_test_res <- differentialGeneTest(cds_subset, fullModelFormulaStr = "~sm.ns(Pseudotime)")
      diff_test_res[,c("gene_short_name", "pval", "qval")]
      
      plot_genes_in_pseudotime(cds_subset, color_by = "Clusters") + 
        theme(legend.position = "top")
    }
    
    generate.pseudo.plot(input$gene)
    
  })
  
  # Interative heatmap that shows the expression levels of the top 15 (highly expresses) genes of each cluster cluster
  output$HeatMapPlot <- renderPlot({
    validate(
      need(input$focus.clusters != "", "Please select a cell type"),
      errorClass = "myClass"
    )
    
    top_genes <- pbmc.markers %>% 
            group_by(cluster) %>% 
            filter(cluster %in% input$focus.clusters) %>% 
            mutate(order = match(cluster, input$focus.clusters)) %>% 
            top_n(15,  avg_logFC) %>% 
            arrange(order)
    
    focus.cells <- WhichCells( pbmc, ident = input$focus.clusters, max.cells.per.ident = 100)
    
    DoHeatmap(object = pbmc, cells.use = focus.cells, genes.use = top_genes$gene, slim.col.label = TRUE, group.order = input$focus.clusters, col.low="#330099",col.mid = "#000000", col.high = "#CC0000")
    
  }, height=800)
  
  
})







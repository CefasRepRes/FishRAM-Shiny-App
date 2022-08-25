simulation_tab <- tabItem(
  tabName = "simulation",
  plotOutput("results_stock", height = "200px"),
  plotOutput("results_impact", height = "200px"),
  plotOutput("results_activity_c", height = "200px"),
  plotOutput("results_activity_r", height = "200px"),
  downloadButton("downloadResults", "Download Results")

)

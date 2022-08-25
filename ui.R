library(shiny)
library(shinydashboard)


source("ui_introduction.R")
source("ui_parameters.R")
source("ui_simulation.R")
ui <- dashboardPage(
    dashboardHeader(title = "FishRAM "),
    dashboardSidebar(
        sidebarMenu(
            id = "tabs",
            menuItem("1. Introduction", tabName = "introduction", icon = icon("book", lib="glyphicon")),
            menuItem("2. Set Parameters", tabName = "parameters", icon = icon("th-large", lib="glyphicon")),
            sliderInput("t_max", label = "Simulation Time", min = 0, max = 50, value = 40, step = 1),
            fluidRow(
                column(6, actionButton("run", label = "Run Model")),
                column(6, actionButton("saveModel", "Save run"))),
            menuItem("3. Simulation Results", tabName = "simulation", icon = icon("play-circle", lib="glyphicon")),
            actionButton("reset", "Reset runs")
        )
    ),
    dashboardBody(
        tabItems(
            introduction_tab,
            parameters_tab,
            simulation_tab
        )
    )
)



initial_values_box <-     box(
  title = "Inital Values",
  status = "info",
  solidHeader = TRUE,
  tags$div(title = "The juvenile stock size in numbers at the start of the simulation.",
    numericInput("initialSJ", "Initial Juvenile Stock (numbers)", value = 2216589, step = 10000),
  ),
  tags$div(title = "The adult stock size in numbers at the start of the simulation.", numericInput("initialSA", "Initial Adult Stock (numbers)", value = 9587569, step = 10000)),
  tags$div(title = "The number of commercial trips occuring in the first year of the simulation.", numericInput("initialTC", "Initial Commerical Trips (numbers)", value = 2833, step = 100)),
  tags$div(title = "The number of recreational trips occuring in the first year of the simulation.", numericInput("initialTR", "Initial Recreational Trips (numbers)", value = 833000, step = 1000))
  , width = 3)

stock_parameters_box <- box(
  title = "Stock Parameters",
  status = "info",
  solidHeader = TRUE,
  tags$div(title = "The constant natural mortality experienced by the adult stock. A natural mortality of 2 means that the average adult fish can expect to live 1/2 year. Natural mortality is applied exponentially, so that doubling the natural mortality halves the time that the average fish can expect to live before being killed due to natural mortality.", sliderInput("muA", " \\(\\mu_A\\) - Adult mortality", value = 0.16, min = 0, max = 0.5, step = 0.01)),
  tags$div(title = "The constant natural mortality experienced by the juvenile stock. A natural mortality of 2 means that the average juvenile fish can expect to live 1/2 year. Natural mortality is applied exponentially, so that doubling the natural mortality halves the time that the average fish can expect to live before being killed due to natural mortality.", sliderInput("muJ", " \\(\\mu_J\\) - Juvenile mortality", value = 0.16, min = 0, max = 0.5, step = 0.01)),
  tags$div(title = "The constant recruitment (in numbers) of new sea bass into the juvenile stock each year.", numericInput("R", " \\(R\\) - Recruitment across simulation", value = 8e6, min = 0, max = 1e10, step = 1e5)),
  width = 3)

commercial_fleet_box <- box(
  title = "Commercial fleet parameters",
  status = "info",
  solidHeader = TRUE,
  tags$div(title = "The proportional change by which commercial activity increases (after profitable years) or decreases (after unprofitable years). For example, if g is 0.5, then the number of commercial trips will increase or decrease by 50% in response to profitability.", sliderInput("g", " \\(g\\) - magnitude of trip change", value = 0.1, min = 0, max = 1, step = 0.01)),
  tags$div(title = "The proportion of sea bass that is removed by one unit of commercial fishing effort. This measures the extent to which sea bass is susceptible to commercial fishing activity.", sliderInput("qC", " \\(q_C\\) - catchability (x10^-6)", value = 12.4, min = 0, max = 100, step = 0.1)),
  tags$div(title = "The number of days at sea for a given commercial trip.", sliderInput("chiC", "\\(\\chi_C\\) - days per commercial trip", value = 0.6625, min = 0, max = 1, step = 0.01)),
  tags$div(title = "The maximum number of commercial trips that can occur in a given year.", numericInput("theta", " \\(\\theta\\) - maximum commercial trips per year", value = 14165, min = 0, max = 1e5, step = 5)),
  tags$div(title = "The proportion of commercially caught fish that are discarded.", sliderInput("eta", "\\(\\eta\\) - commercial discard rate", value = 0.05, min = 0, max = 1, step = 0.05)),
  tags$div(title = "The proportion of discarded fish that survive.", sliderInput("Gamma", "\\(\\Gamma\\) - discard survival rate", value = 0, min = 0, max = 1, step = 0.05)),
  tags$div(title = "The average weight of fish landed by the commercial fleet in kilograms.", numericInput("WC", " \\(W_C\\) - average weight of fish (kg)", value = 1.5, min = 0, max =10, step = 0.1)),
  width =3)


recreational_fleet_box <- box(
  title = "Recreational fleet parameters",
  status = "info",
  solidHeader = T,
  tags$div(title = "The proportional change by which recreational activity increases (after years with high CPUE) or decreases (after years with low CPUE). For example, if p is 0.5, then the number of recreational trips will increase or decrease by 50% in response to CPUE.", sliderInput("p", " \\(p\\) - magnitude of trip change", value = 0.05, min = 0, max = 1, step = 0.01)),
  tags$div(title = "The proportion of sea bass that is removed by one unit of recreational fishing effort. This measures the extent to which sea bass is susceptible to recreational fishing activity.", sliderInput("qR", "\\(q_R\\) - catchability (x10^-7)", value = 1.1, min = 0, max = 50, step = 0.1)),
  tags$div(title = "The maximum amount of catch per unit effort, beyond which an increase in CPUE has no effect on recreational fishing activity.", sliderInput("b", "\\(b\\) - CPUE threshold", value = 1, min = 0, max = 2, step = 0.1)),
  tags$div(title = "The number of days at sea for a given recreational trip.", sliderInput("chiR", "\\(\\chi_R\\) - effort per recreational trip", value = 1.1, min = 0, max = 10, step = 0.1)),
  tags$div(title = "The maximum number of recreational trips that can occur in a given year.", numericInput("gamma", " \\(\\gamma\\) - maximum recreational trips per year", value = 2500000, min = 0, max = 1e7, step = 1e4)),
  tags$div(title = "The proportion of recreationally caught fish that are subsequently released.", sliderInput("delta", "\\(\\delta\\) - release prop", value = 0.75, min = 0, max = 1, step = 0.05)),
  tags$div(title = "The proportion of released fish that survive.", sliderInput("varphi", "\\(\\varphi\\) - release survival", value = 0.95, min = 0, max = 1, step = 0.05)),
  tags$div(title = "The average weight of fish landed by the recreational fleet in kilograms.", numericInput("WR", " \\(W_R\\) - average weight of fish (kg)", value = 1.9, min = 0, max = 10, step = 0.1)),
  width = 3
)

economic_params <- box(
  title = "Economic parameters",
  status = "info",
  solidHeader = T,
  tags$div(title = "The price of one kilogram of fish.", numericInput("nu", " \\(\\nu\\) - fish price per kilo", value = 1e2, min = 0, max = 1e3, step = 5)),
  tags$div(title = "The variable cost of a commercial trip for every day at sea.", numericInput("baromega", " \\(\\bar{\\omega}\\) - variable cost per commercial day at sea.", value = 340, min = 0, max = 1e3, step = 10)),
  tags$div(title = "The proportion of all fixed costs of a commercial fleet which can be attributable to sea bass.", sliderInput("Lambda", " \\(\\Lambda\\) - proportion commercial fixed cost attributable to sea bass.", value = 0.4, min = 0, max = 1, step = 0.05)),
  tags$div(title = "The fixed costs per commercial fleet per year.", numericInput("phi", " \\(\\phi\\) - fixed cost per commercial fleet per year", value = 1.8e7, min = 0, max = 1e9, step = 1e7)),
  tags$div(title = "The average per trip expenditure of recreational anglers.", numericInput("lambda", " \\(\\lambda\\) - average per trip expenditure of recreational anglers.", value = 80, min = 0, max = 1e3, step = 10)),
  h4("GVA Multipliers"),
  tags$div(title = "Gross Value Addeed (GVA) for the commercial fleet is estimated from commercial revenue using a multiplier representing the proportion of revenue which contributes to GVA.", sliderInput("sigma", " \\(\\sigma\\) - commercial GVA multiplier", value = 0.5, min = 0, max = 1, step = 0.05)),
  tags$div(title = "Gross Value Addeed (GVA) for the recreational fleet is estimated from the trip expenditure by using a multiplier representing the estimated proportion of trip expenditure which contributes to GVA.", sliderInput("zeta", " \\(\\zeta\\) - recreational GVA multiplier", value = 0.29, min = 0, max = 1, step = 0.05)),
  width = 3
)




parameters_tab <- tabItem(
  withMathJax(),
  tabName = "parameters",
  fluidRow(
    commercial_fleet_box,
    recreational_fleet_box,
    economic_params,
    initial_values_box,
    stock_parameters_box,
    downloadButton("downloadParams", "Download Parameters")

  )
)

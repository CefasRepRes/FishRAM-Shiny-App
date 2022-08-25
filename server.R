library(shiny)
library(FishRAM)
library(ggplot2)
library(dplyr)
library(reshape2)

shinyServer(function(input, output, session) {
    modelSaved <<- FALSE


    observeEvent(input$saveModel,{
        savedSim <<- sim
        modelSaved <<- TRUE
    })


    observeEvent(input$reset, {
        modelSaved <<- FALSE
    })



    observeEvent(input$run,{
        newParams <- update_params(input)

        sim <<- project(newParams, R = input$R, t_start = 1, t_end = input$t_max)

        if(!modelSaved){
            output$results_stock <- renderPlot({plotStock(sim)})
            output$results_impact <- renderPlot({plotEconomicImpact(sim)})
            output$results_activity_c <- renderPlot({plotActivity(sim, fleet = "C")})
            output$results_activity_r <- renderPlot({plotActivity(sim, fleet = "R")})
        }else{
            years_new <- sim@t_start:sim@t_end
            years_saved <- savedSim@t_start:savedSim@t_end

            df_new <- cbind(years_new, sim@states[, c("SJ", "SA")])
            colnames(df_new) <- c("Year", "Juvenile_new", "Adult_new")
            df_new[, "Juvenile_new"] <- df_new[, "Juvenile_new"]/1000
            df_new[, "Adult_new"] <- df_new[, "Adult_new"]/1000
            df_new <- data.frame(df_new)

            df_saved <- cbind(years_saved, savedSim@states[, c("SJ", "SA")])
            colnames(df_saved) <- c("Year", "Juvenile_saved", "Adult_saved")
            df_saved[, "Juvenile_saved"] <- df_saved[, "Juvenile_saved"] / 1000
            df_saved[, "Adult_saved"] <- df_saved[, "Adult_saved"] / 1000
            df_saved <- data.frame(df_saved)
            df_stock <- full_join(df_new, df_saved)
            df_stock <- reshape2::melt(df_stock, id.vars = "Year")
            colnames(df_stock) <- c("Year", "Stock", "Population (000s)")

            output$results_stock <- renderPlot({ggplot(df_stock, aes(x = Year, y = `Population (000s)`, group = Stock, colour = Stock)) + geom_line()})

            df_new <- cbind(years_new, sim@states[, c("VR", "VC")])
            df_new <- data.frame(df_new)
            colnames(df_new) <- c("Year", "Recreational GVA", "Commercial GVA")

            df_saved <- cbind(years_saved, savedSim@states[, c("SJ", "SA")])
            df_saved <- data.frame(df_saved)
            colnames(df_saved) <-c("Year", "Recreational GVA", "Commercial GVA")
            df_imp <- full_join(df_new, df_saved, by = "Year", suffix = c("_new", "_saved"))
            df_imp <- reshape2::melt(df_imp, id.vars = "Year")
            colnames(df_imp) <- c("Year", "Fleet", "GVA")


            output$results_impact <- renderPlot({ggplot(df_imp, aes(x = Year, y = `GVA`, group = Fleet, colour = Fleet)) + geom_line()})

            df_new <- cbind(years_new, sim@states[, "TC"])
            df_new[, 2] <- df_new[, 2] / 1000
            df_new <- data.frame(df_new)
            colnames(df_new) <- c("Year", "Commercial Trips (000s)")

            df_saved <- cbind(years_new, savedSim@states[, "TC"])
            df_saved[, 2] <- df_saved[, 2] / 1000
            df_saved <- data.frame(df_saved)
            colnames(df_saved) <- c("Year", "Commercial Trips (000s)")

            df_act_c <- full_join(df_new, df_saved, by = "Year", suffix = c("_new", "_saved"))
            df_act_c <- reshape2::melt(df_act_c, id.vars = "Year")
            colnames(df_act_c) <- c("Year", "Fleet", "Commercial Trips (000s)")


            output$results_activity_c <- renderPlot({ggplot(df_act_c, aes(x = Year, y = `Commercial Trips (000s)`, group = Fleet, colour = Fleet)) + geom_line()})

            df_new <- cbind(years_new, sim@states[, "TR"])
            colnames(df_new) <- c("Year", "Recreational Trips (000s)")
            df_new[, 2] <- df_new[, 2] / 1000
            df_new <- data.frame(df_new)

            df_saved <- cbind(years_new, savedSim@states[, "TR"])
            colnames(df_saved) <- c("Year", "Recreational Trips (000s)")
            df_saved[, 2] <- df_saved[, 2] / 1000
            df_saved <- data.frame(df_saved)

            df_act_r <- full_join(df_new, df_saved, by = "Year", suffix = c("_new", "_saved"))
            df_act_r <- reshape2::melt(df_act_r, id.vars = "Year")
            colnames(df_act_r) <- c("Year", "Fleet", "Recreational Trips (000s)")

            output$results_activity_r <- renderPlot({ggplot(df_act_r, aes(x = Year, y = `Recreational Trips (000s)`, group = Fleet, colour = Fleet)) + geom_line()})
        }

    }
    )

    params_download <- reactive({
        param_vals <- c(input$g, input$p, input$b, input$qC, input$qR, input$muA, input$muJ, input$chiR, input$chiC, input$theta, input$gamma, input$delta, input$varphi, input$eta, input$Gamma, input$WR, input$WC, input$nu, input$baromega, input$Lambda, input$phi, input$sigma, input$lambda, input$zeta, input$initialSJ, input$initialSA, input$initialTC, input$initialTR)
        names <- c("g", "p", "b", "qC", "qR", "muA", "muJ", "chiR", "chiC", "theta", "gamma", "delta", "varphi", "eta", "Gamma", "WR", "WC", "nu", "baromega", "Lambda", "phi", "sigma", "lambda", "zeta", "initialSJ", "initialSA", "initialTC", "initialTR")
        data.frame("Parameter" = names, "Value" = param_vals)
    })
    # Downloadable csv of parameters ----
    output$downloadParams <- downloadHandler(
        filename = "params.csv",
        content = function(file) {
            write.csv(params_download(), file, row.names = FALSE)
        }
    )

    results_download <- reactive({
        df <- sim@states[, c("SJ", "SA", "TC", "TR", "tau", "VR", "VC")]
        df <- cbind(sim@t_start:sim@t_end, df)
        colnames(df) <- c("Year", "Juvenile Stock Size", "Adult Stock Size",
                          "Number of Commercial Trips","Number of Recreational Trips",
                          "Commercial profit", "GVA (Recreational)", "GVA (Commercial)")
        df
    })

    output$downloadResults <- downloadHandler(
        filename = "results.csv",
        content = function(file) {
            write.csv(results_download(), file, row.names = FALSE)
        }
    )

    #Uploaded files
    observe({
        if (is.character(input$file_params$datapath)){
            params_raw <- read.csv(input$file_params$datapath)
            params_raw <- split(params_raw[, 2], params_raw[, 1])

            #Initial Values
            updateNumericInput(session, "initialSJ", value = params_raw$initialSJ)
            updateNumericInput(session, "initialSA", value = params_raw$initialSA)
            updateNumericInput(session, "initialTC", value = params_raw$initialTC)
            updateNumericInput(session, "initialTR", value = params_raw$initialTR)

            #Stock Parameters
            updateSliderInput(session, "muA", value = params_raw$muA)
            updateSliderInput(session, "muJ", value = params_raw$muJ)

            #Commercial fleet parameters
            updateNumericInput(session, "theta", value = params_raw$theta)
            updateNumericInput(session, "WC", value = params_raw$WC)
            updateSliderInput(session, "g", value = params_raw$g)
            updateSliderInput(session, "qC", value = params_raw$qC)
            updateSliderInput(session, "chiC", value = params_raw$chiC)
            updateSliderInput(session, "eta", value = params_raw$eta)
            updateSliderInput(session, "Gamma", value = params_raw$Gamma)


            #Recreational fleet parameters
            updateNumericInput(session, "gamma", value = params_raw$gamma)
            updateNumericInput(session, "WR", value = params_raw$WR)
            updateSliderInput(session, "p", value = params_raw$p)
            updateSliderInput(session, "qR", value = params_raw$qR)
            updateSliderInput(session, "b", value = params_raw$b)
            updateSliderInput(session, "chiR", value = params_raw$chiR)
            updateSliderInput(session, "delta", value = params_raw$delta)
            updateSliderInput(session, "varphi", value = params_raw$varphi)

            #Economic parameters
            updateNumericInput(session, "nu", value = params_raw$nu)
            updateNumericInput(session, "baromega", value = params_raw$baromega)
            updateNumericInput(session, "phi", value = params_raw$phi)
            updateNumericInput(session, "lambda", value = params_raw$lambda)
            updateSliderInput(session, "Lambda", value = params_raw$Lambda)
            updateSliderInput(session, "sigma", value = params_raw$sigma)
            updateSliderInput(session, "zeta", value = params_raw$zeta)


        }

    })

})


update_params <- function(input){
    data("seabass")
    newParams <- params
    newParams@g       <- input$g
    newParams@p       <- input$p
    newParams@b       <- input$b
    newParams@qC      <- input$qC
    newParams@qR      <- input$qR
    newParams@muA     <- input$muA
    newParams@muJ     <- input$muJ
    newParams@chiR    <- input$chiR
    newParams@chiC    <- input$chiC
    newParams@theta   <- input$theta
    newParams@gamma   <- input$gamma
    newParams@delta   <- input$delta
    newParams@varphi  <- input$varphi
    newParams@eta     <- input$eta
    newParams@Gamma   <- input$Gamma
    newParams@WR      <- input$WR /1000 #Model requires weight in tonnes
    newParams@WC      <- input$WC /1000 #Model requires weight in tonnes
    newParams@nu      <- input$nu * 1000 # Model is in price per tonnes
    newParams@baromega<- input$baromega
    newParams@Lambda  <- input$Lambda
    newParams@phi     <- input$phi
    newParams@sigma   <- input$sigma
    newParams@lambda  <- input$lambda
    newParams@zeta    <- input$zeta
    newParams@initialSJ <- input$initialSJ
    newParams@initialSA <- input$initialSA
    newParams@initialTC <- input$initialTC
    newParams@initialTR <- input$initialTR
    return(newParams)
}

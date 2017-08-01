
# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Simple Experiment simulator"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
         numericInput("nsubs",
                     "Number of subjects in each Condition:",
                     10),
         numericInput("C1mean",
                      "Mean of Condition 1:",
                      200),
         numericInput("C1sd",
                      "Standard Deviation of Condition 1:",
                      20),
         numericInput("C2mean",
                      "Mean of Condition 1:",
                      225),
         numericInput("C2sd",
                      "Standard Deviation of Condition 1:",
                      20),
         actionButton("action", "Resample"),
         checkboxInput("checkbox", label = "MonteCarlo", value = TRUE),
         numericInput("simruns",
                      "# of Monte Carlo simulations:",
                      20)
      ),

      # Show a plot of the generated distribution
      mainPanel(
        h3("t-test results"),
        verbatimTextOutput("tresults"),
        h3("ANOVA table"),
        verbatimTextOutput("summary"),
        h3("Bar plot"),
        plotOutput("meanPlot"),
        h3("Histrogram of p-values for simulated Experiments"),
        plotOutput("phist"),
        verbatimTextOutput("power")
       # plotOutput("distPlot")
        # tableOutput("view")
      )
   )
)

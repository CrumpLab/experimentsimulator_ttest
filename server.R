# Define server logic required to draw a histogram
server <- function(input, output) {

library(shiny)
library(ggplot2)
library(plyr)
library(Crump)

  makeData <- reactive({
    input$action
    dist1<-rnorm(input$nsubs,input$C1mean,input$C1sd)
    dist2<-rnorm(input$nsubs,input$C2mean,input$C2sd)
    plot_data<-data.frame(dv=c(dist1,dist2),
                          subs=rep(seq(1,input$nsubs,1),2),
                          condition=rep(c("1",2),each=input$nsubs))
  })

  runsim <-reactive({
    if (input$checkbox==TRUE){
      psave<-c()
      for(i in 1:input$simruns){
        #local({
          dist1B<-rnorm(input$nsubs,input$C1mean,input$C1sd)
          dist2B<-rnorm(input$nsubs,input$C2mean,input$C2sd)
          tresults<-t.test(dist1B,dist2B,var.equal=TRUE)
         # plot_dataB<-data.frame(dv=c(dist1B,dist2B),
          #                       subs=rep(seq(1,input$nsubs,1),2),
           #                      condition=rep(c("1","2"),each=input$nsubs))
          #tresults<-t.test(dv~condition,plot_dataB,var.equal=TRUE)
        #})
        psave<-c(psave,tresults$p.value)
      }
      return(psave)
    }
  })

  output$meanPlot <- renderPlot({

    plot_means <- aggregate(dv~condition, makeData(), mean)
    st_errors <- aggregate(dv~condition, makeData(), stde)

    plot_means <- ddply(makeData(), .(condition), summarise,
                      mean_dv = mean(dv),
                      lower = mean(dv)-stde(dv),
                      upper = mean(dv)+stde(dv))

    ggplot(plot_means,aes(y = mean_dv, x = condition))+
      geom_bar(stat = "identity" )+
      geom_errorbar(width = .5 , aes(ymin = lower, ymax = upper))+
      theme_classic(base_size = 15)

  })

   output$distPlot <- renderPlot({
      ggplot(makeData(),aes(dv))+
        geom_histogram()+facet_wrap(~condition)
   })

   output$phist <- renderPlot({
     if(input$checkbox==TRUE){
       phist_df <- data.frame(sim = seq(1,length(runsim()),1), p_values=runsim())
      ggplot(phist_df,(aes(p_values)))+
        geom_histogram(aes(colour="white"))+
        theme_classic(base_size=15)+
        theme(legend.position="none")
     #hist(runsim())
     }
   })

   output$power <- renderPrint({
     print("The proportion of simulations with p < .05 is:")
     print(length(runsim()[runsim()<.05])/length(runsim()))
   })

   output$view <- renderTable({
     head(makeData())
   })

   output$tresults <- renderPrint({
     t.test(dv~condition,makeData(),var.equal=TRUE)
   })

   output$summary <- renderPrint({
     summary(aov(dv~condition,makeData()))
   })
}

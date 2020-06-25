####### Import libraries #######
#library (name)
library(tidyverse)
library(gghalves)


####### Import datasets #######
#dataframe <- read.csv ("filename.csv")
Gamble <- read.csv("Gamble Data.csv")


####### Summary SE function load #######
#provides the standard deviation, standard error of the mean, and a (default 95%) confidence interval
#used to create error bars and mean lines on plots
#copy this directly into your code, change nothing
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=TRUE, conf.interval=.95) {
  library(doBy)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # Collapse the data
  formula <- as.formula(paste(measurevar, paste(groupvars, collapse=" + "), sep=" ~ "))
  datac <- summaryBy(formula, data=data, FUN=c(length2,mean,sd), na.rm=na.rm)
  
  # Rename columns
  names(datac)[ names(datac) == paste(measurevar, ".mean",    sep="") ] <- measurevar
  names(datac)[ names(datac) == paste(measurevar, ".sd",      sep="") ] <- "sd"
  names(datac)[ names(datac) == paste(measurevar, ".length2", sep="") ] <- "N"
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
} 


####### Set default order of variable values ####### 
#this fixes the default order of the levels of a variable (the order it appears in a plot legend)
#dataframe$variable <- factor (dataframe$variable, levels = c("Factor 1", "Factor 2"))
Gamble$Feedback <- factor (Gamble$Feedback, levels = c("Full", "Partial", "Minimal")) 


####### Line plot for gambles over block between frame #######

#these two lines add jitter to the position of the points
#jitter function only works for numeric variables
#I am jittering both the X (Block) and Y (Gamble) variable in my plot
#set jitter amount based on scale of variables
#my X variable has a range of 3 and my Y variable has a range of 1
#dataframe$newjittervariable <- (dataframe$originalvariable, amount = x)
Gamble$BlockJitter <- jitter(Gamble$Block, amount = .05) 
Gamble$GambleJitter <- jitter(Gamble$Gamble, amount = .05) 


#### Plot v1 ####
#if you are unfamiliar with basic ggplot functionality, I would recommend working through my tutorial from last year (see READ ME)
#the order you place function calls is the layout order they will be displayed
plot.gamble.v1 <- ggplot(Gamble, aes(x=Block, y=Gamble, color=Frame, fill=Frame)) +
  
  #we need to specify that we want to use the jitter variables we created for geom_point 
  #geom_point (dataframe, mapping=aes(x=, y=))
  geom_point(mapping=aes(x=BlockJitter, y=GambleJitter), size=.1, position = position_nudge(x=.28)) + 
  #position_nudge moves the points to the right (+) or left (-)
  
  #geom_half_boxplot creates a distribution plot for a given condition
  #we can use tidy filter to generate multiple distribution plots for each X-axis condition
  #geom_half_boxplot (dataframe %>% filter (condition 1, condition 2), mapping=aes(x=, y=))
  geom_half_boxplot(Gamble%>%filter(Block==1),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, center = TRUE, position = position_dodge(width=.4)) + 
  geom_half_boxplot(Gamble%>%filter(Block==2),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, center = TRUE, position = position_dodge(width=.4)) + 
  geom_half_boxplot(Gamble%>%filter(Block==3),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, center = TRUE, position = position_dodge(width=.4)) +
  geom_half_boxplot(Gamble%>%filter(Block==4),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, center = TRUE, position = position_dodge(width=.4)) +
  #alpha changes the opacity of the fill color (closer to 0 closer to opaque)
  #outlier.shape - NA to remove outlier indicators, to change shape use codes (see README)
  #width is size of box, size is thickness of line, color is color of border line
  #errorbar.draw - TRUE or FALSE
  #position_dodge makes it so that the boxplots for the between-subject condition Feedback are not all on top of each other
  #remove position_dodge and see what happens!
  
  #the rest of this code changes the appearance of the plot and will not be changed in further plot iterations
  
  #there are several different themes to choose from, I prefer theme_minimal()
  #see resource in READ ME file - describes properties of different themes and how to create and re-use your own custom theme
  theme_minimal() +
  
  #to change the axis properties of the plot, you can use several scale_ functions
  #be sure to choose the correct data type for your axis (discrete, continuous)
  #scale_x_discrete (name =, breaks = , limits =)
  #breaks=seq(minimum, maximum, interval) sets axis values
  #limits=x(minimum, maximum) sets axis cutoffs
  scale_x_continuous(name= "Trial Block", breaks=seq(0,4,1)) + 
  scale_y_continuous(name="Proportion of Gambles", breaks=seq(0,1,0.2), limits=c(-.05,1.05)) + 
  #note that I set the limits here that so that any jittered data outside 0-1 will be included in the plot
  
  #to change the legend title, you can use labs()
  labs(color= "Frame", fill="Frame") + 
  #note that I have to declare two of the same legend title because I am grouping by both color and fill
  #see what happens when you only declare one legend title
  
  #theme() accepts many arguments that change visual appearance of the plot
  theme (text=element_text(size=10), #change font size of entire plot (different sizes for different heading levels)
         legend.position = "right", #can also use left, top, bottom, or c(x, y) to move legend to specific coordinates
         axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),#adds buffer space between axis title and plot
         axis.title.x = element_text(margin = margin(t = 15, r = 0, b = 0, l = 0)),
         panel.background = element_rect(fill = NA, color = "black")) + #adds black box around row and column panels
  
  #coord_fixed sets ratio of spacing for x-y coordinates
  #coord_fixed (ratio =, expand =)
  #ratio = x coord / y coord (smaller number, longer x axis)
  #expand = TRUE adds margin around plot, FALSE for no margin
  coord_fixed(ratio = 2, expand = TRUE) 

#saves plot to file of fixed size
#ggsave won't accept long file names, so keep it simple to avoid problems
ggsave("Gamble Plot v1.png", width = 8, height = 5) 


#### Plot v2 ####
#remember to place function calls in the layout order you want to be displayed
plot.gamble.v2 <- ggplot(Gamble, aes(x=Block, y=Gamble, color=Frame, fill=Frame)) +
  
  #instead of using jittered points like in last plot, we will align points with boxplot distribution
  #we will use new function geom_half_dotplot
  #geom_half_dotplot (dataframe, mapping=aes(x=, y=))
  geom_half_dotplot(Gamble%>%filter(Block==1), mapping=aes(x=Block, y=GambleJitter), binwidth=.01,
                    method="dotdensity", stackratio=.8, dotsize=1, width=.7) +
  geom_half_dotplot(Gamble%>%filter(Block==2), mapping=aes(x=Block, y=GambleJitter), binwidth=.01,
                    method="dotdensity", stackratio=.8, dotsize=1, width=.7) +
  geom_half_dotplot(Gamble%>%filter(Block==3), mapping=aes(x=Block, y=GambleJitter), binwidth=.01,
                    method="dotdensity", stackratio=.8, dotsize=1, width=.7) +
  geom_half_dotplot(Gamble%>%filter(Block==4), mapping=aes(x=Block, y=GambleJitter), binwidth=.01,
                    method="dotdensity", stackratio=.8, dotsize=1, width=.7) +
  #binwidth sets y-axis binning size
  #method can be dotdensity or histodot, try both and see which you prefer
  #stackratio is how closely you want the dots together
  #width is spacing based on grouping variable Frame
  
  #we will generate boxplots like in the last plot, but without centered lines
  geom_half_boxplot(Gamble%>%filter(Block==1),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, position = position_dodge(width=.7)) + 
  geom_half_boxplot(Gamble%>%filter(Block==2),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, position = position_dodge(width=.7)) + 
  geom_half_boxplot(Gamble%>%filter(Block==3),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, position = position_dodge(width=.7)) +
  geom_half_boxplot(Gamble%>%filter(Block==4),mapping=aes(x=Block, y=Gamble), alpha= 1, outlier.shape = NA,
                    width=.5, size=.2, color="black", errorbar.draw = FALSE, position = position_dodge(width=.7)) +
  
  #we can flip the coordinates of our plot for a different look
  #if you do flip coordinates, be sure to adjust aspect.ratio under theme
  #I also change order of blocks when flipping coordinates by using scale_x_reverse 
  #not that only one coord_ function can be called per plot (cannot call coord_flip and coord_fixed)
  coord_flip() +
  
  #the rest of this code (which sets appearance of plot) has not been changed
  theme_minimal() +
  scale_x_reverse(name= "Trial Block", breaks=seq(0,4,1)) + #instead of scale_x_continuous() + 
  scale_y_continuous(name="Proportion of Gambles", breaks=seq(0,1,0.2), limits=c(-.05,1.05)) + 
  labs(color= "Frame", fill="Frame") + #adding \n between the words adds a new line 
  theme (text=element_text(size=10), 
         legend.position = "right", 
         axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),
         axis.title.x = element_text(margin = margin(t = 15, r = 0, b = 0, l = 0)),
         panel.background = element_rect(fill = NA, color = "black"),
         aspect.ratio = 1.5) #this works the same as coord_fixed but with the opposite ratio

ggsave("Gamble Plot v2.png", width = 8, height = 5)

  
  
#### Plot v3 ####
#since we are going to use errorbars in this plot we need to call function summarySE with relevant inputs
#be sure you put the exact variables you are using in the plot, too many or too few and it won't generate correctly
#name of data fram <- summarySE (dataframe, measurevar =, groupvars = c(Var1, Var2))
summarystats <- summarySE(Gamble, measurevar= "Gamble", groupvars =c("Block", "Frame", "Feedback"))

#this plot uses half violin distribution plots instead of boxplots 
#this plot also introduces a new grouping variable (Feedback Condition)
#remember to place function calls in the layout order you want to be displayed
plot.gamble.v3 <- ggplot(summarystats, aes(x=Block, y=Gamble, color=Feedback, fill=Feedback)) +
  
  #facet_grid(variable ~ variable) adds row and column panels to a plot
  #to only have row panel (variable ~.), to only have column panel (.~ variable)
  #you can also have multi-variable rows or columns by using (variable + variable ~ variable + variable)
  facet_grid(.~Frame) + 
  
  #geom_half_violin creates a distribution plot for a given condition
  #like with half_boxplot we need to call a dataframe that has the point data in order for the plot to be generated correctly
  #we will use tidy filtering again to generate multiple distribution plots for each X-axis condition
  geom_half_violin(Gamble%>%filter(Block==1),mapping=aes(x=Block, y=Gamble), alpha= .5, size=.2, color="black", position = position_dodge(width=.7)) + 
  geom_half_violin(Gamble%>%filter(Block==2),mapping=aes(x=Block, y=Gamble), alpha= .5, size=.2, color="black", position = position_dodge(width=.7)) + 
  geom_half_violin(Gamble%>%filter(Block==3),mapping=aes(x=Block, y=Gamble), alpha= .5, size=.2, color="black", position = position_dodge(width=.7)) +
  geom_half_violin(Gamble%>%filter(Block==4),mapping=aes(x=Block, y=Gamble), alpha= .5, size=.2, color="black", position = position_dodge(width=.7)) +
  #alpha changes the opacity of the fill color (closer to 0 closer to opaque)
  #size is thickness of line, color is color of border line
  #position_dodge makes it so that the half violins for the between-subject condition Feedback are not all on top of each other
  
  #we will also split the points by Feedback condition so they overlay the corresponding violin plot
  #note that we will use the original X and Y variables, not the jittered versions we previously created
  geom_point(Gamble%>%filter(Block==1), mapping=aes(x=Block, y=Gamble), size=.01, 
             position = position_jitterdodge(jitter.width = .25, jitter.height = .05, dodge.width = .7)) + 
  geom_point(Gamble%>%filter(Block==2), mapping=aes(x=Block, y=Gamble), size=.01, 
             position = position_jitterdodge(jitter.width = .25, jitter.height = .05, dodge.width = .7)) +   
  geom_point(Gamble%>%filter(Block==3), mapping=aes(x=Block, y=Gamble), size=.01, 
             position = position_jitterdodge(jitter.width = .25, jitter.height = .05, dodge.width = .7)) + 
  geom_point(Gamble%>%filter(Block==4), mapping=aes(x=Block, y=Gamble), size=.01, 
             position = position_jitterdodge(jitter.width = .25, jitter.height = .05, dodge.width = .7)) + 
  #position_jitterdodge adds x-y jitter to variables 
  #and makes so that the points for the between-subject condition Feedback are not all on top of each other 
  
  #geom_errorbar creates a errorbar based on the available statistics for the dependent variable computed by summarystats (se, sd, ci)
  #the error bars in this plot are computed for +/- 1 standard error
  #geom_errorbar(aes(ymin = , ymax =))
  geom_errorbar(aes(ymin = Gamble-se,ymax = Gamble+se), width=.1, size=.5, position = position_nudge(x=.5)) + 
  #width is size of errorbar, size is thickness of line
  
  #geom_line links errorbars together with horizontal line
  #geom_line ()
  geom_line(size=.5, position = position_nudge(x=.5)) + 
  #size is thickness of line
  
  #the rest of this code (which sets appearance of plot) has not been changed
  theme_minimal() +
  scale_x_continuous(name= "Trial Block", breaks=seq(0,4,1)) + 
  scale_y_continuous(name="Proportion of Gambles", breaks=seq(0,1,0.2), limits=c(-.05,1.05)) + 
  labs(color= "Feedback\nCondition", fill="Feedback\nCondition") + #adding \n between the words adds a new line 
  theme (text=element_text(size=10), 
         legend.position = "right", 
         axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),
         axis.title.x = element_text(margin = margin(t = 15, r = 0, b = 0, l = 0)),
         panel.background = element_rect(fill = NA, color = "black")) + 
  coord_fixed(ratio = 2.5, expand = TRUE) 

ggsave("Gamble Plot v3.png", width = 8, height = 5)


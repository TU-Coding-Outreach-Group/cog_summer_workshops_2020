##Import libararies
library(tidyverse)

##Import datasets
e3 <- read.csv("e3_raw.csv")

##Conditional Statements & Loops Tutorial

#IF-ELSE statement - IF some condition is satisfied DO something, if not satisfied DO something ELSE
#important! in order for IF-ELSE statements to work, make sure all variations of condition have solution (may require nested IF-ELSE statements)
#important! consider the ordering and nesting of conditional statements - different orders/nesting will result in different outcomes

#the following IF-ELSE code will work for changes to entire vector/dataframe

#example softcode:
#new variable <- ifelse (condition, value if satisfied, value if not satisfied)

e3$FilterRT <- ifelse (e3$Choice.RT <= 150, 1, 0)

#example nested softcode:
#new variable <- if else (condition, value if satisified, 
#                         ifelse (different condition, value if satisfied, value if unsatisfied))

e3$FilterRT <- ifelse (e3$Choice.RT == 0, 0, 
                         ifelse (e3$Choice.RT >= 0 & e3$Choice.RT <= 150, 1, NA))

#note that the preceding code used AND logic to state that 2 conditions must both be met to execute code
#example softcode:
#new variable <- ifelse (condition1 & condition2, value if satisfied, value if not satisfied)

#you can also use OR logic to state that either of the 2 conditions could be met to execute code
#example softcode:
#new variable <- ifelse (condition1 | condition2, value if satisfied, value if not satisfied)

#sets Block equal to 1 on Trials 1-18, equal to 2 on Trials 19-36, equal to 3 on Trials 37-54, and equal to 4 on Trials 55-72
e3$Block <- ifelse (e3$Trial >= 1 & e3$Trial <= 18, 1, ifelse(e3$Trial >= 19 & e3$Trial <= 36, 2, 
                                                                 ifelse(e3$Trial >= 37 & e3$Trial <= 54, 3, 4)))


#####


#what if we want to make changes to a vector/dataframe one-row-at-a-time? We need to use a different coding of IF-ELSE statements
#and we need to use IF-ELSE statements in combination with Loops (either for-loop or while-loop)

#FOR set range, DO something
#example softcode:
#for (i in 1:dim(dataframe)[1]) {} 
#where dim(dataframe)[1] returns the max number of rows in dataframe - test it by putting the code in the command window

i <- 1 #this is our index value that increases by 1 each loop
e3$FilterRTtotal <- NA #this is a new variable that will tally the number of responses that didn't meet the 150 ms threshold

for (i in 1:dim(e3)[1]) {
  
  if (e3$Trial[i] == 1) { #checks to see if first trial for participant
    
    if (!is.na(e3$FilterRT[i])){ #checks to see if filter variable is not NA 
      e3$FilterRTtotal[i] <- 1
    } else { #if filter variable is NA
      e3$FilterRTtotal[i] <- 0
    }
  } else { #if not first trial
    
    if (!is.na(e3$FilterRT[i])){ #checks to see if filter variable is not NA 
      e3$FilterRTtotal[i] <- e3$FilterRTtotal[i-1] + 1
    } else { #if filter variable is NA
      e3$FilterRTtotal[i] <- e3$FilterRTtotal[i-1]
    }    
  }
} 

#note the differences between the IF-ELSE code used in the FOR loop and the IF-ELSE code presented previously
#example softcode:
#if (condition) {
#} else {
#}

#example nested softcode:
#if (condition) {
#  if (condition) {} else {}
#} else {
#  if (condition) {} else {}  
#}

#also note that the use of AND/OR logic differs slightly depending on the IF-ELSE code you use & | versus && ||

#in a given dataset, we would probably compute multiple variables on a trial-by-trial basis, but it can get clunky to have so much code in a single loop
#to help keep code orderly, we can create functions that are called within a loop
#the other good thing about functions is it helps us to isolate where code is going wrong

#we will create two functions out of the inner IF-ELSE statements in the FOR loop above
#the purpose of these functions will be to generate the same tally accomplished in the previous FOR loop
#example softcode:
#function name <- function (input1, input2) {code}

FilterRTtotal.1 <- function (RESPcell, RESPtotal){ 
  if (!is.na(RESPcell)){ #checks to see if filter variable is not NA
    RESPtotal<- 1
  } else { #if filter variable is NA
    RESPtotal <- 0
  }
  return(RESPtotal)
}

FilterRTtotal.2 <- function (RESPcell, RESPprevtotal, RESPtotal){
  if (!is.na(RESPcell)){ #checks to see if filter variable is not NA 
    RESPtotal <- RESPprevtotal + 1
  } else { #if filter variable is NA
    RESPtotal <- RESPprevtotal
  }  
}

i <- 1; e3$FilterRTtotal <- NA #reset variables to ensure FOR loop with functions accomplishes desired result

for (i in 1:dim(e3)[1]) {
  
  if (e3$Trial[i] == 1) { #checks to see if first trial for participant
    e3$FilterRTtotal[i] <- FilterRTtotal.1(e3$FilterRT[i],e3$FilterRTtotal[i])

  } else { #if not first trial
    e3$FilterRTtotal[i] <- FilterRTtotal.2(e3$FilterRT[i], e3$FilterRTtotal[i-1], e3$FilterRTtotal[i])
  
  }
} 

##HOMEWORK - Write 2 functions for inside the FOR loop
#FilterGamble.1 function falls inside IF statement, FilterGamble.2 function falls inside ELSE statement
#Together, functions should compute a new variable in e3, FilterGamble, that tallies the proportion of sure choices
#writing this function will require using an IF-ELSE loop in in if(condition){}else{} format
#hint - your functions calls are already plugged into the FOR loop below, they are commented out

FilterGamble.1 <- function (){}

FilterGamble.2 <- function (){}

i <- 1; e3$FilterRTtotal <- NA; #reset variables to ensure FOR loop with functions accomplishes desired result
e3$FilterGamble <- NA #this is a new variable that will tally the number of sure choices made by each participant

for (i in 1:dim(e3)[1]) {
  
  if (e3$Trial[i] == 1) { #checks to see if first trial for participant
    e3$FilterRTtotal[i] <- FilterRTtotal.1(e3$FilterRT[i],e3$FilterRTtotal[i])
    #e3$FilterGamble[i]<- FilterGamble.1(e3$Gamble.Prop[i], e3$FilterGamble[i])
    
  } else { #if not first trial
    e3$FilterRTtotal[i] <- FilterRTtotal.2(e3$FilterRT[i], e3$FilterRTtotal[i-1], e3$FilterRTtotal[i])
    #e3$FilterGamble[i]<- FilterGamble.2(e3$Gamble.Prop[i-1], e3$FilterGamble[i])
  }
} 


#####


#note that for the 2 new tally variables created (FilterRTtotal, FilterGamble), the value we really care about is the final tally
#to pull the final tally for each participant we need to look at the value of variables on the final trial (72)
#we can do this by modifying our previous FOR loop

i <- 1; e3$FilterRTtotal <- NA; e3$FilterGamble <- NA #reset variables to ensure FOR loop with functions accomplishes desired result
e3$FilterRT.final <- NA; e3$FilterGamble.final <- NA #these are new variables that tell whether a participant should be filtered out (1), or not (0)
FilterRT <- numeric (dim(e3)[1]/72); FilterGamble <- numeric (dim(e3)[1]/72) #creates new vectors based on size of participant sample
si <- 1 #new subject index variable

for (i in 1:dim(e3)[1]) {
  
  if (e3$Trial[i] == 1) { #checks to see if first trial for participant
    e3$FilterRTtotal[i] <- FilterRTtotal.1(e3$FilterRT[i],e3$FilterRTtotal[i])
    #e3$FilterGamble[i] <- FilterGamble.1(e3$Gamble.Prop[i], e3$FilterGamble[i])
    
  } else { #if not first trial
    e3$FilterRTtotal[i] <- FilterRTtotal.2(e3$FilterRT[i], e3$FilterRTtotal[i-1], e3$FilterRTtotal[i])
    #e3$FilterGamble[i] <- FilterGamble.2(e3$Gamble.Prop[i-1], e3$FilterGamble[i]
    
    if (e3$Trial[i] == 72){ #checks to see if last trial
      
      #checks to see if participant missed responses on more than 10% of trials
      if (e3$FilterRTtotal[i]/72 >= .10){ 
        FilterRT[si] <- e3$NewSubject[i]
        si <- si + 1 #moves one space in new vector
      } 
      
      #checks to see if participant selected Gamble option on less than 10% of trials
      #if (){}else{}
      
    } 
  }
}

write.csv(FilterRT, file = "Partipants to filter based on RT.csv") #this saves the vector FilterRT to a csv file

#by saving the list of participants to filter in a file, we can access this information later on and use the filter function to remove subjects

##HOMEWORK - Write an IF-ELSE statement to check to see if participant selected Gamble option on less than 10% of trials
#If participant did gamble on less than 10% of trials, assign the participants number to the new vector FilterGamble
#write the vector to a csv file


#####


#to prepare the data for plotting we need to begin to average participant's data across rows (based on within-subjects grouping variables)
#we can use two functions in combination to average our data: group_by, summarise
#example group_by softcode:
#name of new dataframe <- group_by (dataframe, var1, var2, var3...)

e3_plot_Advant <- group_by(e3, Experiment, NewSubject, Block, Bias, Choice)

#example summarise softcode:
#name of new dataframe <- summarise (new dataframe, new variable = mean (old variable, na.rm = TRUE))

e3_plot_Advant <- summarise(e3_plot_Advant, 
                            Advantage = mean(Advantage.Prop, na.rm = TRUE),
                            RT = mean(Choice.RT, na.rm = TRUE)
                            )

#note that e3_plot_Advant has a row of missing data, we can get rid of this using the filter function
#example softcode:
#name of new dataframe <- filter (new dataframe, condition filtered if false)

e3_plot_Advant <- filter(e3_plot_Advant, !is.na(Advantage))

#I can combine these three functions in tidyer code to be more efficient

e3_plot_Advant <- e3 %>% 
  group_by(Experiment, Subject, Block, Bias, Choice) %>%
  summarise (
    Advantage = mean(Advantage.Prop, na.rm = TRUE),
    RT = mean(Choice.RT, na.rm = TRUE)
  ) %>%
  filter (!is.na(Advantage))

#creates dataframe for plotting FGT proportion of gambles
e3_plot_Gamble <- e3 %>% 
  group_by(Experiment, NewSubject, Block, Frame, Feedback) %>%
  summarise (
    Gamble = mean(Gamble.Prop, na.rm = TRUE),
    RT = mean(Choice.RT, na.rm = TRUE),
    TypeCount = n()
  ) %>%
  filter (!is.na(Gamble))


#####


#finally, we want to remove the participants from our new dataframes that were identified in the filtering stage and saved to vectors
#example softcode:
#name of dataframe <- subset(name of dataframe, variable in dataframe to filter by %in% variable in vector to filter by
to.be.filtered.rt <- subset(e3_plot_Advant, NewSubject %in% FilterRT)

#now we subtract the new dataframe from the final dataframe
plot_Advant <- anti_join(e3_plot_Advant, to.be.filtered.rt)

#saves new dataframes to CSV file
write.csv(plot_Advant, file = "plot_Advant.csv")

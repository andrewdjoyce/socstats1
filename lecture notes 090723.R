## Notes 090723

## eventual goal: use computer to show us how to sample so we can learn about sampling & probability
## beforehand: learn more about data wrangling. that's today's goal.
## today's goal: use dplyr to 'wrangle' data
    ## wrangling includes: 
        ## filter: keep certain rows (observations) & gets rid of others
        ## select: keeps some columns (variables) & gets rid of others
        ## mutate: make new variables
        ## group-by:
        ## summarize (summarise also works, thanks UK spelling)

library(tidyverse)
## install package: nycflights13 which is a dataframe used for dplyr training
library(nycflights13)
## btw steve does push these notes into github under the folder "demos"

data(flights)
## this is the name of the data. 336,776 obs of 19 variables
glimpse(flights) ## to take a peek. the viewer is going to be clunky. or type view(flights)
## glimpse will show me each column as its own row.
    ## note that the dataframe in view has rows for each observation, and columns for each variable.
    ## in glimpse, the variables are in the rows, and the observations are in the columns. easier to read, easier to scroll up and down.
## these are all from 2013

?flights ## ask if R knows anything. description: On-time data for all flights that departed NYC (i.e. JFK, LGA or EWR) in 2013.
## you can run all this in the console as well.

table(flights$dest) ##table to see all the destinations.
table(flights$origin) ## table of origins. JFK, La Guardia, and Newark.
table(flights$dest, ## crosstab
      flights$origin)
table(flights$dest, flights$origin) ## these are the same commands. the 'enter' and line break doesn't matter
                                    ## R is just looking for the )
    ## this is a cross-tabulation. good to start with these to understand the data before running fancy shit.
    ## this tells me all flights from NYC -> either OKC or TUL depart from EWR. Didn't know that!
flights |> count(dest, origin)
flights |> count(origin, dest)
    ## this shows me # of flights from EWR to ALB, (439), then EWR to ANC (8). this is helpful.

## command + shift + m: |> 
## %>% does basically the same thing. the differences I will probably not encounter.

## but let's do this in dplyr. more advanced, but the skill leads us to broader things

## what are all the origins?
  flights |> 
    group_by(origin) |> 
    summarize(count = n())
  
  ## take the data frame.
  ## after the pipeline, then group by:  everything from now on, separately by this levels of that variable.
        ## because there's three levels of that variable, we're splitting the data by 3.
  
  ## contrast the above w/ this
  flights |> 
      summarize(count = n())
      ## this just shows me total # of observations. I didn't group by anything.

  ## we can group by anything we want!
  flights |> 
    group_by(dest) |> 
    summarize(count = n())
  ## grouped by destination.
  
  ## summarize: when we take a dataset and break it down into summary data.
  ## sumamrize is a way of making a new variable, & here's the forumula. n(). that is a formula. how many rows.
  flights |> 
    group_by(origin) |> 
    summarize(count = n())
  
  flights |> 
    group_by(origin) |> 
    summarize(numflights = n())
## the same thing is happening. but now I'm calling it "numflights." origin x numflights.
  flights |> 
    group_by(origin) |> 
    summarize(n_flights = n()) ## call it what you want.
  
## back to original dataset. notice, nothing new appeared in my environment. it's because I didn't 'name' the object.
  
d_numflights <- flights |> 
    group_by(origin) |> 
    summarize(numflights = n())

## look! I made a new dataframe.
view(d_numflights)
    ## tiny.

## in R, most things will be dataframes, which are a special kind of matrix.
## tibbles: a special kind of dataframe.
    ## all tibbles are data frames, but not all data frames are tibbles.
    ## tibble: tidyverse-enhanced dataframe.

## how do I know what something is in R?
class(flights)
  ## 3 different thing. tbl_df: tibble data frame. tbl: tibble. data.frame: dataframe.
class(mtcars)
  ## just one thing. a data frame.

## biggest difference. mtcars (not a tibble) does not have a variable for car name. it's just labeled.
## other than that, tibbles & dataframes are pretty much identical.

    ## side: coercing a dataframe into a tibble
          data(mtcars)
          mtcars_tbl <- as_tibble(mtcars) ## coerce a dataframe into a tibble
          view(mtcars_tbl)
          ## the car names disappeared! because they were never a variable to begin with
          view(mtcars)
          ?as_tibble ## help guide. we can find solutions here. but Andrés says there's a function called 'row names to colums"
          mtcars_tbl <- as_tibble(mtcars, rownames = "car")
          view(mtcars_tbl)
          ## 12 variables now, because we successfully have a rowname.

## mutate: a lot like summarize.
          
## I want to create a new variable that asks if this flight was delayed. (binary variable)
glimpse(flights)
## let's figure out dep_delay. compare with dep_time and sched_dep_time.
 ## negative values in dep_delay left early. 
 ## positive values in dep_delay left late-- were delayed.
## a 0 means it left on time.

## dep_delay. at least for positive values, we can say a delay was 2x as long as another delay. definitely an interval variable.
## now we have a rule for mapping things onto this continuous variable. 
## let's call this new variable "late." values 0 or less are NOT LATE (False). values greater than 0 are TRUE (LATE).
## (-infinity, 0] (0, +infinity). the false value does include 0, the true value (late) does not include 0.
## for statistical reasons, we want to encode this as 0 and 1. 0 for false, 1 as true. (though R can code true and false)

## goal: take existing variable (dep_delay) to turn it into a variable that is 1 if certain conditions are met, and 0 if otherwise.
## this will involve two new things: making a new variable & recoding an existing variable using logicals

## flights: currently has 19 columns. we will want 20. but the question is- do we want a new data set or overwrite the original?
## if it's a large dataset, you probably won't want to make a new copy. so you can overwrite. when our session ends, it disappears 
    ## (unlike stata, we're not overwriting and saving a new data file.)
    ## "THe only thing real is CODE." (Steve, quoting Kieran) so when we close the project and open again, we can re-run code and it'll all reappear.

## how to add a new variable
## syntax:  flights <- flights |> 
  ## take flights, and then do some stuff to it, and then save it (<-) as flights. OVERWRITING.

flights <- flights |> 
  mutate(dd2 = dep_delay ) ## create a new variable called dd2, the formula is make it identical to old variable dep_delay
  
## notice: now we have 20 variables in global env
glimpse(flights) ## dd2 is at bottom of new variable.

flights <- flights |> 
  mutate(dd2_sqr = dep_delay^2 ) ## departure delay squared! and the formula for that.
  ## 21 variables now! in this case, this isn't useful, but I have squared variables before.
glimpse(flights)

    ## an aside. typically, in a dplyr pipe, we can reference variables without using "" 

## with that knowledge in mind, we can move to step 2. recoding a variable.
## we'll use if_else() but the tidyverse version- ifelse is a base R, if_else is tidyverse.

## if else will have a logical statement or expression, then 1 what to do if satatement is true, and 0 if statement is false.
  ## logical statement,
  ## 1,  (if statement is true, ==1)
  ## 0 (else [ie statement is false])
flights <- flights |> 
  mutate(late = if_else(dep_delay > 0, 1, 0))
      ## late is a new variable, from mutate function(). if_else() is nested inside mutate().
      ## the forumula is that if dep_delay is GREATER THAN zero, the value is 1. OTHERWISE, the value is zero.

glimpse(flights)
## late variable is at the end now. and it looks like it's binary.
select(flights, dep_delay, late) |> view()
 ## great way to check your recoding.

## right now, stored as dbl (double precision). but could be stored as integer. R is seeing this as 1.000000000000 just in case there's a 1.0000000003
## force to integer
flights <- flights |> 
  mutate(late = if_else(dep_delay > 0, 1L, 0L)) ##1l: one as an integer. 0L; 0 as integer.
glimpse(flights) ## now you can tell this is integer.
## this takes up less storage

## if_else is best for binary. but there are other versions- like keep_case for multinomial.

## how are summarize & Mutate related? 
  ## mutate creates a new column without changing # of rows.
  ## summarize collapses & adds a new column.

## what arlines leaving from NYC area have highest proportion late?
## group by carrier. then summarize, making a new variable called prop_late, with the formula of the mean of the variable late.
flights |> 
  group_by(carrier) |> 
  summarize(prop_late = mean(late))
## there's missing data, so lots of NA. we'll talk more about this later.
flights |> 
  drop_na() |> ## we're doing this after flights to get rid of missing data before means are calculated.
  group_by(carrier) |> 
  summarize(prop_late = mean(late))

## split dataset into the 16 carriers. calculate value of mean variable for each of the 16 carriers. and show it to us.
## group_by is your best friend- esp. with multilevel data, panel data.

flights |> 
  drop_na() |> 
  group_by(carrier) |> 
  summarize(prop_late = mean(late)) |> 
  arrange(prop_late) ## sort by variable

flights |> 
  drop_na() |> 
  group_by(carrier) |> 
  summarize(prop_late = mean(late)) |> 
  arrange(desc(prop_late)) ## sort by descending.

## new function: FILTER
    ## filter gets rid of/keeps rows.

## let's say, I want a new tibble that's JUST the flights from JFK.

flights_jfk <- flights |> 
  filter(origin == "JFK") ## we're evaluating a logical expression. thus ==
## new object, flights-Jfk, with 111,279 obs of 22 variables. so just the rows that have origin==JFK in global env

## select: keep some columns & get rid of others.
glimpse(flights)
## refresh our memory on what variables we have.

## create new object, from original dataframe, pipe, and then select variables of interest
flights_selected <- flights |> 
  select(origin, dest, carrier, late)
glimpse(flights_selected)
## same # of rows, but only 4 columns.

flights_selected2 <- flights |> 
  select(-year) ## this just gets rid of a single variable, here year since they're all 2013.
glimpse(flights_selected2)

## keep a range of variables by :
flights_s3 <- flights |> 
  select(dep_time:carrier, origin, dest)
glimpse(flights_s3)
## just be careful, assumes your variables are in the order you want. just be careful w the colon.

## preview of next week: simulations, sampling.
rbinom(100, 1, .5) ##rbinom (n, size, probability) this works for a coin flip.




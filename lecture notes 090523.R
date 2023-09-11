## Notes 09-05-23

## if you're doing something for production, Quarto is preferred
## but notes for yourself...R script is fine. note that "enter" doesn't run, but command + return runs the code.

library(tidyverse) ##bring this up
data(mtcars) ##bring up data

## I want the mean of mpg
mean(mtcars$mpg) ## option 1
## or, pipe version
mtcars$mpg |>  mean()
## both work. but second is tidyverse style.
mtcars |> filter(am == 1) |> pull(mpg) |> mean()
## take full data set, keep only rows where auto transitions ==1, take out only MPG column, and take the mean.

## COMMAND + SHIFT + M: |> 
## COMMAND + RETURN: run the code

## now. data wrangling

mtcars |> pull(hp)

## only install in the console, fyi.
## but we're going to install.packages("palmerpenguins")

library(palmerpenguins) ## bring it to global env
data(penguins)
view(penguins) ## take a look at it! 344 penguins.

## observational vs experimental data

## penguins is observational data! we observed them. much of the data we use in sociology is observational.
## mtcars is also observational.
## be aware of how the data is generated & collected.

## install package "openintro" to find "bac" & "biontech_adolescents" dataset
library(openintro)
data(bac)
## data on blood alcohol content, from 16 students.
## this is experimental data. we had control over one variable, the # of beers a student drank.
data(biontech_adolescents)
view(biontech_adolescents)

## table command. not for publication tables, but good to 'noodle around'
table(biontech_adolescents$group, 
      biontech_adolescents$outcome)
## this reminds me of tab, tab2, fre in stata. the above command is a two-way table. more experimental data.
## note: R doesn't care when you break a line. you could keep it on one line. you don't need ///. R will keep looking for the )

## third way we can get data. less preferred, but more realistic: bring it into R from elsewhere. 
## Kieran did write a GSS package for R, but we're gonna do it manually.

## surprise: we still need a package. "haven" which was downloaded w/ tidyverse.
library(haven)

## create a new object that is a result of some function, with a resulting object called "gss2022"
## remember, you can pretty much assign everything to an object (except for maybe True, False, IF, etc.)
## package info: ?packagename-package. so here ?haven-package to find info

## read_dta and read_stata are synonyms, btw, you can type either
gss2022 <- read_dta("GSS2022.dta")
## didn't work. why? because our current working directory is not in the same folder that the data is in.
## right now it's looking in my socstats1 folder.

## bad idea, but it works: code the entire file path.
##      gss2022 <- read_dta("/Users/andrewjoyce/Documents/Duke PhD/Fall 2023/SOC 722 Social Stats I/Soc-Stats-HW/socstats1/Data/GSS2022.dta")
## lmao this is what I did in Stata! but if I change computers, this path no longer works.
## & your collaborators definitely don't have it.

## easiest solution: relative path. this is using the folder I have called "Data".
gss2022 <- read_dta("Data/GSS2022.dta")

## but let's say I forgot to open my R into the right project. "we'll come back to that."
## I'm actually not in a working project right now. that's on me, lol.

glimpse(gss2022)
## <dbl + lbl> this happens because stata knows that 1 = white, 2= black, 3 = other. you'll see that a lot.

gss2022v2 <- read_dta("Data/GSS2022.dta") |> zap_labels()
glimpse(gss2022v2) ## zap labels gets rid of those weird labels.

glimpse(gss2022)

## let's talk different kinds of variables.
## categorical & numeric variables
    ##    categorical: binary, nominal, ordinal, 
    ##    numerical: interval, ratio

view(mtcars)

## variable: measurement varies between observations. in mtcars, they are cars. in gss2022, they are people.
## categorical: often stored as numbers, but don't technically need to be.
    ## binary: two options. most common is sex. (sometimes variable is coded "female" as 0/1). again, unordered.
          ## sometimes, when you model, the 1 or 0 is important. like 1 = sick in epidemiology. 
          ## but in reality, the 0/1 is arbitrary. 
    ## nominal: extension of first. no ordering. multiple categories. ie., major. humanities, social science, natural science, engineering.
               ## the number you store it as is ARBITRARY. no inherent ordering.
    ## ordinal: rankable, can be ordered. but distance between isn't clear. (like a PhD isn't 2x larger than a MA)
        ## like T shirt size, or "strongly disagree ---> strongly agree", level of deducation "< HS --> PhD"
        ## ordinal is "on the doorstep of things that can be numeric, but aren't actually"

## numeric: measured with numbers
    ## interval: gap between every unit (interval) is the same
        ## 95 degrees, 96, 97, 98, 99. every time you move up/down a unit you move the same amount.
        ## is 95 degrees TWICE as hot as 45 degrees? NO! because the 0 in farenheit is ARBITRARY
        ## celsius is also interval.
        ## intervals are fairly rare in real life, but if you take the std dev of each score, you then get rid of a meaningful zero.
    ## ratio: zero is meaningful. like $0. 
        ## someone who makes $20k DOES INDEED make twice as much as someone who makes $10k.
        ## 3 sex partners vs 5 sex partners. we can meaningfully say that person 2 has 67% more sex partners than person 1.
        ## is zero meaningful? (ie., does zero mean the absence of something?)
        ## lowest amount of sex partners/income is zero.
  
## so let's take a look at real data to find examples of all of these.

view(mtcars)
## number of cylinders: ratio. it does make sense that a car w/ 8 cylinders has twice as many 
## weight: ratio. car x weighs twice as much as car y.
## "am" automatic transmission. (in mtcars, it's binary. 1=automatic, 0=manual)

## GSS questions: using data explorer.
## wrkstat: nominal
## divorced: binary
## educ: ratio
## degree: nominal
## polviews: ordinal

## very few variables in the GSS are numeric. there's a couple- age, tvhrs, educ (years of ed).
## a lot are ordinal, and you make the decision to treat them as numeric or not.
    ## Steve says the "polviews" outcome is often treated as numeric. which seems controversial to me.
    ## but alternatives are difficult to interpret. and that I agree with- 
      ## logistic regressions are far more difficult to interpret than an OLS, for example.

## with extra time, practice R skills.
## use R for data science textbook.
## every day you don't use R, you will lose knowledge.
    ## without practice, "the tide will take you out" until you have reached a certain level of mastery.
    ## every single day! even for a few minutes.


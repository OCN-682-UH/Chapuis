W15 Homework
================
Micaela Chapuis
2024-12-06

## Assignment Details

You have a set of 4 .csv files in data/homework. Each of these files is
a timeseries of temperature and light data collected in tide pools in
Oregon by Jenn Fields. Your goal is to bring in all 4 files and
calculate the mean and standard deviation of both temperature (Temp.C)
and light (Intensity.lux) for each tide pool. Use both a for loop and
map() functions in your script. (Basically, do it twice).

## Load Libraries

``` r
library(here)
library(tidyverse)
```

## For Loop

First, let’s read in a file to see what it looks like

``` r
test <- read_csv(here("Week15", "Data", "homework","TP1.csv"))
glimpse(test)
```

    ## Rows: 5,981
    ## Columns: 7
    ## $ PoolID          <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    ## $ Foundation_spp  <chr> "Phyllospadix", "Phyllospadix", "Phyllospadix", "Phyll…
    ## $ Removal_Control <chr> "Control", "Control", "Control", "Control", "Control",…
    ## $ Date.Time       <chr> "6/16/19 0:01", "6/16/19 0:16", "6/16/19 0:31", "6/16/…
    ## $ Temp.C          <dbl> 10.21, 10.08, 10.16, 10.12, 10.08, 10.08, 10.04, 10.04…
    ## $ Intensity.lux   <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ LoggerDepth     <dbl> 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, …

Now make a list of all files in the specified path

``` r
filepath <- here("Week15", "Data", "homework") # specify file path

files <- dir(path = filepath, pattern = ".csv") # make a list of all files in this path that match the pattern (in this case ".csv")

files # view
```

    ## [1] "TP1.csv" "TP2.csv" "TP3.csv" "TP4.csv"

Pre-allocate space for the for loop: making an empty dataframe that has
a row for each file (each file is a tidepool) and includes the file name
(tidepool number), the mean and SD for temperature, and the mean and SD
for light.

``` r
pool_data <- tibble(filename =  rep(NA, length(files)),  # column for the file name (tidepool number), length is the number of files we're importing
                   mean_temp = rep(NA, length(files)), # column for the mean temperature
                   sd_temp = rep(NA, length(files)), # column for the temperature sd
                   mean_light = rep(NA, length(files)), # column for the mean light
                   sd_light = rep(NA, length(files))) # column for light sd
                   
pool_data
```

    ## # A tibble: 4 × 5
    ##   filename mean_temp sd_temp mean_light sd_light
    ##   <lgl>    <lgl>     <lgl>   <lgl>      <lgl>   
    ## 1 NA       NA        NA      NA         NA      
    ## 2 NA       NA        NA      NA         NA      
    ## 3 NA       NA        NA      NA         NA      
    ## 4 NA       NA        NA      NA         NA

Now check that my code will work before putting it in the loop

``` r
raw_data <- read_csv(paste0(filepath,"/",files[1])) # read in the first file to make sure it works
# paste0 gives filepath/filename.csv from our list of file names called 'files'
head(raw_data) # it works!
```

    ## # A tibble: 6 × 7
    ##   PoolID Foundation_spp Removal_Control Date.Time    Temp.C Intensity.lux
    ##    <dbl> <chr>          <chr>           <chr>         <dbl>         <dbl>
    ## 1      1 Phyllospadix   Control         6/16/19 0:01   10.2             0
    ## 2      1 Phyllospadix   Control         6/16/19 0:16   10.1             0
    ## 3      1 Phyllospadix   Control         6/16/19 0:31   10.2             0
    ## 4      1 Phyllospadix   Control         6/16/19 0:46   10.1             0
    ## 5      1 Phyllospadix   Control         6/16/19 1:01   10.1             0
    ## 6      1 Phyllospadix   Control         6/16/19 1:16   10.1             0
    ## # ℹ 1 more variable: LoggerDepth <dbl>

Also test our mean and sd code before putting it in loop

``` r
mean_temp <- mean(raw_data$Temp.C, na.rm = TRUE) # calculate mean temp
mean_temp
```

    ## [1] 13.27092

``` r
sd_temp <- sd(raw_data$Temp.C, na.rm = TRUE) # calculate sd for temp
sd_temp
```

    ## [1] 2.324037

Actual for loop now!

``` r
for (i in 1:length(files)){ # loop over the number of files listed in 'files'
  raw_data <- read_csv(paste0(filepath,"/",files[i])) # read in each file as it iterates over the number of files in the list (1-4)
  
  pool_data$filename[i] <- files[i] # store the name of each file in the filename colun
  
  
  pool_data$mean_temp[i] <- mean(raw_data$Temp.C, na.rm =TRUE) # calculate the mean temp for each file and store it in the corresponding row
  pool_data$sd_temp[i] <- sd(raw_data$Temp.C, na.rm = TRUE) # calculate temp sd for each file and store it in corresponding row
  
  
  pool_data$mean_light[i] <- mean(raw_data$Intensity.lux, na.rm = TRUE) # calculate mean light for each file and store it in corresponding row
  pool_data$sd_light[i] <- sd(raw_data$Intensity.lux, na.rm = TRUE) # calculate light sd for each file and store it in corresponding row
} 

pool_data
```

    ## # A tibble: 4 × 5
    ##   filename mean_temp sd_temp mean_light sd_light
    ##   <chr>        <dbl>   <dbl>      <dbl>    <dbl>
    ## 1 TP1.csv       13.3    2.32       427.    1661.
    ## 2 TP2.csv       13.2    2.31      5603.   11929.
    ## 3 TP3.csv       13.1    2.32      5605.   12101.
    ## 4 TP4.csv       13.2    2.27       655.    2089.

## Map Functions

Using the same filepath from above to store the full path of each file
into ‘files’

``` r
files <- dir(path = filepath, pattern = ".csv", full.names = TRUE)
```

``` r
pool_data_map <- files %>% # what we're iterating over, the full path to each file
                  set_names() %>% # sets the id of each row to the file name
                  map_df(read_csv, .id = "filename") %>% # map everything to a dataframe and put the id in a column called filename
  
                  group_by(filename) %>% # group by filename (aka by tidepool)
                  summarise(mean_temp = mean(Temp.C, na.rm = TRUE), # calculate mean temp
                            sd_temp = sd(Temp.C, na.rm = TRUE), # calculate temp sd
                            mean_light = mean(Intensity.lux, na.rm = TRUE), # calculate mean light
                            sd_light = sd(Intensity.lux, na.rm = TRUE)) # calculate light sd

pool_data_map
```

    ## # A tibble: 4 × 5
    ##   filename                                 mean_temp sd_temp mean_light sd_light
    ##   <chr>                                        <dbl>   <dbl>      <dbl>    <dbl>
    ## 1 /Users/micachapuis/GitHub/OCN 682/Chapu…      13.3    2.32       427.    1661.
    ## 2 /Users/micachapuis/GitHub/OCN 682/Chapu…      13.2    2.31      5603.   11929.
    ## 3 /Users/micachapuis/GitHub/OCN 682/Chapu…      13.1    2.32      5605.   12101.
    ## 4 /Users/micachapuis/GitHub/OCN 682/Chapu…      13.2    2.27       655.    2089.

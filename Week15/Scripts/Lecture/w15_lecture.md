W15 Lecture
================
Micaela Chapuis
2024-12-03

## Load Libraries

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(here)
```

    ## here() starts at /Users/micachapuis/GitHub/OCN 682/Chapuis

## For Loops!

### Simple for loops

Start with simple code

``` r
print(paste("The year is", 2000))
```

    ## [1] "The year is 2000"

Now put it in a for loop

``` r
years <- c(2015:2021)

for (i in years){ # set up the for loop where i is the index
  print(paste("The year is", i)) # loop over i
}
```

    ## [1] "The year is 2015"
    ## [1] "The year is 2016"
    ## [1] "The year is 2017"
    ## [1] "The year is 2018"
    ## [1] "The year is 2019"
    ## [1] "The year is 2020"
    ## [1] "The year is 2021"

What we just did printed something over and over, but it did not save it
anywhere. Let’s say you want to save a new vector with all the years. To
do this we need to pre-allocate space and tell R where it is going to be
saved.

Create an empty dataframe called year_data with columns for year and
year_name .

``` r
#Pre-allocate space for the for loop in an empty matrix that is as long as the years vector
year_data <- tibble(year =  rep(NA, length(years)),  # column name for year, repeating NA for the length of the sequence
                    year_name = rep(NA, length(years))) # column name for the year name
year_data
```

    ## # A tibble: 7 × 2
    ##   year  year_name
    ##   <lgl> <lgl>    
    ## 1 NA    NA       
    ## 2 NA    NA       
    ## 3 NA    NA       
    ## 4 NA    NA       
    ## 5 NA    NA       
    ## 6 NA    NA       
    ## 7 NA    NA

Now add the for loop

Let’s first add in the column that is going to have all the names in it.
Notice that I added an index i in the column name.  
I also am having the index go from 1:length(years), which is 1:7. I use
length() because it allows me to change the number of years in the
vector without having to change the for loop.  
Then fill in the year column too.

``` r
for (i in 1:length(years)){ # set up the for loop where i is the index
  year_data$year_name[i] <- paste("The year is", years[i]) # loop over i
  year_data$year[i]<-years[i] # loop over year
}
year_data
```

    ## # A tibble: 7 × 2
    ##    year year_name       
    ##   <int> <chr>           
    ## 1  2015 The year is 2015
    ## 2  2016 The year is 2016
    ## 3  2017 The year is 2017
    ## 4  2018 The year is 2018
    ## 5  2019 The year is 2019
    ## 6  2020 The year is 2020
    ## 7  2021 The year is 2021

### Using loops to read in multiple .csv files

Let’s say you have multiple data files where you want to perform the
same action to each. You can use a for loop to do this.

From the cond_data folder: using 3 files of salinity and temperature
data collected from Mo’orea from a spatial survey.

Read in one of the files so that you can see what it looks like.

``` r
testdata <- read_csv(here("Week15", "Data", "cond_data","011521_CT316_1pcal.csv"))
```

    ## Rows: 1474 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
glimpse(testdata)
```

    ## Rows: 1,474
    ## Columns: 3
    ## $ date        <dttm> 2021-01-15 08:24:40, 2021-01-15 08:24:50, 2021-01-15 08:2…
    ## $ Temperature <dbl> 23.28, 23.28, 23.28, 23.28, 23.28, 23.27, 23.28, 23.28, 23…
    ## $ Salinity    <dbl> 34.83656, 34.59268, 34.90039, 34.72214, 34.53604, 34.42168…

List files in a directory

``` r
# point to the location on the computer of the folder
CondPath <- here("Week15", "Data", "cond_data")

# list all the files in that path with a specific pattern
# In this case we are looking for everything that has a .csv in the filename
# we could use regex to be more specific if you are looking for certain patterns in filenames
files <- dir(path = CondPath, pattern = ".csv")
files
```

    ## [1] "011521_CT316_1pcal.csv" "011621_CT316_1pcal.csv" "011721_CT354_1pcal.csv"

Pre-allocate space for the loop  
Let’s calculate the mean temperature and salinity from each file and
save it

``` r
# make an empty dataframe that has one row for each file and 3 columns
 cond_data <- tibble(filename =  rep(NA, length(files)),  # column name for the file name
                   mean_temp = rep(NA, length(files)), # column name for the mean temperature
                   mean_sal = rep(NA, length(files))) # column name for the mean salinity
                   
cond_data
```

    ## # A tibble: 3 × 3
    ##   filename mean_temp mean_sal
    ##   <lgl>    <lgl>     <lgl>   
    ## 1 NA       NA        NA      
    ## 2 NA       NA        NA      
    ## 3 NA       NA        NA

For loop time!

First make sure code works before putting it in the loop

``` r
raw_data <- read_csv(paste0(CondPath,"/",files[1])) # test by reading in the first file and see if it works
```

    ## Rows: 1474 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# paste0 means pasting with no spaces
# / because it's path then backslash then file name
head(raw_data)
```

    ## # A tibble: 6 × 3
    ##   date                Temperature Salinity
    ##   <dttm>                    <dbl>    <dbl>
    ## 1 2021-01-15 08:24:40        23.3     34.8
    ## 2 2021-01-15 08:24:50        23.3     34.6
    ## 3 2021-01-15 08:25:00        23.3     34.9
    ## 4 2021-01-15 08:25:10        23.3     34.7
    ## 5 2021-01-15 08:25:20        23.3     34.5
    ## 6 2021-01-15 08:25:30        23.3     34.4

And write code to calculate the mean and test it first

``` r
mean_temp <- mean(raw_data$Temperature, na.rm = TRUE) # calculate a mean
mean_temp
```

    ## [1] 29.19296

Turning it into a for loop

First just adding the data in

``` r
for (i in 1:length(files)){ # loop over 1:3 the number of files
  raw_data <- read_csv(paste0(CondPath,"/",files[i])) # read in all files, one at a time
  glimpse(raw_data)
}
```

    ## Rows: 1474 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 1,474
    ## Columns: 3
    ## $ date        <dttm> 2021-01-15 08:24:40, 2021-01-15 08:24:50, 2021-01-15 08:2…
    ## $ Temperature <dbl> 23.28, 23.28, 23.28, 23.28, 23.28, 23.27, 23.28, 23.28, 23…
    ## $ Salinity    <dbl> 34.83656, 34.59268, 34.90039, 34.72214, 34.53604, 34.42168…

    ## Rows: 874 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 874
    ## Columns: 3
    ## $ date        <dttm> 2021-01-16 08:16:00, 2021-01-16 08:16:10, 2021-01-16 08:1…
    ## $ Temperature <dbl> 23.59, 23.60, 23.61, 23.60, 23.60, 23.59, 23.59, 23.59, 23…
    ## $ Salinity    <dbl> 34.04744, 33.96974, 33.93468, 33.91809, 33.87572, 33.85311…

    ## Rows: 1004 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 1,004
    ## Columns: 3
    ## $ date        <dttm> 2021-01-17 08:20:00, 2021-01-17 08:20:10, 2021-01-17 08:2…
    ## $ Temperature <dbl> 23.73000, 23.72900, 23.73000, 23.73000, 23.73000, 23.73000…
    ## $ Salinity    <dbl> NA, NA, NA, NA, NA, NA, NA, 33.48506, 33.47455, 33.45649, …

Now add in the file name to the appropriate column

``` r
for (i in 1:length(files)){ # loop over 1:3 the number of files 
  raw_data <- read_csv(paste0(CondPath,"/",files[i]))
  #glimpse(raw_data)
  cond_data$filename[i] <- files[i]
} 
```

    ## Rows: 1474 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 874 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 1004 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
cond_data
```

    ## # A tibble: 3 × 3
    ##   filename               mean_temp mean_sal
    ##   <chr>                  <lgl>     <lgl>   
    ## 1 011521_CT316_1pcal.csv NA        NA      
    ## 2 011621_CT316_1pcal.csv NA        NA      
    ## 3 011721_CT354_1pcal.csv NA        NA

Now add in our means calculations

``` r
for (i in 1:length(files)){ # loop over 1:3 the number of files 
  raw_data <- read_csv(paste0(CondPath,"/",files[i]))
  #glimpse(raw_data)
  
  cond_data$filename[i] <- files[i]
  
  cond_data$mean_temp[i] <- mean(raw_data$Temperature, na.rm =TRUE)
  cond_data$mean_sal[i] <- mean(raw_data$Salinity, na.rm =TRUE)
} 
```

    ## Rows: 1474 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 874 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 1004 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
cond_data
```

    ## # A tibble: 3 × 3
    ##   filename               mean_temp mean_sal
    ##   <chr>                      <dbl>    <dbl>
    ## 1 011521_CT316_1pcal.csv      29.2     33.7
    ## 2 011621_CT316_1pcal.csv      29.7     33.3
    ## 3 011721_CT354_1pcal.csv      29.2     33.0

## Purrr Package

**Map Functions**  
The pattern of looping over a vector, doing something to each element
and saving the results is so common that the purrr package provides a
family of functions to do it for you. There is one function for each
type of output:

- map() makes a list.  
- map_lgl() makes a logical vector.  
- map_int() makes an integer vector.  
- map_dbl() makes a double vector.  
- map_chr() makes a character vector.  
- map_df() makes a dataframe

Each function takes a vector as input, applies a function to each piece,
and then returns a new vector that’s the same length (and has the same
names) as the input.

Don’t have to pre-allocate space!

### Simple examples

There 3 ways to do the same thing in a map() function:

- Use a canned function that already exists

Let’s calculate the mean from a set of random numbers and do it 10 times

Create a vector from 1:10

``` r
1:10 # a vector from 1 to 10 (we are going to do this 10 times)
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

for each time 1:10 make a vector of 15 random numbers based on a normal
distribution

``` r
1:10 %>% # the vector to iterate over
  map(rnorm, n = 15) # calculate 15 random numbers based on a normal distribution in a list
```

    ## [[1]]
    ##  [1]  0.58757748  0.97449129  0.01338833  2.64075538  0.82703426  0.71637717
    ##  [7]  1.59454705  1.94133016  0.52284470  1.08941375 -0.04330673  2.73636416
    ## [13]  1.02101234  2.20305869  2.36243900
    ## 
    ## [[2]]
    ##  [1]  1.19048633  0.49543045  1.33851000  1.40578540  1.16256648  2.11867239
    ##  [7]  1.25263369 -0.07458166  1.37642892  1.46384709  0.73682420  1.19983312
    ## [13]  1.49682294  3.33329242  2.02953129
    ## 
    ## [[3]]
    ##  [1] 2.462732 1.993173 2.649870 3.313035 3.043933 3.803542 4.264103 2.841016
    ##  [9] 2.945389 3.344194 2.094057 3.356964 2.645344 2.146258 3.663012
    ## 
    ## [[4]]
    ##  [1] 3.204780 3.444658 4.563137 4.184088 6.280682 3.191079 3.228366 5.178786
    ##  [9] 2.899349 2.064885 3.279701 3.393093 4.268045 5.141001 3.257895
    ## 
    ## [[5]]
    ##  [1] 6.433861 5.309834 5.156076 5.371306 5.355098 4.692690 5.057824 4.749358
    ##  [9] 4.539146 4.815834 3.527174 5.407196 5.361475 7.502760 5.462701
    ## 
    ## [[6]]
    ##  [1] 6.234502 5.462135 7.499346 7.294226 6.800224 8.366989 6.410239 6.216965
    ##  [9] 6.227219 7.026828 4.535478 6.029891 7.105849 6.929823 6.535942
    ## 
    ## [[7]]
    ##  [1] 7.806296 7.329496 6.620751 6.093286 5.939230 7.395762 7.038608 7.776551
    ##  [9] 7.631929 7.291829 6.496137 5.339572 6.377684 5.727140 4.821136
    ## 
    ## [[8]]
    ##  [1] 7.818894 9.198845 6.886956 6.883451 7.567101 8.258975 7.935095 7.994581
    ##  [9] 9.061128 8.664720 8.624438 6.065093 8.779901 9.236258 8.484838
    ## 
    ## [[9]]
    ##  [1]  8.099244  7.065419  9.268552  7.669786  9.222675  9.311100  7.222241
    ##  [8]  8.043257  9.307255 10.686015  9.491164  8.263855  9.757309  9.313620
    ## [15]  8.552809
    ## 
    ## [[10]]
    ##  [1]  9.525714  8.779575 10.273939  9.653333  9.089441  8.472437  8.529247
    ##  [8]  9.499641  9.670919  8.701721  8.467349 10.611650 10.377358  9.732462
    ## [15] 10.016402

Calculate the mean from each list

``` r
1:10 %>% # the vector to iterate over
  map(rnorm, n = 15)  %>% # calculate 15 random numbers based on a normal distribution in a list 
  map_dbl(mean) # calculate the mean (canned function that already exists). It is now a vector which is type "double"
```

    ##  [1] 0.8095034 2.1644808 2.8928770 3.8586289 4.6506227 6.0280015 6.9694718
    ##  [8] 7.6777437 8.5627788 9.7493447

### Same thing different notation

``` r
1:10 %>% # list 1:10
  map(function(x) rnorm(15, x)) %>% # make your own function
  map_dbl(mean)
```

    ##  [1]  0.8485396  2.4553998  3.4182204  4.1002691  4.8608683  5.7295191
    ##  [7]  7.4685600  7.9906706  8.6387362 10.0279730

Use a formula when you want to change the arguments within the function

``` r
1:10 %>%
  map(~ rnorm(15, .x)) %>% # changes the arguments inside the function
  # using the ~ and the .x is used to represent the 'i'
  map_dbl(mean)
```

    ##  [1] 1.065706 2.192747 3.515863 3.869741 5.165262 5.857324 6.977956 8.001746
    ##  [9] 9.238539 9.919209

### Bring in files using purrr instead of a for loop

First find the files

``` r
# point to the location on the computer of the folder
CondPath <- here("Week15", "Data", "cond_data")
files <- dir(path = CondPath,pattern = ".csv")
files
```

    ## [1] "011521_CT316_1pcal.csv" "011621_CT316_1pcal.csv" "011721_CT354_1pcal.csv"

Or, we can get the full file names in one less step by doing this…

``` r
files <- dir(path = CondPath, pattern = ".csv", full.names = TRUE)
# full names = TRUE gives the entire path for each one, so save the entire path name
files
```

    ## [1] "/Users/micachapuis/GitHub/OCN 682/Chapuis/Week15/Data/cond_data/011521_CT316_1pcal.csv"
    ## [2] "/Users/micachapuis/GitHub/OCN 682/Chapuis/Week15/Data/cond_data/011621_CT316_1pcal.csv"
    ## [3] "/Users/micachapuis/GitHub/OCN 682/Chapuis/Week15/Data/cond_data/011721_CT354_1pcal.csv"

Next, read in the files using map instead of a for loop while retaining
the filename as a column.

``` r
data <- files %>% # what we're iterating over, the full path to each file
          set_names()%>% # sets the id of each list to the file name
          map_df(read_csv, .id = "filename") # map everything to a dataframe and put the id in a column called filename
```

    ## Rows: 1474 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 874 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 1004 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
data
```

    ## # A tibble: 3,352 × 4
    ##    filename                             date                Temperature Salinity
    ##    <chr>                                <dttm>                    <dbl>    <dbl>
    ##  1 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:24:40        23.3     34.8
    ##  2 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:24:50        23.3     34.6
    ##  3 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:25:00        23.3     34.9
    ##  4 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:25:10        23.3     34.7
    ##  5 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:25:20        23.3     34.5
    ##  6 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:25:30        23.3     34.4
    ##  7 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:25:40        23.3     34.3
    ##  8 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:25:50        23.3     34.3
    ##  9 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:26:00        23.3     34.2
    ## 10 /Users/micachapuis/GitHub/OCN 682/C… 2021-01-15 08:26:10        23.3     34.1
    ## # ℹ 3,342 more rows

Now we have a regular dataframe and we can calculate means in the way we
already know how! group_by filename and use summarize

``` r
data <- files %>%
          set_names()%>% # set's the id of each list to the file name
          map_df(read_csv,.id = "filename") %>% # map everything to a dataframe and put the id in a column called filename
          group_by(filename) %>% # pipe into whatever other code we need to use
          summarise(mean_temp = mean(Temperature, na.rm = TRUE),
                    mean_sal = mean(Salinity,na.rm = TRUE))
```

    ## Rows: 1474 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 874 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 1004 Columns: 3
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl  (2): Temperature, Salinity
    ## dttm (1): date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
data
```

    ## # A tibble: 3 × 3
    ##   filename                                                    mean_temp mean_sal
    ##   <chr>                                                           <dbl>    <dbl>
    ## 1 /Users/micachapuis/GitHub/OCN 682/Chapuis/Week15/Data/cond…      29.2     33.7
    ## 2 /Users/micachapuis/GitHub/OCN 682/Chapuis/Week15/Data/cond…      29.7     33.3
    ## 3 /Users/micachapuis/GitHub/OCN 682/Chapuis/Week15/Data/cond…      29.2     33.0

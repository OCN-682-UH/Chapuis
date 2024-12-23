Good Plot/Bad Plot
================
Micaela Chapuis

- [Assignment Details](#assignment-details)
- [Load Libraries](#load-libraries)
- [Load Data](#load-data)
- [Cleaning Data](#cleaning-data)
- [Bad Plot](#bad-plot)
- [Good Plot](#good-plot)

## Assignment Details

Your homework is to create two version of similar plots, using any
dataset you choose. You must create the plots using ggplot2,
post-processing with Adobe Illustrator or similar is not allowed. This
homework is a contest, and the winner will win a prize to be disclosed.

Please submit your homework by posting a markdown document containing
the plots, the code you used to create them, and your discussion of the
plot within the markdown doc to github. Data also needs to be submitted.

The first plot should be as bad as possible. Your reading from Claus
Wilke’s and Healy’s textbook describe the many ways that a plot can
become misleading, difficult to interpret, or or just plain ugly, and
you should use all of the tools that you can. Please try to make me, a
person who cares a great deal about high-quality data visualization,
cry.

You should explain in text all of the ways in which the bad plot is bad.
Bullet points are fine, but clearly articulate each principle of data
visualization that you have broken.

The second plot should be based on the same or similar data to the first
plot, but it should be good. Write briefly about why this is a
successful plot.

## Load Libraries

``` r
library(tidyverse)
library(here)
library(janitor)
library(extrafont)
library(magick)
library(ggmap)
library(ggspatial)
```

Load fonts

``` r
# font_import() # this takes a while to run
loadfonts()
```

## Load Data

[Data
source](https://data.cityofnewyork.us/Environment/2018-Central-Park-Squirrel-Census-Squirrel-Data/vfnx-vebw/about_data)

``` r
squirrels <- read_csv(here("GoodPlot_BadPlot", "Data", "centralpark_squirrels.csv")) %>% glimpse()
```

    ## Rows: 3,023
    ## Columns: 31
    ## $ X                                            <dbl> -73.95613, -73.96886, -73…
    ## $ Y                                            <dbl> 40.79408, 40.78378, 40.77…
    ## $ `Unique Squirrel ID`                         <chr> "37F-PM-1014-03", "21B-AM…
    ## $ Hectare                                      <chr> "37F", "21B", "11B", "32E…
    ## $ Shift                                        <chr> "PM", "AM", "PM", "PM", "…
    ## $ Date                                         <dbl> 10142018, 10192018, 10142…
    ## $ `Hectare Squirrel Number`                    <dbl> 3, 4, 8, 14, 5, 3, 2, 2, …
    ## $ Age                                          <chr> NA, NA, NA, "Adult", "Adu…
    ## $ `Primary Fur Color`                          <chr> NA, NA, "Gray", "Gray", "…
    ## $ `Highlight Fur Color`                        <chr> NA, NA, NA, NA, "Cinnamon…
    ## $ `Combination of Primary and Highlight Color` <chr> "+", "+", "Gray+", "Gray+…
    ## $ `Color notes`                                <chr> NA, NA, NA, "Nothing sele…
    ## $ Location                                     <chr> NA, NA, "Above Ground", N…
    ## $ `Above Ground Sighter Measurement`           <chr> NA, NA, "10", NA, NA, NA,…
    ## $ `Specific Location`                          <chr> NA, NA, NA, NA, "on tree …
    ## $ Running                                      <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ Chasing                                      <lgl> FALSE, FALSE, TRUE, FALSE…
    ## $ Climbing                                     <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ Eating                                       <lgl> FALSE, FALSE, FALSE, TRUE…
    ## $ Foraging                                     <lgl> FALSE, FALSE, FALSE, TRUE…
    ## $ `Other Activities`                           <chr> NA, NA, NA, NA, NA, NA, N…
    ## $ Kuks                                         <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ Quaas                                        <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ Moans                                        <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ `Tail flags`                                 <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ `Tail twitches`                              <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ Approaches                                   <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ Indifferent                                  <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ `Runs from`                                  <lgl> FALSE, FALSE, FALSE, TRUE…
    ## $ `Other Interactions`                         <chr> NA, NA, NA, NA, NA, NA, N…
    ## $ `Lat/Long`                                   <chr> "POINT (-73.9561344937861…

## Cleaning Data

Cleaning column names

``` r
squirrels <- clean_names(squirrels) # makes column names separated by _ and lowercase
```

Selecting data, recoding NAs, creating combined color column

``` r
squirrels <- squirrels %>% select(x, y, primary_fur_color, highlight_fur_color) %>%  # pick specific columns
                           rename(longitude = x, # rename x and y to long and lat
                                  latitude = y) %>%
  mutate_at(c('primary_fur_color','highlight_fur_color'), ~replace_na(.,"Unknown")) %>% # change all the NAs at those columns to "unknown" 
  mutate(combined_colors = str_c(primary_fur_color, highlight_fur_color, sep = "+")) # create column that combines primary fur color with highlight fur colors
```

Recoding colors + shuffling them

``` r
squirrels$combined_colors <- squirrels$combined_colors %>% 
                      str_replace_all(c("Black"="B", "White"="W", "Cinnamon"="C", "Gray"="G", "Unknown" = "U")) %>% # in combined colors column, recode all colors to be just their initial
                      factor() %>% # make them factors
                      fct_shuffle() # organize them randomly
```

## Bad Plot

``` r
squirrels %>% 
  ggplot(aes(x = combined_colors, 
             y = longitude, 
             color = latitude)) + 
  geom_jitter() + # points need to be jittered to see them better
  scale_color_gradient2(low = "#ff00c3", mid = "#4aff56", high = "#ba7548", midpoint = 40.7825)  + # creates a diverging colour gradient (low-mid-high)
  
  labs(title = "distribution of squirrels by color", # set title, labels, caption
       x = "primary and secondary fur color",
       y = "longitude",
       caption = "IN CENTRAL PARK, NYC, NY, USA",
       col = "latitude") +
  
  theme(
    # background colors
    plot.background = element_rect(fill = "honeydew2"), # general plot background
    panel.background = element_rect(fill = "peachpuff1", color = "deepskyblue4", size = 3, linetype = "dotdash"), # panel background and its border
  
    # grid lines
    panel.grid.major.x = element_line(color = "darkmagenta", linetype = "twodash"), # vertical grid lines
    panel.grid.major.y = element_line(size = 1), # major horizontal grid lines 
    panel.grid.minor.y = element_line(size = 2), # minor horizontal grid lines

    # title and caption
    plot.title = element_text(family = "Trebuchet MS", size = 30, hjust = 1, color = "purple1"), # title
    plot.caption = element_text(family = "Arial Narrow", face = "italic", size = 8, angle = -15, color = "sienna1"), # caption
    
    # axis titles and text
    axis.title = element_text(family = "Brush Script MT", face = "bold.italic", color = "seagreen4", size = 20), # axis titles
    axis.text.y = element_text(family = "Comic Sans MS", face = "italic", size = 15), # y axis text
    axis.text.x = element_text(family = "Papyrus", size = 10,  angle = 45, hjust = .5), # x axis text
    
    # axis ticks lines
    axis.ticks = element_line(color = "plum3", linetype = "dotted", size = 1), # axis tick lines
    axis.ticks.length = unit(0.5, "cm"), # axis tick lines length

    # legend
    legend.background = element_rect(fill = "goldenrod3", color = "black"), # legend background and border
    legend.direction = "horizontal", # color bar is horizontal
    legend.position = "left", # on the left of the plot
    legend.justification = "top", # aligned with the top of the plot
    legend.title = element_text(family = "Impact", color = "snow3", angle = -90), # legend title
    legend.text = element_text(family = "Verdana", face = "italic", color = "yellow4"))  # legend text 
```

``` r
ggsave(here("GoodPlot_BadPlot", "Output", "notfinal_badplot.jpeg"))
```

``` r
squirrel_pic <- image_read(here("GoodPlot_BadPlot", "Data", "squirrel_pic.jpeg")) # load in squirrel pic
squirrel_plot<-image_read(here("GoodPlot_BadPlot", "Output", "notfinal_badplot.jpeg"))
badplot <- image_composite(squirrel_plot, squirrel_pic, offset = "+0+830")

badplot
```

<img src="GoodPlotBadPlot_files/figure-gfm/unnamed-chunk-8-1.png" width="2099" />

``` r
image_write(badplot, here("GoodPlot_BadPlot", "Output", "badplot.jpeg"))
```

#### What is wrong with this plot?

**Where do I start?**  
*Aesthetics:*  
- used multiple different fonts (and mostly bad fonts), sizes, colors,
and faces for the different text parts  
- everything is lowercase (except for caption, which is all uppercase)  
- vertical gridline is a dark color which distracts from the actual
data  
- latitude color gradient is not representative of a continuous
variable, goes through 3 different colors that are all very different  
- minor horizontal gridlines are thicker than major horizontal
gridlines  
- using many different line types (axis tick lines, plot border,
vertical gridline)  
- legend numbers are a similar color to legend background, making it
hard to see  
- there are no spaces between legend numbers, making it look like one
continuous number  
- legend title faces a different direction than other text at 90°
angle  
- there is a picture of a shocked squirrel (and he’s not even lookin at
the graph!)  
- everything else makes the plot so small that you can’t tell which
points belong to which column when there are a lot

*Data Interpretation*  
- there is no legend for the color names (x axis). Are squirrels
**G**rey or **G**reen? Is B **B**lack or **B**rown? What does C even
mean? **C**yan? (it actually means **C**innamon!)  
- primary colors are not grouped together, which makes it harder to
compare how many squirrels of each primary color there are (btw
secondary colors are also not grouped together)  
- longitude is on the y axis, which is not where you would expect it to
be  
- latitude is a color gradient  
- because Central Park is on a diagonal (relative to North-South) and
latitude is a color gradient, we are highlighting the relationship
between longitude and latitude as the takeaway of the plot, which is not
the point of the plot (if you look at good plot map, squirrels in more
southern latitudes are further west because of the shape of the park,
and viceversa)

## Good Plot

``` r
# Make a data frame of Central Park long and lat coordinates 
central_park <- data.frame(lon = -73.968285, lat = 40.782)

# Get base layer centered at those coordinates, zoom in, and choose maptype
squirrel_map <- get_map(central_park, zoom = 14, maptype = "stamen_terrain_background", source = "stadia") 
```

``` r
ggmap(squirrel_map) +  # plot map of Central Park made above
       geom_point(data = squirrels, # add squirrel data as points
                  aes(x = longitude, 
                      y = latitude, 
                      color = primary_fur_color), # color by fur color
                  size = 1,
                  alpha = 0.6) + 
  
  # add titles and labels
       labs(title = "Distribution of Squirrel Observations by Fur Color", 
            subtitle = "Central Park, 2018",
            x = "Longitude",
            y = "Latitude",
            color = "Fur Color") +
  
  
  # set aesthetics
  scale_color_manual(values = c("black", "darkorange4", "honeydew4", "maroon1")) + # set colors to match fur colors
  guides(color = guide_legend(override.aes = list(size=10))) + # make points on the legend bigger
  theme_bw() + 
  theme(legend.title = element_text(size = 14, face = "bold"), # set text sizes
        legend.text = element_text(size = 13),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 10),
        plot.title = element_text(size = 15, face = "bold"),
        plot.subtitle = element_text(size = 14)) +
  
  # add scale bar
       annotation_scale(bar_cols = c("grey10", "white"), # add scale bar, make colors dark grey and white
                        location = "tl",  # put it in the top left
                        text_col = "white") + # make text color white so it can be seen
  
  # add North arrow
       annotation_north_arrow(location = "bl",# add a north arrow in bottom left
                              height = unit(1.5, "cm"), # set size
                              width = unit(1.5, "cm"),
                              style = north_arrow_fancy_orienteering(text_col = 'black', # set type of arrow and   colors for all its parts
                                                                     line_col = 'black',
                                                                     fill = 'white')) +
       coord_sf(crs = 4326) # necessary crs for scale bar to work
```

![](GoodPlotBadPlot_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

``` r
ggsave(here("GoodPlot_BadPlot", "Output", "goodplot.jpeg"))
```

#### Why is this plot good?

- used latitude and longitude properly, to make a map  
- latitude is on the y axis and longitude is on the x axis  
- map includes north arrow and scale bar  
- point color corresponds to squirrel fur color  
- all text is the same font and either black or gray  
- only the important information is on the plot (where squirrels were
  seen and what color they were)  
- the chosen base map shows Central Park and where water is within it
  (which helps explain squirrel observation distributions) with no other
  irrelevant information that could obscure the data

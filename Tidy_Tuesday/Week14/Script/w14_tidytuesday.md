W14 Tidy Tuesday
================
Micaela Chapuis
2024-11-27

## Load Libraries

``` r
library(tidyverse)
library(cowsay)
```

## Load Data

``` r
cbp_resp <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-11-26/cbp_resp.csv')
```

## Data Wrangling

First, I want to see which of areas of responsibility have fewer
countries of citizenship observed so I’m not working with such a huge
dataset (you’ll thank me later)

``` r
cbp_resp %>% 
  group_by(area_of_responsibility) %>% # for each area of resp
  summarize(count = length(unique(citizenship))) %>%  # how many unique countries were observed
  view() # open it because it's long
```

Now, focusing on our specific area of responsibility (Spokane Sector,
because it has the fewest countries observed), I want to see how many
individuals encountered are from each country

``` r
data <- cbp_resp %>% 
        filter(area_of_responsibility == "Spokane Sector") %>% # filter to only see encounters in Spokane
        select(citizenship, encounter_count) %>% # keep only the columns I care about
        group_by(citizenship) %>% # group by country of citizenship
        summarize(encounter_count = sum(encounter_count)) # add up number of individuals encountered from each country 
```

Rename China

``` r
data$citizenship <- str_replace(data$citizenship, "CHINA, PEOPLES REPUBLIC OF", "PEOPLES REPUBLIC OF CHINA")
```

## Output!

My new thing this week is using the ‘cowsay’ package (and the sample
function too I guess). I will have a randomly chosen animal say “country
of citizenship: \# individuals” for each of the countries of citizenship
identified (only 13 countries in Spokane so it doesn’t get too crazy)

``` r
for(i in 1:nrow(data)){  # for each row of the df data
  animal_chosen <- sample(names(animals), 1) # pick a random animal name from the list of possible cowsay animals and store it into "animal_chosen"
  say(what = paste0(data$citizenship[i], ": ", data$encounter_count[i]), # say the country of citizenship at that row, then ": " and then the number of encounters at that row
      by = animal_chosen) # the randomly chosen animal who gets to say that
}
```

    ## 
    ##  ----- 
    ## CANADA: 36 
    ##  ------ 
    ##     \   
    ##      \
    ##      (   )
    ##   (   ) (
    ##    ) _   )
    ##     ( \_
    ##   _(_\ \)__
    ##  (____\ ___)) [nosig]
    ##  ------------- 
    ## PEOPLES REPUBLIC OF CHINA: 2 
    ##  -------------- 
    ##               \   
    ##                \  
    ##                 \
    ##                .--.
    ##               /} p \             /}
    ##              `~)-) /           /` }
    ##               ( / /          /`}.' }
    ##                / / .-'""-.  / ' }-'}
    ##               / (.'       \/ '.'}_.}
    ##              |            `}   .}._}
    ##              |     .-=-';   } ' }_.}
    ##              \    `.-=-;'  } '.}.-}
    ##               '.   -=-'    ;,}._.}
    ##                 `-,_  __.'` '-._}
    ##               jgs   `|||
    ##                    .=='=,
    ## 
    ##  -------------- 
    ## COLOMBIA: 6 
    ##  --------------
    ##     \
    ##       \
    ##         \
    ##      /\-/\
    ##     /a a  \                                 _
    ##    =\ Y  =/-~~~~~~-,_______________________/ )
    ##      ‛^--‛          ________________________/
    ##        \           /
    ##        ||  |---‛\  \
    ##   jgs  (_(__|   ((__|
    ##   
    ##             ------ 
    ##            ECUADOR: 3 
    ##             ------ 
    ##                \   
    ##                 \  
    ##                  \
    ##      .-'          
    ## '--./ /     _.---.
    ## '-,  (__..-`       \
    ##    \          .     |
    ##     `,.__.   ,__.--/
    ##      '._/_.'___.-`
    ## 
    ##  ------------- 
    ## EL SALVADOR: 7 
    ##  -------------- 
    ##               \   
    ##                \  
    ##                 \
    ##                .--.
    ##               /} p \             /}
    ##              `~)-) /           /` }
    ##               ( / /          /`}.' }
    ##                / / .-'""-.  / ' }-'}
    ##               / (.'       \/ '.'}_.}
    ##              |            `}   .}._}
    ##              |     .-=-';   } ' }_.}
    ##              \    `.-=-;'  } '.}.-}
    ##               '.   -=-'    ;,}._.}
    ##                 `-,_  __.'` '-._}
    ##               jgs   `|||
    ##                    .=='=,
    ## 
    ##  -------------- 
    ## GUATEMALA: 53 
    ##  --------------
    ##     \
    ##       \
    ##         \
    ##           _____
    ##        .'` ,-. `'.
    ##       /   ([ ])   \
    ##      /.-""`(`)`""-.\
    ##       <'```(.)```'>
    ##       <'```(.)```'>
    ##        <'``(.)``'>
    ##    sk   <``\_/``>
    ##          `'---'`
    ##   
    ##  ----- 
    ## HONDURAS: 43 
    ##  ------ 
    ##     \   
    ##      \
    ##          _
    ##        _/ }
    ##       `>' \
    ##       `|   \
    ##        |   /'-.     .-.
    ##         \'     ';`--' .'
    ##          \'.    `'-./
    ##           '.`-..-;`
    ##             `;-..'
    ##             _| _|
    ##             /` /` [nosig]
    ##   
    ##               ------ 
    ##              INDIA: 18 
    ##               ------ 
    ##                   \   
    ##                    \  
    ##                     \
    ##                     .
    ##                    / V\
    ##                   / `  /
    ##                  <<   |
    ##                  /    |
    ##                /      |
    ##              /        |
    ##            /    \  \ /
    ##           (      ) | |
    ##   ________|   _/_  | |
    ## <__________\______)\__)
    ##  ------------- 
    ## MEXICO: 472 
    ##  -------------- 
    ##               \   
    ##                \  
    ##                 \
    ## _____________________                              _____________________
    ## `-._                 \           |\__/|           /                 _.-'
    ##     \                 \          |    |          /                 /
    ##      \                 `-_______/      \_______-'                 /
    ##       |                                                          |
    ##       |                                                          |
    ##       |                                                          |
    ##       /                                                          \
    ##      /_____________                                  _____________\
    ##                    `----._                    _.----'
    ##                           `--.            .--'
    ##                               `-.      .-'
    ##                                  \    / :F_P:
    ##                                   \  /
    ##                                    \/
    ## 
    ##  ----- 
    ## NICARAGUA: 7 
    ##  ------ 
    ##     \   
    ##      \
    ##     .ﾊ,,ﾊ
    ##     ( ﾟωﾟ)
    ##     |つ  つ
    ##     U " U
    ##         [BoingBoing]
    ##     
    ##  ----- 
    ## OTHER: 34 
    ##  ------ 
    ##     \   
    ##      \  
    ##       \
    ##          __
    ##         /o \
    ##       <=   |         ==
    ##         |__|        /===
    ##         |   \______/  =
    ##         \     ====   /
    ##          \__________/     [ab]
    ##              ------ 
    ##           ROMANIA: 11 
    ##              ------ 
    ##                  \   
    ##                   \  
    ##                    \
    ##                       . .     
    ##                       |\|\_   
    ##                       /  @ \  
    ##                      /  _-_/° 
    ##    \\\\\\\\\       /   / \    
    ##   ////////////   /  \ / ||    
    ##  \\\\\\\\\\\\\\ /   /\\ \\    
    ## ////////////////   /  \\ \\   
    ##  \\\\\\\\\\\\\/   /  / `` ``  
    ##      /////////   \  /  \      
    ##  ML     \\\\\\___/_/___/      
    ## 
    ##  -------------- 
    ## VENEZUELA: 2 
    ##  --------------
    ##     \
    ##       \
    ##         \
    ##         /\_/\         _
    ##        /``   \       / )
    ##        |n n   |__   ( (
    ##       =(Y =.‛`   `\  \ \
    ##       {`"`        \  ) )
    ##       {       /    |/ /
    ##        \\   ,(     / /
    ##         ) ) /-‛\  ,_.‛
    ##   jgs  (,(,/ ((,,/
    ## 

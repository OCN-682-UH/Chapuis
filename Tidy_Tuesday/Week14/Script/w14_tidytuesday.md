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
    ##       \
    ##        /\___/\
    ##        {o}{o}|
    ##        \ v  /|
    ##        |    \ \
    ##         \___/_/       [ab] 
    ##           | | 
    ## 
    ##  ----- 
    ## CHINA, PEOPLES REPUBLIC OF: 2 
    ##  ------ 
    ##     \   
    ##      \
    ##      _[_]_
    ##       (")
    ##   >--( : )--<
    ##     (__:__) [nosig]
    ##   
    ##  ----- 
    ## COLOMBIA: 6 
    ##  ------ 
    ##     \   
    ##      \
    ##     .ﾊ,,ﾊ
    ##     ( ﾟωﾟ)
    ##     |つ  つ
    ##     U " U
    ##         [BoingBoing]
    ##     
    ##  -------------- 
    ## ECUADOR: 3 
    ##  --------------
    ##     \
    ##      \
    ##       \
    ##          /\_/\
    ##         ( o.o )
    ##          > ^ <      [nosig]
    ## 
    ##              ------ 
    ##           EL SALVADOR: 7 
    ##              ------ 
    ##                  \   
    ##                   \  
    ##                    \
    ##                       . .     
    ##                       |\|\_   
    ##                       /  ^ \  
    ##                      /  _-_/° 
    ##    \\\\\\\\\       /   / \    
    ##   ////////////   /  \ / ||    
    ##  \\\\\\\\\\\\\\ /   /\\ \\    
    ## ////////////////   /  \\ \\   
    ##  \\\\\\\\\\\\\/   /  / `` ``  
    ##      /////////   \  /  \      
    ##  ML     \\\\\\___/_/___/      
    ## 
    ## 
    ##  ----- 
    ## GUATEMALA: 53 
    ##  ------ 
    ##     \   
    ##      \   __
    ##    / \
    ##    | |
    ##    @ @
    ##   || ||
    ##   || ||
    ##   |\_/|
    ##   \___/ GB
    ## 
    ##  ----- 
    ## HONDURAS: 43 
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
    ## 
    ##  ----- 
    ## INDIA: 18 
    ##  ------ 
    ##     \   
    ##      \
    ##                   ___
    ##                ___)__|_
    ##           .-*'          '*-,
    ##          /      /|   |\     \
    ##         ;      /_|   |_\     ;
    ##         ;   |\           /|  ;
    ##         ;   | ''--...--'' |  ;
    ##          \  ''---.....--''  /
    ##           ''*-.,_______,.-*'  [nosig]
    ##   
    ##  ------------- 
    ## MEXICO: 472 
    ##  -------------- 
    ##               \   
    ##                \  
    ##                 \
    ##         __.--'\     \.__./     /'--.__
    ##     _.-'       '.__.'    '.__.'       '-._
    ##   .'                                      '.
    ##  /                                          \
    ## |                                            |
    ## |                                            |
    ##  \         .---.              .---.         /
    ##   '._    .'     '.''.    .''.'     '.    _.'
    ##      '-./            \  /           \.-'
    ##                       ''mrf
    ## 
    ##  ------------- 
    ## NICARAGUA: 7 
    ##  -------------- 
    ##               \   
    ##                \  
    ##                 \
    ## 
    ##                   .="=.
    ##                 _/.-.-.\_     _
    ##                ( ( o o ) )    ))
    ##                 |/  "  \|    //
    ##                  \'---'/    //
    ##            jgs   /`"""`\\  ((
    ##                 / /_,_\ \\  \\
    ##                 \_\_'__/  \  ))
    ##                 /`  /`~\   |//
    ##                /   /    \  /
    ##           ,--`,--'\/\    /
    ##           '-- "--'  '--'
    ## 
    ##  ----- 
    ## OTHER: 34 
    ##  ------ 
    ##     \   
    ##      \
    ##       ( )_( )
    ##       (='.'=)
    ##       (^)_(^) [nosig]
    ##   
    ##  ------ 
    ## ROMANIA: 11 
    ##  ------ 
    ##  \   
    ##   \  
    ##    \
    ## 
    ##    .-~~^-.
    ##  .'  O    \
    ## (_____,    \
    ##  `----.     \
    ##        \     \
    ##         \     \
    ##          \     `.             _ _
    ##           \       ~- _ _ - ~       ~ - .
    ##            \                              ~-.
    ##             \                                `.
    ##              \    /               /           \
    ##               `. |         }     |         }    \
    ##                 `|        /      |        /       \
    ##                  |       /       |       /          \
    ##                  |      /`- _ _ _|      /.- ~ ^-.     \
    ##                  |     /         |     /          `.    \
    ##                  |     |         |     |             -.   ` . _ _ _ _ _ _
    ##                  |_____|         |_____|                ~ . _ _ _ _ _ _ _ >
    ## 
    ##  ----- 
    ## VENEZUELA: 2 
    ##  ------
    ##     \          ,'``.._   ,'``.
    ##      \        :,--._:)\,:,._,.:
    ##       \       :`--,''   :`...';\
    ##                `,'       `---'  `.
    ##                /                 :
    ##               /                   \
    ##             ,'                     :\.___,-.
    ##            `...,---'``````-..._    |:       \
    ##              (                 )   ;:    )   \  _,-.
    ##               `.              (   //          `'    \
    ##                :               `.//  )      )     , ;
    ##              ,-|`.            _,'/       )    ) ,' ,'
    ##             (  :`.`-..____..=:.-':     .     _,' ,'
    ##              `,'\ ``--....-)='    `._,  \  ,') _ '``._
    ##           _.-/ _ `.       (_)      /     )' ; / \ \`-.'
    ##          `--(   `-:`.     `' ___..'  _,-'   |/   `.)
    ##              `-. `.`.``-----``--,  .'
    ##                |/`.\`'        ,','); SSt
    ##                    `         (/  (/
    ## 

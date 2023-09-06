
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 28 Aug 2023

# Install and load packages-----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}

# Import and Clean Dataset -----------------------------------------------------

setwd("../../")
parent <- getwd()

setwd(paste0(parent, "/Group Word Stimuli"))

# The Name Census data was cleaned in the following order: 
# 1) Entries with (S) indicating suppressed values for confidentiality were replaced with 0
# 2) Convert rank, count, pctwhite, pctblack, pctapi, and pcthispanic to numeric
# 3) Convert names to lower case
# 4) Estimate the number of people in the racial/ethnic group that has the name
# by multiplying the total number of people in the US with the name and the pct value
# 5) Remove all names that are shorter than three characters long

names <- read.csv('surnames_2010.csv') %>% 
  mutate(across(everything(), ~replace(., . == '(S)', '0'))) %>%
  mutate_at(c('rank', 'count', 'pctwhite', 'pctblack', 'pctapi', 'pcthispanic'), as.numeric) %>%
  mutate(name = tolower(name)) %>%
  mutate(pctwhite = as.numeric(pctwhite)/100) %>%
  mutate(pctblack = as.numeric(pctblack)/100) %>%
  mutate(pcthispanic = as.numeric(pcthispanic)/100) %>%
  mutate(pctapi = as.numeric(pctapi)/100) %>%
  mutate(whitecount = count * pctwhite) %>% 
  mutate(blackcount = count * pctblack) %>% 
  mutate(hispaniccount = count * pcthispanic) %>% 
  mutate(apicount = count * pctapi)

# Compile List by Racial/Ethnic Group ------------------------------------------

# e.g. African Americans: Use the following steps to compile list of names
# 1) Filter names with pctblack value higher than 0.7
# 2) Filter out names with pctwhite value higher than 0.2
# 3) Filter out names with pctapi value higher than 0.2
# 4) Filter out names with pcthispanic value higher than 0.2
# 5) Choose the top 80 names with highest blackcount value
# 6) Manually review names in case the words are not used as names

black.names <- names %>%
  filter(pctblack > 0.7) %>% 
  filter(pctapi < 0.2) %>%
  filter(pcthispanic < 0.2) %>%
  filter(pctwhite < 0.2) %>%
  slice_max(blackcount, n = 80) %>%
  select('name')

asian.names <- names %>%
  filter(pctapi > 0.7) %>% 
  filter(pctblack < 0.2) %>%
  filter(pcthispanic < 0.2) %>%
  filter(pctwhite < 0.2) %>%
  slice_max(apicount, n = 80) %>%
  select('name')

hispanic.names <- names %>%
  filter(pcthispanic > 0.7) %>%
  filter(pctblack < 0.2) %>%
  filter(pctapi < 0.2) %>%
  filter(pctwhite < 0.2) %>%
  slice_max(hispaniccount, n = 80) %>%
  select('name')

white.names <- names %>%
  filter(pctwhite > 0.7) %>% 
  filter(pctblack < 0.2) %>%
  filter(pctapi < 0.2) %>%
  filter(pcthispanic < 0.2) %>%
  slice_max(whitecount, n = 80) %>%
  select('name')

# Write the Lists as .csv Files ------------------------------------------------

# Navigate the names_70_20 subfolder inside the names folder
setwd(paste0(parent, "/Group Word Stimuli/Names7020"))

write.csv(black.names, 'black_names.csv', quote = FALSE, row.names = FALSE)
write.csv(asian.names, 'asian_names.csv', quote = FALSE, row.names = FALSE)
write.csv(hispanic.names, 'hispanic_names.csv', quote = FALSE, row.names = FALSE)
write.csv(white.names, 'white_names.csv', quote = FALSE, row.names = FALSE)


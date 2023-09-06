
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 28 Aug 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}

# Import and Clean Dataset -----------------------------------------------------

# We use the Racial Distinctiveness data set created by Elder & Hayes, 2023
# The data set can be found: 
# https://dataverse-harvard-edu.libproxy.wustl.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/0LCYN5
names <- read.csv('nameratings.csv') %>%
  select(c("name", "race", "distinct")) %>% 
  mutate(name = tolower(name))

# Import the word embedding model to automatically check if the names
# have projections in the word embedding model
setwd("../../")
parent <- getwd()

setwd(paste0(parent, "/Meta Analysis"))
load("meta.RData")

# Compile List by Racial/Ethnic Group ------------------------------------------

black.names <- names %>%
  filter(name %in% rownames(coca_embed)) %>% 
  filter(race == "black") %>% 
  slice_max(distinct, n = 35) %>%
  select(name)

asian.names <- names %>%
  filter(name %in% rownames(coca_embed)) %>% 
  filter(race == "asian") %>% 
  slice_max(distinct, n = 35) %>%
  select(name)

hispanic.names <- names %>%
  filter(name %in% rownames(coca_embed)) %>% 
  filter(race == "hispanic") %>% 
  slice_max(distinct, n = 35) %>%
  select(name)

white.names <- names %>%
  filter(name %in% rownames(coca_embed)) %>% 
  filter(race == "white") %>% 
  slice_max(distinct, n = 35) %>%
  select(name)

# Write the Lists as .csv Files ------------------------------------------------

setwd(paste0(parent, "/Supplemental Materials/Distinct First Names"))

write.csv(black.names, 'black_names.csv', quote = FALSE, row.names = FALSE)
write.csv(asian.names, 'asian_names.csv', quote = FALSE, row.names = FALSE)
write.csv(hispanic.names, 'hispanic_names.csv', quote = FALSE, row.names = FALSE)
write.csv(white.names, 'white_names.csv', quote = FALSE, row.names = FALSE)


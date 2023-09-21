
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 27 Aug 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("meta")){install.packages("meta", dependencies = TRUE); require("meta")}

# Set random seed
set.seed(1048596)

# Define Function to Perform Meta-Regression -----------------------------------

# NOTE: The output of this code is more readable when run in Terminal

# compare_category() is the function to perform meta-regressions
# The first argument is the data frame of effect sizes (effect_df)
# The second argument is the type of text of interest (genre)

compare_category <- function(effect_df, genre){
  
  # Dummy code the category variable of the effect_df dataframe
  # If the effect sizes correspond to the type of text of interest, 
  # re-code category variable as 1. If not, re-coded category variable as 0. 
  temp <- effect_df %>% mutate(category = ifelse(category == genre, 1, 0))

  # Perform meta-regression using meta object (temp.gen)
  temp.gen <- metagen(TE = yi,
                      seTE = sei,
                      data = temp,
                      fixed = FALSE,
                      random = TRUE)
  temp.reg <- metareg(temp.gen, ~ category)

  # If p-value is smaller than 0.05, print star next to p-value
  if(temp.reg$pval[2] >= 0.05){pvalue = round(temp.reg$pval[2], 4)}
  else{pvalue = paste(round(temp.reg$pval[2], 4), "**")}

  message(paste(genre, ":", 
              round(temp.reg$beta[2], 4), 
              round(temp.reg$zval[2], 4), 
              pvalue))
  
}

# Load Data --------------------------------------------------------------------

# Load group word stimuli
parent <- getwd()
setwd(paste0(parent, "/Results"))

# Load WEAT Ds calculated using ALC embeddings 
# and mutate the category variable to indicate the type of text the WEAT Ds belong to
acad = read.csv('acad_weat_results.csv') %>% mutate(category = "acad")
blog = read.csv('blog_weat_results.csv') %>% mutate(category = "blog")
fic = read.csv('fic_weat_results.csv') %>% mutate(category = "fic")
mag = read.csv('mag_weat_results.csv') %>% mutate(category = "mag")
news = read.csv('news_weat_results.csv') %>% mutate(category = "news")
spok = read.csv('spok_weat_results.csv') %>% mutate(category = "spok")
tvm = read.csv('tvm_weat_results.csv') %>% mutate(category = "tvm")
web = read.csv('web_weat_results.csv') %>% mutate(category = "web")

# Define the types of text we are interested in
category_list = c("acad", "blog", "fic", "mag", "news", "spok", "tvm", "web")

separator <- function(){message(cat(paste(rep("-", 45), collapse= "")))}

# Superiority Tests ------------------------------------------------------------

# Concatenate all WEAT D scores as a single dataframe 
# Calculate standard error from the confidence interval (sei)
superior <- rbind(acad, blog, fic, mag, news, spok, tvm, web) %>% 
  filter(dimension == "Superiority") %>%
  rename(yi = effect) %>%
  mutate(sei = (yi - lower)/1.96)

# Single out the data frame of effect sizes corresponding to single group comparisons
wb_superior <- superior %>% 
  filter(groups == "White v. Black people")
wa_superior <- superior %>% 
  filter(groups == "White v. Asian people")
wh_superior <- superior %>% 
  filter(groups == "White v. Hispanic people")
ab_superior <- superior %>% 
  filter(groups == "Asian v. Black people")
ah_superior <- superior %>% 
  filter(groups == "Asian v. Hispanic people")
bh_superior <- superior %>% 
  filter(groups == "Black v. Hispanic people")

# Meta-Regression (Superiority) ------------------------------------------------

separator()
print('Superiority: White v. Black people')
separator()
for(t in category_list){compare_category(wb_superior, t)}
separator()

print('Superiority: White v. Asian people')
separator()
for(t in category_list){compare_category(wa_superior, t)}
separator()

print('Superiority: White v. Hispanic people')
separator()
for(t in category_list){compare_category(wh_superior, t)}
separator()

print('Superiority: Asian v. Black people')
separator()
for(t in category_list){compare_category(ab_superior, t)}
separator()

print('Superiority: Asian v. Hispanic people')
separator()
for(t in category_list){compare_category(ah_superior, t)}
separator()

print('Superiority: Black v. Hispanic people')
separator()
for(t in category_list){compare_category(bh_superior, t)}
separator()

# Superiority Tests ------------------------------------------------------------

# Concatenate all WEAT D scores as a single dataframe 
# Calculate standard error from the confidence interval (sei)
american <- rbind(acad, blog, fic, mag, news, spok, tvm, web) %>% 
  filter(dimension == "Americanness") %>%
  rename(yi = effect) %>%
  mutate(sei = (yi - lower)/1.96)

# Single out the data frame of effect sizes corresponding to single group comparisons
wb_american <- american %>% 
  filter(groups == "White v. Black people")
wa_american <- american %>% 
  filter(groups == "White v. Asian people")
wh_american <- american %>% 
  filter(groups == "White v. Hispanic people")
ba_american <- american %>% 
  filter(groups == "Black v. Asian people")
bh_american <- american %>% 
  filter(groups == "Black v. Hispanic people")
ah_american <- american %>% 
  filter(groups == "Asian v. Hispanic people")

# Meta-Regression (Americanness) -----------------------------------------------

print('Americanness: White v. Black people')
separator()
for(t in category_list){compare_category(wb_american, t)}
separator()

print('Americanness: White v. Asian people')
separator()
for(t in category_list){compare_category(wa_american, t)}
separator()

print('Americanness: White v. Hispanic people')
separator()
for(t in category_list){compare_category(wh_american, t)}
separator()

print('Americanness: Black v. Asian people')
separator()
for(t in category_list){compare_category(ba_american, t)}
separator()

print('Americanness: Black v. Hispanic people')
separator()
for(t in category_list){compare_category(bh_american, t)}
separator()

print('Americanness: Asian v. Hispanic people')
separator()
for(t in category_list){compare_category(ah_american, t)}
separator()


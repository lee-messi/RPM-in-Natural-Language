
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 6 Sept 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("meta")){install.packages("meta", dependencies = TRUE); require("meta")}

# Set random seed
set.seed(1048596)

# Load Data --------------------------------------------------------------------

setwd("Results")

# Read in all WEAT results for individual types of text
acad = read.csv('acad_weat_results.csv')
blog = read.csv('blog_weat_results.csv')
fic = read.csv('fic_weat_results.csv')
mag = read.csv('mag_weat_results.csv')
news = read.csv('news_weat_results.csv')
spok = read.csv('spok_weat_results.csv')
tvm = read.csv('tvm_weat_results.csv')
web = read.csv('web_weat_results.csv')

# Concatenate all WEAT D scores as a single dataframe 
all_tests <- rbind(acad, blog, fic, mag, news, spok, tvm, web)

separator <- function(){message(cat(paste(rep("-", 55), collapse= "")))}

# Superiority WEAT Ds ----------------------------------------------------------

# Store type of texts as a character vector for later use
category.names <- c('Academic Text', 'Blog', 'Fiction', 'Magazines', 
                    'News Articles', 'Spoken Language', 'TV/Movie Subtitles', 'Web')
text.categories <- rep(category.names, each = 6)

# Filter test results pertaining to the superiority dimension 
# Change the variable names to use the rma() function 
superior <- all_tests %>% 
  filter(dimension == "Superiority") %>%
  mutate(category = text.categories) %>%
  rename(yi = effect) %>%
  mutate(sei = (yi - lower)/1.96) %>%
  mutate(test = paste(category, groups))

# Filter test results pertaining to the Americanness dimension 
american <- all_tests %>% 
  filter(dimension == "Americanness") %>%
  mutate(category = text.categories) %>%
  rename(yi = effect) %>%
  mutate(sei = (yi - lower)/1.96) %>%
  mutate(test = paste(category, groups))

# Superiority WEAT Ds ----------------------------------------------------------

for(j in category.names){
  separator()
  print(j)
  separator()
  for(i in unique(superior$groups)){
    superior.gen <- metagen(TE = yi, seTE = sei, studlab = category, 
                       data = superior %>% filter(groups == i) %>% filter(category == j), 
                       sm = "MD", fixed = FALSE, random = TRUE)
    message(paste(i, ":", round(summary(superior.gen)[["TE.random"]], 4), 
                round(summary(superior.gen)[["lower"]], 4), 
                round(summary(superior.gen)[["upper"]], 4)))
  }
}

# Summary Effect for Each Group Comparison (k = 8) -----------------------------

separator()
for(i in unique(superior$groups)){
  superior.gen <- metagen(TE = yi, seTE = sei, studlab = category, 
                          data = superior %>% filter(groups == i), 
                          sm = "MD", fixed = FALSE, random = TRUE)
  message(paste(i, ":", round(summary(superior.gen)[["TE.random"]], 4), 
              round(summary(superior.gen)[["lower.random"]], 4), 
              round(summary(superior.gen)[["upper.random"]], 4)))
}

# Save Summary Effect for Each Group Comparison (k = 8) ------------------------

superior_meta_df <- NULL

for(i in unique(superior$groups)){
  superior.gen <- metagen(TE = yi, seTE = sei, studlab = category, 
                          data = superior %>% filter(groups == i), 
                          sm = "MD", fixed = FALSE, random = TRUE)
  superior_meta_df <- rbind(superior_meta_df, 
                            c(summary(superior.gen)[["TE.random"]], 
                              summary(superior.gen)[["lower.random"]],
                              summary(superior.gen)[["upper.random"]]))
}

superior_meta_df <- data.frame(cbind(unique(superior$groups), superior_meta_df))
colnames(superior_meta_df) <- c('groups', 'effect', 'lower', 'upper')
write.csv(superior_meta_df, 'superior_meta_estimate.csv', row.names = FALSE, quote = FALSE)

# Summary Effect for Each Type of Text (k = 6) ---------------------------------

separator()
for(j in category.names){
  superior.gen <- metagen(TE = yi, seTE = sei, studlab = groups, 
                     data = superior %>% filter(category == j), 
                     sm = "MD", fixed = FALSE, random = TRUE)
  message(paste(j, ":", round(summary(superior.gen)[["TE.random"]], 4), 
              round(summary(superior.gen)[["lower.random"]], 4), 
              round(summary(superior.gen)[["upper.random"]], 4)))
}

# Overall Effect Size (k = 48) -------------------------------------------------

separator()
overall.superior.gen <- metagen(TE = yi, seTE = sei, studlab = test,
                                data = superior,
                                sm = "MD", fixed = FALSE, random = TRUE)
message(paste("Total:", round(summary(overall.superior.gen)[["TE.random"]], 4), 
            round(summary(overall.superior.gen)[["lower.random"]], 4), 
            round(summary(overall.superior.gen)[["upper.random"]], 4)))

# Americanness WEAT Ds ---------------------------------------------------------

for(j in category.names){
  separator()
  print(j)
  separator()
  for(i in unique(american$groups)){
    american.gen <- metagen(TE = yi, seTE = sei, studlab = category, 
                            data = american %>% filter(groups == i) %>% filter(category == j), 
                            sm = "MD", fixed = FALSE, random = TRUE)
    message(paste(i, ":", round(summary(american.gen)[["TE.random"]], 4), 
                round(summary(american.gen)[["lower"]], 4), 
                round(summary(american.gen)[["upper"]], 4)))
  }
}

# Summary Effect for Each Group Comparison (k = 8) -----------------------------

separator()
for(i in unique(american$groups)){
  american.gen <- metagen(TE = yi, seTE = sei, studlab = category, 
                          data = american %>% filter(groups == i), 
                          sm = "MD", fixed = FALSE, random = TRUE)
  message(paste(i, ":", round(summary(american.gen)[["TE.random"]], 4), 
              round(summary(american.gen)[["lower.random"]], 4), 
              round(summary(american.gen)[["upper.random"]], 4)))
}

# Save Summary Effect for Each Group Comparison (k = 8) ------------------------

american_meta_df <- NULL

for(i in unique(american$groups)){
  american.gen <- metagen(TE = yi, seTE = sei, studlab = category, 
                          data = american %>% filter(groups == i), 
                          sm = "MD", fixed = FALSE, random = TRUE)
  american_meta_df <- rbind(american_meta_df, 
                            c(summary(american.gen)[["TE.random"]], 
                              summary(american.gen)[["lower.random"]],
                              summary(american.gen)[["upper.random"]]))
}

american_meta_df <- data.frame(cbind(unique(american$groups), american_meta_df))
colnames(american_meta_df) <- c('groups', 'effect', 'lower', 'upper')
write.csv(american_meta_df, 'american_meta_estimate.csv', row.names = FALSE, quote = FALSE)

# Summary Effect for Each Type of Text (k = 6) ---------------------------------

separator()
for(j in category.names){
  american.gen <- metagen(TE = yi, seTE = sei, studlab = groups, 
                          data = american %>% filter(category == j), 
                          sm = "MD", fixed = FALSE, random = TRUE)
  message(paste(j, ":", round(summary(american.gen)[["TE.random"]], 4), 
              round(summary(american.gen)[["lower.random"]], 4), 
              round(summary(american.gen)[["upper.random"]], 4)))
}

# Overall Effect Size (k = 48) -------------------------------------------------

separator()
overall.american.gen <- metagen(TE = yi, seTE = sei, studlab = test,
                                data = american,
                                sm = "MD", fixed = FALSE, random = TRUE)
print(paste("Total:", round(summary(overall.american.gen)[["TE.random"]], 4), 
            round(summary(overall.american.gen)[["lower.random"]], 4), 
            round(summary(overall.american.gen)[["upper.random"]], 4)))



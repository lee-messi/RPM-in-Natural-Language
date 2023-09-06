
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 28 Aug 2023

# Install and load packages ----------------------------------------------------

if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("conText")){install.packages("conText", dependencies = TRUE); require("conText")}

# Load All Objects -------------------------------------------------------------

# Load ALC embeddings of group and attribute words
load('alc_embeddings.RData')

# Set random seed and move to parent directory to navigate results folder
set.seed(1048596)
setwd("Results")

# Define Function for WEAT D Calculation ---------------------------------------

# weat_score() is the function that calculates WEAT D using the ALC embeddings
weat_score <- function(group_one_dem, 
                       group_two_dem, 
                       attribute_one, 
                       attribute_two){
  
  g1.diff <- g2.diff <- NULL
  
  for(a in c(1:nrow(group_one_dem))){
    
    g1a1 <- as.numeric(text2vec::sim2(matrix(group_one_dem[a,], ncol = 300),
                                      matrix(attribute_one, ncol = 300), 
                                      method = "cosine", 
                                      norm = "l2"))
    g1a2 <- as.numeric(text2vec::sim2(matrix(group_one_dem[a,], ncol = 300),
                                      matrix(attribute_two, ncol = 300), 
                                      method = "cosine", 
                                      norm = "l2"))
    
    g1.diff <- c(g1.diff, (mean(g1a1) - mean(g1a2)))
    
  }
  
  for(b in c(1:nrow(group_two_dem))){
    
    g2a1 <- as.numeric(text2vec::sim2(matrix(group_two_dem[b,], ncol = 300),
                                      matrix(attribute_one, ncol = 300), 
                                      method = "cosine", 
                                      norm = "l2"))
    g2a2 <- as.numeric(text2vec::sim2(matrix(group_two_dem[b,], ncol = 300),
                                      matrix(attribute_two, ncol = 300),
                                      method = "cosine", 
                                      norm = "l2"))
    
    g2.diff <- c(g2.diff, (mean(g2a1) - mean(g2a2)))
    
  }

  pooled_sd = sqrt((((length(g1.diff) - 1) * sd(g1.diff)**2) + ((length(g2.diff) - 1) * sd(g2.diff)**2))/(length(g1.diff) + length(g2.diff) - 2))
  weat.d = (mean(g1.diff) - mean(g2.diff))/pooled_sd
  
  return(weat.d)
  
}

# Define Function for Permutations ---------------------------------------------

# weat_perm() function calculates the WEAT D score between two groups - 
# group_one and group_two with respect to attributes - 
# attribute_one and attribute_two. We perform 1000 permutations. 

weat_perm <- function(group.comparisons, dimensions, 
                      group_one, group_two, 
                      attribute_one, attribute_two, nperm = 1000){
  
  # Bind the DEMs of the two groups together for the permutations
  both_groups <- rbind(group_one, group_two)
  
  # Initialize Distribution of Effect Sizes 
  perm_effects <- NULL
  
  for(k in c(1:nperm)){
    
    # Randomly permute the DEMs of the two groups
    random_rows <- sample(nrow(both_groups), nrow(group_one))
    random_one <- both_groups[random_rows,]
    random_two <- both_groups[-random_rows,]
    
    # Append the effect size calculated using the randomly permuted DEMs
    perm_effects <- c(perm_effects, weat_score(random_one, 
                                               random_two, 
                                               attribute_one, 
                                               attribute_two))
    
  }
  
  # Compute WEAT D score
  weat_d <- weat_score(group_one, group_two, attribute_one, attribute_two)
  
  # Compute the lower and upper bounds of the 95% confidence interval
  weat_lb <- weat_d - 1.96 * sd(perm_effects)
  weat_ub <- weat_d + 1.96 * sd(perm_effects)
  
  return(c(group.comparisons, dimensions, weat_d, weat_lb, weat_ub))
    
}

# Define Function to Save Results ----------------------------------------------

weat_results <- function(text.category, alc.embeddings, verbose = TRUE){
  
  if(verbose){message("Performing WEATs in the Superiority dimension...[1/3]")}
  # Perform WEATs for group comparisons in the superiority dimension
  wb_superior <- weat_perm('White v. African Americans', 'Superiority',
                           alc.embeddings[[4]], alc.embeddings[[1]], 
                           alc.embeddings[[5]], alc.embeddings[[6]])
  wa_superior <- weat_perm('White v. Asian Americans', 'Superiority',
                           alc.embeddings[[4]], alc.embeddings[[2]], 
                           alc.embeddings[[5]], alc.embeddings[[6]])
  wh_superior <- weat_perm('White v. Hispanic Americans', 'Superiority', 
                           alc.embeddings[[4]], alc.embeddings[[3]], 
                           alc.embeddings[[5]], alc.embeddings[[6]])
  ab_superior <- weat_perm('Asian v. African Americans', 'Superiority', 
                           alc.embeddings[[2]], alc.embeddings[[1]], 
                           alc.embeddings[[5]], alc.embeddings[[6]])
  ah_superior <- weat_perm('Asian v. Hispanic Americans', 'Superiority', 
                           alc.embeddings[[2]], alc.embeddings[[3]], 
                           alc.embeddings[[5]], alc.embeddings[[6]])
  bh_superior <- weat_perm('African v. Hispanic Americans', 'Superiority', 
                           alc.embeddings[[1]], alc.embeddings[[3]], 
                           alc.embeddings[[5]], alc.embeddings[[6]])
  
  if(verbose){message("Performing WEATs in the Americanness dimension...[2/3]")}
  # Perform WEATs for group comparisons in the Americanness dimension
  wb_american <- weat_perm('White v. African Americans', 'Americanness',
                           alc.embeddings[[4]], alc.embeddings[[1]], 
                           alc.embeddings[[7]], alc.embeddings[[8]])
  wa_american <- weat_perm('White v. Asian Americans', 'Americanness', 
                           alc.embeddings[[4]], alc.embeddings[[2]], 
                           alc.embeddings[[7]], alc.embeddings[[8]])
  wh_american <- weat_perm('White v. Hispanic Americans', 'Americanness', 
                           alc.embeddings[[4]], alc.embeddings[[3]], 
                           alc.embeddings[[7]], alc.embeddings[[8]])
  ba_american <- weat_perm('African v. Asian Americans', 'Americanness', 
                           alc.embeddings[[1]], alc.embeddings[[2]], 
                           alc.embeddings[[7]], alc.embeddings[[8]])
  bh_american <- weat_perm('African v. Hispanic Americans', 'Americanness', 
                           alc.embeddings[[1]], alc.embeddings[[3]], 
                           alc.embeddings[[7]], alc.embeddings[[8]])
  ah_american <- weat_perm('Asian v. Hispanic Americans', 'Americanness', 
                           alc.embeddings[[2]], alc.embeddings[[3]], 
                           alc.embeddings[[7]], alc.embeddings[[8]])
  
  if(verbose){message("Saving results as a data frame...[3/3]")}
  # Create dataframe for Superiority WEATs
  superior_df <- rbind(wb_superior, wa_superior, wh_superior, 
                       ab_superior, ah_superior, bh_superior)
  colnames(superior_df) <- c('groups', 'dimension', 'effect', 'lower', 'upper')
  
  # Create dataframe for Americanness WEATs
  american_df <- rbind(wb_american, wa_american, wh_american, 
                       ba_american, bh_american, ah_american)
  colnames(american_df) <- c('groups', 'dimension', 'effect', 'lower', 'upper')
  
  # Append the two data frames together and save as .csv file
  weat_df <- rbind(superior_df, american_df)
  write.csv(weat_df, 
            paste0(text.category, '_weat_results.csv'), 
            quote = FALSE, row.names = FALSE)
  
}

# Create and Save Results ------------------------------------------------------

weat_results("acad", acad_alc)
weat_results("blog", blog_alc)
weat_results("fic", fic_alc)
weat_results("mag", mag_alc)
weat_results("news", news_alc)
weat_results("spok", spok_alc)
weat_results("tvm", tvm_alc)
weat_results("web", web_alc)


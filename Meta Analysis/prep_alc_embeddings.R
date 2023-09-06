
## Lee, Montgomery, Lai
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 27 Aug 2023

# Install and load packages ----------------------------------------------------

if(!require("conText")){install.packages("conText", dependencies = TRUE); require("conText")}
if(!require("quanteda")){install.packages("quanteda", dependencies = TRUE); require("quanteda")}
if(!require("tidyverse")){install.packages("tidyverse", dependencies = TRUE); require("tidyverse")}
if(!require("reticulate")){install.packages("reticulate", dependencies = TRUE); require("reticulate")}
if(!require("devtools")){install.packages("devtools", dependencies = TRUE); require("devtools")}

# As of May 2023, corpus is not available on CRAN. Use devtools to install development version
tmp <- tempfile()
system2("git", c("clone", "--recursive",
                 shQuote("https://github.com/patperry/r-corpus.git"), shQuote(tmp)))
devtools::install(tmp)

# Load All Objects -------------------------------------------------------------

# Load the pre-processed corpus and the embedding model
load('meta.RData')

# Set window size and random seed 
window_size = 6
set.seed(1048596)

# Load group word stimuli
setwd("..")
parent <- getwd()
setwd(paste0(parent, "/Group Word Stimuli/Names70"))

blacks = read.csv('black_names.csv') %>% 
  filter(name %in% rownames(coca_embed)) %>% pull(name)
asians = read.csv('asian_names.csv') %>% 
  filter(name %in% rownames(coca_embed)) %>% pull(name)
hispanics = read.csv('hispanic_names.csv') %>% 
  filter(name %in% rownames(coca_embed)) %>% pull(name)
whites = read.csv('white_names.csv') %>% 
  filter(name %in% rownames(coca_embed)) %>% pull(name)

# Load attribute word stimuli
setwd(paste0(parent, "/Attribute Word Stimuli/Word Stimuli"))

superior = read.csv('superior.csv') %>% 
  filter(words %in% rownames(coca_embed)) %>% pull(words)
inferior = read.csv('inferior.csv') %>% 
  filter(words %in% rownames(coca_embed)) %>% pull(words)
american = read.csv('american.csv') %>% 
  filter(words %in% rownames(coca_embed)) %>% pull(words)
foreign = read.csv('foreign.csv') %>% 
  filter(words %in% rownames(coca_embed)) %>% pull(words)

# Define Function to Induce ALC Embeddings--------------------------------------

# This function induces ALC embeddings for the word stimuli provided 
# using the set of tokens, the window size, the embedding model to use, and 
# the local transformation matrix derived for each sub-corpus.

# The following code was adepted from the conText package: 
# https://github.com/prodriguezsosa/conText/blob/master/vignettes/quickstart.md

alc <- function(tokens, words, size_window, embedding, local_transform){

  # build a corpus of contexts surrounding the target term(s)
  mkws_toks <- tokens_context(x = tokens, 
                              pattern = words, 
                              window = size_window, 
                              verbose = FALSE)
  
  # create document-feature matrix
  mkws_dfm <- dfm(mkws_toks)
  
  # create document-embedding matrix using a la carte
  mkws_dem <- dem(x = mkws_dfm, 
                  pre_trained = embedding, 
                  transform = TRUE, 
                  transform_matrix = local_transform, 
                  verbose = FALSE)
  
  # get embeddings for each pattern
  mkws_wvs <- dem_group(mkws_dem, 
                        groups = mkws_dem@docvars$pattern)

  # identify those words whose ALC embeddings could not be induced
  # confirm that all attribute words have ALC embeddings
  missing_obs = setdiff(words, rownames(mkws_wvs))
  
  if(!is.null(missing_obs)){
    for(obs in missing_obs){
      message(paste0("    - The ALC embedding for the word '", obs, "' was not induced."))
    }
  }
  # print(nrow(mkws_wvs))
  return(mkws_wvs)
  
}

# Induce ALC Embeddings for Each of the Categories -----------------------------

category_list = c("acad", "blog", "fic", "mag", "news", "spok", "tvm", "web")
word_baskets = list(blacks, asians, hispanics, whites, superior, inferior, american, foreign)

category_alc <- function(category, verbose = TRUE){
  
  # Construct Feature Co-occurrence Matrix for the specific sub-corpus
  if(verbose){message("Construct feature co-occurence matrix...[1/3]")}
  input_category <- coca %>% filter(genre == category)
  corpus_category <- corpus(input_category$text)
  toks_category <- tokens(corpus_category)
  
  fcm_category <- fcm(toks_category, 
                      context = "window", 
                      window = window_size, 
                      count = "frequency", 
                      tri = FALSE)
    
  # When computing the transformation matrix, it is recommended 
  # that we use the numeric value 500 as weighting. 
  # As we use a moderately large corpus of 1 billion tokens, we use 500.
  if(verbose){message("Compute transformation matrix...[2/3]")}
  category_transform <- compute_transform(x = fcm_category, 
                                          pre_trained = coca_embed,
                                          weighting = 500)
  
  # Initialize a list where we store ALC Embeddings for all groups and attributes
  alc_list = list()
  
  # Iterate through the lists of word stimuli and store ALC embeddings for 
  # each of the lists as elements inside the alc_embeddings list
  if(verbose){message("Induce ALC embeddings for each word stimuli list...[3/3]")}
  for(index in c(1:length(word_baskets))){
    if(verbose){message(paste0("  [", toString(index), "/8] list started."))}
    alc_list <- append(alc_list, alc(toks_category, 
                                     word_baskets[[index]], 
                                     window_size, 
                                     coca_embed, 
                                     category_transform))
  }
  
  return(alc_list)
}

# Induce ALC Embeddings for all text categories --------------------------------

acad_alc <- category_alc("acad")
blog_alc <- category_alc("blog")
fic_alc <- category_alc("fic")
mag_alc <- category_alc("mag")
news_alc <- category_alc("news")
spok_alc <- category_alc("spok")
tvm_alc <- category_alc("tvm")
web_alc <- category_alc("web")

# Save ALC Embeddings as .RData File -------------------------------------------

setwd(paste0(parent, "/Meta Analysis"))

# Remove all unnecessary files prior to saving to RData
rm(blacks, asians, hispanics, whites)
rm(superior, inferior, american, foreign)
rm(category_list, word_baskets)
rm(coca, coca_embed)
rm(alc, category_alc)
rm(window_size, tmp, parent)

save.image('alc_embeddings.RData')


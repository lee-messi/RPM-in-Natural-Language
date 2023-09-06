
## Lee, Montgomery, Lai
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 1 Sept 2023

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

setwd("..")
parent <- getwd()

# Load ALC embeddings of group word stimuli and word embedding model
setwd(paste0(parent, "/Meta Analysis"))
load("alc_embeddings.RData")
load("meta.RData")

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

# Append ALC embeddings of group words with COCA embeddings of attribute words

acad_alc <- list(acad_alc[[1]], acad_alc[[2]], acad_alc[[3]], acad_alc[[4]], 
                 coca_embed[superior,], coca_embed[inferior,],
                 coca_embed[american,], coca_embed[foreign,])
blog_alc <- list(blog_alc[[1]], blog_alc[[2]], blog_alc[[3]], blog_alc[[4]], 
                 coca_embed[superior,], coca_embed[inferior,],
                 coca_embed[american,], coca_embed[foreign,])
fic_alc <- list(fic_alc[[1]], fic_alc[[2]], fic_alc[[3]], fic_alc[[4]], 
                coca_embed[superior,], coca_embed[inferior,],
                coca_embed[american,], coca_embed[foreign,])
mag_alc <- list(mag_alc[[1]], mag_alc[[2]], mag_alc[[3]], mag_alc[[4]], 
                 coca_embed[superior,], coca_embed[inferior,],
                 coca_embed[american,], coca_embed[foreign,])
news_alc <- list(news_alc[[1]], news_alc[[2]], news_alc[[3]], news_alc[[4]], 
                 coca_embed[superior,], coca_embed[inferior,],
                 coca_embed[american,], coca_embed[foreign,])
spok_alc <- list(spok_alc[[1]], spok_alc[[2]], spok_alc[[3]], spok_alc[[4]], 
                 coca_embed[superior,], coca_embed[inferior,],
                 coca_embed[american,], coca_embed[foreign,])
tvm_alc <- list(tvm_alc[[1]], tvm_alc[[2]], tvm_alc[[3]], tvm_alc[[4]], 
                 coca_embed[superior,], coca_embed[inferior,],
                 coca_embed[american,], coca_embed[foreign,])
web_alc <- list(web_alc[[1]], web_alc[[2]], web_alc[[3]], web_alc[[4]], 
                 coca_embed[superior,], coca_embed[inferior,],
                 coca_embed[american,], coca_embed[foreign,])

# Save ALC Embeddings as .RData File -------------------------------------------

setwd(paste0(parent, "/Supplement. Meta Analysis"))

# Remove all unnecessary files prior to saving to RData
rm(parent, tmp)
rm(coca, coca_embed)
rm(superior, inferior, american, foreign)

save.image('alc_embeddings.RData')


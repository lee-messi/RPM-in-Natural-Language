
## Anonymous
# America's Racial Framework of Superiority and Americanness Embedded in Natural Language

## Script date: 25 Aug 2023

#Install and load packages -----------------------------------------------------

if(!require("reticulate")){install.packages("reticulate", dependencies = TRUE); require("reticulate")}
# If pandas is not installed, run:
# py_install(pandas)
pd <- import("pandas")

# Import Cleaned Corpus for Tokenization ---------------------------------------

# Navigate the corpus folder where 'cleaned_coca.pkl' is
setwd("../../")
parent <- getwd()
setwd(paste0(parent, "/Corpus"))

coca <- pd$read_pickle('cleaned_coca.pkl')

# Import Pre-trained Word Embedding Model --------------------------------------

# Navigate the embedding folder where 'coca.txt' is
setwd(paste0(parent, "/Embedding Model"))

coca_embed = as.matrix(data.table::fread('coca.txt', 
                                         data.table = F,
                                         header = F, 
                                         encoding = 'UTF-8'))
rownames(coca_embed) <- coca_embed[,1]
coca_embed <- coca_embed[,-1]
colnames(coca_embed) <- NULL
mode(coca_embed) <- "numeric"

# Save All Objects -------------------------------------------------------------

# Navigate the meta_analysis folder
setwd(paste0(parent, "/Supplement. WEAT/Meta Analysis"))
rm(pd, parent)
save.image('meta.RData')

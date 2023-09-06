import re, sys, nltk, mapply, string, contractions
import numpy as np
import pandas as pd
from tqdm import tqdm
from gensim.models import phrases
from nltk import word_tokenize as nltk_word_tokenize

tqdm.pandas()
mapply.init(n_workers=-1, chunk_size=1)

# Define stopwords we would like to remove 
stop_words = ['i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'are', 'will', 'would', 'should', 'could', 'is', 'your', 'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'have', 'has', 'had', 'her', 'hers', 'herself', 'it', 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which', 'who', 'whom', 'this', 'that', "that'll", 'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until', 'while', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through', 'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in', 'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'even', 'also', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't', 'can', 'just', 'don', 'should', 'now', 'd', 'll', 'm', 'o', 're', 've', 'y', 'ain', 'aren', 'couldn', 'didn', 'doesn', 'hadn', 'hasn', 'haven',  'isn', 'ma', 'mightn', 'mustn', 'needn', 'shan', 'shouldn', 'wasn', 'weren', 'won', 'nt', 'like']

# Import merged COCA as a pandas dataframe 
corpus = pd.read_pickle('merged_coca.pkl')

# Convert all letters to lower case 
corpus.text = corpus.text.str.lower()

# Expand contractions before removing stopwords
corpus.text = corpus.text.mapply(lambda x: contractions.fix(x))

# Replace hyphens with spaces
corpus.text = corpus.text.mapply(lambda x: re.sub('-', ' ', x))

# Remove all punctuation other than those that indicate end of sentence 
original_punct = string.punctuation
original_punct = original_punct.replace('!', '')
original_punct = original_punct.replace('?', '')
original_punct = original_punct.replace('.', '')
corpus.text = corpus.text.mapply(lambda x: x.translate(str.maketrans(' ', ' ', original_punct)))

# After removing all punctuation, replace nt with not for negation identification
corpus.text = corpus.text.mapply(lambda x: re.sub("\\bnt\\b", "not", x))

# Remove all numbers, links, and any extra whitespace
corpus.text = corpus.text.mapply(lambda x: ''.join(word for word in x if not word.isdigit()))
corpus.text = corpus.text.mapply(lambda x: re.sub(r"\S*https?\S*", " ", x))
corpus.text = corpus.text.mapply(lambda x: re.sub(r'\s+', ' ', x))

# Group all instances of the word 'not' and the following word into a single token
corpus.text = corpus.text.mapply(lambda x: re.sub('not ', 'not_', x))

# Remove all stop words 
corpus.text = corpus.text.mapply(lambda words: ' '.join(word for word in words.split() if word not in stop_words))

# Tokenize the text into sentences
# NLTK tokenizers look for punctuation and words to detect end of sentence 
corpus.text = corpus.text.mapply(lambda x: nltk.tokenize.sent_tokenize(x))

# Tokenize the sentences into words
corpus.text = corpus.text.mapply(lambda x: [nltk.word_tokenize(re.sub(r'[^\w\s]', ' ', t)) for t in x])

# Transform the list in text column to separate rows 
# This puts a sentence in each row and replicates keeping all other column values as is
corpus = corpus.explode('text')

# Identify common phrases (bi- and tri-grams) and group them together into a single token
bigrams = phrases.Phrases(corpus.text, min_count = 30)
trigrams = phrases.Phrases(bigrams[corpus.text], min_count = 30)
corpus.text = bigrams[corpus.text]
corpus.text = trigrams[corpus.text]

# Save preprocessed COCA as a pickle 
corpus.to_pickle('preprocessed_coca.pkl')

corpus.text = corpus.text.mapply(lambda x: ' '.join(word for word in x))
corpus.to_pickle('cleaned_coca.pkl')


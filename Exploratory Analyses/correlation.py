import os, math, random
import numpy as np
import pandas as pd
from scipy import stats
from numpy import dot
from numpy.linalg import norm
from gensim.models import Word2Vec

def score(vectors, group, attribute_one, attribute_two):

  group_vec = [vectors[word] for word in group]

  a1_vec = [vectors[word] for word in attribute_one]
  a2_vec = [vectors[word] for word in attribute_two]

  # Initialize vectors of scores
  score_list = []

  # Iterate over the group vectors
  for group_word in group_vec:

    # Initialize two vectors of cosine similarities - one for each attribute 
    diff_one = []
    diff_two = []
    
    # Iterate over the first attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to first list
    for a1_word in a1_vec:
      diff_one.append(dot(group_word, a1_word)/(norm(group_word)*norm(a1_word)))

    # Iterate over the second attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to second list
    for a2_word in a2_vec:
      diff_two.append(dot(group_word, a2_word)/(norm(group_word)*norm(a2_word)))

    # Calculate the difference in mean cosine similarity value - one for each word
    score_list.append(np.mean(diff_one) - np.mean(diff_two))

  return(score_list)


if __name__ == "__main__": 

  # Set the parent directory as current path 
  current_path = os.path.abspath('..')

  # Import words to represent African, Asian, and Hispanic Americans
  os.chdir(os.path.join(current_path, 'Group Word Stimuli/Names70'))
  blacks = pd.read_csv("black_names.csv").name.tolist()
  asians = pd.read_csv("asian_names.csv").name.tolist()
  hispanics = pd.read_csv("hispanic_names.csv").name.tolist()

  # Create a list of the names of the three minority groups
  names = blacks + asians + hispanics 

  # Import words to represent superiority, inferiority, Americanness, foreignness attributes
  os.chdir(os.path.join(current_path, 'Attribute Word Stimuli/Word Stimuli'))
  superior = pd.read_csv("superior.csv").words.tolist()
  inferior = pd.read_csv("inferior.csv").words.tolist()
  american = pd.read_csv("american.csv").words.tolist()
  foreign = pd.read_csv("foreign.csv").words.tolist()

  # Import word embedding model trained using COCA
  os.chdir(os.path.join(current_path, 'Embedding Model'))
  word_vectors = Word2Vec.load('coca.model').wv

  # Calculate scores of group word stimuli in each dimension
  superior_scores = score(word_vectors, names, superior, inferior)
  american_scores = score(word_vectors, names, american, foreign)

  # Calculate the correlation of the two scores
  cor_results = stats.pearsonr(superior_scores, american_scores)
  print("Correlation is {cor}. p-value is {pval}.".format(cor = cor_results[0], pval = cor_results[1]))


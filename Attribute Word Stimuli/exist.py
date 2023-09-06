import os
import gensim
import pandas as pd
from gensim.models import Word2Vec
pd.set_option('display.max_rows', None)

def exists(model, wordlist):
  for term in wordlist:  
    try:
      # Search for the word in the embedding space.  
      query = word_vectors[term]
      print(term + ": exists.")
    except: 
      # If the above returns an error, the word does not exist in the embedding space.
      print(term + "DOES NOT EXIST!!!!!! ")

  # Mark end of function call
  print('--------------------------------')

if __name__ == "__main__": 

  # Import word embedding model trained using COCA
  current_path = os.path.abspath('..')
  os.chdir(os.path.join(current_path, 'embedding'))
  word_vectors = Word2Vec.load('coca.model').wv

  # Import attribute word stimuli
  os.chdir(os.path.join(current_path, 'attributes/attributes'))
  superior = pd.read_csv('superior.csv').words
  inferior = pd.read_csv('inferior.csv').words
  american = pd.read_csv('american.csv').words
  foreign = pd.read_csv('foreign.csv').words

  exists(word_vectors, superior)
  exists(word_vectors, inferior)
  exists(word_vectors, american)
  exists(word_vectors, foreign)


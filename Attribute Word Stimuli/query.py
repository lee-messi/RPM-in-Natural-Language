import os, sys
import gensim
import pandas as pd
from gensim.models import Word2Vec
pd.set_option('display.max_rows', None)

def query(model, term, rank):
  try: 
    # Find rank number of most similar words of the query term
    query = pd.DataFrame(word_vectors.most_similar(term, topn = rank)).iloc[::-1]
    print(query)
  except: 
    print(term + ' does not exist in the embedding model.')

if __name__ == "__main__": 

  # Import word embedding model trained using COCA
  current_path = os.path.abspath('..')
  os.chdir(os.path.join(current_path, 'Embedding Model'))
  word_vectors = Word2Vec.load('coca.model').wv

  # Use the query function to expand the list of attribute word stimuli
  # Compile a list of similar words and manually select those that are appropriate
  query(word_vectors, sys.argv[1:], 100)

import os, gensim
import pandas as pd
from gensim.models import Word2Vec

if __name__ == "__main__": 

  # Before running this code, make sure that names connect with a hyphen
  # e.g., Pierre-Louis, Jean-Baptiste are separated by an underscore
  # as these names will be identified as a bi-grams

  # Import word embedding model trained using COCA
  current_path = os.path.abspath('../..')
  os.chdir(os.path.join(current_path, 'Embedding Model'))
  word_vectors = Word2Vec.load('coca.model').wv

  # Import group word stimuli
  os.chdir(os.path.join(current_path, 'Group Word Stimuli/Names70'))
  blacks = pd.read_csv('black_names.csv').name
  asians = pd.read_csv('asian_names.csv').name
  hispanics = pd.read_csv('hispanic_names.csv').name
  whites = pd.read_csv('white_names.csv').name

  for name in blacks: 
    if name in word_vectors: print(name + ' exists.')
    else: print(name + ' does not exist.')

  for name in asians: 
    if name in word_vectors: print(name + ' exists.')
    else: print(name + ' does not exist.')

  for name in hispanics: 
    if name in word_vectors: print(name + ' exists.')
    else: print(name + ' does not exist.')

  for name in whites: 
    if name in word_vectors: print(name + ' exists.')
    else: print(name + ' does not exist.')

  # Identify those words that are projected in the word embedding model
  existing_blacks = pd.DataFrame([term for term in blacks if term in word_vectors], columns = ['name'])
  existing_asians = pd.DataFrame([term for term in asians if term in word_vectors], columns = ['name'])
  existing_hispanics = pd.DataFrame([term for term in hispanics if term in word_vectors], columns = ['name'])
  existing_whites = pd.DataFrame([term for term in whites if term in word_vectors], columns = ['name'])

  # Save existing names as the new .csv file
  existing_blacks.to_csv('black_names.csv', index = False)
  existing_asians.to_csv('asian_names.csv', index = False)
  existing_hispanics.to_csv('hispanic_names.csv', index = False)
  existing_whites.to_csv('white_names.csv', index = False)



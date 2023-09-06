import os, mapply, sys, re
import pandas as pd
import numpy as np

mapply.init(n_workers=-1, chunk_size=1)

# Import words to represent superiority, inferiority, Americanness, foreignness attributes
# Set the parent directory as current path 
current_path = os.path.abspath('..')
os.chdir(os.path.join(current_path, 'names/names_70'))

blacks = pd.read_csv('black_names.csv').name.tolist()
asians = pd.read_csv('asian_names.csv').name.tolist()
hispanics = pd.read_csv('hispanic_names.csv').name.tolist()
whites = pd.read_csv('white_names.csv').name.tolist()

# Import words to represent superiority, inferiority, Americanness, foreignness attributes
os.chdir(os.path.join(current_path, 'attributes/word_stimuli'))

superior = pd.read_csv('superior.csv').words.tolist()
inferior = pd.read_csv('inferior.csv').words.tolist()
american = pd.read_csv('american.csv').words.tolist()
foreign = pd.read_csv('foreign.csv').words.tolist()

word_list = blacks + asians + hispanics + whites + superior + inferior + american + foreign
count_list = []

# Import merged COCA as a pandas dataframe
os.chdir(os.path.join(current_path, 'corpus'))
coca = pd.read_pickle('cleaned_coca.pkl')

# Iterate through the words inside the word list and store count inside a list
for word in word_list:
  word_count = coca.text.str.count(r'\b' + re.escape(word) + r'\b').sum()
  print("The word {} appears {} times in the corpus.".format(word, word_count))
  count_list.append(word_count)

count_df = pd.DataFrame(list(zip(word_list, count_list)), columns=['word', 'count'])

os.chdir(os.path.join(current_path, 'weat'))
count_df.to_csv('counts.csv', index = False)



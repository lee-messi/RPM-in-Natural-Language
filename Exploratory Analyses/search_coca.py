import os, sys, re
import pandas as pd
import numpy as np

pd.set_option('display.max_colwidth', None)

# Import words to represent superiority, inferiority, Americanness, foreignness attributes
# Set the parent directory as current path 
current_path = os.path.abspath('..')

# Import merged COCA as a pandas dataframe
os.chdir(os.path.join(current_path, 'Corpus'))
coca = pd.read_pickle('cleaned_coca.pkl')

# Set query term to African Americans
query_term = "asian_americans"
query_df = coca.text[coca.text.str.contains(pat = query_term)]

print(query_df.head(3))

# os.chdir(os.path.join(current_path, 'Exploratory Analyses'))
# query_df.to_csv('asian_americans.csv', index = False)



import os, math, random
import numpy as np
import pandas as pd
from numpy import dot
from numpy.linalg import norm
from gensim.models import Word2Vec

def perm(vectors, group_one, group_two, attribute_one, attribute_two, nperm): 

  # Store word vector projections of the words as lists: g1_vec, g2_vec, a1_vec, a2_vec
  # Note that the words used must have projections inside the embedding model that is passed on 
  g1_vec = [vectors[word] for word in group_one]
  g2_vec = [vectors[word] for word in group_two]
  a1_vec = [vectors[word] for word in attribute_one]
  a2_vec = [vectors[word] for word in attribute_two]

  # Calculate WEAT D-score using the weat() function defined below using the actual set of word stimuli
  actual = weat(g1_vec, g2_vec, a1_vec, a2_vec)
  # print(actual)

  # Concatenate two group lists together 
  group_attributes = g1_vec + g2_vec

  # Initialize list of WEAT D-scores 
  effect_list = []

  for i in range(nperm):

    # Randomly shuffle the concatenated group list and split them into random_one and random_two
    random.shuffle(group_attributes)
    random_one = group_attributes[:len(g1_vec)]
    random_two = group_attributes[len(g1_vec):]

    # Concatenate the WEAT D-score using permuted group words onto the list of effect sizes
    effect_list.append(weat(random_one, random_two, a1_vec, a2_vec))

  # To calculate p-value, count the number of elements inside the list of effect sizes 
  larger_elements = [element for element in effect_list if element >= actual]
  pvalue = len(larger_elements)/len(effect_list)
  
  # The standard error of the effect size is the standard deviation of the permutation distribution
  effect_se = np.std(effect_list)

  # Use the standard error value to compute the 95% Confidence Interval (CI)
  lower_ci = actual - 1.96 * effect_se
  upper_ci = actual + 1.96 * effect_se 
  
  # Return the actual WEAT D-score and the 95% Confidence Interval as a row in a dataframe
  a = np.array([actual, lower_ci, upper_ci])
  columns = ['effect', 'lower', 'upper']
  df = pd.DataFrame(np.reshape(a, (1,len(a))),columns=columns)

  return(df)
  

def weat(group_one, group_two, attribute_one, attribute_two):

  # Initialize two vectors of differential associations - one for each group 
  diff_one = []
  diff_two = []

  # Iterate over the first group vectors
  for g1_vec in group_one:

    # Initialize two vectors of cosine similarities - one for each attribute 
    diff_one_one = []
    diff_one_two = []

    # Iterate over the first attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to first list
    for a1_word in attribute_one:
      diff_one_one.append(dot(g1_vec, a1_word)/(norm(g1_vec)*norm(a1_word)))

    # Iterate over the second attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to second list
    for a2_word in attribute_two:
      diff_one_two.append(dot(g1_vec, a2_word)/(norm(g1_vec)*norm(a2_word)))

    # Calculate the difference in mean cosine similarity value - one for each word
    association_one = np.mean(diff_one_one) - np.mean(diff_one_two)
    diff_one.append(association_one)

  # Iterate over the second group vectors
  for g2_vec in group_two:

    # Initialize two vectors of cosine similarities - one for each attribute 
    diff_two_one = []
    diff_two_two = []

    # Iterate over the first attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to first list
    for a1_word in attribute_one:
      diff_two_one.append(dot(g2_vec, a1_word)/(norm(g2_vec)*norm(a1_word)))

    # Iterate over the second attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to second list
    for a2_word in attribute_two:
      diff_two_two.append(dot(g2_vec, a2_word)/(norm(g2_vec)*norm(a2_word)))

    # Calculate the difference in mean cosine similarity value - one for each word
    association_two = np.mean(diff_two_one) - np.mean(diff_two_two)
    diff_two.append(association_two)

  # Calculate pooled standard deviation 
  pooled_sd = math.sqrt((((len(diff_one) - 1) * np.std(diff_one)**2) + ((len(diff_two) - 1) * np.std(diff_two)**2))/(len(diff_one) + len(diff_two) - 2))
  weat_d = (np.mean(diff_one) - np.mean(diff_two))/pooled_sd

  return(weat_d)

if __name__ == "__main__": 

  # Set the parent directory as current path 
  current_path = os.path.abspath('../..')

  # Import word stimuli pertaining to the specific domain
  superior = pd.read_csv("intellectual_mental_superior.csv").words.tolist()
  inferior = pd.read_csv("intellectual_mental_inferior.csv").words.tolist()

  # Import words to represent African, Asian, Hispanic, and White Americans
  os.chdir(os.path.join(current_path, 'Group Word Stimuli/Names70'))
  blacks = pd.read_csv("black_names.csv").name.tolist()
  asians = pd.read_csv("asian_names.csv").name.tolist()
  hispanics = pd.read_csv("hispanic_names.csv").name.tolist()
  whites = pd.read_csv("white_names.csv").name.tolist()

  # Import word embedding model trained using COCA
  os.chdir(os.path.join(current_path, 'Embedding Model'))
  word_vectors = Word2Vec.load('coca.model').wv

  # Set number of permutations and random seed
  random.seed(1048596)
  num_perm = 1000

  # Six WEATs pertaining to Superiority 
  wb_superior_label = ['White v. African Americans', 'Superiority']
  print('Whites v. Blacks | Superior v. Inferior')
  wb_superior = perm(word_vectors, whites, blacks, superior, inferior, num_perm)
  row1 = np.concatenate((wb_superior_label, wb_superior), axis = None)

  wa_superior_label = ['White v. Asian Americans', 'Superiority']
  print('Whites v. Asian | Superior v. Inferior')
  wa_superior = perm(word_vectors, whites, asians, superior, inferior, num_perm)
  row2 = np.concatenate((wa_superior_label, wa_superior), axis = None)

  wh_superior_label = ['White v. Hispanic Americans', 'Superiority']
  print('Whites v. Hispanics | Superior v. Inferior')
  wh_superior = perm(word_vectors, whites, hispanics, superior, inferior, num_perm)
  row3 = np.concatenate((wh_superior_label, wh_superior), axis = None)

  ab_superior_label = ['Asian v. African Americans', 'Superiority']
  print('Asians v. Blacks | Superior v. Inferior')
  ab_superior = perm(word_vectors, asians, blacks, superior, inferior, num_perm)
  row4 = np.concatenate((ab_superior_label, ab_superior), axis = None)

  ah_superior_label = ['Asian v. Hispanic Americans', 'Superiority']
  print('Asians v. Hispanics | Superior v. Inferior')
  ah_superior = perm(word_vectors, asians, hispanics, superior, inferior, num_perm)
  row5 = np.concatenate((ah_superior_label, ah_superior), axis = None)

  bh_superior_label = ['African v. Hispanic Americans', 'Superiority']
  print('Blacks v. Hispanics | Superior v. Inferior')
  bh_superior = perm(word_vectors, blacks, hispanics, superior, inferior, num_perm)
  row6 = np.concatenate((bh_superior_label, bh_superior), axis = None)


  # Store the group and dimension labels, WEAT D-score, and 95% CIs as a pandas dataframe
  weat_df = pd.DataFrame(np.array([row1, row2, row3, row4, row5, row6]), columns = ['groups', 'dimensions', 'effect', 'lower', 'upper'])

  # Store the results inside the results folder
  os.chdir(os.path.join(current_path, 'Supplement. Domain Analysis/intellectual_mental'))
  weat_df.to_csv('intellectual_mental_weat_results.csv', index = False)



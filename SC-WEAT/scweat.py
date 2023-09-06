import os, math, random
import numpy as np
import pandas as pd
from numpy import dot
from numpy.linalg import norm
from gensim.models import Word2Vec

def boot(vectors, group, attribute_one, attribute_two, nboot): 

  # Store word vector projections of the words as lists: g_vec, a1_vec, a2_vec
  # Note that the words used must have projections inside the embedding model that is passed on 
  group_vec = [vectors[word] for word in group]
  a1_vec = [vectors[word] for word in attribute_one]
  a2_vec = [vectors[word] for word in attribute_two]

  # Calculate SC-WEAT D-score using the scweat() function defined below using the actual set of word stimuli
  actual = scweat(group_vec, a1_vec, a2_vec)

  # Initialize list of SC-WEAT D-scores
  effect_list = []

  for i in range(nboot):

    # Resample indices with replacement and use them to create random group list
    choice_indices = np.random.choice(len(group_vec), size = len(group_vec), replace = True)
    boot_group = [group_vec[index] for index in choice_indices]

    # Concatenate the SC-WEAT D-score using resampled group words onto the list of effect sizes
    effect_list.append(scweat(boot_group, a1_vec, a2_vec))

  # The standard error of the effect size is the standard deviation of the permutation distribution
  effect_se = np.std(effect_list)

  # Use the percentile bootstrap to estimate the 95% confidence interval
  lower_ci = actual - 1.96 * effect_se
  upper_ci = actual + 1.96 * effect_se

  # Return the actual SC-WEAT D-score and the 95% Confidence Interval as a row in a dataframe
  a = np.array([actual, lower_ci, upper_ci])
  columns = ['effect', 'lower', 'upper']
  df = pd.DataFrame(np.reshape(a, (1,len(a))),columns=columns)

  return(df)


def scweat(group, attribute_one, attribute_two):

  # Initialize a vector of differential associations
  mean_diff = []

  # Iterate over the group vectors
  for group_vec in group:

    # Initialize two vectors of cosine similarities - one for each attribute 
    diff_one = []
    diff_two = []
    
    # Iterate over the first attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to first list
    for a1_word in attribute_one:
      diff_one.append(dot(group_vec, a1_word)/(norm(group_vec)*norm(a1_word)))

    # Iterate over the second attribute vectors
    # Calculate cosine similarity between group vector and attribute vector and append it to second list
    for a2_word in attribute_two:
      diff_two.append(dot(group_vec, a2_word)/(norm(group_vec)*norm(a2_word)))

    # Calculate the difference in mean cosine similarity value - one for each word
    mean_diff.append(np.mean(diff_one) - np.mean(diff_two))

  # Calculate pooled standard deviation 
  scweat_d = np.mean(mean_diff)/np.std(mean_diff, ddof = 1)

  return(scweat_d)


if __name__ == "__main__": 

  # Set the parent directory as current path 
  current_path = os.path.abspath('..')

  # Import words to represent African, Asian, Hispanic, and White Americans
  os.chdir(os.path.join(current_path, 'Group Word Stimuli/Names70'))
  blacks = pd.read_csv("black_names.csv").name.tolist()
  asians = pd.read_csv("asian_names.csv").name.tolist()
  hispanics = pd.read_csv("hispanic_names.csv").name.tolist()
  whites = pd.read_csv("white_names.csv").name.tolist()

  # Import words to represent superiority, inferiority, Americanness, foreignness attributes
  os.chdir(os.path.join(current_path, 'Attribute Word Stimuli/Word Stimuli'))
  superior = pd.read_csv("superior.csv").words.tolist()
  inferior = pd.read_csv("inferior.csv").words.tolist()
  american = pd.read_csv("american.csv").words.tolist()
  foreign = pd.read_csv("foreign.csv").words.tolist()

  # Import word embedding model trained using COCA
  os.chdir(os.path.join(current_path, 'Embedding Model'))
  word_vectors = Word2Vec.load('coca.model').wv

  # Set number of bootstrap samples
  boot_num = 1000
  np.random.seed(1048597)

  # Four SC-WEATs pertaining to Superiority
  black_superior_label = ['African Americans', 'Superiority']
  print('Blacks | Superior v. Inferior')
  black_superior = boot(word_vectors, blacks, superior, inferior, boot_num)
  row1 = np.concatenate((black_superior_label, black_superior), axis = None)

  asian_superior_label = ['Asian Americans', 'Superiority']
  print('Asians | Superior v. Inferior')
  asian_superior = boot(word_vectors, asians, superior, inferior, boot_num)
  row2 = np.concatenate((asian_superior_label, asian_superior), axis = None)

  hispanic_superior_label = ['Hispanic Americans', 'Superiority']  
  print('Hispanics | Superior v. Inferior')
  hispanic_superior = boot(word_vectors, hispanics, superior, inferior, boot_num)
  row3 = np.concatenate((hispanic_superior_label, hispanic_superior), axis = None)

  white_superior_label = ['White Americans', 'Superiority']  
  print('Whites | Superior v. Inferior')
  white_superior = boot(word_vectors, whites, superior, inferior, boot_num)
  row4 = np.concatenate((white_superior_label, white_superior), axis = None)

  # Four SC-WEATs pertaining to Americanness
  black_american_label = ['African Americans', 'Americanness'] 
  print('Blacks | American v. Foreign')
  black_american = boot(word_vectors, blacks, american, foreign, boot_num)
  row5 = np.concatenate((black_american_label, black_american), axis = None)

  asian_american_label = ['Asian Americans', 'Americanness'] 
  print('Asians | American v. Foreign')
  asian_american = boot(word_vectors, asians, american, foreign, boot_num)
  row6 = np.concatenate((asian_american_label, asian_american), axis = None)
 
  hispanic_american_label = ['Hispanic Americans', 'Americanness'] 
  print('Hispanics | American v. Foreign')
  hispanic_american = boot(word_vectors, hispanics, american, foreign, boot_num)
  row7 = np.concatenate((hispanic_american_label, hispanic_american), axis = None)
  
  white_american_label = ['White Americans', 'Americanness'] 
  print('Whites | American v. Foreign')
  white_american = boot(word_vectors, whites, american, foreign, boot_num)
  row8 = np.concatenate((white_american_label, white_american), axis = None)
    
  # Store the group and dimension labels, SC-WEAT D-score, and 95% CIs as a pandas dataframe
  scweat_df = pd.DataFrame(np.array([row1, row2, row3, row4, row5, row6, row7, row8]), columns = ['groups', 'dimensions', 'effect', 'lower', 'upper'])

  # Store the results inside the results folder
  os.chdir(os.path.join(current_path, 'SC-WEAT/Results'))
  scweat_df.to_csv('scweat_results.csv', index = False)


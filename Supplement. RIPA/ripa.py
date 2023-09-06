import os, sys
import numpy as np
import pandas as pd
import scipy.stats as stats
from gensim.models import Word2Vec

# b_vec() and ripa_scores() below are implemented with reference to the RIPA 
# metric implementation in the WEFE package: 

"""
References
----------
| [1]: Badilla, Pablo, Bravo-Marquez, Felipe and Pérez, Jorge. (2020, July).
       WEFE: The Word Embeddings Fairness Evaluation Framework.

"""

# Define function to calculate the relation vector given a pair of attribute word vectors
def b_vec(word_vec_1: np.ndarray, word_vec_2: np.ndarray) -> np.ndarray:
        vec = np.array(word_vec_1) - np.array(word_vec_2)
        norm = np.linalg.norm(vec)
        return vec / norm

# Define function to calculate RIPA scores given a word embedding model, 
# a set of group words, and sets of attribute words (attribute_1 and attributbe_2)
def ripa_scores(model, group_words, attribute_1, attribute_2):

    # The attribute words need to be of equal length. If not, return value error.
    if len(attribute_1) != len(attribute_2):
        raise ValueError("The two attribute sets do not have the same length.")
    
    # Look up embeddings of group and attribute words
    group_embeddings = [model[x] for x in group_words]
    attribute_embeddings_1 = [model[y] for y in attribute_1]
    attribute_embeddings_2 = [model[z] for z in attribute_2]

    score_list = []
    
    # Calculate RIPA scores for each group word vector and all base pairs
    # Each group word vector is associated with n RIPA scores where n is 
    # number of attribute words. We need the same number of words to represent 
    # the two attributes: superiority/inferiority and Americanness/foreignness
    for word in group_embeddings:
        for index in range(len(attribute_1)):
            bvec = b_vec(attribute_embeddings_1[index], attribute_embeddings_2[index])
            score = np.dot(word, bvec)
            score_list.append(score)

    return score_list

# Define function to calculate Cohen's d effect size to compare RIPA scores
def cohend(d1, d2, verbose = True): 
    n1, n2 = len(d1), len(d2)
    s1, s2 = np.var(d1, ddof = 1), np.var(d2, ddof = 1)
    s = np.sqrt(((n1 - 1) * s1 + (n2 - 1) * s2) / (n1 + n2 - 2))
    u1, u2 = np.mean(d1), np.mean(d2)

    d = (u1 - u2)/s
    se = np.sqrt((n1 + n2)/(n1 * n2) + d * d / (2 * n1 * n2))

    lb = d - 1.96 * se
    ub = d + 1.96 * se

    if verbose == True:
         separator = '\n'+'-' * 45
         print("Cohen's d: {}, 95% CI: {}".format(round(d, 4), [round(lb, 4), round(ub, 4)]), separator)

    return([d, lb, ub])

if __name__ == "__main__": 
     
    # Set the parent directory as current path 
    current_path = os.path.abspath('../../..')

    # Import group word stimuli to represent racial/ethnic groups
    os.chdir(os.path.join(current_path, 'Group Word Stimuli/Names70')) # Depending on threshold, change here:
    black_names = pd.read_csv('black_names.csv').name.tolist()
    asian_names = pd.read_csv('asian_names.csv').name.tolist()
    hispanic_names = pd.read_csv('hispanic_names.csv').name.tolist()
    white_names = pd.read_csv('white_names.csv').name.tolist()

    # Import attribute word stimuli to represent the four attributes
    os.chdir(os.path.join(current_path, 'Attribute Word Stimuli/Word Stimuli'))
    superior_list = pd.read_csv('superior.csv').words.tolist()
    inferior_list = pd.read_csv('inferior.csv').words.tolist()
    american_list = pd.read_csv('american.csv').words.tolist()
    foreign_list = pd.read_csv('foreign.csv').words.tolist()

    # Load the word embedding model trained on COCA
    os.chdir(os.path.join(current_path, 'Embedding Model'))
    model = Word2Vec.load('coca.model').wv

    # RIPA scores of four racial/ethnic groups wrt superiority and inferiority
    black_superiority = ripa_scores(model, black_names, superior_list, inferior_list)
    asian_superiority = ripa_scores(model, asian_names, superior_list, inferior_list)
    hispanic_superiority = ripa_scores(model, hispanic_names, superior_list, inferior_list)
    white_superiority = ripa_scores(model, white_names, superior_list, inferior_list)

    # RIPA scores of four racial/ethnic groups wrt Americanness and foreignness
    black_americanness = ripa_scores(model, black_names, american_list, foreign_list)
    asian_americanness = ripa_scores(model, asian_names, american_list, foreign_list)
    hispanic_americanness = ripa_scores(model, hispanic_names, american_list, foreign_list)
    white_americanness = ripa_scores(model, white_names, american_list, foreign_list)

    # Six RIPA comparisons pertaining to Superiority 
    wb_superior_label = ['White v. African Americans', 'Superiority']
    print('Whites v. Blacks | Superior v. Inferior')
    wb_superior = cohend(white_superiority, black_superiority, verbose = True)
    row1 = np.concatenate((wb_superior_label, wb_superior), axis = None)

    wa_superior_label = ['White v. Asian Americans', 'Superiority']
    print('Whites v. Asian | Superior v. Inferior')
    wa_superior = cohend(white_superiority, asian_superiority, verbose = True)
    row2 = np.concatenate((wa_superior_label, wa_superior), axis = None)

    wh_superior_label = ['White v. Hispanic Americans', 'Superiority']
    print('Whites v. Hispanics | Superior v. Inferior')
    wh_superior = cohend(white_superiority, hispanic_superiority, verbose = True)
    row3 = np.concatenate((wh_superior_label, wh_superior), axis = None)

    ab_superior_label = ['Asian v. African Americans', 'Superiority']
    print('Asians v. Blacks | Superior v. Inferior')
    ab_superior = cohend(asian_superiority, black_superiority, verbose = True)
    row4 = np.concatenate((ab_superior_label, ab_superior), axis = None)

    ah_superior_label = ['Asian v. Hispanic Americans', 'Superiority']
    print('Asians v. Hispanics | Superior v. Inferior')
    ah_superior = cohend(asian_superiority, hispanic_superiority, verbose = True)
    row5 = np.concatenate((ah_superior_label, ah_superior), axis = None)

    bh_superior_label = ['African v. Hispanic Americans', 'Superiority']
    print('Blacks v. Hispanics | Superior v. Inferior')
    bh_superior = cohend(black_superiority, hispanic_superiority, verbose = True)
    row6 = np.concatenate((bh_superior_label, bh_superior), axis = None)

    # Six RIPA comparisons pertaining to Americanness
    wb_american_label = ['White v. African Americans', 'Americanness']
    print('Whites v. Blacks | American v. Foreign')
    wb_american = cohend(white_americanness, black_americanness, verbose = True)
    row7 = np.concatenate((wb_american_label, wb_american), axis = None)

    wa_american_label = ['White v. Asian Americans', 'Americanness']
    print('Whites v. Asians | American v. Foreign')
    wa_american = cohend(white_americanness, asian_americanness, verbose = True)
    row8 = np.concatenate((wa_american_label, wa_american), axis = None)

    wh_american_label = ['White v. Hispanic Americans', 'Americanness']
    print('Whites v. Hispanics | American v. Foreign')
    wh_american = cohend(white_americanness, hispanic_americanness, verbose = True)
    row9 = np.concatenate((wh_american_label, wh_american), axis = None)

    ba_american_label = ['African v. Asian Americans', 'Americanness']
    print('Blacks v. Asians | American v. Foreign')
    ba_american = cohend(black_americanness, asian_americanness, verbose = True)
    row10 = np.concatenate((ba_american_label, ba_american), axis = None)

    bh_american_label = ['African v. Hispanic Americans', 'Americanness']
    print('Blacks v. Hispanics | American v. Foreign')
    bh_american = cohend(black_americanness, hispanic_americanness, verbose = True)
    row11 = np.concatenate((bh_american_label, bh_american), axis = None)

    ah_american_label = ['Asian v. Hispanic Americans', 'Americanness']
    print('Asians v. Hispanic | American v. Foreign')
    ah_american = cohend(asian_americanness, hispanic_americanness, verbose = True)
    row12 = np.concatenate((ah_american_label, ah_american), axis = None)

    # Store the group and dimension labels, ripa D-score, and 95% CIs as a pandas dataframe
    ripa_df = pd.DataFrame(np.array([row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12]), 
                           columns = ['groups', 'dimensions', 'effect', 'lower', 'upper'])

    # Store the results inside the results folder
    os.chdir(os.path.join(current_path, 'Supplemental Materials/RIPA/RIPA/Results'))
    ripa_df.to_csv('RIPA_70.csv', index = False) # Depending on threshold, change here:


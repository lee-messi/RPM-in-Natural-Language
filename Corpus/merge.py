import os
import numpy as np
import pandas as pd

# Place all raw COCA files in a folder named Raw
# This python code should be stored in the same folder as the Raw folder
current_path = os.getcwd()
os.chdir(os.path.join(current_path, 'Raw'))

# Create lists of years, genres, and numbers used to iterate through text files 
# The six genres in 'genres' are separated by year 
# The two genres in 'web_genres' are separated sequentially from 01 to 34  
web_genres = ['web', 'blog']
years = list(range(1990, 2020))
genres = ['acad', 'fic', 'news', 'spok', 'tvm', 'mag']
numbers = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', 
'11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', 
'23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34']

# Initialize list of text values as 'final'
final = []

# Iterate through the year and genre values to look for relevant files
# Append the text files as elements of the 'final' list 
for year in years: 
  for genre in genres: 
    temp = []
    filename = 'text_' + str(genre) + '_' + str(year) + '.txt'
    text_file = open(filename, "r")
    print("--------------------------------------------")
    print("Importing " + filename + " file.")
    temp.append(text_file.read())
    text_file.close()
    final.append(str(temp))

# Iterate through the number and web_genre values to look for relevant files
# Append the text files as elements of the 'final' list
for num in numbers: 
  for web_genre in web_genres: 
    temp = []
    filename = 'text_' + str(web_genre) + '_' + str(num) + '.txt'
    text_file = open(filename, "r")
    print("--------------------------------------------")
    print("Importing " + filename + " file.")
    temp.append(text_file.read())
    text_file.close()
    final.append(str(temp))

# The genre column consists of the genre values repeated 30 times and web_genre values repeated 34 times
genre_column = genres * 30 + web_genres * 34
texts = list(zip(genre_column, final))

# Store the genre_column and elements of 'final' and create a pandas dataframe
corpus = pd.DataFrame(texts, columns = ['genre', 'text'])

# Save merged COCA as a pickle
os.chdir(current_path)
corpus.to_pickle('merged_coca.pkl')


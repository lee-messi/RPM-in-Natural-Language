from tqdm import tqdm
from gensim.models import Word2Vec
from gensim.models.keyedvectors import KeyedVectors

model = Word2Vec.load('coca.model').wv
model.save_word2vec_format('coca.txt', binary=False)


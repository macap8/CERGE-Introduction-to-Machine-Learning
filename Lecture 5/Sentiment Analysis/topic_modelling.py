# -*- coding: utf-8 -*-
"""
Created on Thu Feb  9 12:57:25 2017

@author: pmaldonado
"""

import pandas as pd 
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import Normalizer
from sklearn.cluster import KMeans
from sklearn.decomposition import TruncatedSVD
from sklearn.pipeline import make_pipeline


df = pd.read_csv("Tweets.csv")


from sklearn.feature_extraction import stop_words

sw = stop_words.ENGLISH_STOP_WORDS 
sw = list(sw)
sw = sw + ['flight','flights','http','thanks',
           'cancelled', 'hold','amp',
           'united','just','help','united']

vec = CountVectorizer(analyzer="word", stop_words=sw)



# Convert text into matrix form
X = vec.fit_transform(df['text'])


# Project into a lower dimensional space and normalize
svd = TruncatedSVD()
normalizer = Normalizer(copy=False)
lsa = make_pipeline(svd, normalizer)

X = lsa.fit_transform(X)

# Clustering: k-means

test_k = 5

km = KMeans(n_clusters=test_k, init = "k-means++")

km.fit(X)

# Reinterprete the model in terms of the or
original_space_centroids = svd.inverse_transform(km.cluster_centers_)
order_centroids = original_space_centroids.argsort()[:,::-1]

terms = vec.get_feature_names()

for i in range(test_k):
    print("Cluster %d:" % i, end = '')
    for ind in order_centroids[i,:10]:
        print(' %s ' % terms[ind], end = ' ')
    print()
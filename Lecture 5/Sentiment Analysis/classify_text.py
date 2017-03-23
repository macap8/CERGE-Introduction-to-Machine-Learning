# -*- coding: utf-8 -*-
"""
Created on Thu Feb  9 09:44:16 2017

@author: pmaldonado
"""

import pandas as pd
import numpy as np

df = pd.read_csv("Tweets.csv")

## Split randomly in training and testing
train = df.sample(frac=0.8)
test = df.loc[~df.index.isin(train.index)]


##########################################
## Feature extraction 
##########################################

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction import stop_words

sw = stop_words.ENGLISH_STOP_WORDS #default sklearn stop words

# regex search on train['text'] for *air*

# custom stop words
sw = list(sw) + ['http','flight','just']

count_vect = CountVectorizer(analyzer="word", stop_words=sw)

#count_vect = CountVectorizer(analyzer="word")



#  Different methods of counting word frequency
X_train_counts = count_vect.fit_transform(train['text'])


## Label encoder
from sklearn.preprocessing import LabelEncoder

le  = LabelEncoder()
y_train = le.fit_transform(train['airline_sentiment'])



# This stores word frequency
count_vect.vocabulary_.get(u'ppl')

# Words appearing once are deleted
count_vect.vocabulary_.get(u'@TilleyMonsta')


##########################################
## Training the model
##########################################


from sklearn.naive_bayes import MultinomialNB

clf = MultinomialNB().fit(X_train_counts, y_train)

# Convert to matrix form the test data
X_test = count_vect.transform(test['text'])
y_test = le.transform(test['airline_sentiment'])


y_preds = clf.predict(X_test)


from sklearn.metrics import classification_report
print(classification_report(y_test, y_preds))


##########################################
## Interpreting model results
##########################################

def print_top10(vect, clf, class_labels):
    feature_names = vect.get_feature_names()
    for i, class_label in enumerate(class_labels):
        top10 = np.argsort(clf.coef_[i])[-10:]
        print("%s: %s "% (class_label,
              " ".join(feature_names[j] for j in top10)))


# Show important words
print_top10(count_vect, clf, le.classes_)        
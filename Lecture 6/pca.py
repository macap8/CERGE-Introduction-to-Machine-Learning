
# Example for an SVD computation:
import numpy as np

matrix = np.matrix([[0.3, 0.2],
                    [0.2, 1.0]])

U, Sigma, V = np.linalg.svd(matrix, full_matrices=False)
S = np.diag(Sigma)
U * np.diag(Sigma) * V.T


from scipy import linalg
U, S, V = linalg.svd(matrix, full_matrices=False)
U, S, V


# # General settings for the examples

# In[3]:

#get_ipython().magic('matplotlib inline')
import matplotlib.pyplot as plt
import numpy as np
from numpy import *

# ###### Creating the data matrix and a plot

# In[4]:

# For reproducibility of the results, set the seed:
np.random.seed(0)

mean = np.array([0, 0])
cov = np.array([[0.3, 0.2],
                [0.2, 1.0]])

# Draw 500 samples from a multivariate normal distribution with mean 
#`mean` and covariance matrix `covariance`:
data = np.random.multivariate_normal(mean, cov, 500)
# Draw a scatter plot of the data:
plt.scatter(data[:,0], data[:,1], color = '.05')
plt.show()


# ##### Computing the eigenvalues and an ONB eigenvectors

# In[5]:

# Compute the eigenvalues and eigenvectors of the covariance:
eig_val, eig_vec = np.linalg.eig(cov)
print("Eigenvalues:" + str(eig_val))
print("Eigenvectors:" + str(eig_vec[0]) + " and " + str(eig_vec[1]))


# Thus $\lambda_1=1.05311289$ and $\lambda_2=0.24688711$ if we want to order
# the eigenvalues decreasingly. Correspondingly, we pick our ONB $(b_1, b_2)$ 
#of eigenvectors as follows:

# In[6]:

b1 = eig_vec[1]
b2 = eig_vec[0]
# This prints the basis vectors and confirms that the they have unit length:
b1, b2, np.linalg.norm(b1), np.linalg.norm(b2)


# The columns of $V$, as computed from the SVD of the data matrix, 
# look slightly different though:



from scipy import linalg
U, S, V = linalg.svd(data, full_matrices=False)
V



from sklearn.decomposition import PCA
print(PCA.transform.__doc__)


# The `components_` member variable of the PCA object contains the 
#`n_components` first principal components:

# In[9]:

# Perform PC-Transformation:
from sklearn.decomposition import PCA
pca = PCA(n_components=2)
pca.fit(data)
print(pca.components_)


# Again this result slightly differs from the first `n_components` 
# first columns of $V$ due to rounding erros: internally, the `fit` method 
#first computes the mean of the data matrix and centers it accordingly:

# In[10]:

np.mean(data, axis=0)


# Although all data points a sampled from a distribution with zero mean, 
#the sample mean is non-zero. This yields slight numerical differences 

# In[11]:

# Perform PC-Transformation:
from sklearn.decomposition import PCA
pca = PCA(n_components=2)
pca.fit(data)
data_transformed = pca.transform(data)

# Draw a scatter plot of the input data in light gray:
plt.scatter(data[:,0], data[:,1], color = '.5')

# Draw a scatter plot of the transformed data in orange:
plt.scatter(data_transformed[:,0], data_transformed[:, 1], color = 'orange')
# plt.scatter(data_transformed[:,0], 0 * data_transformed[:,0], color = 'red', alpha = 0.1)
# The choosen eigenvectors 'nearly' give the standard coordinate system:
# plt.scatter(eig_vec[:,0], eig_vec[:,1], color = 'red')
plt.show()


# In[12]:

# Perform PC-Transformation:
from sklearn.decomposition import PCA
pca = PCA(n_components=2)
pca.fit(data)
data_transformed = pca.transform(data)

# Draw a scatter plot of the input data in light gray:
plt.scatter(data[:,0], data[:,1], color = '.5')

# Draw a scatter plot of the transformed data in orange:
plt.scatter(data_transformed[:,0], data_transformed[:, 1], color = 'orange')
# Keep only the first principal component:
n_components=1
# Project the transformed data onto the first principal component 
# (add alpha chanel in order to distinguish the projected data points):
plt.scatter(data_transformed[:,0], 0 * data_transformed[:,0], color = 'indigo', alpha = 0.1)
# The choosen eigenvectors 'nearly' give the standard coordinate system:
# plt.scatter(eig_vec[:,0], eig_vec[:,1], color = 'red')
plt.show()


# **Note:** The new data (in orange) set is not only rotated 
#but also reflected, that is the transformation is not entirely in $SO(2)$.
#     This seems to be due to the implementation.

# In[13]:

pca.explained_variance_ratio_


# In[14]:

total_variance = eig_val[0] + eig_val[1]
eig_val[1] / total_variance, eig_val[0] / total_variance


# # Example: Handwritten Digits

# **Aim:** Apply PC-decomposition to do some exploratory data analysis. 
#More concretely, we look for clusters in a set of handwritten digits.

# Scikit-Learn comes with a number of data sets. 
#Here we take a look at the digits data set. This data set consists of 
#images of handwritten digits, each represent by $(8\times 8)$ 
#matrix of greyscale values, or equivalently a 64-dimensional vector. 
#In addition, there are labels for the images given the actual digit. 
#The data set is neatly structured in form of a dictionary:

# In[15]:

from sklearn.datasets import load_digits
digits = load_digits()
# The images are given by `digits.data' and the corresponding 
# labels are given in `digits.target`:
X_digits, y_digits = digits.data, digits.target
print(digits.keys())


# There is a description string `DESCR`:

# In[16]:

print(digits.DESCR)


# Let us plot a (4x5)-matrix of images of handwritten digits labeled 
# with the predicted value.

# In[17]:

n_row, n_col = 4, 5

def print_digits(images, y, max_n=10):
    fig = plt.figure(figsize=(n_col, n_row))
    i=0
    while i < max_n and i < images.shape[0]:
        p = fig.add_subplot(n_row, n_col, i + 1, xticks=[], yticks=[])
        p.imshow(images[i], cmap=plt.cm.bone, interpolation='nearest')
        # Label the image with the target value:
        p.text(0, -1, str(y[i]))
        i = i + 1

print_digits(digits.images, digits.target, max_n=20)


# The following prints the first digit as an array and gives its shape, 
# confirming the above description:

# In[18]:

print(X_digits[0])
X_digits[0].shape


# Next we perform the PC-decomposition on the digits data set, 
# keeping 10 components:

# In[19]:

from sklearn.decomposition import PCA
pca = PCA(n_components=10)
X_pca = pca.fit_transform(X_digits)
for i, explained_variance_ratio in enumerate(pca.explained_variance_ratio_):
    print("Variance explained by the " + str(i + 1) + \
          "-th principal component:\t" + str(explained_variance_ratio))


# Judging from this one could try to argue that only 
# the first three principal components account
# for must of the variance. We use the first two to produce a 
#two-dimensional scatterplot of the data:

# In[20]:

def plot_pca_scatter():
    colors = ['black', 'blue', 
              'purple', 'yellow', 'white', 'red', 
              'lime', 'cyan', 'orange', 'gray']
    for i in range(len(colors)):
        px = X_pca[:, 0][y_digits == i]
        py = X_pca[:, 1][y_digits == i]
        plt.scatter(px, py, c=colors[i])
        plt.legend(digits.target_names)
        plt.xlabel('First Principal Component')
        plt.ylabel('Second Principal Component')
        
n_components=2
plot_pca_scatter()
X_pca.shape, X_digits.shape


# From this scatterplot we can clearly see some clusters, some more and some 
#less separated from the others. The clusters overlap where one might exp

# Finally, let us have a brief look at the principal components themselves:

# In[21]:

def print_pca_components(images, n_col, n_row):
    plt.figure(figsize=(2. * n_col, 2.26 * n_row))
    for i, comp in enumerate(images):
        if i <= n_col * n_row:
            plt.subplot(n_row, n_col, i + 1)
            plt.imshow(comp.reshape((8, 8)), interpolation='nearest')
            plt.text(0, -1, str(i + 1) + '-component')
            plt.xticks(())
            plt.yticks(())
        else:
            break
        
print_pca_components(pca.components_, 5, 2)


# As we can see the components themselves are hard to interpet and 
#do not correspond to digits in an obvious manner.

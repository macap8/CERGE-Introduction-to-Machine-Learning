library(dplyr)
library(stringr)

#One-liner to change the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


df <- read.csv("./data/out.c-pa.orders_refine.csv", encoding = "UTF-8")
head(df)

df$DATE_UPDATED <- as.Date(df$DATE_UPDATED)

max(df$DATE_UPDATED) #Check the latest date

ref_date <- as.Date("2016-05-18")

################################################
##  Step 1: RFM Summary                       #
##############################################

rfm <- df %>% 
  group_by(CUSTOMER_ID) %>%
  summarise(
    Recency = as.integer(difftime(ref_date,max(DATE_UPDATED), units = "days")), 
    Frequency = n(), 
    Monetary = sum(PRODUCT_COUNT*PRODUCT_PRICE)) 


################################################
##  Step 2: Binning                           #
##############################################

rfm$rec_bin <- sapply(rfm$Recency, function(x){ifelse(x<50,1,ifelse(x<100,2,3))})
rfm$freq_bin <- sapply(rfm$Frequency, function(x){ifelse(x<1,1,ifelse(x<5,2,3))})
rfm$mon_bin <- sapply(rfm$Monetary, function(x){ifelse(x<300,1,ifelse(x<1000,2,3))})


# Get rid of NAs -- normally you would have 
# to find out the cause of NAs from data
rfm <- na.omit(rfm)

data <- rfm %>% select(rec_bin, freq_bin, mon_bin)


################################################
##  Step 3: Clustering                        #
##############################################

## First we determine the maximum number of clusters
kmax <- 15
tot.withinss <- sapply(1:kmax, function(k){kmeans(data,k)$tot.withinss})
plot(1:kmax, tot.withinss, type = "l")

# From the plot it seems like 8 is a reasonable choice

km <- kmeans(data,8)

rfm$cluster <- km$cluster


################################################
##  Step 4: Interprete cluster                #
##############################################
m_rec <- mean(rfm$Recency)
m_freq <- mean(rfm$Frequency)
m_mon <- mean(rfm$Monetary)


output <- rfm %>% 
  group_by(cluster) %>% 
  summarise(avg_rec = mean(Recency), 
            avg_freq = mean(Frequency), 
            avg_mon = mean(Monetary)) %>% 
  mutate(label = str_c(ifelse(avg_rec>m_rec, "H","L"),
                       ifelse(avg_freq>m_freq, "H","L"),
                       ifelse(avg_mon>m_mon, "H","L")
                       ))

## Some interpretation for the labels:
## - LHH: Diamond segment, our best customers
## - LHL: Frequent buyers, figure out what do they like and try to cross-sell something
## - LLH: Promising
## - LLL: Hard to assess
## - HHH: Sleeping beauties, good customers that need reactivation
## - HHL: Budget-conscious, worth reactivating if the goal is increase market share
## - HLH: Worth reactivating if the goal is to increase sales
## - HLL: Probably lost, may not be worth reactivating




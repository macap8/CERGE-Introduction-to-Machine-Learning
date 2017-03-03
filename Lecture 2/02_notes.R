rm(list=ls())
setwd("~/Disk Google/Repositories/CERGE-Introduction-to-Machine-Learning/Lecture 1")
getwd()

df <- read.csv("./data/orders.csv")

df$Date <- as.Date(df$Date, format = "%m/%d/%Y")

max(df$Date) #Check the latest date

ref_date <- as.Date("2016-05-18")

################################################
##  Step 1: RFM Summary                       #
##############################################

rfm <- df %>% 
  group_by(Customer.ID) %>%
  summarise(
    Recency = as.integer(difftime(ref_date,max(Date), units = "days")), 
    Frequency = n(), 
    Monetary = sum(Subtotal)
    )

hist(rfm$Frequency)
hist(rfm$Monetary)
hist(rfm$Recency)

table(rfm$Monetary)

################################################
##  Step 2: Binning                           #
##############################################


rfm$rec_bin <- sapply(rfm$Recency, function(x){ifelse(x<1000,1,ifelse(x<2000,2,3))})
rfm$freq_bin <- sapply(rfm$Frequency, function(x){ifelse(x>10,1,ifelse(x>4,2,3))})
rfm$mon_bin <- sapply(rfm$Monetary, function(x){ifelse(x<50,1,ifelse(x<100,2,3))})

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

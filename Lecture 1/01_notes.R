rm(list=ls())
setwd("~/Disk Google/Repositories/CERGE-Introduction-to-Machine-Learning/Lecture 1")
getwd()

#install.packages("dplyr")
library(dplyr)
library(ggplot2)

df <- read.csv("./data/orders.csv")

# Check everything loaded correctly
head(df)
tail(df)
summary(df)

# Coerce to date types
df$Date <- as.Date(df$Date, format = "%m/%d/%Y")

summary(df)

# Recency - Days form last purchase
# Frequency - Total # of purchases
# Monetary - sum subtotals

#### dplyr ####
# select
df %>% select(Customer.ID, Country) %>% head

# filter 
df %>% filter(Customer.ID=="7")

# Monetary 
df %>% 
  group_by(Customer.ID) %>%
  summarise(Monetary = sum(Subtotal))  %>%
  head

# Frequency 
df %>% 
  group_by(Customer.ID) %>%
  summarise(Frequency = n()) %>% #count number of rows
  head

rfm = df %>%
          group_by(Customer.ID) %>%
          summarise(last_purchase = max(Date), 
                    recency = as.double(difftime("2016-01-01",
                                                   as.Date(last_purchase, 
                                                           origin = "1970-01-01"),
                                                   units = "days"
                                                   )),
                    frequency = n(),
                    monetary = sum(Subtotal))
head(rfm)


# Are custome

ggplot(rfm, aes(x= recency, 
                y= frequency, 
                size=monetary,
                color = monetary)) + geom_point()
          

##  YOUR TURN:

# Revenue per country/region?
country = df %>% 
             group_by(Country) %>%
             summarise(Monetary = sum(Subtotal))
region = df %>% 
  group_by(State) %>%
  summarise(Monetary = sum(Subtotal))

# Which country/region has: 
# - the largest purchase
print(df$Country==max(df$Country))

# - the biggest revenue
print(country==max(country$Monetary))

# - the biggest total sales?


# Revenue of one-time purchasers per country?

df %>%
  group_by(Country) %>%
  summarise(max_pch = sum(Subtotal)) %>%
  arrange(desc(max_pch)) %>%
  head

df %>%
  group_by(Country) %>%
  summarise(max_pch = max(Subtotal)) %>%
  arrange(desc(max_pch)) %>%
  head

df %>%
  group_by(Country) %>%
  summarise(max_pch = n()) %>%
  arrange(desc(max_pch)) %>%
  head






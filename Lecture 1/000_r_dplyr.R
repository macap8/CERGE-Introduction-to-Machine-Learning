library(dplyr)
library(ggplot2)

df <- read.csv("./data/orders.csv")

# Check everything loaded correctly
head(df)

tail(df)



# Coerce to date types
df$Date <- as.Date(df$Date, format = "%m/%d/%Y")


# select 
df %>% select(Customer.ID, Country) %>% head

# filter 
df %>% filter(Customer.ID=='7', Subtotal > 0.4)

# arrange, other verbs... 
df %>% slice(3:5) %>% select(Country)

# group operations
df %>% 
  group_by(Customer.ID) %>% 
  summarise(Monetary = sum(Subtotal)) %>% 
  head


df %>% 
  group_by(Customer.ID) %>%
  summarise(Frequency = n()) %>% #count(*) in SQL
  filter(Frequency > 10)


# Calculate RFM with dplyr
rfm <- df%>%
  group_by(Customer.ID) %>%
  summarise(last_purchase=max(Date), 
            recency = as.double(difftime("2016-01-01",
                                         as.Date(last_purchase, origin="1970-01-01"),  
                                        units = "day")), 
            frequency = n(), 
            monetary = sum(Subtotal)
            )
  
head(rfm)

# Are customers purchasing more recently more profitable?
ggplot(rfm, aes(x=recency, y = frequency, size = monetary)) + geom_point()

rfm %>% ggplot(aes(x=recency, y=monetary)) + geom_point(position = "jitter")+theme_bw()


# Do one-time-purchasers spend more or less in average?
rfm %>% 
  mutate(one_time = ifelse(frequency==1, "One-timer","More than once")) %>%
  group_by(one_time) %>%
  summarise(avg_spent = mean(monetary))

# Distribution of money spent between one-time purchase and the rest?
rfm2 <- rfm %>% 
        mutate(one_time = ifelse(frequency==1, "One-timer","More than once"), 
               avg_per_purchase = monetary/frequency) %>%
        group_by(one_time)


rfm2 %>% ggplot(aes(x=one_time, y=monetary))+geom_violin()


# Ok, we obviously have an outlier
rfm2 %>% 
  filter(monetary<1000)%>%
  ggplot(aes(x=one_time, y=monetary))+geom_violin()+
  xlab("One-time purchasers")+theme_bw()

## Oops, that didn't work out... perhaps you meant?

rfm2 %>% 
  filter(monetary<1000)%>%
  ggplot(aes(x=as.factor(one_time), y=monetary))+geom_violin(fill="blue")+
  xlab("One-time purchasers")+theme_bw()

##  YOUR TURN:

# Revenue per country/region?
# Which country/region has: 
# - the largest sale
# - the biggest revenue
# - the biggest total sales?

# Revenue of one-time purchasers per country?
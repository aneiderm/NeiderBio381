

library(dplyr)
library(TeachingDemos)
char2seed("AuntMarge")

HarryPotter <- read.csv("Class demos/HarryPotter.csv")
head(HarryPotter)
glimpse(HarryPotter)

# subset observations (rows)
# 1. Filter: return rows that satisfy a condition
# filter the rows for the weasley family

output=HarryPotter %>% filter(Last.Name=="Weasley")
print(output)

# filter the rows for the weasley family and keep family members born after 1980
HarryPotter %>% filter(Last.Name=="Weasley",BirthYear>=1980)

# Random sample / selection of rows 
# sample_n
# sample_frac

# sample_frac sample 10% of the rows in the entire in the dataset
sample_frac(HarryPotter,size = 0.1, replace = FALSE)

# sample_n
output=HarryPotter %>% filter(Blood_Status=="HalfBlood", Sex=="Female")
print(output)

sample_n(output,size = 2,replace = FALSE)

# re-order rows using the function arrange
output <- HarryPotter%>%
  filter(Blood_Status=="PureBlood",
         Sex=="Male")%>%
  arrange(Last.Name,First.Name)
print(output)

# subset variables (columns)
# select specfic columns
output <- HarryPotter %>% 
  select(First.Name,House)
print(output)

HarryPotter %>% 
  select(First.Name,House)%>% 
  head

# to select all columns except a specific one 
# use the -

HarryPotter %>% 
  select(-Sex)%>% 
  head(8)

# seelct a range of columns
HarryPotter %>% 
  select(Last.Name:House)%>%
  head

# select helper functions
# select columns sharing similar names
# "ends_with"

HarryPotter %>%
  select(ends_with("Name")) %>%
  head

# regular expressions - set of characters that you can use to look for particular patterns in your data
HarryPotter %>% 
  select(matches("\\.")) %>%
  head

# create a new variable/ column
# Mutate and Transmutate

# add a new column called "Name"
# first and last name combined

# add a new column called "Age"
output <- HarryPotter %>%
  mutate(Name=paste(First.Name,"_",
                    Last.Name),
         Age=(2018-BirthYear))
print(output)

# add a new column called "Name"
# replace everything else
names= HarryPotter %>%
  transmute(Name= paste(First.Name,
                        "_",Last.Name))
head(names)

# summarize the data

# summarize: create summary stats for a given columns or columns in the data frame
# group_by: group/ split the data

# split the data by house
# take the average of people in those houses
# find the max height
# provide the total number of observations providing data
# for a particular house

HarryPotter %>%
  group_by(House)%>%
  summarise(avg_height=mean(Height),
             tallest=max(Height),
            total_ppl=n())

# combine row and column functions

HarryPotter %>%
  select(Sex, Blood_Status, Height) %>%
  filter(Sex=="Male",Blood_Status=="PureBlood")%>%
  filter(Height>67, Height<72)%>%
  arrange(desc(Height))

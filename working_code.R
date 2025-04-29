# Required packages
# Load the necessary libraries
library(tidymodels)
library(readxl)
library(tidyverse)
library(here)
library(performance)
library(usethis)
library(gitcreds)
library(tidyverse)
library(emmeans)
library(janitor)
library(see)


#setting up github on the new work space----
#use_git_config(user.name  = "Ben Wildey",
#user.email = "benwildey8@gmail.com")

#usethis::create_github_token()
#used to make the token 

#gitcreds::gitcreds_set()
#used to set the token
#________________----


# Read the dataset into R
ch4 <- read_xlsx(here("data", "DNA methylation data.xlsm"), sheet = 1)

# Explore the first few rows
head(ch4)


# Create the bar graph to check age distribution of samples
ggplot(ch4, aes(x = factor(Age), y = frequency(Age))) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Samples for Each Age",
       x = "Age",
       y = "Number of Samples") +
  theme_minimal()

#checking methylation values are all between 0-100
summary(ch4)



# Separate the column into two new columns
ch4_clean <- ch4 %>% separate(Sample, into = c("Location", "Year"), sep = "[_-]")


#checking for missing data %'s

# Calculate the percentage of missing values for each column
column_missing_percentage <- colMeans(is.na(ch4)) * 100
print(column_missing_percentage)
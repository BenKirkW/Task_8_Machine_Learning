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
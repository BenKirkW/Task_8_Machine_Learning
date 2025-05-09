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
#less than 5% missing data so we will drop it 
ch4_clean_done<-drop_na(ch4_clean)
column_missing_percentage <- colMeans(is.na(ch4_clean_done)) * 100
print(column_missing_percentage)

#Our goal is to determine if DNA methylation patterns at specific CpG sites can serve as epigenetic biomarkers of aging in bats. This “epigenetic clock” approach has been used successfully in humans and other mammals to estimate biological age.

linear_model <- linear_reg() |> 
  set_engine("lm")  # We are using the "lm" engine for linear regression
#Why is linear regression an appropriate starting point for this biological question? What assumptions are we making about the relationship between methylation levels and age?
#Linear regression provides a straightforward approach to quantifying relationships between variables. In our bat methylation dataset, we’re assuming that changes in methylation at specific CpG sites correlate linearly with age - similar to how methylation-based “epigenetic clocks” work in humans and other mammals.

#In methylation studies, preprocessing steps can dramatically affect your results. The variability of methylation measurements between samples often requires normalization to reveal meaningful biological patterns rather than technical artifacts.
#Centering a predictor variable means subtracting its mean from each value, so that the mean of the variable becomes zero. This is an important step for several reasons

#Let’s center the predictors (methylation values for each CpG site) in the recipe: ----

age_recipe <- recipe(Age ~ ., data = ch4_clean_done) |> 
  step_center(all_predictors(),-all_nominal())  # Centering the predictors except the 3 factor variables: Location, Year, and Age category

#Create a Workflow
#One of the key advantages of tidymodels is the ability to combine model specification and preprocessing into a single workflow. This ensures consistency and reproducibility.
workflow_model <- workflow() |> 
  add_model(linear_model) |> 
  add_recipe(age_recipe)
#By combining these steps, you ensure that: 1. The same preprocessing steps are applied consistently to new data 2. The entire modeling process can be saved as a single object 3. Cross-validation and resampling can be performed on the complete workflow

#fit the model----
fit_model <- fit(workflow_model, data = ch4_clean_done)

fit_model_summary <- tidy(fit_model)
fit_model_summary

#Biological Interpretation: Each coefficient represents how much a one-unit change in methylation at a specific CpG site affects predicted age. Positive coefficients indicate sites where methylation increases with age, while negative coefficients show sites where methylation decreases with age.
#Stop and Think: Which CpG sites appear most important for predicting age? Are there any that don’t seem significantly associated with age?



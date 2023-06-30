options(warn = -1)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#This procedure and its code is for cleaning and compiling the dataset to be used in STATA

library(dplyr)
library(haven)
library(stringr)

polvol <- read_dta("Dataset_HighProfileCriminalViolence.dta")

munpop <- read.csv("mexico_mun_census_2010.csv", header = TRUE)

munpop <- munpop[, c("state", "municipality", "total_pop")]

munpop$municipality <- str_trim(munpop$municipality)
munpop$state <- str_trim(munpop$state)

full_dataset <- left_join(polvol, munpop, by = c("state","municipality"))

# Check for differences in municipality and state values between the datasets
mismatched_municipalities <- setdiff(unique(polvol$municipality), unique(munpop$municipality))
mismatched_states <- setdiff(unique(polvol$state), unique(munpop$state))

print(mismatched_municipalities)
print(mismatched_states)

# Export the merged dataset as a Stata data file
write_dta(full_dataset, "merged_dataset.dta")

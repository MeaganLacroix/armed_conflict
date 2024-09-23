
library(here)
library(dplyr)
library(tidyr)
library(purrr)
library(countrycode)




raw_mat_mor <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)
raw_inf_mor <- read.csv(here("original", "infantmortality.csv"), header = TRUE)
raw_neonat_mor <- read.csv(here("original", "neonatalmortality.csv"), header = TRUE)
raw_under5_mor <- read.csv(here("original", "under5mortality.csv"), header = TRUE)


clean_data <- function(x, suffix) {
  subset <- x %>%
    select(Country.Name, X2000:X2019) %>%
    pivot_longer(!Country.Name, names_to = "year", values_to = "Mor") %>%
    mutate(year = as.numeric(gsub("^X", "", year))) %>%
    rename_at(vars(Mor), ~ paste0("Mor_", suffix))  # Add suffix to the Mor column
  
  return(subset)
}



dat_long_inf_mor <- clean_data(raw_inf_mor, "inf")
dat_long_neonat_mor <- clean_data(raw_neonat_mor, "neonat")
dat_long_under5_mor <- clean_data(raw_under5_mor, "under5")
dat_long_mat_mor <- clean_data(raw_mat_mor, "mat")



write.csv(dat_long_mat_mor, here("data", "dat_long_mat_more.csv"), row.names = FALSE)
write.csv(dat_long_inf_mor, here("data", "dat_long_inf_more.csv"), row.names = FALSE)
write.csv(dat_long_neonat_mor, here("data", "dat_long_neonat_more.csv"), row.names = FALSE)
write.csv(dat_long_under5_mor, here("data", "dat_long_under5_more.csv"), row.names = FALSE)



#Merge the four datasets
list_mor <- list(dat_long_inf_mor, dat_long_neonat_mor, dat_long_under5_mor, dat_long_mat_mor)

merged_mor <- reduce(list_mor, full_join, by = c("Country.Name", "year"))



merged_mor$ISO <- countrycode(merged_mor$Country.Name,
                              origin = "country.name",
                              destination = "iso3c")

write.csv(merged_mor, here("data", "merged_mor.csv"), row.names = FALSE)


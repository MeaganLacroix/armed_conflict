
library(here)
library(dplyr)

covs <- read.csv(here("original", "covariates.csv"), header = TRUE)

source(here("R", "prepare_mortality.R"))
source(here("R", "prepare_disaster.R"))
source(here("R", "prepare_conflict.R"))


alllist <- list(clean_conflict, clean_disaster, merged_mor)



finaldata0 <- alllist %>%
  reduce(full_join, by = c('ISO', 'year'))  

finaldata <- covs %>%
  left_join(finaldata0, by = c('ISO', 'year'))


finaldata <- finaldata %>%
  mutate(armconf1 = replace_na(armconf1, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         totdeath = replace_na(totdeath, 0))

write.csv(finaldata, file = here("Data", "finaldata.csv"), row.names = FALSE)



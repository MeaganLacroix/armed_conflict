#Disaster data

library(here)
library(dplyr)

raw_disaster <- read.csv(here("original", "disaster.csv"), header = TRUE)

clean_disaster <- raw_disaster %>%
  filter(Year >= 2000 & Year <= 2019, Disaster.Type %in% c("Earthquake", "Drought")) %>%
  select(Year, ISO, Disaster.Type) %>%
  rename(year = Year) %>%
  group_by(year, ISO) %>%
  mutate(drought = ifelse(Disaster.Type == "Drought", 1, 0),
         earthquake = ifelse(Disaster.Type == "Earthquake", 1, 0)) %>%
  summarize(
    drought = max(drought),            
    earthquake = max(earthquake),      
    .groups = 'drop'
  )

write.csv(clean_disaster, here("data", "clean_disaster.csv"), row.names = FALSE)
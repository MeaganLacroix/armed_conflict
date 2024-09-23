library(here)
library(dplyr)

raw_conflict <- read.csv(here("original", "conflictdata.csv"), header = TRUE)

clean_conflict <- raw_conflict %>%
  group_by(ISO, year) %>%
  summarise(totdeath = sum(best)) %>%
  mutate(armconf1 = ifelse(totdeath < 25, 0, 1)) %>%
  ungroup() %>%
  mutate(year = year + 1) 

write.csv(clean_conflict, here("data", "clean_conflict.csv"), row.names = FALSE)
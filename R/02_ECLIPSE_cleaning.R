### clean baseline local histogram data from ECLIPSE and create
## 1) file with summary whole lung LH values
## 2) file with subtype whole lung LH values


### import ECLIPSE baseline LH dataset ###
ECLIPSE_raw <- read_csv("data/raw_data/ECLIPSE_L1_localHistogram_parenchymaPhenotypes_20180305_wideFormat.csv")
ECLIPSE_pre1 <- clean_names(ECLIPSE_raw)

###################################### file with summary whole lung LH values ######################################
eclipse_LH_summary_whole_pre1 <- ECLIPSE_pre1 %>% select(starts_with("whole")) %>% select(-contains("wild")) %>% select(contains("type_frac"))
eclipse_CID <- ECLIPSE_pre1 %>% select(contains("cid")) %>% mutate(sid=str_sub(cid,start=1L,end=12L))
eclipse_LH_summary_whole_pre2 <- bind_cols(eclipse_LH_summary_whole_pre1,eclipse_CID)

eclipse_LH_summary_whole <- eclipse_LH_summary_whole_pre2 %>% 
  mutate(percent_normal = whole_lung_normal_parenchyma_type_frac) %>% 
  mutate(percent_emphysema = whole_lung_centrilobular_emphysema_type_frac + whole_lung_paraseptal_emphysema_type_frac) %>% 
  mutate(percent_interstitial = whole_lung_reticular_type_frac + whole_lung_subpleural_line_type_frac) %>% 
  select(cid, sid, percent_normal, percent_emphysema, percent_interstitial)

write_csv(eclipse_LH_summary_whole, "data/clean_data/ECLIPSE_L1_localHistogram_parenchymaPhenotypes_20180305_summary_wholelung.csv")

###################################### file with subtype whole lung LH values ######################################
write_csv(eclipse_LH_summary_whole_pre2, "data/clean_data/ECLIPSE_L1_localHistogram_parenchymaPhenotypes_20180305_subtype_wholelung.csv")

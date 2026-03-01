rm(list = ls())

library(dplyr)
library(ggplot2)
library(pharmaverseadam)
library(scales)

adsl <- pharmaverseadam::adsl
adae <- pharmaverseadam::adae

adae_saf <- adae %>%
  filter(SAFFL == "Y")

adsl_saf <- adsl %>% 
  filter(SAFFL == "Y")

N_total <- n_distinct(adsl_saf$USUBJID)

ae_subject_level <- adae_saf %>%
  filter(!is.na(AETERM)) %>%
  distinct(USUBJID, AETERM)

top10_ae <- ae_subject_level %>%
  count(AETERM, name = "n") %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)

top10_ae_1 <- top10_ae %>%
  rowwise() %>%
  mutate(
    incidence = n / N_total,
    ci = list(binom.test(n, N_total, conf.level = 0.95)$conf.int),
    lower = ci[1],
    upper = ci[2]
  ) %>%
  ungroup() %>%
  select(-ci)

ae_plot2 <- ggplot(top10_ae_1,
                   aes(x = reorder(AETERM, incidence),
                       y = incidence)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = lower, ymax = upper),
                width = 0.2) +
  coord_flip() +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Top 10 Most Frequent Adverse Events",
    subtitle=paste0("n = ",N_total," subjects; 95% Clopper-Pearson CIs"),
    x = " ",
    y = "Percentage of Patients (%)"
  ) +
  theme_gray() +
  theme(
    plot.title = element_text(hjust = 0)
  )

ggsave(
  filename = "question_4_tlg/output/ae_top_10_fp.png",
  plot = ae_plot2,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300
)
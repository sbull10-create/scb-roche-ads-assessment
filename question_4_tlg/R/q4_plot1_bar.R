rm(list = ls())

library(dplyr)
library(ggplot2)
library(pharmaverseadam)
library(scales)

adsl <- pharmaverseadam::adsl
adae <- pharmaverseadam::adae

adae_saf <- adae %>%
 filter(SAFFL == "Y")

ae_sev_summary <- adae_saf %>%
  filter(!is.na(AESEV)) %>%
  count(ACTARM, AESEV) %>%
  group_by(ACTARM)

ae_sev_sum <- ggplot(ae_sev_summary,
       aes(x = ACTARM, y = n, fill = AESEV)) +
  geom_col(position = "stack", color = "black") +
  labs(
    title = "AE severity distribution by treatment",
    x = "Treatment Arm",
    y = "Count of AEs",
    fill = "Severity/Intensity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "right"
  )

ggsave(
  filename = "question_4_tlg/output/ae_severity_distribution.png",
  plot = ae_sev_sum,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300
)

# Install and load
devtools::install("")
library(descriptiveStats)
# Example data
data<-  c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)
# Use functions
calc_mean(data) # 3.3
calc_median(data) # 4.5
calc_mode(data) # 5
calc_q1(data) # 2.5
calc_q3(data) # 5.5
calc_iqr(data) # 3
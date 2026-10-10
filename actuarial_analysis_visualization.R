
# Project: Cyber Risk Pricing Pipeline
# Module: Portfolio Risk Visualization & Actuarial Hypothesis Testing



# Core libraries for visualization and relational interfaces
library(DBI)
library(RSQLite)
library(ggplot2)

# 1. Database Connection Initialization
db_path > EXECUTING INFERENCE RUN 1: WELCH'S T-TEST (LOG-TRANSFORMED DATA)")
t_test_result <- t.test(log(mfa_yes), log(mfa_no))
print(t_test_result)

# Execution Framework 2: Non-Parametric Wilcoxon Rank-Sum Evaluation
message("\n>>> EXECUTING INFERENCE RUN 2: WILCOXON RANK-SUM TEST (RAW VOLUME BOUNDARIES)")
wilcox_result <- qcc::wilcox.test(mfa_yes, mfa_no)  # Maps your original raw call specifications
print(wilcox_result)

install.packages("ggplot2")






# ==========================================
# Cyber Risk Portfolio Visualizations
# ==========================================

library(DBI)
library(RSQLite)
library(ggplot2)

# 1. Connect to SQLite database
setwd("C:/Users/pc/OneDrive/Documents")
con <- DBI::dbConnect(RSQLite::SQLite(), "cyber_risk_database.db")

# 2. Extract data for Industry Sector Rankings
sector_query <- "
SELECT 
    c.industry_sector,
    COUNT(b.incident_id) AS total_incidents,
    SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout) AS total_aggregate_loss
FROM insured_companies c
JOIN breach_events b ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.industry_sector
ORDER BY total_aggregate_loss ASC;
"
sector_df <- DBI::dbGetQuery(con, sector_query)

# 3. Extract data for MFA Impact
mfa_query <- "
SELECT 
    CASE WHEN c.mfa_enabled = 1 THEN 'MFA Enabled' ELSE 'MFA Disabled' END AS mfa_status,
    SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout) AS total_aggregate_loss
FROM insured_companies c
JOIN breach_events b ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.mfa_enabled;
"
mfa_df <- DBI::dbGetQuery(con, mfa_query)

# Disconnect safely
DBI::dbDisconnect(con)

# ==========================================
# 4. Plot 1: Industry Sector Loss Rankings
# ==========================================
p1 <- ggplot(sector_df, aes(x = industry_sector, y = total_aggregate_loss / 1e6, fill = industry_sector)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Total Aggregate Cyber Loss by Industry Sector",
    subtitle = "Portfolio Risk Exposure Rankings",
    x = "Industry Sector",
    y = "Total Aggregate Loss ($ Millions)"
  ) +
  theme_minimal()

print(p1)

# ==========================================
# 5. Plot 2: MFA Risk Mitigation Impact
# ==========================================
p2 <- ggplot(mfa_df, aes(x = mfa_status, y = total_aggregate_loss / 1e6, fill = mfa_status)) +
  geom_bar(stat = "identity", width = 0.5, show.legend = FALSE) +
  labs(
    title = "Aggregate Cyber Loss by MFA Status",
    subtitle = "Evaluating Security Control Effectiveness",
    x = "Multi-Factor Authentication Status",
    y = "Total Aggregate Loss ($ Millions)"
  ) +
  theme_minimal()

print(p2)







# ==========================================
# Actuarial Cyber Risk Hypothesis Testing
# ==========================================

library(DBI)
library(RSQLite)

# 1. Connect to SQLite database
setwd("C:/Users/pc/OneDrive/Documents")
con <- DBI::dbConnect(RSQLite::SQLite(), "cyber_risk_database.db")

# 2. Pull individual loss data with MFA status
query <- "
SELECT 
    c.mfa_enabled,
    (f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout) AS total_loss
FROM insured_companies c
JOIN breach_events b ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id;
"

df <- DBI::dbGetQuery(con, query)
DBI::dbDisconnect(con)

# Separate data into groups
mfa_yes <- df$total_loss[df$mfa_enabled == 1]
mfa_no  <- df$total_loss[df$mfa_enabled == 0]

# ==========================================
# TEST 1: Two-Sample t-Test on Log-Transformed Losses
# (Since cyber losses are heavy-tailed log-normal, log-transforming normalizes them)
# ==========================================
cat("==========================================")
cat("\nTEST 1: Welch's t-Test (Log-Transformed Losses)\n")
cat("==========================================\n")
t_test_result <- t.test(log(mfa_yes), log(mfa_no))
print(t_test_result)

# ==========================================
# TEST 2: Wilcoxon Mann-Whitney Non-Parametric Test
# (Robust test that doesn't assume normal distribution)
# ==========================================
cat("\n==========================================")
cat("\nTEST 2: Wilcoxon Rank-Sum Test (Raw Losses)\n")
cat("==========================================\n")
wilcox_result <- wilcox.test(mfa_yes, mfa_no)
print(wilcox_result)

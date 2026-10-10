
# Project: Cyber Risk Pricing Pipeline
# Module: Feature Engineering & Detection Dwell-Time Lag Analysis
# Analyst: Lenny Wanjiru (DeKUT Actuarial Science)


# Core libraries for database connectivity
library(DBI)
library(RSQLite)

# 1. Database Connection Initialization
# [Note: Removed environment-specific setwd() to guarantee cross-platform portability]
db_path <- "cyber_risk_database.db"

if (!file.exists(db_path)) {
  stop(paste("Execution aborted: Target database file '", db_path, "' not found in current directory."))
}

con <- dbConnect(SQLite(), db_path)


# FEATURE ENGINEERING: CALCULATE PORTFOLIO DETECTION LAG METRICS


# Query to extract average detection lag intervals grouped by company profile
lag_query <- "
SELECT 
    c.company_id,
    c.industry_sector,
    c.mfa_enabled,
    COUNT(b.incident_id) AS total_breaches,
    ROUND(AVG(b.detection_lag_days), 2) AS avg_detection_lag_days
FROM insured_companies c
JOIN breach_events b ON c.company_id = b.company_id
GROUP BY c.company_id, c.industry_sector, c.mfa_enabled
ORDER BY avg_detection_lag_days DESC;
"

# Ingest and map unstructured database records to workspace feature memory
detection_lag_df <- dbGetQuery(con, lag_query)

# Safe termination of connection parameters now that features are safely cached
dbDisconnect(con)


# OPERATIONAL REPORTING TELEMETRY

message("\n>>> EXECUTING LOG: PORTFOLIO FEATURE EXTRACTION SUITE")
cat("Feature Metric Isolated: Dwell Time (Detection Lag Days) Per Enterprise\n")

# Log top 10 systemic exposure outliers directly to system console
message("\n>>> TOP 10 HIGHEST RISK PROFILE DETECTION OUTLIERS")
print(head(detection_lag_df, 10))
 


# Feature Engineering: Detection Lag Analysis

library(DBI)
library(RSQLite)

# 1. Connect to SQLite database
setwd("C:/Users/pc/OneDrive/Documents")
con <- DBI::dbConnect(RSQLite::SQLite(), "cyber_risk_database.db")

# 2. Query to calculate average detection lag per company and flatten the table
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

detection_lag_df <- DBI::dbGetQuery(con, lag_query)

# 3. Print the top 10 companies with the highest average detection lag
print("==========================================")
print("   COMPANY DETECTION LAG FEATURE TABLE    ")
print("==========================================")
print(head(detection_lag_df, 10))

# 4. Clean disconnect
DBI::dbDisconnect(con)
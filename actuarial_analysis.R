
 
# Project: Cyber Risk Pricing Pipeline
# Module: Actuarial Data Aggregation & Sector Exploratory Analysis
# Analyst: Lenny Wanjiru (DeKUT Actuarial Science)


# Core dependencies for relational interface
library(DBI)
library(RSQLite)

# 1. Database Connection Initialization
# [Note: Hardcoded local setwd() removed to maintain relative project path portability]
db_path <- "cyber_risk_database.db"

if (!file.exists(db_path)) {
  stop(paste("Execution aborted: Target database file '", db_path, "' not found in current workspace."))
}

con <- dbConnect(SQLite(), db_path)


# PART 1: MULTI-FACTOR AUTHENTICATION (MFA) MITIGATION EXPOSURE TESTING


mfa_query <- "
SELECT 
    CASE WHEN c.mfa_enabled = 1 THEN 'MFA Enabled' 
         ELSE 'MFA Disabled' 
    END AS mfa_status,
    COUNT(b.incident_id) AS total_incidents,
    ROUND(AVG(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS avg_financial_loss,
    ROUND(SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS total_aggregate_loss
FROM insured_companies c
JOIN breach_events b    ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.mfa_enabled;
"

mfa_results <- dbGetQuery(con, mfa_query)

# Structured execution telemetry logging
message("\n>>> EXECUTING LOG: MFA RISK MITIGATION PERFORMANCE BRIEF")
print(mfa_results)


# PART 2: SYSTEMIC ACCUMULATION & INDUSTRY SECTOR RISK RANKINGS


sector_query <- "
SELECT 
    c.industry_sector,
    COUNT(b.incident_id) AS total_incidents,
    ROUND(SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS total_aggregate_loss,
    ROUND(AVG(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS average_loss
FROM insured_companies c
JOIN breach_events b    ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.industry_sector
ORDER BY total_aggregate_loss DESC;
"

sector_results <- dbGetQuery(con, sector_query)

message("\n>>> EXECUTING LOG: PORTFOLIO RISK DISTRIBUTION BY INDUSTRY SECTOR")
print(sector_results)


# 3. Connection Termination

dbDisconnect(con)
message("\nDatabase connection closed successfully. Workflow complete.")

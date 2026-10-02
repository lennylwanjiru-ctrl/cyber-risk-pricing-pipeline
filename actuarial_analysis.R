
 1. Set working directory
setwd("C:/Users/pc/OneDrive/Documents")

 2. Connect to the SQLite database
con <- DBI::dbConnect(RSQLite::SQLite(), "cyber_risk_database.db")



 PART 1: MFA Risk Mitigation Impact Query

mfa_query <- "
SELECT 
    CASE WHEN c.mfa_enabled = 1 THEN 'MFA Enabled' ELSE 'MFA Disabled' END AS mfa_status,
    COUNT(b.incident_id) AS total_incidents,
    ROUND(AVG(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS avg_financial_loss,
    ROUND(SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS total_aggregate_loss
FROM insured_companies c
JOIN breach_events b ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.mfa_enabled;
"

mfa_results <- DBI::dbGetQuery(con, mfa_query)
print("==========================================")
print("   MFA RISK MITIGATION IMPACT REPORT      ")
print("==========================================")
print(mfa_results)
cat("\n\n")


 PART 2: Industry Sector Loss Rankings Query

sector_query <- "
SELECT 
    c.industry_sector,
    COUNT(b.incident_id) AS total_incidents,
    ROUND(SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS total_aggregate_loss,
    ROUND(AVG(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 2) AS average_loss
FROM insured_companies c
JOIN breach_events b ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.industry_sector
ORDER BY total_aggregate_loss DESC;
"

sector_results <- DBI::dbGetQuery(con, sector_query)
print("==========================================")
print("   INDUSTRY SECTOR LOSS RANKINGS          ")
print("==========================================")
print(sector_results)

 3. Clean disconnect from database
DBI::dbDisconnect(con)

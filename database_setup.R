 1. Set working directory to the exact folder where your CSVs live
setwd("C:/Users/pc/OneDrive/Desktop/project_data_used")

 2. Connect to database
con <- DBI::dbConnect(RSQLite::SQLite(), "cyber_risk_database.db")

 3. Write/refresh the tables from your CSV files
DBI::dbWriteTable(con, "insured_companies", read.csv("cyber_insured_companies.csv"), overwrite = TRUE)
DBI::dbWriteTable(con, "breach_events", read.csv("cyber_breach_events.csv"), overwrite = TRUE)
DBI::dbWriteTable(con, "financial_losses", read.csv("cyber_financial_losses.csv"), overwrite = TRUE)

print("Tables successfully loaded into SQLite database!")

 4. Run the SQL join query across all three tables
sql_query <- "
SELECT 
    c.company_id,
    c.industry_sector,
    b.incident_id,
    b.breach_type,
    (f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout) AS total_financial_loss
FROM insured_companies c
JOIN breach_events b ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
LIMIT 10;
"

relational_results <- DBI::dbGetQuery(con, sql_query)
print("SQL Join Query Results:")
print(relational_results)

 5. Clean disconnect
DBI::dbDisconnect(con)
print("Pipeline execution complete and disconnected successfully.")









 Reconnect to your database
con <- DBI::dbConnect(RSQLite::SQLite(), "cyber_risk_database.db")

# Pull a larger sample or the full joined results
full_results <- DBI::dbGetQuery(con, "
  SELECT 
      c.company_id,
      c.industry_sector,
      b.incident_id,
      b.breach_type,
      (f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout) AS total_financial_loss
  FROM insured_companies c
  JOIN breach_events b ON c.company_id = b.company_id
  JOIN financial_losses f ON b.incident_id = f.incident_id
")

 This opens an interactive spreadsheet viewer window in your editor!
View(full_results)

 Clean disconnect
DBI::dbDisconnect(con)

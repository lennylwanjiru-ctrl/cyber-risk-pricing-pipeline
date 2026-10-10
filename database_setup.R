
# Project: Cyber Risk Pricing Pipeline
# Module: Relational Database Initialization & Data Ingestion Engine
# Analyst: Lenny Wanjiru (DeKUT Actuarial Science)


library(DBI)
library(RSQLite)

# 1. Database Connection Initialization
# [Note: Hardcoded path setwd() removed to enforce cross-platform relative pathing]
db_path <- "cyber_risk_database.db"
con <- dbConnect(SQLite(), db_path)


# DATA INGESTION & SCHEMATIC MAPPING (CSV to SQLite)

message("\n>>> INITIALIZING DATA INGESTION SUITE...")

# Ingest unstructured source exposures and cache into structured tables
dbWriteTable(con, "insured_companies", read.csv("cyber_insured_companies.csv"), overwrite = TRUE)
dbWriteTable(con, "breach_events",    read.csv("cyber_breach_events.csv"),    overwrite = TRUE)
dbWriteTable(con, "financial_losses",  read.csv("cyber_financial_losses.csv"),  overwrite = TRUE)

message("Tables successfully materialized within the relational database schema.")


# QUANTITATIVE DATA PIPELINE EXECUTION


# Core SQL Join Architecture matching company profiles to loss aggregates
core_sql_query <- "
SELECT 
    c.company_id,
    c.industry_sector,
    b.breach_type,
    b.incident_id,
    (f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout) AS total_financial_loss
FROM insured_companies c
JOIN breach_events b    ON c.company_id = b.company_id
JOIN financial_losses f ON b.incident_id = f.incident_id
"

# 1. Execution Phase A: Bounded Telemetry Test Run
message("\n>>> EXECUTING SUBSAMPLE LOG: INITIAL RATING CHECKS (LIMIT 10)")
limited_query <- paste(core_sql_query, "LIMIT 10;")
relational_results <- dbGetQuery(con, limited_query)
print(relational_results)

# 2. Execution Phase B: Ingest Full Portfolio Matrix into Active Workspace Memory
message("\n>>> INGESTING METRIC POOL FOR IN-MEMORY ACTUARIAL MODELING...")
full_results <- dbGetQuery(con, core_sql_query)


# DISCONNECT & DATA FRAME PRESERVATION

# Safe termination of connection parameters now that observations are loaded
dbDisconnect(con)
message("\nDatabase connection closed successfully. Workflow complete.")

# Telemetry inspection confirmation printout
cat(sprintf("Total Ingested Portfolio Exposure Records: %d\n", nrow(full_results)))

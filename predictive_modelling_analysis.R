
# Project: Cyber Risk Pricing Pipeline
# Module: Actuarial Predictive Modeling (Parametric GLM Optimization)
# Analyst: Lenny Wanjiru (DeKUT Actuarial Science)


library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Database Connection Initialization
db_path <- "cyber_risk_database.db"

if (!file.exists(db_path)) {
  stop(paste("Execution aborted: Target database file '", db_path, "' not found."))
}

con <- dbConnect(SQLite(), db_path)

# ==============================================================================
# EXPOSURE INGESTION & DATA FRAMING
# ==============================================================================

model_query <- "
SELECT 
    c.company_id,
    c.industry_sector,
    c.mfa_enabled,
    COALESCE(AVG(b.detection_lag_days), 0) AS avg_detection_lag,
    COALESCE(SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 0) AS total_loss
FROM insured_companies c
LEFT JOIN breach_events b    ON c.company_id = b.company_id
LEFT JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.company_id, c.industry_sector, c.mfa_enabled;
"

df_raw <- dbGetQuery(con, model_query)
dbDisconnect(con)

# 2. Operational Data Subsetting & Feature Isolation
# Filters zero-loss records to isolate true positive severity parameters
modeling_df <- df_raw %>%
  filter(total_loss > 0) %>%
  mutate(
    industry_sector = as.factor(industry_sector),
    mfa_enabled     = as.factor(mfa_enabled)
  )

# ==============================================================================
# RATING STRUCTURE 1: GAUSSIAN GLM DEPLOYMENT
# ==============================================================================

cyber_glm <- glm(
  total_loss ~ industry_sector + mfa_enabled + avg_detection_lag,
  data   = modeling_df,
  family = gaussian(link = "log")
)

message("\n>>> EXECUTING MODEL BRIEF: BASE GAUSSIAN GLM PREDICTIONS")
print(summary(cyber_glm))

# Extract initial factor relativities
risk_relativities <- exp(coef(cyber_glm))
message("\n>>> GAUSSIAN EXPOSURE RISK RELATIVITIES")
print(round(risk_relativities, 4))

# ==============================================================================
# MODEL DIAGNOSTICS & GOODNESS-OF-FIT BENCHMARKS
# ==============================================================================
message("\n>>> DEPLOYING VALIDATION MATRIX: DEVIANCE & AIC ASSESSMENTS")

null_deviance <- cyber_glm$null.deviance
res_deviance  <- cyber_glm$deviance
aic_value     <- AIC(cyber_glm)

cat(sprintf("Null Deviance Parameter:     %.2f\n", null_deviance))
cat(sprintf("Residual Deviance Parameter: %.2f\n", res_deviance))
cat(sprintf("Calculated Akaike Info (AIC): %.2f\n", aic_value))

# Likelihood Ratio Chi-Square Assessment for Global Significance Evaluation
chi_sq_stat  <- null_deviance - res_deviance
df_diff      <- cyber_glm$df.null - cyber_glm$df.residual
p_value_main <- 1 - pchisq(chi_sq_stat, df = df_diff)
cat(sprintf("Overall Model Chi-Sq p-value: %e\n", p_value_main))

# ==============================================================================
# CROSS-VALIDATION EVALUATION (80/20 TRAINING SPLIT)
# ==============================================================================
message("\n>>> INITIALIZING OUT-OF-SAMPLE CROSS-VALIDATION ENVIRONMENT...")

set.seed(42)
train_index <- sample(1:nrow(modeling_df), size = 0.8 * nrow(modeling_df))
train_set   <- modeling_df[train_index, ]
test_set    <- modeling_df[-train_index, ]

# Refit baseline Gaussian model over bounded training observations
train_glm <- glm(
  total_loss ~ industry_sector + mfa_enabled + avg_detection_lag,
  data   = train_set,
  family = gaussian(link = "log")
)

# Run predictive inferences against testing cohort vectors
predictions <- predict(train_glm, newdata = test_set, type = "response")
actuals     <- test_set$total_loss

# Compute robust out-of-sample error aggregates
rmse_metric <- sqrt(mean((actuals - predictions)^2))
mae_metric  <- mean(abs(actuals - predictions))
r_squared   <- cor(actuals, predictions)^2

message("\n>>> OUT-OF-SAMPLE PREDICTIVE POWER METRICS")
cat(sprintf("Root Mean Squared Error (RMSE): $%,.2f\n", rmse_metric))
cat(sprintf("Mean Absolute Error (MAE):       $%,.2f\n", mae_metric))
cat(sprintf("Out-of-Sample R-Squared Index:   %.4f\n", r_squared))

# ==============================================================================
# RATING STRUCTURE 2: OPTIMIZED TRUE ACTUARIAL GAMMA GLM
# ==============================================================================

gamma_glm <- glm(
  total_loss ~ industry_sector + mfa_enabled + avg_detection_lag,
  data   = train_set,
  family = Gamma(link = "log")
)

message("\n>>> EXECUTING OPTIMIZED MODEL BRIEF: ACTUARIAL GAMMA GLM ANALYSIS")
print(summary(gamma_glm))
cat(sprintf("Gamma Execution Model AIC: %.2f\n", AIC(gamma_glm)))

# Final Multiplicative Tariff Relativities
gamma_relativities <- exp(coef(gamma_glm))
message("\n>>> FINAL WINNING TARIFF DESIGN: WINNING GAMMA RISK FACTORS")
print(round(gamma_relativities, 4))
 

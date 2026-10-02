# ==========================================
# Actuarial Predictive Modeling: Cyber GLM
# ==========================================

library(DBI)
library(RSQLite)

# 1. Connect to SQLite database
setwd("C:/Users/pc/OneDrive/Documents")
con <- DBI::dbConnect(RSQLite::SQLite(), "cyber_risk_database.db")

# 2. Pull feature-engineered modeling dataset
model_query <- "
SELECT 
    c.company_id,
    c.industry_sector,
    c.mfa_enabled,
    COALESCE(AVG(b.detection_lag_days), 0) AS avg_detection_lag,
    COALESCE(SUM(f.forensic_cleanup_cost + f.regulatory_fines + f.business_interruption_payout), 0) AS total_loss
FROM insured_companies c
LEFT JOIN breach_events b ON c.company_id = b.company_id
LEFT JOIN financial_losses f ON b.incident_id = f.incident_id
GROUP BY c.company_id, c.industry_sector, c.mfa_enabled;
"

df <- DBI::dbGetQuery(con, model_query)
DBI::dbDisconnect(con)

# Filter out companies with zero losses for the severity/loss GLM, 
# or keep them if modeling total pure premium. Let's model companies with recorded losses:
modeling_df <- df[df$total_loss > 0, ]

# Ensure categorical variables are factors
modeling_df$industry_sector <- as.factor(modeling_df$industry_sector)
modeling_df$mfa_enabled <- as.factor(modeling_df$mfa_enabled)

# ==========================================
# 3. Fit Actuarial Gamma GLM (Log Link)
# ==========================================
# Gamma GLM with log link handles positive, right-skewed insurance loss data natively
cyber_glm <- glm(
  total_loss ~ industry_sector + mfa_enabled + avg_detection_lag,
  data = modeling_df,
  family = gaussian(link = "log") # Using log-link regression for skewed severity
)

# ==========================================
# 4. Extract Actuarial Risk Relativities
# ==========================================
print("==========================================")
print("   CYBER RISK PRICING MODEL SUMMARY       ")
print("==========================================")
summary_output <- summary(cyber_glm)
print(summary_output)

# Convert coefficients to multiplicative risk factors (exp(estimate))
risk_relativities <- exp(coef(cyber_glm))
print("\n==========================================")
print("   ACTUARIAL RISK RELATIVITIES (FACTORS)  ")
print("==========================================")
print(round(risk_relativities, 4))








# ==========================================
# Actuarial Model Validation & Diagnostics (Base R)
# ==========================================

# (Assumes 'cyber_glm' and 'modeling_df' are already in your R environment)

# ==========================================
# 1. Goodness-of-Fit Tests (Deviance & AIC)
# ==========================================
cat("==========================================")
cat("\n1. GOODNESS-OF-FIT METRICS\n")
cat("==========================================\n")
null_deviance <- cyber_glm$null.deviance
residual_deviance <- cyber_glm$deviance
aic_value <- AIC(cyber_glm)

cat(sprintf("Null Deviance:      %.2f\n", null_deviance))
cat(sprintf("Residual Deviance:  %.2f\n", residual_deviance))
cat(sprintf("AIC (Model Fit):    %.2f\n", aic_value))

# Likelihood Ratio Chi-Square Test for overall model significance
chi_sq_stat <- null_deviance - residual_deviance
df_diff <- cyber_glm$df.null - cyber_glm$df.residual
p_value_model <- 1 - pchisq(chi_sq_stat, df_diff)
cat(sprintf("Overall Model p-value: %.5f\n", p_value_model))

# ==========================================
# 2. Predictive Power: Out-of-Sample Metrics (Base R Split)
# ==========================================
set.seed(42)
train_index <- sample(1:nrow(modeling_df), size = 0.8 * nrow(modeling_df))
train_set <- modeling_df[train_index, ]
test_set  <- modeling_df[-train_index, ]

# Refit on training set
train_glm <- glm(
  total_loss ~ industry_sector + mfa_enabled + avg_detection_lag,
  data = train_set,
  family = gaussian(link = "log")
)

# Predict on test set
predictions <- predict(train_glm, newdata = test_set, type = "response")

# Calculate Out-of-Sample Error Metrics
actuals <- test_set$total_loss
rmse <- sqrt(mean((actuals - predictions)^2))
mae <- mean(abs(actuals - predictions))
r_squared <- cor(actuals, predictions)^2

cat("\n==========================================")
cat("\n2. OUT-OF-SAMPLE PREDICTIVE POWER\n")
cat("==========================================\n")
cat(sprintf("Root Mean Squared Error (RMSE): $%.2f\n", rmse))
cat(sprintf("Mean Absolute Error (MAE):      $%.2f\n", mae))
cat(sprintf("Out-of-Sample R-Squared ($R^2$):  %.4f\n", r_squared))




















# Fit a true Actuarial Gamma GLM
gamma_glm <- glm(
  total_loss ~ industry_sector + mfa_enabled + avg_detection_lag,
  data = train_set,
  family = Gamma(link = "log")
)

# View the Gamma model summary and AIC
summary(gamma_glm)
cat(sprintf("Gamma Model AIC: %.2f (Compare with Gaussian AIC: 131698.08)\n", AIC(gamma_glm)))














# ==========================================
# Finalizing Module 2: Gamma Risk Relativities
# ==========================================

# Extract multiplicative rating factors from the Gamma GLM
gamma_relativities <- exp(coef(gamma_glm))

print("==========================================")
print("   WINNING MODEL: GAMMA RISK RELATIVITIES ")
print("==========================================")
print(round(gamma_relativities, 4))

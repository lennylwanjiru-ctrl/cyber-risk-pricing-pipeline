
# Project: Cyber Risk Pricing Pipeline
# Module: Gamma GLM Underwriting Tariff & Real-Time Quotation Engine
# Analyst: Lenny Wanjiru (DeKUT Actuarial Science)


library(tidyverse)

#' Generate Risk-Adjusted Commercial Cyber Underwriting Quote
#' @param sector Character string specifying the target industry vertical.
#' @param mfa_status Integer indicating corporate MFA deployment (1 = Active, 0 = Inactive).
#' @param detection_lag_days Numeric count of breach containment dwell time.
#' @return Bounded numeric value representing the total written commercial premium.
generate_cyber_quote <- function(sector, mfa_status, detection_lag_days) {
  
  # Step A: Baseline Parametric Intercept from Validated Gamma GLM Execution
  base_severity <- 106914.77
  
  # Multiplicative Sector Relativity Multipliers
  sector_factors <- c(
    "Finance & Insurance" = 1.0000,
    "Healthcare"          = 1.0450,
    "Manufacturing"       = 0.9688,
    "Professional Services" = 1.0760,
    "Retail & E-commerce" = 1.0886,
    "Technology"          = 1.0389
  )
  
  # Fallback allocation if industry category mapping drops out of boundary boundaries
  sec_multiplier <- if (sector %in% names(sector_factors)) {
    sector_factors[sector]
  } else {
    1.0000
  }
  
  # Step B: Compute Baseline Technical Risk Premium Profile
  technical_base_loss <- base_severity * sec_multiplier
  
  # Step C: Assess Underwriting Credit / Surcharge Modifiers
  security_modifier <- 1.0
  
  if (mfa_status == 1) {
    security_modifier <- security_modifier - 0.15
  } else {
    security_modifier <- security_modifier + 0.10
  }
  
  if (detection_lag_days > 14) {
    extra_weeks <- floor((detection_lag_days - 14) / 7)
    security_modifier <- security_modifier + (0.05 * extra_weeks)
  }
  
  # Constrain modifier parameter within regulatory capital buffer limits
  security_modifier <- max(0.70, min(1.50, security_modifier))
  
  # Step D: Apply Expected Portfolio Management Loadings (10% Target Factor)
  pure_premium <- technical_base_loss * 0.10
  final_quote  <- pure_premium * security_modifier
  
  # Step E: Logging Telemetry Audit Trails to System Console
  message("\n>>> GENERATING RISK-ADJUSTED PREMIUM TARIFF BRIEF")
  cat(sprintf("Industry Vertical Group:  %s (Factor: %.4f)\n", sector, sec_multiplier))
  cat(sprintf("Security Configuration:   MFA Status: %d | Operational Lag: %d days\n", mfa_status, detection_lag_days))
  cat(sprintf("Risk Security Modifier:   %.2f Index Ratio\n", security_modifier))
  cat(sprintf("Calculated Annual Premium: $%,.2f Net\n", final_quote))
  
  return(invisible(final_quote))
}


# PRODUCTION VALIDATION UNIT TESTS

message("\n>>> INITIALIZING RATEMAKING ENVIRONMENT VERIFICATION SUITE...")

# Client Case Study 1: High-Exposure Sub-Portfolio Profile
message("\nProcessing Pipeline Verification Run 1: High Risk Tracking")
quote_1 <- generate_cyber_quote(sector = "Retail & E-commerce", mfa_status = 0, detection_lag_days = 45)

# Client Case Study 2: Low-Exposure Proactive Profile
message("\nProcessing Pipeline Verification Run 2: Optimized Risk Track")
quote_2 <- generate_cyber_quote(sector = "Technology", mfa_status = 1, detection_lag_days = 5)
 


# Module: Operational Underwriting Rating & Security Credit Valuation Engine



library(tidyverse)

#' Calculate Dynamic Risk-Adjusted Underwriting Security Modifier
#' @param mfa_enabled Integer vector (1 = Active, 0 = Inactive) indicating MFA status.
#' @param avg_detection_lag_days Numeric vector tracking breach detection dwell time.
#' @return A bounded numeric risk modifier between 0.70 (max credit) and 1.50 (max penalty).
calculate_security_credit <- function(mfa_enabled, avg_detection_lag_days) {
  # Base condition factor initialized at neutral parity
  security_modifier <- 1.0
  
  # Rule 1: Multi-Factor Authentication Underwriting Credit Assessment
  if (mfa_enabled == 1) {
    security_modifier <- security_modifier - 0.15
  } else {
    security_modifier <- security_modifier + 0.10
  }
  
  # Rule 2: Detection Dwell Time Lag Penalty Evaluation
  if (avg_detection_lag_days > 14) {
    extra_weeks <- floor((avg_detection_lag_days - 14) / 7)
    security_modifier <- security_modifier + (0.05 * extra_weeks)
  }
  
  # Rule 3: Enforce Portfolio Capital Adequacy Risk Boundaries
  # Bounded between a 30% max discount (0.70) and a 50% max surcharge penalty (1.50)
  bounded_modifier <- max(0.70, min(1.50, security_modifier))
  return(bounded_modifier)
}

# ==============================================================================
# VERIFICATION SUITE: SCENARIO PROFILE BENCHMARKS
# ==============================================================================
message("\n>>> DEPLOYING VALIDATION COHORTS: RATING ENGINE TELEMETRY")

# Scenario A: Robust Security Controls (MFA Enabled, Rapid 5-Day Containment)
credit_A <- calculate_security_credit(mfa_enabled = 1, avg_detection_lag_days = 5)
cat(sprintf("Scenario A (MFA-Yes, Lag-5 days):  %.2f multiplier (%.0f%% Discount)\n", 
            credit_A, (1 - credit_A) * 100))

# Scenario B: High Vulnerability Profile (No MFA, 35-Day Critical Lag)
credit_B <- calculate_security_credit(mfa_enabled = 0, avg_detection_lag_days = 35)
cat(sprintf("Scenario B (MFA-No,  Lag-35 days): %.2f multiplier (%.0f%% Surcharge)\n", 
            credit_B, (credit_B - 1) * 100))

# Scenario C: Baseline Operational Hygiene (MFA Enabled, 21-Day Evaluation Delay)
credit_C <- calculate_security_credit(mfa_enabled = 1, avg_detection_lag_days = 21)
cat(sprintf("Scenario C (MFA-Yes, Lag-21 days): %.2f multiplier (%.0f%% Discount)\n", 
            credit_C, (1 - credit_C) * 100))


# PORTFOLIO INTEGRATION & PREMIUM UNDERWRITING WORKFLOW


# Ensure core exposure framework data structure is loaded in current session
if (exists("modeling_df")) {
  message("\n>>> EXECUTING PORTFOLIO-WIDE RISK ADJUSTMENT SCORING...")
  
  # 1. Map dynamic modifier vector across active exposure profiles
  modeling_df$security_modifier <- mapply(
    calculate_security_credit, 
    modeling_df$mfa_enabled, 
    modeling_df$avg_detection_lag 
  )
  
  # 2. Compute pure premium proxy scaled at a target 10% expected loss loading factor
  modeling_df$base_pure_premium <- modeling_df$total_loss * 0.10
  
  # 3. Calculate final underwritten portfolio premiums
  modeling_df$final_charged_premium <- modeling_df$base_pure_premium * modeling_df$security_modifier
  
  # 4. Generate system execution ledger reporting
  message("\n>>> PORTFOLIO SECURITY RATING MATRIX OVERVIEW")
  print(head(modeling_df[, c("company_id", "industry_sector", "mfa_enabled", "avg_detection_lag", "security_modifier", "final_charged_premium")], 10))
  
  cat(sprintf("\nMean Portfolio Risk Security Modifier: %.2f\n", mean(modeling_df$security_modifier)))
  cat(sprintf("Total Aggregate Written Portfolio Premium: $%,.2f\n", sum(modeling_df$final_charged_premium)))
} else {
  warning("Operational Data Frame 'modeling_df' not found in current environment workspace. Portfolio integration skipped.")
}
 


 Module 3: Security Credit & Risk Mitigation Engine


 1. Define the Security Credit Function
calculate_security_credit <- function(mfa_enabled, avg_detection_lag_days) {
  
   Base security modifier starts at 1.0 (Neutral)
  security_modifier <- 1.0
  
   Rule 1: MFA Discount
   Actuarial justification: MFA heavily reduces breach frequency. 
   Give a 15% premium credit (discount) if enabled.
  if (mfa_enabled == 1) {
    security_modifier <- security_modifier - 0.15 
  } else {
    # 10% Surcharge/Penalty for lacking basic MFA hygiene
    security_modifier <- security_modifier + 0.10 
  }
  
   Rule 2: Detection Lag Penalty
   Actuarial justification: The longer a hacker is in the network, the worse it gets.
   If detection takes longer than 14 days, add a 5% surcharge per additional week.
  if (avg_detection_lag_days > 14) {
    extra_weeks <- floor((avg_detection_lag_days - 14) / 7)
    security_modifier <- security_modifier + (0.05 * extra_weeks)
  }
  
   Cap the maximum credit at 0.70 (30% max discount) 
   and max surcharge at 1.50 (50% max penalty)
  security_modifier <- max(0.70, min(1.50, security_modifier))
  
  return(security_modifier)
}

 2. Test the Underwriting Engine on 3 Scenarios

cat("==========================================\n")
cat("   SECURITY CREDIT PRICING MODIFIERS      \n")
cat("==========================================\n")

# Scenario A: Great Cyber Hygiene (MFA enabled, caught in 5 days)
credit_A <- calculate_security_credit(mfa_enabled = 1, avg_detection_lag_days = 5)
cat(sprintf("Scenario A (MFA=Yes, Lag=5 days):   %.2f multiplier (%.0f%% Discount)\n", 
            credit_A, (1 - credit_A) * 100))

# Scenario B: Poor Cyber Hygiene (No MFA, caught in 35 days)
credit_B <- calculate_security_credit(mfa_enabled = 0, avg_detection_lag_days = 35)
cat(sprintf("Scenario B (MFA=No, Lag=35 days):   %.2f multiplier (%.0f%% Surcharge)\n", 
            credit_B, (credit_B - 1) * 100))

# Scenario C: Average Hygiene (MFA enabled, caught in 21 days)
credit_C <- calculate_security_credit(mfa_enabled = 1, avg_detection_lag_days = 21)
cat(sprintf("Scenario C (MFA=Yes, Lag=21 days):  %.2f multiplier (%.0f%% Discount)\n", 
            credit_C, (1 - credit_C) * 100))











 Module 3 (Completion): Portfolio-Wide Security Credit Rating


 1. Ensure our security credit function is loaded (from earlier)
calculate_security_credit <- function(mfa_enabled, avg_detection_lag_days) {
  security_modifier <- 1.0
  if (mfa_enabled == 1) {
    security_modifier <- security_modifier - 0.15 
  } else {
    security_modifier <- security_modifier + 0.10 
  }
  if (avg_detection_lag_days > 14) {
    extra_weeks <- floor((avg_detection_lag_days - 14) / 7)
    security_modifier <- security_modifier + (0.05 * extra_weeks)
  }
  return(max(0.70, min(1.50, security_modifier)))
}

 2. Apply the security credit modifier to every company in modeling_df
modeling_df$security_modifier <- mapply(
  calculate_security_credit, 
  mfa_enabled = modeling_df$mfa_enabled, 
  avg_detection_lag_days = modeling_df$avg_detection_lag
)

 3. Calculate Final Adjusted Premium 
 (Using total loss / expected loss as a baseline proxy for pure premium, then multiplying by the modifier)
modeling_df$base_pure_premium <- modeling_df$total_loss * 0.10 # 10% expected loss ratio baseline
modeling_df$final_charged_premium <- modeling_df$base_pure_premium * modeling_df$security_modifier

 4. View a summary of how the portfolio was priced
cat("==========================================")
cat("\n   PORTFOLIO SECURITY RATING SUMMARY      \n")
cat("==========================================\n")
print(head(modeling_df[, c("company_id", "industry_sector", "mfa_enabled", "avg_detection_lag", "security_modifier", "final_charged_premium")], 10))

cat(sprintf("\nAverage Security Modifier: %.2f\n", mean(modeling_df$security_modifier)))
cat(sprintf("Total Portfolio Premium:   $%.2f\n", sum(modeling_df$final_charged_premium)))

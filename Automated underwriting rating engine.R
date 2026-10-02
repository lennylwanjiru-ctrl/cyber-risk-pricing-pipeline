
 Module 5: Automated Underwriting Rating Engine


 1. Define the Production Underwriting Function
generate_cyber_quote <- function(sector, mfa_status, detection_lag_days) {
  
   Step A: Base intercept and coefficients from your winning Gamma GLM
 (Extracted directly from your earlier model outputs)
  base_severity <- 106914.77  # Intercept
  
  # Sector multipliers (relativities)
  sector_factors <- c(
    "Finance & Insurance"         = 1.0000, # Baseline reference
    "Healthcare"                  = 1.0450,
    "Manufacturing"               = 0.9688,
    "Professional Services"       = 1.0760,
    "Retail & E-commerce"         = 1.0886,
    "Technology"                  = 1.0389
  )
  
   Fallback if sector is unknown
  sec_multiplier <- if (sector %in% names(sector_factors)) sector_factors[sector] else 1.00
  
   Step B: Calculate Technical Base Premium (Gamma GLM prediction)
   Severity * Sector Relativities
  technical_base_loss <- base_severity * sec_multiplier
  
   Step C: Apply Module 3 Security Credit Modifier
  security_modifier <- 1.0
  if (mfa_status == 1) {
    security_modifier <- security_modifier - 0.15 # 15% Discount
  } else {
    security_modifier <- security_modifier + 0.10 # 10% Surcharge
  }
  
  if (detection_lag_days > 14) {
    extra_weeks <- floor((detection_lag_days - 14) / 7)
    security_modifier <- security_modifier + (0.05 * extra_weeks)
  }
  security_modifier <- max(0.70, min(1.50, security_modifier)) # Bound limits
  
   Step D: Final Commercial Premium Quote 
   (Assuming standard 10% expected loss ratio / loading factor)
  pure_premium <- technical_base_loss * 0.10
  final_quote <- pure_premium * security_modifier
  
   Step E: Return structured underwriting decision
  cat("==========================================\n")
  cat("   CYBER INSURANCE UNDERWRITING QUOTE     \n")
  cat("==========================================\n")
  cat(sprintf("Industry Sector:         %s (Factor: %.2f)\n", sector, sec_multiplier))
  cat(sprintf("Security Posture:        MFA=%d | Detection Lag=%d days\n", mfa_status, detection_lag_days))
  cat(sprintf("Security Modifier:       %.2f multiplier\n", security_modifier))
  cat(sprintf("Final Annual Premium:    $%.2f\n", final_quote))
  cat("==========================================\n")
  
  return(invisible(final_quote))
}

# ==========================================
# 2. Test the Automated Engine on New Clients
# ==========================================

cat("Testing Quote Generation for Client 1 (High Risk):\n")
generate_cyber_quote(sector = "Retail & E-commerce", mfa_status = 0, detection_lag_days = 45)

cat("\nTesting Quote Generation for Client 2 (Low Risk):\n")
generate_cyber_quote(sector = "Technology", mfa_status = 1, detection_lag_days = 5)

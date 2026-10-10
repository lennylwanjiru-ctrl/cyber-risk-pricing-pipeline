
# Project: Cyber Risk Pricing Pipeline
# Module: Systemic Accumulation Modeling & Stochastic Monte Carlo Simulation
# Analyst: Lenny Wanjiru (DeKUT Actuarial Science)


library(tidyverse)


# PART 1: CORE STOCHASTIC INTEGRATED MONTE CARLO SIMULATION


if (exists("modeling_df")) {
  
  set.seed(42)
  n_sims <- 10000
  integrated_aggregate_losses <- numeric(n_sims)
  
  # Extract true loss intensity parameters from the active portfolio
  portfolio_losses <- modeling_df$total_loss[modeling_df$total_loss > 0]
  lambda           <- length(portfolio_losses)
  gamma_dispersion <- 0.8371478
  
  # Calculate Gamma parameter bounds using method of moments matching
  shape_param <- 1 / gamma_dispersion
  mean_severity <- mean(portfolio_losses, na.rm = TRUE)
  scale_param <- mean_severity / shape_param
  
  # Run the core portfolio simulation loop
  for (i in 1:n_sims) {
    # Step 1: Evaluate probability of a systemic supply chain outage event (5% threshold)
    is_systemic_year <- runif(1) < 0.05
    
    # Step 2: Adjust portfolio claims frequency intensity based on structural shock
    year_lambda <- if (is_systemic_year) lambda * 1.8 else lambda
    n_claims    <- rpois(1, lambda = year_lambda)
    
    # Step 3: Simulate individual operational hazard severities
    if (n_claims > 0) {
      claim_severities <- rgamma(n_claims, shape = shape_param, scale = scale_param)
      
      # Step 4: Apply systemic severity loading factor for multi-client accumulation events
      if (is_systemic_year) {
        claim_severities <- claim_severities * 2.0
      }
      integrated_aggregate_losses[i] <- sum(claim_severities)
    } else {
      integrated_aggregate_losses[i] <- 0
    }
  }
  
  # Calculate empirical capital adequacy requirements for base simulation
  integrated_var_99  <- as.numeric(quantile(integrated_aggregate_losses, 0.99, na.rm = TRUE))
  integrated_tvar_99 <- mean(integrated_aggregate_losses[integrated_aggregate_losses >= integrated_var_99], na.rm = TRUE)
  
  message("\n>>> EXECUTING SOLVENCY REPORT: INTEGRATED STOCHASTIC MODEL RESIDUALS")
  cat(sprintf("Structural 99%% Value at Risk (VaR):   $%,.2f\n", integrated_var_99))
  cat(sprintf("Structural 99%% Tail Value at Risk (TVaR): $%,.2f\n", integrated_tvar_99))
  
} else {
  warning("Primary data vector 'modeling_df' missing from current session workspace. Section 1 skipped.")
}


# PART 2: REGULATORY SHOCK COMPLIANCE MODULE (SYSTEMIC ACCUMULATION SIMULATOR)


#' Simulate Portfolio Systemic Accumulation Shock Events
#' @param portfolio_losses A numeric vector tracking active historical losses.
#' @param shock_probability Numeric baseline probability of global event (default: 0.05).
#' @param impact_multiplier Scaling coefficient applied to extreme exposures (default: 2.5).
#' @return A structured list containing simulated losses and shock metadata.
simulate_systemic_shock <- function(portfolio_losses, shock_probability = 0.05, impact_multiplier = 2.5) {
  
  n_sims <- length(portfolio_losses)
  systemic_losses <- portfolio_losses
  
  # Identify historical simulation points breaching the shock threshold bounds
  is_systemic_year <- runif(n_sims) < shock_probability
  
  # Amplify aggregate losses under highly-correlated multi-client stress events
  systemic_losses[is_systemic_year] <- systemic_losses[is_systemic_year] * impact_multiplier
  
  return(list(
    losses              = systemic_losses,
    systemic_years_count = sum(is_systemic_year)
  ))
}

# Execute Stress Testing Suite
message("\n>>> INITIALIZING STRESS-TEST SUITE: MODULE 6 PORTFOLIO VALUATION")
set.seed(123)

# Generate baseline data to validate the functional rating engine wrapper
annual_aggregate_losses <- rgamma(10000, shape = 2, rate = 0.00001)

shock_result <- simulate_systemic_shock(
  portfolio_losses  = annual_aggregate_losses, 
  shock_probability = 0.05, 
  impact_multiplier = 2.5
)

# Recalculate robust capital metrics under acute accumulation stress conditions
new_var_99  <- as.numeric(quantile(shock_result$losses, 0.99, na.rm = TRUE))
new_tvar_99 <- mean(shock_result$losses[shock_result$losses >= new_var_99], na.rm = TRUE)

message("\n>>> ACCUMULATION COMPLIANCE TARGET RUN COMPLETED")
cat(sprintf("Systemic Stress Cycles Triggered: %d out of %d observations\n", 
            shock_result$systemic_years_count, length(annual_aggregate_losses)))
cat(sprintf("Stress-Adjusted 99%% Annual VaR:   $%,.2f\n", new_var_99))
cat(sprintf("Stress-Adjusted 99%% Annual TVaR:  $%,.2f\n", new_tvar_99))


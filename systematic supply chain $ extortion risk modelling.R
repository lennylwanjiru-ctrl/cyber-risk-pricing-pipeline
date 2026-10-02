
 Integrated Enterprise Model: Monte Carlo + Systemic Shock


n_sims <- 10000
integrated_aggregate_losses <- numeric(n_sims)

# Parameters
lambda <- length(modeling_df$total_loss[modeling_df$total_loss > 0])
gamma_dispersion <- 0.8371478
shape_param <- 1 / gamma_dispersion
mean_severity <- mean(modeling_df$total_loss[modeling_df$total_loss > 0])
scale_param <- mean_severity / shape_param

set.seed(42)
cat("Running integrated simulation with structural systemic shocks...\n")

for (i in 1:n_sims) {
  
  # 1. Check if this simulated year suffers a Systemic Supply Chain Outage (e.g., 5% probability)
  is_systemic_year <- runif(1) < 0.05
  
  # 2. Adjust Frequency based on systemic shock 
  # (During a cloud outage, claim count spikes because multiple companies are hit at once)
  year_lambda <- if (is_systemic_year) lambda * 1.8 else lambda
  n_claims <- rpois(1, lambda = year_lambda)
  
  if (n_claims > 0) {
    # 3. Simulate severities
    claim_severities <- rgamma(n_claims, shape = shape_param, scale = scale_param)
    
    # 4. Adjust Severity if it's a systemic year 
    # (Extortion/systemic breaches cost more due to widespread disruption)
    if (is_systemic_year) {
      claim_severities <- claim_severities * 2.0
    }
    
    integrated_aggregate_losses[i] <- sum(claim_severities)
  } else {
    integrated_aggregate_losses[i] <- 0
  }
}

# Calculate the new structurally modeled Tail Risk
integrated_var_99  <- quantile(integrated_aggregate_losses, 0.99)
integrated_tvar_99 <- mean(integrated_aggregate_losses[integrated_aggregate_losses >= integrated_var_99])

cat("\n==========================================\n")
cat("   STRUCTURAL MODEL SOLVENCY REPORT       \n")
cat("==========================================\n")
cat(sprintf("99%% Annual VaR (Structural):        $%.2f\n", integrated_var_99))
cat(sprintf("99%% Annual TVaR (Structural):       $%.2f\n", integrated_tvar_99))
cat("==========================================\n")











# Create temporary test data so Module 6 runs successfully
set.seed(123)
annual_aggregate_losses <- rgamma(10000, shape = 2, rate = 0.00001)





















 Module 6 (Bonus): Systemic Supply Chain & Extortion Risk


 1. Simulate a Systemic Cloud Outage Shock Event
 Actuarial concept: Unlike physical property (where a hurricane hits one region), 
 cyber risk has systemic accumulation because companies share the same cloud infrastructure.

simulate_systemic_shock <- function(portfolio_losses, shock_probability = 0.05, impact_multiplier = 2.5) {
  
  n_sims <- length(portfolio_losses)
  systemic_losses <- portfolio_losses
  
  Identify which simulation years suffer a systemic supply chain event (e.g., 5% chance per year)
  is_systemic_year <- runif(n_sims) < shock_probability
  
   For systemic years, amplify aggregate losses due to correlated multi-client claims
  systemic_losses[is_systemic_year] <- systemic_losses[is_systemic_year] * impact_multiplier
  
  return(list(
    losses = systemic_losses,
    systemic_years_count = sum(is_systemic_year)
  ))
}

 2. Run the Systemic Shock Analysis
shock_result <- simulate_systemic_shock(annual_aggregate_losses)

 Recalculate Tail Risk under Systemic Threat
new_var_99 <- quantile(shock_result$losses, 0.99)
new_tvar_99 <- mean(shock_result$losses[shock_result$losses >= new_var_99])

cat("==========================================\n")
cat("   MODULE 6: SYSTEMIC ACCUMULATION REPORT \n")
cat("==========================================\n")
cat(sprintf("Systemic Shock Years Simulated:    %d out of 10,000\n", shock_result$systemic_years_count))
cat(sprintf("Adjusted 99%% Annual VaR (with shock):  $%.2f\n", new_var_99))
cat(sprintf("Adjusted 99%% Annual TVaR (Tail Risk):  $%.2f\n", new_tvar_99))
cat("==========================================\n")

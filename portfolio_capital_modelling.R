

# Module:portfolio capital modelling


library(tidyverse)

# Ensure the core underwriting dataset is active in the workspace
if (exists("modeling_df")) {
  
  # 1. Isolate Non-Zero Historical Portfolio Losses
  portfolio_losses <- modeling_df$total_loss[modeling_df$total_loss > 0]
  
  # 2. Define Solvency Target Confidence Levels (Alpha)
  conf_95 <- 0.95
  conf_99 <- 0.99
  
  # 3. Compute Value at Risk (VaR) Percentiles
  var_95 <- as.numeric(quantile(portfolio_losses, conf_95, na.rm = TRUE))
  var_99 <- as.numeric(quantile(portfolio_losses, conf_99, na.rm = TRUE))
  
  # 4. Compute Tail Value at Risk (TVaR / Expected Shortfall)
  # Evaluates the conditional expectation of losses exceeding the VaR thresholds
  tvar_95 <- mean(portfolio_losses[portfolio_losses >= var_95], na.rm = TRUE)
  tvar_99 <- mean(portfolio_losses[portfolio_losses >= var_99], na.rm = TRUE)
  
  
  # CORPORATE METRICS REPORTING & TELEMETRY

  message("\n>>> GENERATING SOLVENCY AUDIT REPORT: CAPITAL ADEQUACY MATRIX")
  
  # Structural summary data frame for logging
  solvency_summary <- tibble(
    Metric_Type      = c("Value at Risk (VaR)", "Tail Value at Risk (TVaR)"),
    Confidence_95_USD = c(var_95, tvar_95),
    Confidence_99_USD = c(var_99, tvar_99)
  )
  
  # Detailed terminal telemetry printout
  cat(sprintf("Active Underwriting Exposure Records: %d\n", length(portfolio_losses)))
  cat(sprintf("Empirical Mean Portfolio Loss:        $%,.2f\n\n", mean(portfolio_losses, na.rm = TRUE)))
  
  print(solvency_summary)
  
} else {
  warning("Operational Data Frame 'modeling_df' missing from workspace. Solvency calculations aborted.")
}


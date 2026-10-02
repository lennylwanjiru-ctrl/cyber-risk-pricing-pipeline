
 Module 4: Portfolio Capital Modeling (VaR & TVaR)


 1. Extract historical loss distribution from the active portfolio
portfolio_losses <- modeling_df$total_loss[modeling_df$total_loss > 0]

 2. Define Solvency Confidence Levels
conf_95 <- 0.95
conf_99 <- 0.99

 3. Calculate Value at Risk (VaR)
var_95 <- quantile(portfolio_losses, conf_95)
var_99 <- quantile(portfolio_losses, conf_99)

 4. Calculate Tail Value at Risk (TVaR / Expected Shortfall)
 TVaR is the average of all losses that exceed the VaR threshold
tvar_95 <- mean(portfolio_losses[portfolio_losses >= var_95])
tvar_99 <- mean(portfolio_losses[portfolio_losses >= var_99])


 5. Print Solvency Capital Report

cat("==========================================\n")
cat("   PORTFOLIO SOLVENCY & CAPITAL REPORT    \n")
cat("==========================================\n")
cat(sprintf("Active Loss Records Analyzed:     %d\n", length(portfolio_losses)))
cat(sprintf("Portfolio Mean Loss:              $%.2f\n\n", mean(portfolio_losses)))

cat(sprintf("95%% Value at Risk (VaR):          $%.2f\n", var_95))
cat(sprintf("95%% Tail VaR (TVaR):              $%.2f\n\n", tvar_95))

cat(sprintf("99%% Value at Risk (VaR):          $%.2f\n", var_99))
cat(sprintf("99%% Tail VaR (TVaR):              $%.2f\n", tvar_99))
cat("==========================================\n")

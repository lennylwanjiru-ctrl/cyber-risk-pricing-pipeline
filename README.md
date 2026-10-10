# Quantitative Cyber Insurance Ingestion, Pricing & Solvency Pipeline
**Analyst:** Lenny Wanjiru | Dedan Kimathi University of Technology (DeKUT)  
**Core Stack:** R (100%), SQLite, `tidyverse`, `ggplot2`



##  Executive Summary & Stakeholder Alignment
As global digitalization accelerates, standard property and casualty actuarial models break down when applied to cyber risks due to systemic accumulation hazards, heavy-tailed loss distributions, and severe reporting delays (detection lags). 

This repository implements a modular, end-to-end quantitative pipeline in **R** engineered to meet the analytical standards of international public and private stakeholders:
*   **Commercial Underwriters:** Generates data-driven rating structures and risk-adjusted pricing engines based on security control metrics.
*   **Multilateral Development Financial Institutions (e.g., World Bank Group, IFC):** Provides macroeconomic stress-testing frameworks to quantify systemic digital infrastructure vulnerabilities.
*   **National Regulators & Statutory Bodies (e.g., IRA, KNBS):** Delivers empirical Tail Value at Risk (TVaR) capital adequacy models to prevent cascading institutional insolvency.


##  Technical Architecture & Core Modules

### Module 1: Relational Database Ingestion & Exposure Architecture
*   **Objective:** Eliminates detached spreadsheets by architecting a structured local SQLite environment.
*   **Execution:** Automated ingestion of unstructured records (`cyber_breach_events.csv`, `cyber_financial_losses.csv`, `cyber_insured_companies.csv`) using optimized relational joins to map company profiles directly to forensic cost indicators.

### Module 2 & 3: Alternative Risk Analysis & Actuarial Hypothesis Testing
*   **Objective:** Quantifies the financial impact of specific security controls (Multi-Factor Authentication - MFA) across corporate sectors.
*   **Findings:** Evaluation of 5,076 active records reveals that portfolios with MFA disabled suffer an average loss severity of **\$71,474.54** (Total: \$386.1M) across 5,403 incidents, with Technology and Healthcare maintaining the highest risk concentrations.
*   **Statistical Validation:** Executed a log-transformed Welch’s t-Test (t = -0.582, p = 0.5604) paired with a non-parametric Wilcoxon Rank-Sum Test (p = 0.449) to validate loss behavior boundaries under normal vs. fat-tailed assumptions.

### Module 4: Feature Engineering & Detection Lag Analysis
*   **Objective:** Models the operational "dwell time" (the span between breach occurrence and formal detection).
*   **Findings:** Engineered aggregated company-level feature metrics highlighting a extreme portfolio average detection lag of **782 days**. Advanced technical outliers (e.g., COMP-0756) exhibited dwell times stretching past **2,080 days**, demonstrating why traditional linear pricing fails.

### Module 5 & 6: Actuarial Predictive Modeling & GLM Pricing Tariffs
*   **Objective:** Replaces flat historical averages with dynamic insurance rating factors.
*   **Execution:** Fitted a **Gamma Generalized Linear Model (GLM)** with a log-link function, which significantly outperformed standard Gaussian models by isolating true strictly positive, right-skewed cyber severities (AIC drop to 102,121.60).
*   **Risk Relativities:** Extracted multiplicative coefficients mapping sector risks—identifying Retail & E-Commerce as the peak exposure line (1.0886 relativity factor) and Professional Services at 1.0760.

### Module 7 & 8: Risk-Based Underwriting & Real-Time Quotation Engine
*   **Objective:** Operationalizes GLM parameters into a reactive premium rating script.
*   **Execution:** Coded a custom R function (`calculate_security_credit`) enforcing clear underwriting boundaries:
    *   Applies a **15% premium discount** for verified MFA deployment.
    *   Imposes a **5% compounding surcharge** per additional week of detection dwell time exceeding a 14-day operational baseline.
*   **Live Simulation:** Evaluated contrasting corporate exposures:
    *   *Client 1 (High-Risk Retail, No MFA, 45-day lag):* Annual Premium Quote = **\$15,130.36**.
    *   *Client 2 (Low-Risk Tech, MFA Enabled, 5-day lag):* Annual Premium Quote = **\$9,441.27**.

### Module 9 & 10: Monte Carlo Tail-Risk Simulation & Portfolio Relative Visualization
*   **Objective:** Stress-tests entire insurance portfolios against extreme, highly-correlated systemic shock events (e.g., shared cloud infrastructure outages).
*   **Execution:** Executed a **10,000-year compound stochastic Monte Carlo simulation** mapping aggregate annual losses to derive empirical solvency thresholds:
    *   **95% Value at Risk (VaR):** \$302,913.52
    *   **99% Value at Risk (VaR):** \$495,582.47
    *   **95% Tail Value at Risk (TVaR):** \$431,693.07
    *   **99% Tail Value at Risk (TVaR):** \$672,206.52
*   **Visualization:** Generated horizontal relative risk charts via `ggplot2` to map sector pricing differentials seamlessly for corporate executives and regulatory auditors.


##  Infrastructure Recommendations for Public & Private Sectors
1.  **Establish Centralized Data Registries:** National insurance commissions and statistical bureaus should mandate relational data tracking repositories rather than isolated reporting sheets to combat tracking deficiencies.
2.  **Enforce TVaR-Based Solvency Capital:** Regulatory frameworks must transition from crude VaR thresholds to TVaR requirements to account for the true catastrophic overshoot of extreme cyber tail events.
3.  **Deploy Public-Private Reinsurance Backstops:** Because extreme systemic cyber accumulation risks can cross the \$2.0B threshold in stochastically simulated stress years, governments must construct joint reinsurance facilities to preserve market stability.

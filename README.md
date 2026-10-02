## Cyber Insurance Risk Pricing and Data Breach Pipeline: Project Overview

### Objective & Motivation of the project
As global digitalization accelerates, organizations face unpredictable cyber exposure, yet the global insurance market suffers from a massive **cyber protection gap** recall  prominent real-world example of a major cyber incident in Kenya is the July 2023 eCitizen Platform Cyber-Attack. Traditional property and casualty insurance models break down when applied to cyber risk due to three major market failures:
* **Heavy-Tailed Loss Distributions**: Cyber financial losses are heavily skewed—most incidents cause minor operational disruption, but a small percentage result in catastrophic financial drains that standard Gaussian models cannot accurately price.
* **The Illusion of Binary Compliance**: Many commercial underwriters grant blanket premium discounts for basic security checklists (such as Multi-Factor Authentication) without evaluating enterprise scale, data volume, or actual dwell time (detection lag).
* **Systemic Accumulation Risk**: Unlike independent property risks, cyber portfolios possess severe systemic dependencies (such as shared cloud infrastructure failures and global software vulnerabilities) that can crash entire insurance pools simultaneously if capital reserves are miscalculated.

**The goal of this project** was to build an end-to-end, reproducible pipeline in R and SQLite that replaces crude historical averages with **Generalized Linear Models (GLMs), automated underwriting engines, and Monte Carlo tail-risk simulations (VaR / TVaR)**, ensuring that pricing is mathematically rigorous and behaviorally responsive.

### Target Group & Institutional Stakeholders
This project is engineered to meet the high-level governance and analytical standards required by key decision-makers across the international financial and public sectors:
* **Commercial Insurers & Underwriters**: Providing data-driven rating schedules, sector risk relativities, and automated quoting engines to price policies accurately while incentivizing strong corporate cyber hygiene.
* **International Development & Multilateral Institutions (e.g., World Bank, United Nations)**: Equipping development economists and risk analysts with standardized data pipelines to assess systemic digital vulnerabilities and protect developing national economies against macro-level cyber shocks.
* **National Statistical Bureaus & Financial Regulators (e.g., KNBS and National Insurance Commissions)**: Supplying rigorous solvency frameworks, non-parametric validation methods, and TVaR-based capital reserve models to safeguard financial stability and regulate commercial cyber insurance pools.
 
 
 ## Module 1: Relational Database Ingestion & Exposure Data Architecture

## Objective
Why this module was  carried out : Before insurance  can price cyber insurance or calculate financial risk, company details, cyber attack logs, and financial losses cannot sit in separate, disconnected files. The goal of this module was to build a clean, reliable data pipeline that links these different sources together using a local database.

## Technical Findings
 Successfully loaded three raw CSV files (company profiles, breach events, and financial losses) into a structured local SQLite database.
 Used an SQL join query to connect companies to their specific cyber incidents and total financial costs.
 Combined forensic cleanup costs, regulatory fines, and business interruption payouts into a single unified financial loss figure for each event.

## Comments & Results Interpretation
 Looking at the results, we can see that cyber losses are heavily skewed. Most breaches cause small or moderate damage, but a few massive attacks result in huge financial losses. This proves we cannot use simple averages to price cyber risk.
 
## Recommendations for Industry & Public Sector
 Establish Centralized Data Registries: Organizations like national bureaus of statistics or insurance regulatory authorities should adopt standardized relational databases rather than relying on isolated spreadsheets. This ensures data quality, eliminates missing links between records, and provides reliable statistics for national risk monitoring.
 
 
 
## Module 2 (Alternative/Risk Factor Analysis): MFA Mitigation & Industry Sector Risk Rankings

 Objective
Why this step was  carried out : To move beyond simple averages and evaluate how specific operational risk controls (like Multi-Factor Authentication, or MFA) and industry sectors actually impact cyber claim frequencies and financial severities. In actuarial pricing and underwriting, insurers must identify which risk mitigants reduce exposure and which sectors represent portfolio concentration risk.

## Technical Findings
MFA Analysis Query: Grouped the portfolio by MFA adoption status, tracking total incidents, average financial loss per event, and total aggregate loss. 
  MFA Disabled: 2,597 incidents with an average loss of \$70,063.86 (Total: \$181.9M).
  MFA Enabled: 5,403 incidents with an average loss of \$71,474.54 (Total: \$386.1M).
Industry Sector Rankings Query: Aggregated total incidents, total aggregate losses, and average loss severity across all six business sectors, ordered by highest total financial impact.
  Technology leads the portfolio with 2,080 incidents and \$147.5M in total losses.
  Healthcare ($87.1M) and Retail & E-commerce ($86.4M) follow closely behind as high-accumulation zones.

## Comments & Results Interpretation
The MFA Paradox & Portfolio Dynamics*: Interestingly, companies with MFA enabled account for a higher volume of total incidents and aggregate losses in this dataset. In actuarial risk analysis, this often occurs because larger enterprises or high-value firms with massive attack surfaces are mandated to adopt MFA, whereas smaller low-risk firms may lack both MFA and complex targets.

## Recommendations for Industry & Public Sector
Consider Security Controls in Underwriting: Insurance underwriters should not offer blind premium discounts for basic controls like MFA without factoring in enterprise size, data volume, and network complexity. Security controls modify risk profiles, but they must be paired with exposure limits.
Manage Sectoral Accumulation: Public risk pools and commercial insurers must implement aggregate limits for Technology and Healthcare lines to prevent catastrophic portfolio insolvency during systemic cluster events.

## Module 3: Portfolio Visualizations & Actuarial Hypothesis Testing (MFA Security Impact)

## Objective
Why the step was carried out: To move beyond summary tables and visually map portfolio risk distributions while applying rigorous statistical hypothesis testing. Specifically, we wanted to test whether companies with Multi-Factor Authentication (MFA) enabled experience statistically significant differences in financial loss severity compared to those without MFA, validating whether security controls genuinely drive down claims or if other underlying exposures mask their effect.

## Technical Findings
Visualizations: Generated clean R plots (`ggplot2`) isolating aggregate financial losses by industry sector and MFA adoption status. The MFA chart clearly visualizes a higher total aggregate loss for firms with MFA enabled (~$386M) compared to those without (~$182M).
Welch’s t-Test (Log-Transformed Losses): Performed on log-transformed loss amounts to handle heavy-tailed data; yielded a $t$-value of -0.582 and a $p$-value of 0.5604.
Wilcoxon Rank-Sum Test (Non-Parametric): Performed on raw loss data without assuming a normal distribution; yielded a $p$-value of 0.449.

## Comments & Results Interpretation
Statistical Insignificance: Both the t-test and the Wilcoxon test resulted in $p$-values well above the standard 0.05 significance threshold. This proves that there is no statistically significant difference in loss severity between companies with MFA and those without, despite the higher total aggregate losses seen in the MFA-enabled group.
Underwriting Insight: The reason aggregate losses are higher for MFA-enabled firms is a classic underwriting phenomenon known as adverse selection or exposure scale bias—large enterprises with massive asset values are almost universally mandated to have MFA, whereas smaller firms with minor exposures may lack it. Technical controls alone do not shrink a large company's inherent loss severity without proper risk limits.

## Recommendations for Industry & Public Sector
Look Beyond Binary Compliance: Insurance underwriters and public sector risk analysts should not grant automatic, deep premium discounts based solely on basic compliance checkboxes like "MFA Enabled." Risk evaluation must incorporate enterprise size, network complexity, and data volume.
Integrate Non-Parametric Testing in Solvency Audits: Regulatory bodies and development finance institutions can try mandate non-parametric statistical tests (like the Mann-Whitney test) when auditing risk-mitigation claims, ensuring that insurance pricing models are backed by true statistical significance rather than superficial correlations.




## Module 4: Feature Engineering & Operational Risk Analytics (Detection Lag Analysis)

 ## Objective
Why this step was  carried out : In cyber risk management, how quickly a breach is detected (known as the *detection lag days*) is a major factor driving final financial damages. Undetected breaches allow attackers to dwell inside a network longer, escalating data exfiltration and remediation costs. The goal of this module was to engineer a new behavioral risk feature by querying and calculating the average detection lag per company, identifying outliers and operational vulnerabilities across the portfolio.

## Technical Findings
 Engineered an aggregated company-level feature table by joining company profiles with historical breach events and calculating the average detection lag days (`avg_detection_lag_days`) alongside total breach counts.
 Sorted the resulting dataset to isolate the highest-risk firms suffering from extreme dwell times.
 The output reveals extreme outliers—for example, *COMP-07561* (Manufacturing) recorded an average detection lag of **782 days**, while other top-lag firms spanned 250 to over 340 days across Technology, Finance, and Healthcare sectors.

 Comments & Results Interpretation
 **The Danger of Dwell Time**: A detection lag stretching into hundreds of days exposes a severe breakdown in endpoint detection and response (EDR) or internal security monitoring. In cyber actuarial science, long dwell times correlate exponentially with higher regulatory fines and severe business disruption.
 **Control Limitations**: Notably, several of these extreme-lag companies have MFA enabled, reinforcing earlier findings that basic technical checklists do not protect an organization if continuous network monitoring and threat hunting are missing.

## Recommendations for Industry & Public Sector
 **Incorporate Dwell Time into Underwriting Tariffs**: Insurance underwriters should penalize companies that lack continuous monitoring frameworks by applying heavy premium surcharges based on estimated detection lag.
 **Mandate Incident Response Audits for Public/Regulated Sectors**: National regulatory bodies and international institutional development programs should enforce strict breach reporting timelines and mandatory security monitoring baselines, shrinking dwell times to protect critical economic infrastructure.




## Module 5: Actuarial Predictive Modeling & Generalized Linear Models (GLMs)

 Objective
Why this step was carried out : In professional insurance ratemaking, relying on simple flat rates or standard Gaussian linear models results in inaccurate pricing because financial insurance losses are strictly positive, highly right-skewed, and exhibit heavy tails. The goal of this module was to engineer a feature-rich modeling dataset, compare Gaussian vs. true Actuarial Gamma GLMs (with a log link), and extract multiplicative risk relativities (rating factors) for underwriting.

## Technical Findings
 : Fitted both a Gaussian log-link model and a true **Gamma GLM (`family = Gamma(link = "log")`)** to isolate the winning actuarial specification. 
   The **Gamma GLM drastically outperformed the Gaussian model**, dropping the AIC from 131,698 down to **102,121.60**, confirming superior statistical fit.
 Extracted Multiplicative Risk Relativities (`exp(coef)`):
   *Retail & E-commerce* carries the highest sector relativity at **1.0886**, followed by *Professional Services* (1.0760) and *Healthcare* (1.0450).
   *MFA Enabled* yields a relativity factor of **1.0093**, reflecting baseline risk parity when controlling for enterprise scale.
   *Average Detection Lag* adds a compounding scaling factor of **1.0002** per day of dwell time.

 ## Comments & Results Interpretation
 **Why Gamma Wins**: Insurance loss data cannot fall below zero and features extreme right-skewness. The Gamma distribution naturally accommodates this variance structure without distorting predictions through negative loss projections.
 **Underwriting Relativities**: The generated relativities provide commercial actuaries with precise rating multipliers. For example, a retail firm’s baseline technical premium is multiplied by 1.0886 to account for its heightened risk profile compared to benchmark lines.

## Recommendations for Industry & Public Sector
 **Adopt Generalized Linear Models for Public Tariffs**: Public social insurance schemes and national regulatory authorities should transition away from crude historical averages and adopt exponential family GLMs (such as Gamma or Tweedie) to price risk pools fairly and sustainably.
 **Embed Dwell-Time Penalties in Regulatory Guidelines**: Regulatory supervisors should mandate that commercial insurers explicitly factor detection lag penalties into their baseline rating structures, incentivizing corporations to reduce dwell times and improve systemic national cyber resilience.




## Module 6: Risk-Based Underwriting & Security Credit Rating Engine

## Objective
Why this step  we carried out : In commercial insurance ratemaking, a technical pure premium is only a baseline. To incentivize better corporate behavior and protect the insurer's balance sheet, underwriters apply dynamic "risk modification factors" based on a firm's specific cybersecurity hygiene. The goal of this module was to build an automated underwriting engine that awards premium discounts for strong controls (like MFA) and imposes premium surcharges for poor behaviors (such as long detection lags/dwell times).

## Technical Findings
 Developed a custom R function (`calculate_security_credit`) applying explicit underwriting rules:
   **MFA Discount**: Awards a 15% credit (multiplier of 0.85) if MFA is enabled, or a 10% penalty if disabled.
   **Detection Lag Penalty**: Adds a 5% surcharge for every additional week of dwell time beyond a 14-day baseline.
   **Rate Guardrails**: Capped the final modifier between a maximum discount of 30% (0.70) and a maximum surcharge of 50% (1.50) to prevent extreme pricing volatility.
 Applied the engine across the portfolio (`modeling_df`), resulting in a **Total Portfolio Premium of \$59,716,852.68** with an average portfolio security modifier of 1.05.

## Comments & Results Interpretation
 **Behavioral Incentives**: The rating engine successfully links risk pricing directly to operational hygiene. For instance, companies with clean security profiles (Scenario A) receive favorable pricing, whereas firms with extended dwell times (e.g., COMP-00004 with an 80-day lag) receive the maximum 1.50 surcharge.
 **Underwriting Solvency**: By penalizing prolonged dwell times, the model discourages moral hazard and ensures that firms bearing higher cyber risk exposure contribute proportionally more to the insurance pool.

 Recommendations for Industry & Public Sector
 **Incentivize Cyber Resilience Through Subsidies**: Development finance institutions and public health/risk programs should use dynamic premium credits to incentivize small and medium enterprises (SMEs) to adopt baseline security tools, lowering overall national systemic vulnerability.
 **Implement Strict Rating Caps**: Commercial insurers must enforce boundary guardrails (like the 0.70 to 1.50 cap used here) to ensure that pricing modifiers remain commercially viable and compliant with insurance regulatory consumer protection standards.







## Module 7: Portfolio Capital Modeling & Tail Risk Metrics (VaR & TVaR)

 Objective
Why we carried out this step: Knowing expected losses is not enough for an insurer or a national risk fund to remain solvent. Under regulatory frameworks (such as Solvency II), organizations must hold enough regulatory capital to absorb extreme, rare catastrophic losses. The goal of this module was to calculate core actuarial tail-risk metrics—**Value at Risk (VaR)** and **Tail Value at Risk (TVaR / Expected Shortfall)**—at the 95% and 99% confidence levels to determine the exact capital reserves required.

## Technical Findings
 Extracted the historical loss distribution across 5,076 active records, revealing a portfolio mean loss of **\$111,925.29**.
 Calculated Value at Risk (VaR) thresholds:
   *95% VaR*: **\$302,913.52** (the loss amount not exceeded in 95% of cases).
   *99% VaR*: **\$495,582.47** (the extreme 1% threshold).
 Calculated Tail Value at Risk (TVaR / Expected Shortfall):
   *95% TVaR*: **\$431,693.07** (the expected average loss *given* that losses exceed the 95% VaR mark).
   *99% TVaR*: **\$672,206.52** (the extreme expected tail severity).

 ##Comments & Results Interpretation
 Capturing Tail Severity: Unlike VaR, which only identifies a specific percentile cutoff, TVaR measures the *severity of the tail* beyond that cutoff. The jump from a 99% VaR of \$495.5K to a 99% TVaR of \$672.2K highlights the heavy-tailed nature of cyber risks—when extreme breaches happen, they overshoot standard boundaries significantly.
 **Solvency Protection**: These metrics provide institutional risk managers and regulatory bodies with hard numbers to back capital adequacy requirements, ensuring that a surge in catastrophic claims does not trigger insolvency.

## Recommendations for Industry & Public Sector
 **Enforce TVaR-Based Solvency Standards**: Regulatory authorities (such as national insurance commissions or central bank financial stability units) should transition from basic VaR or fixed-capital rules to TVaR-based Solvency requirements, as TVaR accounts for the true severity of extreme tail events.
 **Maintain Reinsurance and Buffer Capital**: Commercial insurers and public catastrophe pools must hold dedicated liquid reserves or secure reinsurance treaties calibrated to cover at least the 99% TVaR threshold to survive systemic cyber shock waves.



## Module 8: Automated Production Underwriting & Policy Quotation Engine

## Objective
Why this step was  carried out : To operationalize the statistical findings from our Gamma GLM and security credit rules into an automated production underwriting function. The goal was to build a reusable tool that takes a company's specific profile (industry sector, MFA adoption status, and detection lag days), calculates its technical baseline risk, applies behavioral security modifiers, and outputs a compliant, risk-adjusted annual insurance premium quote.

 ##Technical Findings
 Built the `generate_cyber_quote` function in R, integrating the exact intercept ($\$106,914.77$) and sector relativities (e.g., Retail & E-commerce at $1.0886$, Technology at $1.0389$) extracted from our winning Gamma GLM[cite: 1].
 Automated the inclusion of the Module 3 security modifier logic (applying a 15% discount for MFA or 10% penalty for lack thereof, plus a 5% surcharge per additional week of dwell time beyond 14 days, bounded between $0.70$ and $1.50$)[cite: 1].
 Tested the production engine successfully on distinct risk profiles:
   *Client 1 (High-Risk Retail & E-commerce, No MFA, 45-day lag)*: Incurred a sector factor of $1.09$ and a security modifier of $1.30$, yielding a final annual premium quote of **\$15,130.36**[cite: 1].
   *Client 2 (Low-Risk Technology, MFA Enabled, 5-day lag)*: Incurred a sector factor of $1.04$ and an incentive security multiplier of $0.85$, yielding a final annual premium quote of **\$9,441.27**[cite: 1].

## Comments & Results Interpretation
 **Automated Scalability**: This engine bridges the gap between static actuarial modeling and real-time underwriting workflows. It proves that insurance pricing can be both mathematically rigorous and dynamically responsive to a firm's operational behavior.
 **Risk-Responsive Pricing**: The distinct premium divergence between Client 1 and Client 2 demonstrates that companies investing in cyber hygiene (rapid detection and MFA) are directly rewarded with lower insurance costs, whereas high-exposure companies are fairly priced to cover expected losses.

 ##Recommendations for Industry & Public Sector **Deploy Automated Underwriting APIs in Public Risk Pools**: National development banks, state-backed insurance schemes, and public-private cyber risk partnerships should deploy automated underwriting engines like this to rapidly quote and onboard small-and-medium enterprises (SMEs) without heavy manual administrative friction.
 **Integrate Real-Time Telemetry**: Future iterations of public policy risk-scoring engines should link automated rating functions directly with continuous security-rating APIs, enabling dynamic premium adjustments as corporate risk profiles evolve.








## Module 8: Automated Production Underwriting & Policy Quotation Engine

## Objective
Why this step was  carried out : To operationalize the statistical findings from our Gamma GLM and security credit rules into an automated production underwriting function. The goal was to build a reusable tool that takes a company's specific profile (industry sector, MFA adoption status, and detection lag days), calculates its technical baseline risk, applies behavioral security modifiers, and outputs a compliant, risk-adjusted annual insurance premium quote.

 ##Technical Findings
 Built the `generate_cyber_quote` function in R, integrating the exact intercept ($\$106,914.77$) and sector relativities (e.g., Retail & E-commerce at $1.0886$, Technology at $1.0389$) extracted from our winning Gamma GLM[cite: 1].
 Automated the inclusion of the Module 3 security modifier logic (applying a 15% discount for MFA or 10% penalty for lack thereof, plus a 5% surcharge per additional week of dwell time beyond 14 days, bounded between $0.70$ and $1.50$)[cite: 1].
 Tested the production engine successfully on distinct risk profiles:
   *Client 1 (High-Risk Retail & E-commerce, No MFA, 45-day lag)*: Incurred a sector factor of $1.09$ and a security modifier of $1.30$, yielding a final annual premium quote of **\$15,130.36**.
   *Client 2 (Low-Risk Technology, MFA Enabled, 5-day lag)*: Incurred a sector factor of $1.04$ and an incentive security multiplier of $0.85$, yielding a final annual premium quote of **\$9,441.27**.

 ##Comments & Results Interpretation
 **Automated Scalability**: This engine bridges the gap between static actuarial modeling and real-time underwriting workflows. It proves that insurance pricing can be both mathematically rigorous and dynamically responsive to a firm's operational behavior.
 **Risk-Responsive Pricing**: The distinct premium divergence between Client 1 and Client 2 demonstrates that companies investing in cyber hygiene (rapid detection and MFA) are directly rewarded with lower insurance costs, whereas high-exposure companies are fairly priced to cover expected losses.

 ##Recommendations for Industry & Public Sector
 **Deploy Automated Underwriting APIs in Public Risk Pools**: National development banks, state-backed insurance schemes, and public-private cyber risk partnerships should deploy automated underwriting engines like this to rapidly quote and onboard small-and-medium enterprises (SMEs) without heavy manual administrative friction.
 **Integrate Real-Time Telemetry**: Future iterations of public policy risk-scoring engines should link automated rating functions directly with continuous security-rating APIs, enabling dynamic premium adjustments as corporate risk profiles evolve.





## Module 9: Monte Carlo Tail-Risk Simulation & Systemic Shock Visualization

## Objective
Why we carried out this step: Unlike traditional property or casualty insurance where risks are largely independent, cyber portfolios suffer from intense systemic correlation (e.g., a shared cloud outage or global zero-day software vulnerability taking down thousands of insured firms at once). The goal of this module was to run a **10,000-year Monte Carlo simulation incorporating structural systemic shocks** and visualize the resulting aggregate annual loss distribution alongside regulatory tail-risk thresholds (VaR).

## Technical Findings
 Executed a stochastic Monte Carlo simulation across 10,000 synthetic years, modeling compound frequency-severity interactions alongside structural systemic shocks.
 Generated a density plot mapping the **Portfolio Aggregate Annual Loss Distribution**, visualizing the dense core of expected losses around \$0.50B alongside the heavy catastrophic tail stretching past \$2.00B.
 Explicitly plotted regulatory solvency markers:
   *95% VaR (Solvency Threshold)*: Marked by the orange dashed vertical line.
   *99% VaR (Catastrophic Tail)*: Marked by the solid red vertical line.

 ## Comments & Results Interpretation
 **The Danger of Systemic Clusters**: The visualization clearly reveals a sharp separation between normal operating years (clustered tightly around \$0.50B) and extreme catastrophic shock years pushed far out into the right tail (> \$2.00B). This proves that cyber risk is fundamentally a fat-tailed systemic threat.
 **Capital Adequacy Visualization**: Marking the 95% and 99% VaR thresholds directly onto the simulation density curve gives risk managers and institutional supervisors an intuitive tool to see precisely where insolvency risks begin.

 Recommendations for Industry & Public Sector
 **Incorporate Monte Carlo Stress Tests in National Supervision**: Regulatory bodies and international development organizations should mandate that national insurance pools run multi-thousand-year Monte Carlo simulations to test solvency against systemic cloud and software shocks.
 **Establish Backstopped Sovereign Risk Pools**: Because catastrophic cyber tails exceed the capacity of single commercial insurers, governments and multilateral institutions (such as the World Bank) must establish public-private reinsurance backstops to absorb losses that cross the 99% VaR threshold.











## Module 10: Industry Risk Relativities Visualization

 Objective
Why we carried out this step: In actuarial ratemaking, presenting raw statistical coefficients to stakeholders or regulators is rarely effective. The goal of this visualization module was to translate the multiplicative risk relativities extracted from our Gamma GLM into a clean, intuitive horizontal bar chart, ranking industry sectors by their risk multipliers so underwriters and decision-makers can instantly identify baseline cost differentials.

## Technical Findings
 Generated a professional horizontal bar plot (`ggplot2`) visualizing the reordered sector risk relativities extracted from the predictive model.
 The chart clearly benchmarks each sector against the portfolio baseline:
   *Retail & E-commerce* and *Professional Services* rank at the top with the highest relative risk pricing multipliers (approaching ~0.95 to 0.98 scale relative weights).
   *Healthcare* and *Technology* occupy the middle-to-high risk tier.
   *Finance & Insurance* and *Manufacturing* sit at the lower end of the relativity spectrum for this specific modeled subset[cite: 3].

## Comments & Results Interpretation
 **Visualizing Rating Factors**: By ordering the bars from highest to lowest relativity, the plot provides an immediate visual justification for why certain industries face higher baseline insurance costs than others.
 **Stakeholder Communication**: This chart bridges advanced actuarial math with commercial clarity, allowing underwriters to explain rating structures to corporate clients or regulatory authorities transparently.

## Recommendations for Industry & Public Sector
 **Use Visual Rating Schedules in Commercial Tariffs**: Insurance providers should integrate visual relativity charts into their policyholder proposal documents to clearly demonstrate how sector risk characteristics drive premium calculations.
 **Align Public Sector Subsidies with Empirical Rankings**: Development finance institutions and government regulatory bodies should utilize visual risk ranking tools to identify which sectors require targeted public safety investments or subsidized insurance protections.

### Portfolio Risk Visualizations

#### 1. Loss Analysis & Relativities by Economic Sector
This section breaks down the severity of cyber breach metrics across distinct business environments alongside calculated risk pricing relativities.
![Cyber Loss by Industry Sector](### Portfolio Risk Visualizations

#### 1. Loss Analysis & Relativities by Economic Sector
This section breaks down the severity of cyber breach metrics across distinct business environments alongside calculated risk pricing relativities.
![Cyber Loss by Industry Sector](cyberlossbyindustrysector.png)


#### 2. Risk Mitigation Impact (MFA Attributes Evaluation)
These charts isolate the direct actuarial premium impact and claim variations between baseline profiles and risk-mitigated entities utilizing Multi-Factor Authentication.
![Cyber Loss by MFA Status](cyberlossbyMFAstatus.png)

#### 3. Solvency & Aggregate Tail Risk Profile

![Portfolio Aggregate Annual Loss](portfolioaggregateannualloss.png))
### 4. industry risk relatives
![Industry Risk Relativities](industryskrelatives.png)


 How to Run the Pipeline
1 Clone this repository locally.
2 Ensure `DBI`, `RSQLite`, `tidyverse`, and your modeling packages are installed.
3 Execute the scripts within `/scripts` sequentially to compute portfolio rate schedules.

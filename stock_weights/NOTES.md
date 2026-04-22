---
title:
author: "Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>"
tags:
links:
---


# USE age as factor?

- Use when age classes are discrete and you want separate year effects for each age.
- Benefit: separate smooths capture distinct temporal patterns per age class and can be implemented with group-level (by-factor) smooths
- Use instead of cohort effect to avoid year-age-cohort interactions?
- Modeling s(year, by = age) with age as a factor yields age-specific year effects; these can absorb cohort-like structure but do not by themselves identify separate year versus cohort mechanisms.
- If the goal includes forecasting or modeling latent temporal trends beyond smooth year effects, Dynamic GAM approaches can jointly estimate smooth predictors and unobserved dynamic components to capture complex temporal structure [1]

[1] E. J. Pedersen, E. J. Pedersen, D. L. Miller, G. Simpson, and N. Ross, “Hierarchical generalized additive models in ecology: an introduction with mgcv,” PeerJ, vol. 7, May 2019, doi: 10.7717/PEERJ.6876.
[2] N. J. Clark and K. Wells, “Dynamic Generalised Additive Models (DGAM) for forecasting discrete ecological time series,” bioRxiv, Feb. 2022, doi: 10.1111/2041-210X.13974.

# MODEL cohort

- Age: Continuous vs. Factor: Treating age as continuous (within a smooth) is generally preferred if you have many age classes or want to model growth as a smooth process. Using age as a factor is useful if you have very few age classes or suspect highly distinct, non-smooth differences between them (e.g., specific life-history stages).
- Cohort Effects: In a 2D smooth $f(age, year)$, the "diagonals" represent cohort effects. By using te() or ti(), the model can capture these without the identifiability issues that arise from including $s(age) + s(year) + s(cohort)$ directly.
- Identifiability: The mgcv package's tensor products (te, ti) use a penalty structure that naturally handles the linear dependency between age, year, and cohort, provided you do not add a separate linear cohort term.

[3] Cheng, M. L., Thorson, J. T., Ianelli, J., & Cunningham, C. (2023). Unlocking the triad of age, year, and cohort effects for stock assessment: Demonstration of a computationally efficient and reproducible framework using weight-at-age. Fisheries Research, 264, 106755.
[4] Citores Martinez, L. (2021). From habitat to management: a simulation framework for improving statistical methods in fisheries science. PhD Thesis, AZTI/University of the Basque Country.
[5] Wood, S. N. (2017). Generalized Additive Models: An Introduction with R (2nd Ed.). Chapman and Hall/CRC.


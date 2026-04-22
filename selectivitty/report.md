---
title: "Proposed changes of selectivity patterns in the North Sea sole SS3 assessment"
subtitle: "ICES WGNSSK"
author: 
  - Alessandro Orio (SLU Aqua)^[Department of Aquatic Resources. Institute of Marine Research. Lysekil (SE)]
  - Iago Mosqueira (WMR)^[Wageningen Marine Research, IJmuiden (NL), <iago.mosqueira@wur.nl>]
date: "21-30 April 2026"
output:
  bookdown::pdf_document2:
    toc: false
    fig_caption: yes
    latex_engine: pdflatex
documentclass: scrartcl
fontsize: 12pt
toc-depth: 1
header-includes: 
  - \usepackage{fancyhdr}
  - \pagestyle{fancy}
  - \fancyhead[L]{Author - Short}
  - \fancyhead[R]{Doc. reference}
tags:
license: Creative Commons Attribution-ShareAlike 4.0 International Public License
---

# Introduction

The current assessment of North Sea sole models selectivity of all 4 fleets (landings, discards, BTS and COAST) using a random walk approach, being time-varying for the landings fleet and time-invariant for the discards fleet and both surveys, with a constant assumption from age 5 onward.

The report of last year WGNSSK states: "The selectivity of the fleet as estimated by the SS3 model is presented in Figure 16.34. The changes in pattern on landings selectivity in recent years appear to be linked to the progression of the strong 2018 year class. Stock numbers at age 4 are high in 2022 (Table 16.10) and have only been estimated as high 4 times over the entire time series. If a similar selectivity pattern (without drop at age 4) as estimated in the previous years would be applied, this would result in a much too high prediction of the numbers at age 4. Therefore, the model reduced the selectivity at age 4 (unexpected drop; \~40% reduction) to obtain a better fit. Despite this reduction, a high positive residual can still be observed for age 4 (Figure 16.29). Similarly, selectivity is estimated lower for age 5 (and older ages, as it is set constant; drop of \~35%) in 2024 compared to the previous years, where selectivity was always highest for these older ages. A similar pattern was repeated last year for the 2023 estimates. This requires some investigation on what factors are affecting the model estimate in the last available year."

The final year selectivity of the landings fleet and the selectivity of the other three fleets (Figure 1) show that none of the fleets have full selectivity for older ages. In the case of the landings, full selectivity for older ages was estimated up to 2022 but in the last two years a drop can be seen from age 3 to age 4, in particular for 2024 (as shown in Figure 1). This could lead to the creation of cryptic biomass in the stock in the future if the landings selectivity does not revert to a logistic curve. Moreover, from Figure 1 it can be seen that the selectivity shape for both the BTS and COAST surveys show a drop in age 3 potentially due to the flexibility allowed by the selectivity random walk and not reflecting the real selectivity of the survey.

Because of these issues we have investigated the potential impact of trying to reduce the flexibility in the selectivity estimation by moving away from using a random walk and instead using a logistic selectivity for the landings and a double normal selectivity for the other fleets. Moreover, the selectivity of the landings has been changed from being time-varying for the entire time series to time-varying only from 2009 to 2021 which represents the period between the introduction and the complete ban of pulse trawling.

Figure 2 shows the selectivity at age from the new run with updated selectivity parameter. The main differences are for the landings fleet that now has full selectivity for ages 4+. The other fleet show quite similar pattern to the original run but without any sudden drop at age 3. Figure 3 shows the selectivity of the Landings fleet in the time-varying period 2008-2022. Figure 4 shows the trends in SSB, F and recruitment from the WGNSSK 2025 assessment run and the proposed new run with changes in the selectivity. The trends between the two runs are very similar, in particular for SSB and recruitment, while the F produced by the two runs show slightly more differences. Figure 5 shows very minor differences in the fit to the index between the two different runs. Figure 6 shows the comparison between the retrospective analyses of the two runs. The retrospectives are very similar and the Mohn's rho is the same for the SSB and slightly better for F in the updated run (-0.04 compared to -0.05). Figures 7 and 8 show the residuals from the WGNSSK run and the updated one. The residuals in the updated selectivity are higher in the Landings fleet, in particular for ages 1-3. This is expected and due to the removal of the full flexibility given by the time-varying random walk selectivity. Figure 9 shows the comparison of the hindcasting between two runs. In this case the values of the updated run are slightly higher for both BTS and COAST in the updated run.

In conclusion we propose moving to the new selectivity settings given in Table 1 that the trends in assessment are similar, the selectivity patterns are more realistic and can help avoid future issues with cryptic biomass, and the diagnostics are comparable with the exception of worse residuals for the Landings fleet.

\tiny

Table 1:

| # LO | HI | INIT | PRIOR | PR_SD | PR_type | PHASE | env-var | use_dev | dev_mnyr | dev_mxyr | dev_PH | Block | Blk_Fxn | parm_name |  |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| # 1 |  |  | Fleet | AgeSelex |  |  |  |  |  |  |  |  |  |  |  |
| 0 | 20 | 2.23076 | 10 | 4 | 0.5 | 5 | 0 | 23 | 2009 | 2021 | 5 | 0 | 0 | Age_inflection_Fleet(1) |  |
| -4 | 30 | 0.710311 | 1 | 4 | 0.5 | 6 | 0 | 23 | 2009 | 2021 | 6 | 0 | 0 | Age_95%width_Fleet(1) |  |
| # 2 |  |  | BTS | AgeSelex |  |  |  |  |  |  |  |  |  |  |  |
| 0 | 9.9 | 1.2036 | 2 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_peak_BTS(2) |  |
| -5 | 3 | -3.79741 | -5 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_top_logit_BTS(2) |  |
| -4 | 12 | -1.44672 | 8.4 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_ascend_se_BTS(2) |  |
| -10 | 6 | -3.47201 | 3 | 1 | 0.05 | -4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_descend_se_BTS(2) |  |
| -15 | 5 | -3.38987 | 0 | 1 | 0.05 | -4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_start_logit_BTS(2) |  |
| -5 | 15 | 1.63717 | 0.9 | 1 | 0.05 | -4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_end_logit_BTS(2) |  |
| # 3 | COAST | AgeSelex |  |  |  |  |  |  |  |  |  |  |  |  |  |
| 0 | 9.9 | 4.32E-05 | 2 | 1 | 0.05 | -4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_peak_COAST(3) |  |
| -15 | 3 | -12.5387 | -5 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_top_logit_COAST(3) |  |
| -30 | 12 | -20.9735 | 5.9 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_ascend_se_COAST(3) |  |
| -2 | 6 | 1.82926 | 0.3 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_descend_se_COAST(3) |  |
| -15 | 5 | 1.31219 | 0.8 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_start_logit_COAST(3) |  |
| -15 | 5 | -11.8416 | 0 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_end_logit_COAST(3) |  |
| # 4 | Discards | AgeSelex |  |  |  |  |  |  |  |  |  |  |  |  |  |
| 0 | 9.9 | 1.19921 | 2 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_peak_Discards(4) |  |
| -15 | 3 | -10.277 | -5 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_top_logit_Discards(4) |  |
| -4 | 12 | -3.59095 | 0.3 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_ascend_se_Discards(4) |  |
| -2 | 6 | 1.956 | 1 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_descend_se_Discards(4) |  |
| -15 | 5 | -14.6525 | 0 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_start_logit_Discards(4) |  |
| -5 | 5 | -2.14541 | 0.2 | 1 | 0.05 | 4 | 0 | 0 | 0 | 0 | 0.5 | 0 | 0 | Age_DblN_end_logit_Discards(4) |  |

![](report/media/image1.png){width="4in" align="center"}

Figure 1. Sole in Subarea 4. Selectivity at age for the fleets in the assessment model of North Sea sole.

![](report/media/image2.png){width="4in" align="center"}

Figure 2. Sole in Subarea 4. Selectivity at age from the new run with updated selectivity (Selectivity).

![](report/media/image3.png){width="5in" align="center"}

Figure 3. Sole in Subarea 4. Selectivity at age from the new run with updated selectivity (Selectivity) for the Landings fleet during the period where selectivity is time-varying.

![](report/media/image4.png){width="2in" align="center"}
![](report/media/image5.png){width="2in" align="center"}
![](report/media/image6.png){width="2in" align="center"}

Figure 4. Sole in Subarea 4. Comparison of stock status trends from last year assessment run (WGNSSK) and the new run with updated selectivity (Selectivity).

![](report/media/image7.png){width="3in" align="center"}
![](report/media/image8.png){width="3in" align="center"}

Figure 5. Sole in Subarea 4. Comparison of the fit to the indices from last year assessment run (WGNSSK) and the new run with updated selectivity (Selectivity).

![](report/media/image9.jpeg){width="3in" align="center"}
![](report/media/image10.jpeg){width="3in" align="center"}

Figure 6. Sole in Subarea 4. Comparison of the retros from last year assessment run (WGNSSK on the left) and the new run with updated selectivity (Selectivity on the right).

![](report/media/image11.png){width="6in" align="center"}

Figure 7. Sole in Subarea 4. Residuals from the new run with updated selectivity (Selectivity).

![](report/media/image12.png){width="6in" align="center"}

Figure 8. Sole in Subarea 4. Residuals from last year assessment run (WGNSSK).

![](report/media/image13.jpeg){width="5in" align="center"}

![](report/media/image14.jpeg){width="5in" align="center"}

Figure 9. Sole in Subarea 4. Comparison of the hindcasting from last year assessment run (WGNSSK on the top) and the new run with updated selectivity (Selectivity on the bottom).



# report_plots.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/2026_sol.27.4_review/selectivity/report_plots.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

# RMSE
SSplotJABBAres(out, subplots="cpue", print=TRUE,
  plotdir=dir, filenameprefix = "cpue_")

SSplotJABBAres(out, subplots="age", print=TRUE,
  plotdir=dir, filenameprefix = "age_")

# RETRO
taf.png(file.path(dir, "retro.png"))
sspar(mfrow=c(2,1), plot.cex = 0.65)
SSplotRetro(retroSummary, add=T, subplots="SSB", forecast=FALSE)
SSplotRetro(retroSummary, add=T, subplots="F", forecast=FALSE)
dev.off()

# XVAL
SSplotHCxval(retroSummary, print=TRUE, plotdir=dir)

# model_ss3.R - DESC
# 2026_sol.27.4_assessment/model_ss3.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


# FIT
r4ss::run(path, exe=exe, show_in_console=TRUE, skipfinished=FALSE)

# LOAD SS_output
out <- SS_output(path, covar=TRUE)

# LOAD FLStocks
sol <- readsol274(path)
run <- sol$run
stk <- sol$stk

# SS plots
SS_plots(out, uncertainty=T, png=T, forecastplot=TRUE, fitrange = TRUE, 
  parrows=5, parcols=4, showdev=FALSE, html = TRUE,
  printfolder = paste0("../../report/", basename(path)))

# RETRO
retro(path, exe=exe, show_in_console=TRUE, overwrite=TRUE, skipfinished=FALSE)

# RETROSPECTIVE runs

retros <- file.path(path, "retrospectives", paste("retro",0:-5,sep=""))

retroSummary <- SSsummarize(SSgetoutput(dirvec=retros))

retroStocks <- lapply(setNames(retros, nm=c('final',
  paste("retro", -1:-5, sep=""))),  readFLSss3)

retroStocks <- FLStocks(Map(function(x, y)
  window(x, end=y), x=retroStocks, y=seq(2022, 2017)))

# RUN jitter

mkdir(file.path(path, "jitter"))

copy_SS_inputs(path, file.path(path, "jitter"))
cp(file.path(path, 'ss3.par'), file.path(path, "jitter"))

jitters <- jitter(dir=file.path(path, "jitter"), Njitter=50,
  jitter_fraction=0.05, exe=exe, extras = '-nohess')

# SUMMARY jitter profiles
profsum <- SSsummarize(SSgetoutput(dirvec = file.path(path, 'jitter'),
  keyvec = 1:50, getcovar = FALSE))

# TABLE params
table_pars <- table_parcounts(out)

# MVLN
library(ss3diags)
mvln <- SSdeltaMVLN(out)

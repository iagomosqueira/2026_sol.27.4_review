# model.R - RUN SS3 model, retrospectives and jitters
# 2024_sol.27.4_assessment/model.R

# Copyright (c) WUR, 2024.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(TAF)
mkdir("model")

library(ss3om)
source("utilities.R")

# LOAD data
load("data/data.rda")

# SET model executable
exe <- normalizePath('boot/software/ss_3.30.24.1')

# - RUN with fixed discard ratio

path <- "model/new"
mkdir(path)
cp("boot/data/ss3/*", path) 

SS_writedat(dat, outfile="model/new/sol274.dat", overwrite=TRUE)

# FIT
r4ss::run(path, exe=exe, show_in_console=TRUE, skipfinished=FALSE)

# RETRO

# REFPTS

# CHECK:

# LOAD
new <- readsol274(path)$run
out <- readOutputss3(path)

# PLOT

taf.png("report/runs.png")
plot(FLStocks(WGNSSK25=run, DISCARDS=new, INPUT=stk),
  metrics=list(Rec=rec, SSB=ssb, Catch=catch, Discards=discards, F=fbar))
dev.off()

taf.png("report/discards_ratio.png")
plot(FLStocks(WGNSSK25=run, DISCARDS=new, INPUT=stk),
  metrics=list(Ratio=function(x) discards(x) / catch(x))) +
  geom_hline(yintercept=c(yearMeans((discards(stk) / catch(stk))[, ac(2001:2006)])),
    linetype=2) +
  ylim(0, 1)
dev.off()


# PLOTS

SS_plots(out, uncertainty=T, png=T, forecastplot=TRUE, fitrange = TRUE, 
  parrows=5, parcols=4, showdev=FALSE, html = TRUE,
  printfolder = "../../report/ss3")

# RETRO
retro(path, exe=exe, show_in_console=TRUE, overwrite=FALSE, skipfinished=FALSE)

# RETROSPECTIVE runs
retros <- file.path(path, "retrospectives", paste("retro",0:-5,sep=""))

retroSummary <- SSsummarize(SSgetoutput(dirvec=retros))

retroStocks <- lapply(setNames(retros, nm=c('final',
  paste("retro", -1:-5, sep=""))),  readFLSss3)

retroStocks <- FLStocks(Map(function(x, y)
  window(x, end=y), x=retroStocks, y=seq(2023, 2018)))

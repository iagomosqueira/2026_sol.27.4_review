# model_refpts_bevholt.R - DESC
# 2024_sol.27.4_benchmark_assessment/model_refpts_bevholt.R

# Copyright (c) WUR, 2024.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(msy)
library(FLCore)

source("utilities.R")

# LOAD
# load('model/model.rda')

# SETTINGS 

Fs <- seq(0, 1.5, length=51)
nsamp <- 1000

# USE 5 y for selex and biology (TBB -> pulse, lower wt)
bio.years <- c(-4, -0) + dims(run)$maxyear
sel.years <- c(-4, -0) + dims(run)$maxyear

# REMOVE no years
remove.years <- 2023

# GET sigmar and rho
sigmaR <- out$parameters["SR_sigmaR", "Value"]
rho <- out$parameters["SR_autocorr", "Value"]

# SET Blim & Bpa
Blim <- sort(c(ssb(run)))[4]

# TEST: 10% B0
# Blim <- c(rps$SB0 * 0.10)

pa <- exp(1.645 * 0.20)
Bpa <- Blim * pa

# FIT boundedSegreg
srfit1 <- eqsr_fit(run, nsamp = nsamp,
  models = c("boundedSegreg"), remove.years=remove.years) 

eqsr_plot(srfit1, ggPlot = FALSE)

# PA from cv=0.2, exp(1.645 * 0.2)
pa <- exp(1.645 * 0.2)

# SIMULATE w/5 y, Fcv=Fphi=0, Btrigger=0
srsim1 <- eqsim_run(srfit1,
  bio.years = bio.years, sel.years = sel.years,
  Fcv = 0, Fphi = 0,
  Btrigger=0, Blim = Blim, Bpa = Bpa,
  Fscan = Fs,
  verbose = FALSE)

# EXTRACT Flim and Fpa
Flim <- srsim1$Refs2["catF", "F50"]
Fpa <- Flim / pa

# WKNEWREF
# round(srsim1$refs_interval$FmsylowerMedianL, 3)

# SIMULATE w/ Fcv=0.212, Fphi=0.423 (WKMSYREF4)
srsim2 <- eqsim_run(srfit1,
  bio.years = bio.years, sel.years = sel.years,
  bio.const = FALSE, sel.const = FALSE,
  Fcv=0.212, Fphi=0.423,
  Btrigger=0, Blim = Blim, Bpa = Bpa,
  Fscan = seq(0, 1.5, length=251),
  verbose = FALSE)

cFmsy <- srsim2$Refs2["lanF", "medianMSY"]

# NOTE: STOCK fished at FMSY for 5+ years? NO

cBtrigger <- Bpa

# SIMULATE w/cBtrigger
srsim3 <- eqsim_run(srfit1,
  bio.years = bio.years, sel.years = sel.years,
  bio.const = FALSE, sel.const = FALSE,
  Fcv=0.212, Fphi=0.423,
  Btrigger=cBtrigger, Blim = Blim, Bpa = Bpa,
  Fscan = Fs,
  verbose = FALSE)

Fmsy <- min(srsim3$Refs2["catF", "F05"], cFmsy)

# SET Btrigger
Btrigger <- Bpa

# SET Fpa
Fpa <- Fmsy

# lFMSY
lFmsy <- min(Fmsy, srsim2$Refs2["lanF", "Medlower"])

# Landings for Fmsy
lan <-   data.table(srsim2$rbp)[abs(Ftarget - Fmsy) == min(abs(Ftarget - Fmsy)) & variable == 'Landings', p50]

lFmsy <- data.table(srsim2$rbp)[variable == 'Landings' & p50 >= lan * 0.95, Ftarget][1]

# uFMSY
uFmsy <- min(Fpa, srsim2$Refs2["lanF", "Medupper"])

# REFPTS
nrefpts <- FLPar(Btrigger=Btrigger, Fmsy=Fmsy, Blim=Blim, Bpa=Bpa,
  Flim=Flim, Fpa=Fpa, lFmsy=lFmsy, uFmsy=uFmsy,
  units=c("t", "f", rep("t", 2), rep("f", 4), rep("t", 2)))

# SAVE
save(nrefpts,  srfit1=srfit1, srsim1, srsim2, srsim3,
  file=file.path("model", "eqsim.rda"), compress="xz")

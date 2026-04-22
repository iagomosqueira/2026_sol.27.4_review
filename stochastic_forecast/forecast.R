# forecast.R - DESC
# stochastic_forecast/forecast.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(FLasher)
library(ss3om)

# LOAD run & results

load('output.rda')

load('results.rda')

# GENERATE uncertainty

fqs <- ssmvln(out$CoVar, out$derived_quants, mc=500, new=!FALSE)

# CV SSB final year
cv(fqs$Bratio[,'2024'])

# RUN hindcast for F with Recr

hin <- fwd(propagate(run, 500), sr=fqs$Recr,
  fbar=fqs$F[, ac(rev(seq(from=2024, by=-1, length=15)))])

# CV SSB final year
cv(ssb(hin)[, '2024'])

# PLOT
plot(run, hin)

# P(B<Blim)
iterMeans((ssb(hin) / refpts$Blim) < 1) * 100


# ADD SRR deviances

hindev <- fwd(propagate(run, 500), sr=fqs$Recr,
  fbar=fqs$F[, ac(rev(seq(from=2024, by=-1, length=15)))],
  deviances=rlnormar1(500, years=2010:2024, meanlog=0, sd=0.3))

plot(FLStocks(RUN=run, HIND=hin, HINDEV=hindev))

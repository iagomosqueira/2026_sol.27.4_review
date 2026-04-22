# output.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/stock_weights/output.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(TAF)
mkdir("output")

library(ss3om)
library(r4ss)
library(data.table)

source("utilities.R")

# LOAD

load("model/model.rda")

dirs <- c(WGNNSK="model/ss3", "s(year, 15)"="model/ss3_gam15",
  "waa_2023"="model/ss3_nochange", "TE (age, year)"="model/ss3_teageyear")

# SS_output
outs <- lapply(dirs, readOutputss3)

# FLStock
stks <- FLStocks(parallel::mclapply(dirs,  function(x) readsol274(x)$run, mc.cores=4))

# retro FLStocks
rets <- parallel::mclapply(dirs, readFLRetross3, mc.cores=4)

# SS retro summaries
retsums <- parallel::mclapply(dirs, readRetross3, mc.cores=4)

# SAVE
save(dat, mods, outs, stks, rets, retsums, file = "output/output.rda", compress = "xz")

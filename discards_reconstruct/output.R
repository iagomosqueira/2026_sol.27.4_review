# output.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/discards_reconstruct/output.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

library(TAF)
mkdir("output")

library(ss3om)
source("utilities.R")

# OUTPUT folders
dirs <- setNames(list.dirs("model", recursive=FALSE),
  nm=basename(list.dirs("model", recursive=FALSE)))

# LOAD SS3 runs and outputs
runs <- FLStocks(lapply(dirs, function(x) readsol274(x)$run))

outs <- lapply(dirs, readOutputss3)

dat <- rbindlist(lapply(outs, function(x) data.table(x$discard)), idcol="model")

# LOAD refpts
refpts <- lapply(dirs, function(x) readRDS(file.path(x, "refpts.rds")))

# SAVE
save(runs, outs, refpts, file="output/output.rda")

# model_run.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/stock_weights/model_run.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


mkdir(path)
cp("boot/data/ss3/*", path)

# UPDATE wtatage

wts <- data.table(SS_readwtatage(file.path("boot", "data", "ss3", 'wtatage.ss')))

nwts <- copy(wts)

nwts[fleet == 0 & year <= 2024, as.character(0:10) :=
  dcast(dat[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]
nwts[fleet == -1 & year <= 2024, as.character(0:10) :=
  dcast(dat[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]
nwts[fleet == -2 & year <= 2024, as.character(3:10) :=
  dcast(dat[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -c(1,2,3,4)]]
nwts[fleet == 2 & year <= 2024, as.character(0:10) :=
  dcast(dat[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]
nwts[fleet == 3 & year <= 2024, as.character(0:10) :=
  dcast(dat[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]

# WRITE
SS_writewtatage(nwts, dir=path, overwrite=TRUE)

# RUN

r4ss::run(path, exe=exe, show_in_console=TRUE, skipfinished=FALSE)

# RETRO
retro(path, exe=exe, show_in_console=TRUE, skipfinished=FALSE, overwrite=TRUE)

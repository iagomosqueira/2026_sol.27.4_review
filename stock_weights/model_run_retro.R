# model_run_retro.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/stock_weights/model_run_retro.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


# REFIT GAM and RERUN retro

waas <- parallel::mclapply(seq(5), function(i) {

  y <- 2024 - i

  inp <- copy(dat)[year <= y]

  rfit  <- update(mods[[mod]], data = inp)

  inp[, teageyear := exp(predict(rfit, newdata = inp))]

  rpath <- file.path(path, "retrospectives",
    paste0("retro-", i))

  waa <- data.table(SS_readwtatage(file.path(rpath, "wtatage.ss")))

  waa[fleet == 0 & year <= y, as.character(0:10) :=
    dcast(inp[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]
  waa[fleet == -1 & year <= y, as.character(0:10) :=
    dcast(inp[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]
  waa[fleet == -2 & year <= y, as.character(3:10) :=
    dcast(inp[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -c(1,2,3,4)]]
  waa[fleet == 2 & year <= y, as.character(0:10) :=
    dcast(inp[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]
  waa[fleet == 3 & year <= y, as.character(0:10) :=
    dcast(inp[, .SD, .SDcols = cols], year ~ age, value.var=cols[3])[, -1]]

  SS_writewtatage(waa, dir=rpath, overwrite=TRUE)

  r4ss::run(rpath, exe=exe, show_in_console=TRUE, skipfinished=FALSE)

  return(waa)

  }, mc.cores=4)

# PLOT: waas

dt <- rbindlist(waas, idcol="ay")

save(dt, file = paste0("output/", mod,  "waas.rda"), compress = "xz")

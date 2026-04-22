# model.R - RUN SS3 model, retrospectives and jitters
# 2024_sol.27.4_assessment/model.R

# Copyright (c) WUR, 2024.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


# - SETUP run
mkdir(path)

orig <- file.path("boot", "data", ss3)

cp(paste0(orig, "/*"), path) 

# - LOAD & MODIFY dat.ss

dat <- SS_readdat(file.path(orig, "sol274.dat"))

# dat$discard_data

dat$discard_data <- as.data.frame(rbind(
  res[year < 2002, .(year, month=1, fleet=4, obs=.SD[[1]], stderr=0.2), .SDcols = mod],
  dat$discard_data))

# dat$catch

datc <- data.table(dat$catch)

datc <- rbind(datc,
  res[year < 2002, .(year, seas=1, fleet=4, catch = .SD[[1]], catch_se=0.01), 
  .SDcols = mod])

dat$catch <- as.data.frame(datc)

# dat$bycatch_fleet_info
dat$bycatch_fleet_info$F_or_first_year <- 1959
dat$bycatch_fleet_info$F_or_last_year <- 2024

# SAVE dat
SS_writedat(dat, outfile=file.path(path, "sol274.dat"), overwrite=TRUE)

# FIT
r4ss::run(path, exe=exe, show_in_console=TRUE, skipfinished=FALSE)

# RETRO
# plan(multicore, workers = 5)
# retro(path, exe=exe, show_in_console=TRUE, overwrite=FALSE, skipfinished=FALSE)

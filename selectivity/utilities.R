# utilities.R - DESC
# 2026_sol.27.4_assessment/utilities.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


# readsol274 {{{

readsol274 <- function(path) {

  # LOAD output
  out <- SS_output(path, covar=TRUE)

  # LOAD wtatage
  waa <- data.table(SS_readwtatage(file.path(path, 'wtatage.ss_new')))

  # LOAD data
  dat <- SS_readdat(file.path(path, 'sol274.dat'))

  # FLStock 
  run <- readFLSss3(path, range=c(minfbar=2, maxfbar=6))

  yrs <- dimnames(run)$year
  dyrs <- out$discard$Yr

  # ESTIMATED landings & discards

  landings.n(run)[, yrs] <- t(data.table(out$catage)[Fleet == 1 &
    Yr %in% yrs, 12:22, with=FALSE])

  landings.wt(run) <- c(t(waa[fleet == 1 & year %in% yrs,
    seq(7, 17), with=FALSE]))

  landings(run)[, ac(dyrs)] <- data.table(out$catch)[Fleet == 1 &
    Yr %in% dyrs]$Exp

  discards.n(run)[, ac(dyrs)] <- t(data.table(out$catage)[Fleet == 4 &
    Yr %in% dyrs, 12:22, with=FALSE])

  discards.wt(run)[, ac(dyrs)] <- c(t(waa[fleet == 4 & year %in% dyrs,
    seq(7, 17), with=FALSE]))

  discards(run)[, ac(dyrs)] <- data.table(out$catch)[Fleet == 4 &
    Yr %in% dyrs]$dead_bio

  catch(run) <- computeCatch(run, 'all')

  # INPUT FLStock
  stk <- run

  # INPUT landings & discards
  landings.n(stk) <- 0
  landings.n(stk)[as.character(out$agebins),] <-
    c(t(data.table(dat$agecomp)[fleet == 1, paste0("a",  out$agebins), 
    with=FALSE]))

  landings(stk) <- data.table(dat$catch)[fleet == 1 & year %in% yrs,
    catch]

  discards.n(stk) <- 0
  discards.n(stk)[as.character(out$agebins), ac(dyrs)] <-
    c(t(data.table(dat$agecomp)[fleet == 4, paste0("a",  out$agebins), 
    with=FALSE]))

  discards(stk)[, ac(dyrs)] <- data.table(dat$catch)[fleet == 4 &
    year %in% dyrs, catch]

  catch(stk) <- computeCatch(stk, 'all')

  return(FLStocks(run=run, stk=stk))
}

# }}}


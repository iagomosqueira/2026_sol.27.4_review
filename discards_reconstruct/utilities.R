# utilities.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/discards_reconstruct/utilities.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


# readsol274 {{{

# BUG: TEMPORARY function to deal with 2 fleets for landings & discards

readsol274 <- function(path) {

  # LOAD output
  out <- SS_output(path, covar=TRUE)

  # LOAD wtatage
  waa <- data.table(SS_readwtatage(file.path(path, 'wtatage.ss_new')))

  # LOAD data
  dat <- SS_readdat(file.path(path, 'sol274.dat'))

  # FLStock 
  run <- readFLSss3(path, range=c(minfbar=2, maxfbar=6))

  # ESTIMATED landings & discards

  landings.n(run)[, ac(1957:2024)] <- t(data.table(out$catage)[Fleet == 1 &
    Yr %in% 1957:2024, 12:22, with=FALSE])

  landings.wt(run) <- c(t(waa[fleet == 1 & year %in% seq(1957, 2024),
    seq(7, 17), with=FALSE]))

  landings(run)[, ac(2002:2024)] <- data.table(out$catch)[Fleet == 1 &
    Yr %in% seq(2002, 2024)]$Exp

  discards.n(run)[, ac(2002:2024)] <- t(data.table(out$catage)[Fleet == 4 &
    Yr %in% 2002:2024, 12:22, with=FALSE])

  discards.wt(run) <- c(t(waa[fleet == 4 & year %in% seq(1957, 2024),
    seq(7, 17), with=FALSE]))

  discards(run)[, ac(2002:2024)] <- data.table(out$catch)[Fleet == 4 &
    Yr %in% seq(2002,2024)]$dead_bio

  catch(run) <- computeCatch(run, 'all')

  # INPUT FLStock
  stk <- run

  # INPUT landings & discards
  landings.n(stk) <- 0
  landings.n(stk)[as.character(out$agebins),] <-
    c(t(data.table(dat$agecomp)[fleet == 1, paste0("a",  out$agebins), 
    with=FALSE]))

  landings(stk) <- data.table(dat$catch)[fleet == 1 & year %in% 1957:2024,
    catch]

  discards.n(stk) <- 0
  discards.n(stk)[as.character(out$agebins), ac(2002:2024)] <-
    c(t(data.table(dat$agecomp)[fleet == 4, paste0("a",  out$agebins), 
    with=FALSE]))

  discards(stk)[, ac(2002:2024)] <- data.table(dat$catch)[fleet == 4 &
    year %in% 2002:2024, catch]

  catch(stk) <- computeCatch(stk, 'all')

  return(FLStocks(run=run, stk=stk))
}

# }}}

# boundedSegreg {{{

boundedSegreg <- function(ab, ssb) {
  ab$b <- ab$b + Blim
  Segreg (ab, ssb)
}
# }}}

library(ggplot2)
library(patchwork)

glm_diag_panel <- function(mod, data, time_var) {

  df_aug <- data.frame(
    fitted = fitted(mod),
    resid_pearson = residuals(mod, type = "pearson"),
    resid_dev = residuals(mod, type = "deviance"),
    obs = model.response(model.frame(mod)),
    time = data[[time_var]]
  )

  p1 <- ggplot(df_aug, aes(fitted, obs)) +
    geom_point(alpha = 0.6) +
    geom_abline(slope = 1, intercept = 0, linetype = 2) +
    theme_bw() +
    labs(x = "Fitted", y = "Observed")

  p2 <- ggplot(df_aug, aes(fitted, resid_pearson)) +
    geom_point(alpha = 0.6) +
    geom_hline(yintercept = 0, linetype = 2) +
    theme_bw() +
    labs(x = "Fitted", y = "Pearson residuals")

  p3 <- ggplot(df_aug, aes(time, resid_pearson)) +
    geom_point(alpha = 0.6) +
    geom_smooth(se = FALSE, method = "loess") +
    geom_hline(yintercept = 0, linetype = 2) +
    theme_bw() +
    labs(x = "Time", y = "Pearson residuals")

  p4 <- ggplot(df_aug, aes(sample = resid_dev)) +
    stat_qq() +
    stat_qq_line() +
    theme_bw() +
    labs(x = "Theoretical", y = "Deviance residuals")

  (p1 | p2) / (p3 | p4)
}

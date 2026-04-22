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

# osa_ss3 {{{

# TMB:::install.contrib("https://github.com/vtrijoulet/OSA_multivariate_dists/archive/main.zip")
# remotes::install_github("fishfollower/compResidual/compResidual", force=TRUE)

library(compResidual)


osa_ss3 <- function(x, plot=FALSE){ # x is the output list from SS_output in r4ss
  
  '%!in%' <- function(x,y)!('%in%'(x,y))
  
  res <- list()
  
  ## Dirichlet Multinomial OSA residuals
  for (k in unique(x$agedbase$Fleet)){
    
    theta <- subset(x$Age_Comp_Fit_Summary, Fleet==k)$val1
    
    tmp <- subset(x$agedbase, Fleet==k) # Obs = observed prop at age, Exp = predicted prop at age
    #tmp$obsN <- tmp$Obs*tmp$DM_effN
    tmp$obsN <- tmp$Obs*tmp$Nsamp_DM
    tmp$alpha <- tmp$Exp*theta*tmp$Nsamp_adj
    
    tmp2 <- reshape(tmp[,c("Yr", "Bin", "obsN", "alpha")], idvar="Bin", timevar="Yr", direction="wide")
    
    DM_obs <- as.matrix(tmp2[,grep("obsN",colnames(tmp2))]) # obs should be rounded 
    DM_alpha <- as.matrix(tmp2[,grep("alpha",colnames(tmp2))]) # pred cannot be 0
    
    # NOTE: Age 11 gets lost
    osa_res <- resDirM(round(DM_obs), DM_alpha)

    dimnames(osa_res) <- list(tmp2$Bin[-nrow(DM_obs)], unique(tmp$Yr))

    if (length(as.numeric(colnames(osa_res))[1]:as.numeric(colnames(osa_res))[ncol(osa_res)])!=ncol(osa_res)) {

      missing_years <- (as.numeric(colnames(osa_res))[1]:as.numeric(colnames(osa_res))[ncol(osa_res)])[as.numeric(colnames(osa_res))[1]:as.numeric(colnames(osa_res))[ncol(osa_res)] %!in% as.numeric(colnames(osa_res))]
      
      tmp3 <- matrix(nrow=nrow(osa_res), ncol=length(missing_years), dimnames=list(rownames(osa_res), missing_years))
      
      osa_res <- cbind(osa_res,tmp3)[,as.character(as.numeric(colnames(osa_res))[1]:as.numeric(colnames(osa_res))[ncol(osa_res)])]
      
      class(osa_res) <- "cres"
    }
    if (plot) plot(osa_res, main=paste0("Fleet ", k))
    
    res[[length(res)+1]] <- osa_res
  }
  res
}
# }}}

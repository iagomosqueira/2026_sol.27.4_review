# utilities.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/stock_weights/utilities.R

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

# buildFLwtatagess3 {{{

buildFLwtatagess3 <- function(dat, ...) {

  dats <- split(dat, by='fleet')

  names(dats) <- c("landings.wt", "BTS", "COAST", "discards.wt",
    "mat", "stock.wt", "stock.wt.mid")

  units <- c("kg", "kg", "kg", "kg", "NA", "kg", "kg")

  res <- Map(function(x,y)
    as.FLQuant(melt(x, id.vars='year', measure.vars=as.character(0:10),
      variable.name = "age", value.name = "data"), units=y), dats, units)

  return(res)
}
# }}}

# readFLRetross3 {{{

readFLRetross3 <- function(path) {
 
  # PASTE path and backward retrospectives/*
  paths <- file.path(path, "retrospectives", paste("retro",0:-5,sep=""))
  
  rsummary <- SSsummarize(SSgetoutput(dirvec=paths))

  rstocks <- lapply(setNames(paths, nm=seq(2024, 2019, -1)),  readsol274)
  rstocks <- lapply(rstocks, '[[', 'run')
  rstocks <- lapply(setNames(nm=names(rstocks)), function(x)
    window(rstocks[[x]], end=as.numeric(x)))

  return(FLStocks(rstocks))
}
# }}}

# readRetross3 {{{
readRetross3 <- function(path) {
 
  # PASTE path and backward retrospectives/*
  paths <- file.path(path, "retrospectives", paste("retro",0:-5,sep=""))
  
  rsummary <- SSsummarize(SSgetoutput(dirvec=paths))

  return(rsummary)
}
# }}}

library(bibtex)

# getBibTeX {{{

getBibTeX <- function(bibfile, file="report.Rmd", output = "report/references.bib") {

  # LOAD report
  lines <- readLines("report.Rmd")

  # Extract citation patterns
  matches <- regmatches(lines, gregexpr("\\[@([^]]+)\\]", lines))

  # Flatten and clean
  citations <- gsub("\\[@|\\]", "", unlist(matches))

  # Handle multiple citations like [@A; @B]
  citations <- unlist(strsplit(citations, ";\\s*"))

  citations <- unique(citations)

  bib <- read.bib("boot/references.bib")
  bib_keys <- names(bib)

  matched <- intersect(citations, bib_keys)

  missing <- setdiff(citations, bib_keys)

  bib_matched <- bib[matched]

  write.bib(bib_matched, file = "report/references.bib")
}
# }}}

# model.R - RUN SS3 model, retrospectives and jitters
# 2024_sol.27.4_assessment/model.R

# Copyright (c) WUR, 2024.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(TAF)
mkdir("model")

library(ss3om)

source("utilities.R")

# SETUP parallel
library(furrr)
plan(multicore, workers = 5)

# SET ss3 executable
if(os.linux()) {
  exe <- normalizePath('boot/software/ss_3.30.24.1')
} else if(os.windows()) {
  exe <- normalizePath('boot/software/ss_3.30.24.1.exe')
} else {
  stop()
}  

# --- WGNSSK

# SET model folder
path <- "model/ss3"

cp('boot/data/ss3/*', path)

# CALL fit, retro and jitter
source("model_ss3.R")

# SAVE
saveRDS(list(out=out, run=run, stk=stk, retroSummary=retroSummary,
  retroStocks=retroStocks, profsum=profsum, table_pars=table_pars),
    file="model/ss3.rds", compress="xz")

# --- SELEX

# SET model folder
path <- "model/selex"

mkdir(path)
cp('boot/data/ss3/*', path)
cp('boot/data/selex/*', path)

# CALL fit, retro and jitter
source("model_ss3.R")

# SAVE
saveRDS(list(out=out, run=run, stk=stk, retroSummary=retroSummary,
  retroStocks=retroStocks, profsum=profsum, table_pars=table_pars),
    file="model/selex.rds", compress="xz")

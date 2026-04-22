# model.R - RUN SS3 model, retrospectives and jitters
# 2024_sol.27.4_assessment/model.R

# Copyright (c) WUR, 2024.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

library(TAF)
mkdir("model")

library(msy)
library(ss3om)
source("utilities.R")

# LOAD glm results
load("model/discards.rda")

# model_ss3.R - RUN SS3 model, retrospectives and jitters

# SET model executable
exe <- normalizePath('boot/software/ss_3.30.24.2')

# wgnssk
path <- file.path("model", "wgnssk")
mkdir(path)
cp(paste0("boot/data/wgnssk/*"), path) 

r4ss::run(path, exe=exe, show_in_console=TRUE, skipfinished=FALSE)

source('model_refpts.R')

# predratio
ss3 <- "wgnssk"
mod <- "predratio"
path <- file.path("model", paste(mod, ss3, sep="_"))

source('model_ss3.R')
source('model_refpts.R')

# mod00:  D ~ L
ss3 <- "wgnssk"
mod <- "mod00"
path <- file.path("model", paste(mod, ss3, sep="_"))

source('model_ss3.R')
source('model_refpts.R')

# modR: D ~ L + R
ss3 <- "wgnssk"
mod <- "modR"
path <- file.path("model", paste(mod, ss3, sep="_"))

source('model_ss3.R')
source('model_refpts.R')

# modR new SS3: D ~ L + R
# ss3 <- "logistic_dnorm"
# mod <- "modR"
# path <- file.path("model", paste(mod, ss3, sep="_"))
# 
# source('model_ss3.R')
# source('model_refpts.R')

# report.R - Prepare plots and tables for report
# 2024_sol.27.4_benchmark_assessment/report.R

# Copyright (c) WUR, 2024.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(TAF)
mkdir("report")

library(ggplotFL)
library(patchwork)
library(ggrepel)
library(ss3diags)


# ss3
model <- 'ss3'
path <- file.path("model", model)
dir <- file.path("report", model)

spread(readRDS('model/ss3.rds'), FORCE = TRUE)

source("report_plots.R")

# ss3_selex
model <- 'selex'
path <- file.path("model", model)
dir <- file.path("report", model)

spread(readRDS('model/selex.rds'), FORCE = TRUE)

source("report_plots.R")

# RENDER
render("presentation.Rmd", output_dir="report",
  output_file="sol274_selectivity_settings_SS3-WGNSSK_2026-presentation.pdf")

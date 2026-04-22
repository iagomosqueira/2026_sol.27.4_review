# data.R - DESC
# discards_reconstruct/data.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(TAF)

library(ss3om)
library(ggplotFL)

# LOAD past results
load('boot/data/output_sol.27.4_wgnnsk-2025.rda')

# SET years
ys <- 1959:2024
dys <- 2002:2024

# COMPUTE discards from ratio 2001:2006
dis <- landings(stk)[, ac(dys)] %*%
  yearMeans((discards(stk) / landings(stk))[, ac(2002:2006)])

# ASSEMBLE dataset

data <- data.table(
  year=ys,
  # rayio D / L
  ratio=c((discards(stk) / landings(stk))[, ac(ys)]),
  # L
  landings=c(landings(stk)[, ac(ys)]),
  # D
  discards=c(discards(stk)[, ac(ys)]),
  # Age 1 abundance
  rec1=c(rec(stk)[, ac(ys - 1)]),
  # Age 2 abundance
  rec2=c(rec(stk)[, ac(ys - 2)]),
  # Prop. discards age 1
  pd1=c((discards.n(stk) * discards.wt(stk))['1', ac(ys)] / discards(stk)[, ac(ys)]),
  # Prop. discards age 2
  pd2=c((discards.n(stk) * discards.wt(stk))['2', ac(ys)] / discards(stk)[, ac(ys)])
)

# ADD total recruits (ages 1 and 2)
data[, rec := rec1 + rec2]
# PROP discards ages 1 and 2
data[, pd:=pd1 + pd2]

# SAVE
save(data, stk, file="data/data.rda")

# model.R - DESC
# sol274_ICES_WGNSSK/stock_weights/model.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(ss3om)
library(r4ss)
library(data.table)
library(mgcv)

source("utilities.R")

# LOAD data
load("data/data.rda")

# --- 2024 as 2023

dat[, nochange := weight]
dat[year == 2024, nochange:= dat[year == 2023, weight]]

# --- log(weight) ~ as.factor(age) + s(year, by = as.factor(age))

# - AGE, k=10

fac_age10 <- gam(
  weight ~ as.factor(age) + s(year, by = as.factor(age), k = 10),
  data   = dat,
  family = Gamma(link = "log"),
  method = "REML"
)

gam.check(fac_age10)

dat[, facage10 := exp(predict(fac_age10, newdata = dat))]

# - AGE, k=15

fac_age15 <- gam(
  weight ~ as.factor(age) + s(year, by = as.factor(age), k = 15),
  data   = dat,
  family = Gamma(link = "log"),
  method = "REML"
)

gam.check(fac_age15)

dat[, facage15 := exp(predict(fac_age15, newdata = dat))]

# - AGE, k=20

fac_age20 <- gam(
  weight ~ as.factor(age) + s(year, by = as.factor(age), k = 20),
  data   = dat,
  family = Gamma(link = "log"),
  method = "REML"
)

gam.check(fac_age20)

dat[, facage20 := exp(predict(fac_age20, newdata = dat))]


# PLOT: Predictions by age

taf.png("gam_predictions_by_age.png")
ggplot(dat, aes(x = year)) +
  geom_point(aes(y = weight, colour = "Original"), alpha = 0.7) +
  geom_line(aes(y = facage10, colour = "GAM: factor(year) k=10"), alpha = 0.7) +
  geom_line(aes(y = facage15, colour = "GAM: factor(year) k=15"), alpha = 0.7) +
  geom_line(aes(y = facage20, colour = "GAM: factor(year) k=20"), alpha = 0.7) +
  facet_wrap(~ age, scales = "free_y") +
  labs(x = "", y = "Stock weight (kg)", colour = "Series") +
  ylim(0, NA) +
  theme_bw() +
  theme(legend.position=c(0.9,0.2))
dev.off()

# --- tensor product smooths, log(weight) ~ te(age, year, k = c(10, 10))

te_age_year <- gam(weight ~ te(age, year, k = c(9, 15)), data = dat,
  family = Gamma(link = "log"))

gam.check(te_age_year)

dat[, teageyear := exp(predict(te_age_year, newdata = dat))]

# --- tensor product interactions, log(weight) ~ ti(age, year, k = c(10, 10))

ti_age_year <- gam(weight ~ s(age) + s(year, k=15) + ti(age, year, k = c(9, 15)),
  data = dat, family = Gamma(link = "log"))

gam.check(ti_age_year)

dat[, tiageyear := exp(predict(ti_age_year, newdata = dat))]

mods <- list(GAM10=fac_age10, GAM15=fac_age15, GAM20=fac_age20, TE=te_age_year,
  TI=ti_age_year)

# PLOT: Predictions by age

taf.png("gam_predictions_by_age_te_ti.png")
ggplot(dat, aes(x = year)) +
  geom_point(aes(y = weight, colour = "Original"), alpha = 0.7) +
  geom_line(aes(y = teageyear, colour = "GAM: te(age+year) k=10,10"), alpha = 0.7) +
  geom_line(aes(y = tiageyear, colour = "GAM: ti(age+year) k=10,10"), alpha = 0.7) +
  facet_wrap(~ age, scales = "free_y") +
  labs(x = "", y = "Weight (kg)", colour = "Series") +
  ylim(0, NA) +
  theme_bw() +
  theme(legend.position=c(0.9,0.2))
dev.off()

# PLOT: Predictions by age

taf.png("gam_predictions_by_age_te_ti.png")
ggplot(dat, aes(x = year)) +
  geom_point(aes(y = weight, colour = "Original"), alpha = 0.7) +
  geom_line(aes(y = teageyear, colour = "GAM: te(age+year) k=10,10"), alpha = 0.7) +
  geom_line(aes(y = facage15, colour = "GAM: factor(year) k=15"), alpha = 0.7) +
  facet_wrap(~ age, scales = "free_y") +
  labs(x = "", y = "Weight (kg)", colour = "Series") +
  ylim(0, NA) +
  theme_bw() +
  theme(legend.position=c(0.9,0.2))
dev.off()

AIC(fac_age10, fac_age15, fac_age20, te_age_year, ti_age_year)
BIC(fac_age10, fac_age15, fac_age20, te_age_year, ti_age_year)

# SAVE
save(dat, mods, file = "model/model.rda", compress = "xz")

# --- RUNS

exe <- normalizePath('boot/software/ss_3.30.24.1')

# BASE case
path <- "model/ss3"
cols <- c('year', 'age', 'weight')

source("model_run.R")

# NO CHANGE

path <- "model/ss3_nochange"
cols <- c('year', 'age', 'nochange')

source("model_run.R")

# GAM AGE 15

path <- "model/ss3_gam15"
mod  <- "GAM15"
cols <- c('year', 'age', 'facage15')

source("model_run.R")
source("model_run_retro.R")

# TE

path <- "model/ss3_teageyear"
mod <- "TE"
cols <- c('year', 'age', 'teageyear')

source("model_run.R")
source("model_run_retro.R")

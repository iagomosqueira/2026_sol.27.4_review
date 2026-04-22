# data.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/stock_weights/data.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(ss3om)
library(r4ss)
library(data.table)
library(ggplot2)

source("utilities.R")

# - LOAD data

wts <- data.table(SS_readwtatage('boot/data/ss3/wtatage.ss'))

# BUILD FLQuants
fqs <- buildFLwtatagess3(wts)

# SUBSET stock.wt (fleet 0), year <= 2024 & columns
dat <- copy(wts)[fleet == 0 & year <= 2024, c(1, 7:17)]

# RESHAPE
dat <- melt(dat, id.vars=1, measure.vars=as.character(0:10),
  variable.name = "age", value.name = "weight")

dat[, age := as.numeric(as.character(age))]

dat[, cohort := year - age]

# SAVE
save(dat, fqs, file = "data/data.rda", compress = "xz")

# PLOT: stock weight at age
taf.png("stock_weight_at_age.png")
ggplot(dat, aes(x=year, y=weight, group=age)) +
  geom_line(aes(colour=factor(age))) +
  geom_point(data=dat[age >= 2], aes(colour=factor(age)), size=1) +
  geom_smooth(data=dat[age >= 2], aes(colour=factor(age)), method="loess",
    linewidth=0.5, se=FALSE) +
  labs(x = "", y = "Weight (kg)", colour = "Age") +
  theme_bw() +
  theme(legend.position = "none")
dev.off()

# PLOT: stock weight at age
taf.png("stock_weight_at_age_2010.png")
ggplot(dat[year >= 2010], aes(x=year, y=weight, group=age)) +
  geom_line(aes(colour=factor(age))) +
  geom_point(data=dat[year >= 2010 & age >= 2], aes(colour=factor(age)), size=1) +
  geom_smooth(data=dat[year >= 2010 & age >= 2], aes(colour=factor(age)), 
    method="loess", linewidth=0.5, se=FALSE) +
  labs(x = "", y = "Weight (kg)", colour = "Age") +
  theme_bw() +
  theme(legend.position = "none")
Dev.off()

# PLOT: Changes in stock weight at age by year

library(ggrepel)

x <- fqs$stock.wt[, ac(2010:2024)]
x <- 100 * ((x[, -1] / x[,-15]) - 1)

taf.png("stock_weight_at_age_change.png")
ggplot(x[4:11,], aes(x=year, y=data, group=age)) +
  geom_line(aes(colour=factor(age))) +
  geom_hline(yintercept=0, linetype="dashed", colour="black") +
  geom_point(data=as.data.frame(x[4:11, '2024']), aes(colour=factor(age))) +
  geom_label_repel(data=as.data.frame(x[4:11, '2024']), aes(label=age, 
    fill=factor(age)), xlim=c(NA, 2025), nudge_x=0.5) +
  labs(x = "", y = "Inter-annual change in mean weight", colour = "Age") +
  theme_bw() +
  theme(legend.position = "none")
dev.off()

# PLOT: cohort growth

min <- 2003
max <- 2022

sub <- dat[cohort > min & cohort < max]

taf.png("cohort_growth.png")
ggplot(dat[cohort > min & cohort < max], aes(x=year, y=weight, group=cohort)) +
  geom_line(aes(colour=factor(cohort))) +
  geom_point(data=sub,
    aes(colour=factor(cohort)), size=1) +
  geom_point(data=sub[age >= 3],
    aes(colour=factor(cohort)), size=2) +
  geom_text_repel(data=sub[age == 0], aes(label=cohort)) +
  labs(x = "", y = "Weight (kg)", colour = "Series") +
  theme_bw() +
  theme(legend.position = "none")
dev.off()

# PLOT: differences in growth by decade

dat[, mean(weight), by = .(age)]

dat[, mean := mean(weight), by = .(age)]
dat[, diff := weight - mean]

ggplot(dat, aes(x=factor(age), y=diff, fill=factor(age))) +
  geom_boxplot() +
  labs(x = "Age", y = "Difference from mean weight (kg)") +
  theme_bw() +
  facet_wrap(~ (year - year %% 10), scales = "free_y")

# PLOT differences in growth within decades

dat[, dmean := mean(weight), by = .(age, round(year, -1) )]
dat[, ddiff := weight - dmean]

ggplot(dat, aes(x=factor(age), y=ddiff, fill=factor(age))) +
  geom_boxplot() +
  labs(x = "Age", y = "Difference from mean weight (kg)") +
  theme_bw() +
  facet_wrap(~ round(year, -1) , scales = "free_y")


# report.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/discards_reconstruct/report.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(ggplotFL)
library(r4ss)

# --- data

# LOAD data
load("data/data.rda")

discards(stk)[, ac(1957:2001)] <- NA

# PLOT total discards and landings
taf.png("discards_landings.png")
plot(stk, metrics=list(Landings=landings, Discards=discards))
dev.off()

# PLOT proportion of discards over catch
taf.png("discards_prop_catch.png")
ggplot((discards(stk) / catch(stk))[, ac(2002:2024)],
  aes(x=ISOdate(year,1,1), y=data)) +
  geom_col() +
  xlab("") + scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  ylab("Proportion of discards over catch")
dev.off()


# PLOT proportion of discards by age (1,2)
dt <- melt(data[year > 2001, .(year, pd1, pd2)], id.vars="year", value.name="data",
  variable.name="age")
dt[, age := ifelse(age == 'pd1', 1, 2)]

dt2 <- data[year > 2001, .(year, discards)]
dt2[, discards := discards / max(discards) * 100]

taf.png("discards_prop.png")
ggplot(dt, aes(x=ISOdate(year, 1, 1), y=data * 100)) +
  geom_bar(aes(fill=factor(age, levels=c(2,1))), position="stack", stat="identity") +
  geom_line(data=dt2, aes(y=discards), alpha=0.6) +
  geom_point(data=dt2, aes(y=discards), alpha=0.6) +
  ylim(0, 100) + ylab("Proportion of discards in weight") + xlab("") +
  labs(fill='Age')
dev.off()

# TODO:
ggplot(
  (discards.n(stk)[, ac(2002:2024)] * discards.wt(stk)[, ac(2002:2024)]) /
  (catch.n(stk)[, ac(2002:2024)] * catch.wt(stk)[, ac(2002:2024)]),
  aes(x=ISOdate(year,1,1), y=data, fill=factor(age))) +
  geom_col() +
  xlab("") + ylab("Discards")


# --- model

load("model/discards.rda")

mods <- mods[c('Landings', 'LandingsR12','LandingsR')]

# AIC, BIC, anova 

AIC(mods[['Landings']], mods[['LandingsR12']], mods[['LandingsR']])
BIC(mods[['Landings']], mods[['LandingsR12']], mods[['LandingsR']])

anova(mods[['Landings']], mods[['LandingsR12']])
anova(mods[['Landings']], mods[['LandingsR']])

# PLOT diagnostics

taf.png("landings_model_diagnostics.png")
glm_diag_panel(mods[['Landings']], data[year > 2001], 'year') + 
  plot_annotation(title = "Discards ~ Landings")
dev.off()

taf.png("landingsrec12_model_diagnostics.png")
glm_diag_panel(mods[['LandingsR12']], data[year > 2001], 'year') + 
  plot_annotation(title = "Discards ~ Landings + R1 + R2")
dev.off()

taf.png("landingsrec_model_diagnostics.png")
glm_diag_panel(mods[['LandingsR']], data[year > 2001], 'year') + 
  plot_annotation(title = "Discards ~ Landings + R12")
dev.off()

# PREDICTIONS

preds <- melt(res[, .(year, discards, predratio, mod00, mod12, modR)],
  id.vars="year", variable.name='model', value.name='data')

preds[model == 'Discards', data := ifelse(data == 0, NA, data)]

levels(preds$model) <- c("Discards", "Ratio 2001-2006", "Landings",
  "Landings + R1 + R2", "Landings + R")

# PLOT predictions

taf.png("discards_predictions.png")
ggplot() +
  # dots for special model (shown in every facet)
  geom_point(
    data = preds[model == "Discards"],
    aes(x = year, y = ifelse(data == 0, NA, data)),
    alpha=0.6) +
  # lines for all other models (faceted)
  geom_line(
    data = preds[model != "Discards"],
    aes(x = year, y = data, group = model, colour=model)) +
  labs(x= "", y = "Total discards (t)", colour = "")
dev.off()

# --- output

# LOAD output
load("output/output.rda")

# r4ss PLOTS
lapply(names(outs), function(x) {
  SS_plots(outs[[x]], uncertainty=T, png=T, forecastplot=TRUE, fitrange = TRUE, 
    parrows=5, parcols=4, showdev=FALSE, html = FALSE,
    dir=file.path("report", x))
})

# SELECT outputs to compare
names(outs) <- c("Landings", "Landings + R", "Ratio 2001-2006", "WGNSSK")

# plot SSB & Fbar
taf.png("SSBs.png", width=2200)
ggplot(FLQuants(lapply(outs, extractSSB)), aes(x=ISOdate(year,1,1), y=data, colour=qname)) +
  geom_line() +
  labs(x="", y="SSB (t)", colour="Model") +
  ylim(0, NA)
dev.off()

taf.png("Fbars.png", width=2200)
ggplot(FLQuants(lapply(outs, extractFbar)), aes(x=ISOdate(year,1,1), y=data, colour=qname)) +
  geom_line() +
  labs(x="", y="F", colour="Model") +
  ylim(0, NA)
dev.off()

#
dat <- rbindlist(lapply(outs, '[[', 'discard'), idcol='model')

gglot(dat, aes(x=Yr)) +
  geom_point(aes(y=Obs)) +
  geom_line(aes(y=Exp), alpha=0.5) +
  facet_wrap(~model)

# PLOT changes in SSB and F relative to wgnssk

dat <- runs[c("mod00_wgnssk", "modR_wgnssk", "predratio_wgnssk")]
names(dat) <- c("Landings", "Landings + R", "Ratio 2001-2006")

taf.png("SSBs_compare.png")
plot(dat, metrics=list(SSB =function(x) ssb(x) / ssb(runs$wgnssk),
  F=function(x) fbar(x) / fbar(runs$wgnssk))) +
  geom_hline(yintercept=1, lty=2)
dev.off()

# PLOT SSB againts SSB refpts

taf.png("SSBs_refpts.png", width=2200)
Reduce('+', Map(function(x, y, z) {
  plot(ssb(x)) +
    geom_hline(aes(yintercept=y$Btrigger), lty=2) +
    geom_hline(aes(yintercept=y$Blim), lty=3) +
    ggtitle(z) +
    ylim(0, 220000)
}, x=runs, y=refpts, z=c("Landings", "Landings + R", "Ratio 2001-2006", "WGNSSK")))
dev.off()

tab <- data.table("Reference point"=c("MSYB[trigger]", "F[MSY]", "B[lim]"),
  WGNSSK=c(refpts$wgnssk[c(1,2,3)]),
  Landings=c(refpts$mod00_wgnssk[c(1,2,3)]),
  "Landings + R"=c(refpts$modR_wgnssk[c(1,2,3)]),
  "Ratio 2001-2006"=c(refpts$predratio_wgnssk[c(1,2,3)]))

kable(tab, digits=3)

lapply(refpts, as.data.frame, drop=TRUE)
lapply(lapply(refpts, as.data.frame), t)

# WGNSSK 2021 AAP

load('boot/data/sol274_wgnssk_2021.rda')

preds2 <- rbind(preds, cbind(model="AAP", as.data.frame(discards(run_aap_2021), drop=TRUE)))

taf.png("discards_predictions_aap.png")
ggplot() +
  # dots for special model (shown in every facet)
  geom_point(
    data = preds2[model == "Discards"],
    aes(x = year, y = ifelse(data == 0, NA, data)),
    alpha=0.6) +
  # lines for all other models (faceted)
  geom_line(
    data = preds2[model != "Discards"],
    aes(x = year, y = data, group = model, colour=model)) +
  labs(x= "", y = "Total discards (t)", colour = "")
dev.off()

# RENDER
render("report.Rmd", output_dir="report",
  output_file="sol274_discard_reconstruction-WGNSSK_2026.pdf")

render("presentation.Rmd", output_dir="report",
  output_file="sol274_discard_reconstruction-WGNSSK_2026-presentation.pdf")


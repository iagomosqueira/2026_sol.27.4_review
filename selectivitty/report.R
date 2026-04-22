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

source("utilities.R")


# RMSE
SSplotJABBAres(out, subplots="cpue", print=TRUE,
  plotdir=file.path("report", model), filenameprefix = "cpue_")

SSplotJABBAres(out, subplots="age", print=TRUE,
  plotdir=file.path("report", model), filenameprefix = "age_")

# RETRO
taf.png("retro.png")
sspar(mfrow=c(2,1), plot.cex = 0.65)
SSplotRetro(retroSummary, add=T, subplots="SSB", forecast=FALSE)
SSplotRetro(retroSummary, add=T, subplots="F", forecast=FALSE)
dev.off()

mkdir("report/retro")
SSplotComparisons(retroSummary, endyrvec=retroSummary$endyrs + 0:-5,
  legendlabels=seq(2024, 2024 - 5), png = TRUE,
  plotdir=file.path("report", "retro"), uncertainty = T)

# XVAL
SSplotHCxval(retroSummary, print=TRUE, plotdir="report/")

# futs TEST
SSplotfutstest(out, print=TRUE, plotdir="report/")

SSplotfutstest(out, subplots="age", print=TRUE, plotdir="report/")







# -- data {{{

load("output/official.rda")

# Official vs. ICES landings

taf.png("official_ices_landings.png", width=2800)
ggplot(melt(official[, .(year, official, ices)], id.vars="year",
  variable.name="source", value.name="data", verbose=FALSE),
  aes(x=year, y=data)) +
  geom_col(aes(fill=source), position = "dodge") +
  ylab("Landings (t)") + xlab("") +
  guides(fill=guide_legend(nrow=1,byrow=TRUE)) +
  theme(legend.title = element_blank()) +
  scale_fill_discrete(labels=c(official='Official landings', ices='ICES'))
dev.off()

# Official landings prop by country

taf.png("official_landings.png")
ggplot(melt(official[, .(year, BE, DK, FR, DE, NL, UK, other)], id.vars="year",
  variable.name="country", value.name="data", verbose=FALSE),
  aes(x=year, y=data)) +
  geom_col(aes(fill=country)) + ylab("Landings (t)") + xlab("") +
  guides(fill=guide_legend(nrow=1,byrow=TRUE)) +
  theme(legend.title = element_blank())
dev.off()

# Catches and TACs

taf.png("official_catch.png")
ggplot(melt(official[, .(year, official, ices, tac)], id.vars="year",
  variable.name="category", value.name="data", verbose=FALSE),
  aes(x=year, y=data)) +
  geom_line(aes(colour=category), size=1) +
  ylab("Landings (t)") + xlab("") +
  guides(colour=guide_legend(nrow=1,byrow=TRUE)) +
  theme(legend.title = element_blank()) +
  ylim(c(0,NA)) +
  scale_colour_discrete(labels=c(official='Official landings', ices='ICES',
    tac="TAC"))
dev.off()

# }}}

# -- model {{{

load("output/output_sol.27.4_wgnnsk-2025.rda")

mets <- metrics(stk, list(Catch=catch, Landings=landings, Discards=discards))

mets$Discards[, ac(1957:2001)] <- NA

dy <- dims(stk)$maxyear

## C prop 20-18 cohort

taf.png("data_catches.png")
plot(mets) + ylab("Catch (t)") +
  theme(legend.position='bottom') +
  labs(fill='', colour='') +
  ylim(0, NA)
dev.off()
 
taf.png("data_catches_panel.png")
ggplot(mets, aes(x=year, y=data, colour=qname)) +
  geom_line() +
  ylab("Yield (t)") + xlab("") +
  theme(legend.position='bottom', legend.title = element_blank()) +
  ylim(0, NA)
dev.off()
 
taf.png("data_catch.png")
plot(mets$Catch) + ylab("Yield (t)") +
  theme(legend.position='bottom') +
  labs(fill='', colour='') +
  ylim(0, NA)
dev.off()
  
taf.png("data_catchnts.png")
plot(catch.n(stk)[-1]) + ylab("Catch (t)")
dev.off()
 
# Time-series of catch at age

taf.png("data_catchnb.png")
ggplot(catch.n(stk), aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data)), shape=21, na.rm=TRUE) +
  scale_size(range = c(0.1, 12)) +
  ylab(paste0("Catch (", units(catch.n(stk)),")")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Time-series of landings at age

taf.png("data_landingsn.png")
ggplot(landings.n(stk), aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data)), shape=21, na.rm=TRUE) +
  scale_size(range = c(0.1, 12)) +
  ylab(paste0("Landings (", units(catch.n(stk)),")")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Time-series of discards at age

taf.png("data_discardsn.png")
ggplot(window(discards.n(stk), start=2000),
  aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data)), shape=21, na.rm=TRUE) +
  scale_size(range = c(0.1, 12)) +
  ylab(paste0("Discards (", units(discards.n(stk)),")")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Time-series of discard proportion at age

taf.png("data_discardsp.png")
ggplot(window(discards.n(stk), start=2002) /
  window(catch.n(stk), start=2002),
  aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data), fill=data), shape=21, na.rm=TRUE) +
  scale_size_continuous(range = c(0.1, 8), name="p") +
  scale_fill_gradient(low = "white", high = "gray50", name="p", guide = "legend") +
  ylab(paste0("Proportion discarded")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Discards ratio

taf.png("data_discardratio.png")
ggplot(window(discards.n(stk) / catch.n(stk), start=2002),
  aes(x=year, y=data, colour=factor(age))) + geom_line() +
  geom_label_repel(data=as.data.frame((discards.n(stk) /
    catch.n(stk))[, ac(dy)]),
    aes(label=age), colour="black") +
  guides(colour=FALSE) + ylab("Discard ratio (discards/catch)") +
  xlab("") + ylab("")
dev.off()

# Time series of catch by cohort

ggplot(as.data.frame(FLCohort(catch.n(stk))), aes(x=cohort, y=data, group=age)) +
  geom_line(aes(colour=factor(age))) +
  xlab("Cohort") + ylab("Catch (thousands)") +
  theme(legend.position="none")
dev.off()

taf.png("data_catchcoh2.png")
ggplot(as.data.frame(FLCohort(catch.n(stk))), aes(x=cohort, y=data, group=age)) +
  geom_line(aes(colour=factor(age))) +
  facet_grid(age~., scales="free") +
  xlab("") + ylab("Catch (thousands)") +
  theme(legend.position="none")
dev.off()

# WAA

taf.png("data_stockwt.png")
ggplot(stock.wt(stk), aes(x=year, y=data * 1000, group=age, colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_smooth(se=FALSE, linewidth=0.5, alpha=0.2) +
  geom_text_repel(data=as.data.frame(stock.wt(stk)[, ac(1957)]),
    aes(x=year - 1, label=age), colour="black") +
  geom_text_repel(data=as.data.frame(stock.wt(stk)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none") +
  geom_vline(xintercept=dy - 9, alpha=0.5) +
  ylim(0, 800) +
  ggtitle("Stock weight-at-age (Q2)")
dev.off()

taf.png("data_stockwt_recent.png")
ggplot(tail(stock.wt(stk), 15), aes(x=year, y=data * 1000, group=age, colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_smooth(se=FALSE, linewidth=0.5, alpha=0.2) +
  geom_text_repel(data=as.data.frame(stock.wt(stk)[, ac(2009)]),
    aes(x=year - 1, label=age), colour="black") +
  geom_text_repel(data=as.data.frame(stock.wt(stk)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none") +
  ylim(0, 700) +
  ggtitle("Stock weight-at-age (Q2)")
dev.off()

taf.png("data_catchwt.png")
ggplot(catch.wt(stk), aes(x=year, y=data * 1000, group=age, colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_smooth(se=FALSE, linewidth=0.5, alpha=0.2) +
  geom_text_repel(data=as.data.frame(catch.wt(stk)[, ac(1957)]),
    aes(x=year - 1, label=age), colour="black") +
  geom_text_repel(data=as.data.frame(catch.wt(stk)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none") +
  geom_vline(xintercept=2014, alpha=0.5) +
  ylim(0, 800) +
  ggtitle("Catch weight-at-age")
dev.off()

taf.png("data_landingswt.png")
ggplot(landings.wt(stk), aes(x=year, y=data * 1000, group=age,
  colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_smooth(se=FALSE, linewidth=0.5, alpha=0.2) +
  geom_text_repel(data=as.data.frame(landings.wt(stk)[, ac(1957)]),
    aes(x=year - 1, label=age), colour="black") +
  geom_text_repel(data=as.data.frame(landings.wt(stk)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none") +
  geom_vline(xintercept=2014, alpha=0.5) +
  ylim(0, 800) +
  ggtitle("Landings weight-at-age")
dev.off()

taf.png("data_discardswt.png")
ggplot(discards.wt(stk)[, ac(2002:dy)], aes(x=year, y=data * 1000, group=age,
  colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
#  geom_smooth(se=FALSE, linewidth=0.5, alpha=0.2) +
  geom_text_repel(data=as.data.frame(discards.wt(stk)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none") +
  geom_vline(xintercept=2014, alpha=0.5)
dev.off()

dat <- FLQuants(Landings=landings.wt(stk), Discards=discards.wt(stk))
dat$Discards[, ac(1957:2001)] <- NA

taf.png("data_landiswt.png", height=800)
ggplot(dat, aes(x=year, y=data * 1000, group=age,
  colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_text_repel(data=as.data.frame(discards.wt(stk)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none") +
  facet_grid(.~qname)
dev.off()

dat <- window(FLQuants(Landings=landings.wt(stk), Discards=discards.wt(stk),
  Stock=stock.wt(stk)), start=2010)

taf.png("data_weights_recent.png", height=800)
ggplot(dat, aes(x=year, y=data * 1000, group=age,
  colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_text_repel(data=as.data.frame(discards.wt(stk)[, ac(dy)]),
    aes(x=2010, label=age), colour="black") +
  theme(legend.position="none") +
  facet_grid(.~qname)
dev.off()

# Catch COHCORR
taf.png("data_catchn_corr.png")
cohcorrplot(catch.n(stk)[-1])
dev.off()

# - indices

load("data/indices.rda")

taf.png("indices_compare.png", height=800)
plot(indices)
dev.off()

# }}}

# -- model_forecast {{{

library(ss3om)

load('output/output_sol.27.4_wgnnsk-2025.rda')

fut <- futs$advice

dimnames(refpts)$params[1] <- "Btrigger / Bpa"

# MODEL, ADVICE and FORECAST year

dy <- dims(run)$maxyear
ay <- dy + 1
fy <- ay + 1

# GRAPHICAL elements

box <- annotate("rect", xmin = ay - 0.5, xmax = fy + 1, ymin=-Inf, ymax=Inf,
  fill="lightgrey", alpha = .2)

vline <- geom_vline(xintercept=dy, linetype=1, colour="#464A54", alpha=0.3)

# SELEX

taf.png("catchsel_periods.png")
ggplot(FLQuants(Y3=yearMeans(catch.sel(run)[, ac(seq(dy-2, dy))]),
  Y5=yearMeans(catch.sel(run)[, ac(seq(dy-4, dy))])),
  aes(x=age, y=data, colour=qname)) +
  geom_line()
dev.off()

asel <- data.table(out$ageselex)[Yr %in% seq(1957, 2024) & Factor == 'Asel',]

asel <- melt(asel, id.vars=c('Fleet', 'Yr'), measure.vars=ac(seq(0, 10)),
  value.name='data', variable.name="age")

#
map <- c("Landings", 'BTS', 'Coast', 'Discards')
asel[, label:=map[Fleet]]

taf.png("selex_ss3.png")
ggplot(asel[Fleet %in% c(1,4) & Yr > 2015],
  aes(x=as.numeric(age), y=data, colour=factor(label))) +
  geom_line() + facet_wrap(~Yr) +
  ylab("Selectivity") + xlab("") +
  labs(color='')
dev.off()


inp <- FLQuants(catch.sel=catch.sel(fut)[, ac(2019:2025)],
  landings.sel=landings.sel(fut)[, ac(2019:2025)],
  discards.sel=discards.sel(fut)[, ac(2019:2025)])

taf.png("model_selex.png")
ggplot(inp, aes(x=age, y=data, colour=qname)) +
  geom_line() + facet_wrap(~year) + xlab("age") + ylab("Selectivity")
dev.off()

# WT

taf.png("forecast_stockwt.png")

dat <- FLQuants(c(lapply(setNames(c(3, 5, 10), nm=paste('Mean', c(3,5,10))), 
  function(x) yearMeans(window(stock.wt(run), start=-x))),
  divide(window(stock.wt(run), start=-10), 2)))

ggplot(dat, aes(x=age, y=data, group=qname, colour=factor(qname))) +
  geom_line()

# FIT

# BASIS

# FWD run

probs <- c(0.10, 0.25, 0.50, 0.75, 0.90)

taf.png("model_fwd.png")
(plot(window(ssb(futs$advice), end=fy + 1), probs=probs) +
  geom_flpar(data=refpts[c(1, 3)], x=1961, colour=c("black", "red"),
    linetype=c(3,1)) +
  vline + ylab("SSB (t)") + ylim(c(0, NA))) /
(plot(window(fbar(futs$advice), end=fy-1), probs=probs) + vline +
  geom_flpar(data=refpts[c(2, 5, 6)], x=1961, colour=c("black", "red", "black"),
    linetype=c(1,1, 3)) +
    vline + ylab("F (2-6)") + ylim(c(0, NA)))
dev.off()


fill <- c("#21313E","#214C57","#1F6969","#2A8674","#4AA377","#78BF73",
  "#AFD96C","#EFEE69")
msb <- (stock.n(futs$advice) * stock.wt(futs$advice) * mat(futs$advice))[-c(1,2,3),]

taf.png("model_fwd_propssb.png")
ggplot(msb %/% quantSums(msb), aes(x=year, y=data, fill=as.factor(age))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("") + ylab("Proportion of SSB") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.title=element_blank(), legend.position="right") +
  guides(fill = guide_legend(nrow = 8)) +
  geom_vline(xintercept=dy, alpha=0.5)
dev.off()

fill <- viridis::viridis(11)
msb <- (stock.n(fut) * stock.wt(fut))

taf.png("model_fwd_proptsb.png")
ggplot(msb %/% quantSums(msb), aes(x=year, y=data, fill=as.factor(age))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("") + ylab("Proportion of TSB") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.title=element_blank(), legend.position="right") +
  guides(fill = guide_legend(nrow = 8)) +
  geom_vline(xintercept=dy, alpha=0.5)
dev.off()

# PLOT prop by cohort in catch

fill <- viridis::viridis(19)
fill[11] <- '#ffa500'

dat <- (catch.n(futs[[1]]) * catch.wt(futs[[1]])) %/% catch(futs[[1]])

taf.png("model_fwd_propc_cohort.png")
ggplot(dat[, ac(2018:2026)], aes(x=as.factor(year), y=data, fill=as.factor(cohort))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("Year") + ylab("Proportion of catch by cohort") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.position="right") + labs(fill="Cohort")
dev.off()

# PLOT prop by cohort in ssb

dat <- (stock.n(futs[[1]]) * stock.wt(futs[[1]]) * mat(futs[[1]])) %/%
  ssb(futs[[1]])

taf.png("model_fwd_propssb_cohort.png")
ggplot(dat[, ac(2018:2026)], aes(x=as.factor(year), y=data, fill=as.factor(cohort))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("Year") + ylab("Proportion of SSB by cohort") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.position="right") + labs(fill="Cohort")
dev.off()

# }}}

# TODO: COMPARE weights and estimates

load("boot/data/advice_2024.rda")

futwts <- FLQuants('2024'=stock.wt(advice)[3:10, ac(2024:2026)],
  '2025'=stock.wt(futs$advice)[3:10, ac(2024:2026)])

ggplot(futwts, aes(x=factor(age), y=data, group=qname)) +
  geom_col(aes(fill=qname), position = position_dodge(), alpha = 0.75) +
  facet_wrap(~year) +
  ylab('Weight-at-age (kg)') + xlab("Age")

futwts <- FLQuants('Forecast 2024'=stock.wt(advice)[4:11, ac(2024)],
  'Assessment 2025'=stock.wt(futs$advice)[4:11, ac(2024)])

taf.png("compare_wtatages_stk")
ggplot(futwts, aes(x=as.factor(age), y=data, group=qname)) +
  geom_col(aes(fill=qname), position = position_dodge(), alpha = 0.75) +
  facet_wrap(~year) +
  ylab('Weight-at-age (kg)') + xlab("Age") +
  labs(fill='')
dev.off()

futns <- FLQuants('Forecast 2024'=stock.n(advice)[4:11, ac(2024)],
  'Assessment 2025'=stock.n(futs$advice)[4:11, ac(2024)])

taf.png("compare_ns_stk")
ggplot(futns, aes(x=as.factor(age), y=data, group=qname)) +
  geom_col(aes(fill=qname), position = position_dodge(), alpha = 0.75) +
  facet_wrap(~year) +
  ylab('Abundance (1000s)') + xlab("Age") +
  labs(fill='')
dev.off()

# compare {{{

library(r4ss)

waa24 <- data.table(SS_readwtatage("boot/initial/model/ss3_2024/wtatage.ss"))
setorder(waa24, fleet, year)

waa25 <- data.table(SS_readwtatage("boot/initial/model/ss3/wtatage.ss"))
setorder(waa25, fleet, year)

# -2 (mat*fec)

dat <- rbindlist(list('2024' = waa24[fleet == -2], '2025' = waa25[fleet == -2]),
  idcol='set')

dat <- melt(dat, id.vars=1:7, measure.vars=8:18, variable.name = "age",
  value.name = "data")

taf.png("compare_wtatagess_mat")
ggplot(dat[year >= 1957,], aes(x=year, y=data, group=set, colour=set)) +
  geom_line() +
  ggtitle("mat * fec") +
  facet_wrap(~age)
dev.off()

# -1 (stock.wt 2)

dat <- rbindlist(list('2024' = waa24[fleet == -1], '2025' = waa25[fleet == -1]),
  idcol='set')

dat <- melt(dat, id.vars=1:7, measure.vars=8:18, variable.name = "age",
  value.name = "data")

taf.png("compare_wtatagess_swt")
ggplot(dat[year >= 1957,], aes(x=year, y=data, group=set, colour=set)) +
  geom_line() +
  ggtitle("stock.wt") +
  facet_wrap(~age)
dev.off()

# 0 (stock.wt 1)

dat <- rbindlist(list('2024' = waa24[fleet == 0], '2025' = waa25[fleet == 0]),
  idcol='set')

dat <- melt(dat, id.vars=1:7, measure.vars=8:18, variable.name = "age",
  value.name = "data")

ggplot(dat[year >= 1957,], aes(x=year, y=data, group=set, colour=set)) +
  geom_line() +
  ggtitle("stock.wt 2") +
  facet_wrap(~age)

# 1 (landings.wt)

dat <- rbindlist(list('2024' = waa24[fleet == 1], '2025' = waa25[fleet == 1]),
  idcol='set')

dat <- melt(dat, id.vars=1:7, measure.vars=8:18, variable.name = "age",
  value.name = "data")

taf.png("compare_wtatagess_lwt")
ggplot(dat[year >= 1957,], aes(x=year, y=data, group=set, colour=set)) +
  geom_line() +
  ggtitle("landings.wt") +
  facet_wrap(~age)
  facet_wrap(~age)
dev.off()

# 2 (BTS)

dat <- rbindlist(list('2024' = waa24[fleet == 2], '2025' = waa25[fleet == 2]),
  idcol='set')

dat <- melt(dat, id.vars=1:7, measure.vars=8:18, variable.name = "age",
  value.name = "data")

ggplot(dat[year >= 1957,], aes(x=year, y=data, group=set, colour=set)) +
  geom_line() +
  ggtitle("BTS") +
  facet_wrap(~age)

# 3 (COAST)

dat <- rbindlist(list('2024' = waa24[fleet == 3], '2025' = waa25[fleet == 3]),
  idcol='set')

dat <- melt(dat, id.vars=1:7, measure.vars=8:18, variable.name = "age",
  value.name = "data")

ggplot(dat[year >= 1957,], aes(x=year, y=data, group=set, colour=set)) +
  geom_line() +
  ggtitle("COAST") +
  facet_wrap(~age)

# 4 (discards.wt)

dat <- rbindlist(list('2024' = waa24[fleet == 4], '2025' = waa25[fleet == 4]),
  idcol='set')

dat <- melt(dat, id.vars=1:7, measure.vars=8:18, variable.name = "age",
  value.name = "data")

taf.png("compare_wtatagess_dwt")
ggplot(dat[year >= 1957,], aes(x=year, y=data, group=set, colour=set)) +
  geom_line() +
  ggtitle("discards.wt") +
  facet_wrap(~age)
dev.off()

# }}}

# -- compare {{{


# - indices

ind24 <- mget(load('boot/data/indices.rda'))$indices

# - model

load('boot/data/wgnssk_2024.rda')

wgnssk <- run

load("model/model.rda")

taf.png("stocks_compare.png")
plot(FLStocks(WGNSSK=wgnssk, NEW=run)) +
  geom_line(linewidth=1, alpha=0.5)
dev.off()

# }}}

# TODO LOAD forecasts 24 & 25

dat <- FLQuants(WGNSSK2024=stock.wt(proj24)[, ac(2023:2026)],
  EWGNSSK2025=stock.wt(proj25)[, ac(2023:2026)])

taf.png("change_wt.png")
ggplot(dat, aes(x=age, y=data)) +
  geom_line(aes(colour=qname)) +
  facet_wrap(~year) +
  ylab("weight (kg)") + xlab("")
dev.off()

dat <- FLQuants(WGNSSK2024=stock.n(proj24)[, ac(2023:2026)],
  WGNSSK2025=stock.n(proj25)[, ac(2023:2026)])

taf.png("change_n.png")
ggplot(dat, aes(x=age, y=data)) +
  geom_line(aes(colour=qname)) +
  facet_wrap(~year) +
  ylab("Numbers (1000s)") + xlab("")
dev.off()


# -- model {{{

# LOAD new results

load("output/output_sol.27.4_wgnnsk-2025.rda")

library(r4ss)
library(ss3diags)

clean("report/ss3")
mkdir("report/ss3")

SS_plots(out, uncertainty=T, png=T, forecastplot=TRUE, fitrange = TRUE, 
  parrows=5, parcols=4, showdev=FALSE, html = FALSE,
  printfolder = "../../report/ss3")

# OSA
taf.png("osa_fleet.png")
plot(osa[[1]], 1, main='Fleet')
dev.off()

taf.png("osa_bts.png")
plot(osa[[2]], 1, main='BTS')
dev.off()

taf.png("osa_coast.png")
plot(osa[[3]], 1, main='Coast')
dev.off()

taf.png("osa_discards.png")
plot(osa[[4]], 1, main='Discards')
dev.off()

# RESIDUALS
# catch.n
dat <- FLQuants(
  Landings=residuals(landings.n(stk) + 1, landings.n(run) + 1),
  Discards=residuals(discards.n(stk) + 1, discards.n(run) + 1)[, ac(2002:dy)])

taf.png("residuals_catches.png", width=2200)
print(ggplot(dat, aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data), fill=as.factor(sign(data))),
    shape=21, na.rm=TRUE) +
  ylab("Log residuals") + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1)) +
  facet_grid(qname~., scales='free'))
dev.off()

  # catch
  dat <- FLQuants(
    Landings=residuals(landings(stk), landings(run)),
    Discards=residuals(discards(stk), discards(run))[, ac(2002:dy)])

  taf.png("residuals_catch.png", height=600)
  print(ggplot(dat, aes(x=year, y=qname)) +
    geom_point(aes(size=abs(data), fill=as.factor(sign(data))),
      shape=21, na.rm=TRUE) +
    ylab("Log residuals") + xlab("") +
    theme(legend.title=element_blank(), legend.position="bottom") +
    guides(size = guide_legend(nrow = 1)))
  dev.off()

  # cpue biomass
  taf.png("residuals_cpuebiomass.png", width=2200)
  print(ggplot(data.table(out$cpue), aes(x=Yr, y=Fleet_name)) +
    geom_point(aes(size=abs(Dev), fill=as.factor(sign(Dev))),
      shape=21, na.rm=TRUE) +
    scale_size(range = c(0.1, 8)) +
    ylab("Log residuals") + xlab("") +
    theme(legend.title=element_blank(), legend.position="bottom") +
    guides(size = guide_legend(nrow = 1)))
  dev.off()

 # RESIDUALS
 # catch.n
 dat <- FLQuants(
  Landings=residuals(landings.n(stk) + 1, landings.n(run) + 1),
  Discards=residuals(discards.n(stk) + 1, discards.n(run) + 1)[, ac(2002:dy)])

 taf.png("residuals_catches.png", width=2200)
 print(ggplot(dat, aes(x=year, y=as.factor(age))) +
   geom_point(aes(size=abs(data), fill=as.factor(sign(data))),
     shape=21, na.rm=TRUE) +
   ylab("Log residuals") + xlab("") +
   theme(legend.title=element_blank(), legend.position="bottom") +
   guides(size = guide_legend(nrow = 1)) +
   facet_grid(qname~., scales='free'))
 dev.off()

# catch
dat <- FLQuants(
  Landings=residuals(landings(stk), landings(run)),
  Discards=residuals(discards(stk), discards(run))[, ac(2002:dy)])

taf.png("residuals_catch.png", height=600)
print(ggplot(dat, aes(x=year, y=qname)) +
  geom_point(aes(size=abs(data), fill=as.factor(sign(data))),
    shape=21, na.rm=TRUE) +
  ylab("Log residuals") + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1)))
dev.off()

# cpue biomass
taf.png("residuals_cpuebiomass.png", width=2200)
print(ggplot(data.table(out$cpue), aes(x=Yr, y=Fleet_name)) +
  geom_point(aes(size=abs(Dev), fill=as.factor(sign(Dev))),
    shape=21, na.rm=TRUE) +
  scale_size(range = c(0.1, 8)) +
  ylab("Log residuals") + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1)))
dev.off()

# discardsa ratio

ggplot((discards(run) / catch(run))[, ac(2002:dy)],
  aes(x=year, y=data)) + geom_col() +
  ylab("Proportion discarded") + xlab("") +
  scale_y_continuous(labels = scales::percent, lim=c(0, 1))


# RMSE
SSplotJABBAres(out, subplots="cpue", print=TRUE,
  plotdir=file.path("report", model), filenameprefix = "cpue_")

SSplotJABBAres(out, subplots="age", print=TRUE,
  plotdir=file.path("report", model), filenameprefix = "age_")

# RETRO
taf.png("retro.png")
sspar(mfrow=c(2,1), plot.cex = 0.65)
SSplotRetro(retroSummary, add=T, subplots="SSB", forecast=FALSE)
SSplotRetro(retroSummary, add=T, subplots="F", forecast=FALSE)
dev.off()

mkdir("report/retro")
SSplotComparisons(retroSummary, endyrvec=retroSummary$endyrs + 0:-5,
  legendlabels=seq(2024, 2024 - 5), png = TRUE,
  plotdir=file.path("report", "retro"), uncertainty = T)

# XVAL
SSplotHCxval(retroSummary, print=TRUE, plotdir="report/")

# futs TEST
SSplotfutstest(out, print=TRUE, plotdir="report/")

SSplotfutstest(out, subplots="age", print=TRUE, plotdir="report/")

# stock
taf.png("stock.png")
plot(metrics(run)[c("Catch", "Rec", "SSB", "F")]) +
  ylim(0, NA)
dev.off()

# proportion SSB at age
fill <- c("#21313E","#214C57","#1F6969","#2A8674","#4AA377","#78BF73",
  "#AFD96C","#EFEE69")
msb <- (stock.n(run) * stock.wt(run) * mat(run))[-c(1,2,3),]

taf.png("model_propssb.png")
ggplot(msb %/% quantSums(msb), aes(x=year, y=data, fill=as.factor(age))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("") + ylab("Proportion of SSB") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.title=element_blank(), legend.position="right") +
  guides(fill = guide_legend(nrow = 8))
dev.off()

fill <- viridis::viridis(11)
msb <- (stock.n(run) * stock.wt(run))

taf.png("model_propbiom.png")
ggplot(msb %/% quantSums(msb), aes(x=year, y=data, fill=as.factor(age))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("") + ylab("Proportion of SSB") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.title=element_blank(), legend.position="right") +
  guides(fill = guide_legend(nrow = 8))
dev.off()

# TSB and SSB

taf.png("ssbtsb.png")
ggplot(metrics(run, list(TSB=tsb, SSB=ssb)), aes(x=year, y=data, colour=qname)) +
  geom_line(size=1) + xlab("") + ylab("Biomass (t)") +
  theme(legend.title=element_blank())
dev.off()

taf.png("vulbiom.png")
ggplot(metrics(run, list(TSB=tsb, SSB=ssb, VB=vb)),
  aes(x=year, y=data, group=qname, colour=qname)) +
  geom_line() + xlab("") + ylab("Biomass (t)") +
  theme(legend.title=element_blank())
dev.off()

# Fs

taf.png("model_fatage.png")
ggplot(harvest(run), aes(x=year, y=data, colour=factor(age))) +
  geom_line() + facet_wrap(~age) + xlab("") + ylab("F") +
  theme(legend.position="none")
dev.off()

# STK

taf.png("model_stock.png", width=2200)
plot(run)
dev.off()

# REC

rec0gm <- exp(mean(log(window(stock.n(run)["0",], end=-3))))

taf.png("model_rec.png", width=2200)
plot(rec(run)) + ylim(0, NA) +
  geom_hline(yintercept=rec0gm, linetype=2) +
  ylab("Age 0 recruits (thousands)")
dev.off()

# Productivity

plot(log(rec(run)[,-1] / ssb(run)[,-dims(run)$year])) +
  geom_point(size=3, colour='white') +
  geom_point(size=2, shape=1) +
  ylab("log(recruits / SSB)")

# REC CVs

dat <- data.table(year=1990:dy,
  cv=data.table(out$derived_quants)[108:141, StdDev / Value])

taf.png("model_reccv.png")
ggplot(dat[year < dy], aes(x=year, y=cv)) +
  geom_point() +
  geom_line() +
  xlab("") + ylab("CV(R)") + ylim(0,NA)
dev.off()

# F vs. reference points

load('boot/data/refpts.rda')
metF <- extractFbar(out)[, ac(1958:dy)]

taf.png("refpts_fbaref.png")
plot(metF) +
  geom_hline(yintercept=c(refpts$Flim), color="red", linewidth=0.25)+
    geom_text(x=2022+1, y=c(refpts$Flim + 0.01), label=expression(F[lim])) +
    geom_hline(yintercept=c(refpts$Fpa), linetype=3) +
    geom_text(x=2022+1, y=c(refpts$Fpa + 0.01), label=expression(F[PA])) +
  geom_hline(yintercept=c(refpts$Fmsy), linetype=2) +
    geom_text(x=2022+1, y=c(refpts$Fmsy - 0.01), label=expression(F[MSY])) +
  ylim(c(0,NA)) + ylab("F (ages 2-6)")
dev.off()

# SSB vs. reference points

metSB <- extractSSB(out)[, ac(1958:dy)]

taf.png("refpts_ssbref.png")
plot(metSB) +
  geom_hline(yintercept=c(refpts$Bpa), color="red", linewidth=0.25) +
    geom_text(x=1957, y=c(refpts$Bpa - 3500), label=expression(B[PA]), hjust="inward") +
  geom_hline(yintercept=c(refpts$Btrigger), linetype=3) +
    geom_text(x=1957, y=c(refpts$Btrigger + 3500), 
      label=expression(MSYB[trigger]), hjust="inward") +
  geom_hline(yintercept=c(refpts$Blim), linetype=2) +
    geom_text(x=1957, y=c(refpts$Blim + 3500), label=expression(B[lim]),
      hjust="inward") +
  ylim(c(0,NA)) + ylab("SSB (tonnes)")
dev.off()

# Stock status

library(FLRef)

taf.png("stock_status.png")
plotAdvice(run, refpts)
dev.off()

taf.png("stock_rps.png", height=1800)
plot(metrics(run, metrics=list('Spawning~biomass' = ssb,
  'Fishing~mortality' = fbar, 'Recruitment' = rec, 'Catch' = catch))) +
  xlab("Year") + ylim(0, NA) +
  geom_flpar(data=FLPars('Spawning~biomass'=FLPar(Blim=refpts$Blim,),
    'Fishing~mortality'=FLPar(Flim=refpts$Flim)), x=c(1963), colour="red",
    linetype=1) +
  geom_flpar(data=FLPars('Spawning~biomass'=FLPar(Btrigger=refpts$Btrigger),
    'Fishing~mortality'=FLPar(FMSY=refpts$Fmsy)), x=c(1956), colour='orange',
    linetype=2) +
  geom_line(linewidth=1)
dev.off()

# Uncertainty

mvln <- SSdeltaMVLN(out, mc=1000, catch.type='Exp', plot=FALSE, verbose=FALSE)

uncMetrics <- FLQuants(lapply(setNames(nm=mvln$quants), function(x) {
  df <- mvln$kb[, c('year', 'iter', x)]
  colnames(df)[3] <- 'data'
  as.FLQuant(df)
  }
))

uncert <- ssmvln(out, mc = 1000)

umetrics <- FLQuants(lapply(setNames(c(7, 8, 9), nm=c("SSB", "F", "Recr")), 
  function(x) {
    dat <- uncert[[1]][, c(1, 4, x)]
    names(dat)[3] <- 'data'
    as.FLQuant(dat)
  }))

taf.png("uncertmetrics.png")
plot(umetrics) + ylim(0, NA)
dev.off()

# SRR

dat <- data.table(model.frame(FLQuants(Recruitment=rec(as.FLSR(run)),
  SSB=ssb(as.FLSR(run)))))
dat[year %in% c(1958, seq(1960, dy, by=5), dy), label:=year]

taf.png("model_recssb.png")
ggplot(dat, aes(x=SSB, y=Recruitment, label=label)) + geom_path(alpha=0.3) +
  geom_point() +
  geom_label_repel(data=dat,
    fill=c("#bfcf9f", rep("white", dim(dat)[1] - 2), "#c03839"),
    colour=c(rep(1, dim(dat)[1] - 1), "white"), alpha=0.8) +
  xlab("SSB (t)") + ylab("Recruitment (thousands)")
dev.off()

# SELEX
sel <- data.table(out$ageselex)
dat <- melt(sel[Factor=='Asel' & Fleet %in% 1,], id.vars=1:7,
    variable.name="age", value.name="data")
  
  yrs <- c(1960, 1970, 1980, 1990, 2000, 2005, 2010, 2012:dy)
  
  taf.png("landings_selex.png")
  print(ggplot(dat[Yr %in% yrs], aes(x=as.integer(age), y=data)) +
    facet_wrap(~Yr) +
    geom_line(aes(colour=factor(round(Yr / 10)))) +
    theme(legend.position='none') +
    ylab("Selectivity") + xlab("Age"))
  dev.off()
 
# SELEX

dat <- melt(sel[Factor=='Asel' & Fleet == 1,], id.vars=1:7, variable.name="age",
  value.name="data")

taf.png("catch_selex.png")
ggplot(dat[Yr %in% 2013:2024], aes(x=as.integer(age), y=data)) +
  facet_wrap(~Yr) +
  geom_line(aes(colour=factor(Yr))) +
  theme(legend.position='none') +
  ylab("Selectivity") + xlab("Age")
dev.off()

# }}}

# NL {{{
taf.png("NL_stock.png")
plot(metrics(run, metrics=list('Paaiende~biomassa' = ssb,
  'Visserijsterfte' = fbar, 'Aanwas' = rec, 'Vangsten' = catch))) +
  xlab("Jaren") + ylim(0, NA)
dev.off()

taf.png("NL_stock_rps.png", height=1800)
plot(metrics(run, metrics=list('Paaiende~biomassa' = ssb,
  'Visserijsterfte' = fbar, 'Aanwas' = rec, 'Vangsten' = catch))) +
  xlab("Jaren") + ylim(0, NA) +
  geom_flpar(data=FLPars('Paaiende~biomassa'=FLPar(Blim=refpts$Blim,),
    'Visserijsterfte'=FLPar(Flim=refpts$Flim)), x=c(1963), colour="red",
    linetype=1) +
  geom_flpar(data=FLPars('Paaiende~biomassa'=FLPar(Btrigger=refpts$Btrigger),
    'Visserijsterfte'=FLPar(FMSY=refpts$Fmsy)), x=c(1956), colour='orange',
    linetype=2) +
  geom_line(linewidth=1)
dev.off()

taf.png("NL_stock_rps_2.png")
plot(metrics(run, metrics=list('Paaiende~biomassa' = ssb,
  'Visserijsterfte' = fbar, 'Aanwas' = rec, 'Vangsten' = catch))) +
  xlab("Jaren") + ylim(0, NA) +
  geom_flpar(data=FLPars('Paaiende~biomassa'=FLPar(Blim=refpts$Blim,),
    'Visserijsterfte'=FLPar(Flim=refpts$Flim)), x=c(1957), colour="red",
    linetype=1) +
  geom_flpar(data=FLPars('Paaiende~biomassa'=FLPar(Btrigger=refpts$Btrigger),
    'Visserijsterfte'=FLPar(FMSY=refpts$Fmsy)), x=c(1980), colour='orange',
    linetype=2) +
  geom_line(linewidth=1) +
  facet_wrap(~qname, scales='free', labeller=label_parsed)
dev.off()

taf.png("NL_ssb.png")
plot(ssb(run)) + ylim(0, NA) + ylab('Paaiende~biomassa (t)') +
  xlab("Jaren") + geom_line(linewidth=1) 
dev.off()

# }}}

# RENDER

render("presentation_assessment.Rmd", output_dir="report",
  output_file="sol.27.4_assessment_presentation.pdf")

render("presentation_forecast.Rmd", output_dir="report",
  output_file="sol.27.4_forecast_presentation.pdf")

render("report.Rmd", output_dir="report",
  output_file="WGNSSK_2025_Section-16_Sole_in_Subarea_4.docx")

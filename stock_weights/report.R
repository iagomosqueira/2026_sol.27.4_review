# report.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/stock_weights/report.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(ggplotFL)
library(ss3om)
library(ss3diags)

load("output/output.rda")

# PLOT: proportion of SSB by age

run <- stks[[1]]

# proportion SSB at age
fill <- rev(c("#21313E","#214C57","#1F6969","#2A8674","#4AA377","#78BF73",
  "#AFD96C","#EFEE69"))
msb <- (stock.n(run) * stock.wt(run) * mat(run))[-c(1,2,3),]

taf.png("model_propssb.png")
ggplot(msb %/% quantSums(msb), aes(x=year, y=data, fill=as.factor(age))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("") + ylab("Proportion of SSB") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.title=element_blank(), legend.position="right") +
  guides(fill = guide_legend(nrow = 8))
dev.off()

# SS3 PLOTs
#lapply(outs, SS_plots, uncertainty=T, png=T, forecastplot=TRUE, fitrange = TRUE, 
#  parrows=5, parcols=4, showdev=FALSE, html = FALSE)

# PLOT: compare stocks
taf.png("stock_comparison.png")
plot(stks, metrics=list(SSB=ssb, F=fbar))
dev.off()

# PLOT:  compare SSB
taf.png("ssb_comparison.png")
plot(stks, metrics=list(SSB=ssb))
dev.off()

# PLOT:

# SSplotComparisons(osums, legendlabels=names(outs), print = T,
#  plotdir = file.path("report", "comp"))

# PLOT: 3-year average stock weights at age
futs <- FLQuants(lapply(rets[c(1,2,4)], function(x) ybind(FLQuants(lapply(x, function(y)
  yearMeans(stock.wt(y)[4:11, seq(dim(y)[2] - 4, dim(y)[2])]))))))

taf.png("stock_weights_averages.png")
ggplot(futs, aes(x=year, y=data, colour=factor(age))) + 
  geom_line() +
  facet_grid(. ~ qname) +
  geom_label(aes(label = ifelse(year==2019, age, NA))) +
  theme_bw() +
  labs(x="Last year of 3-year average", y="Mean weight at age (kg)", colour="Model") +
  theme(legend.position="none")
dev.off()

# PLOT: retrospective patterns
# BUG:
for(i in seq_along(retsums)) {
  retsums[[i]]$SpawnOutputUnits <- "t"
}

taf.png("retrospective_comparison.png")
sspar(mfrow=c(3,2), plot.cex = 0.65)
SSplotRetro(retsums[[1]], add=T, subplots="SSB", forecast=FALSE, ylim=c(0, 2e5))
SSplotRetro(retsums[[1]], add=T, subplots="F", forecast=FALSE, ylim=c(0, 0.6))
SSplotRetro(retsums[[2]], add=T, subplots="SSB", forecast=FALSE, ylim=c(0, 2e5))
SSplotRetro(retsums[[2]], add=T, subplots="F", forecast=FALSE, ylim=c(0, 0.6))
SSplotRetro(retsums[[4]], add=T, subplots="SSB", forecast=FALSE, ylim=c(0, 2e5))
SSplotRetro(retsums[[4]], add=T, subplots="F", forecast=FALSE, ylim=c(0, 0.6))
dev.off()

# RENDER

rmarkdown::render('report.Rmd', output_dir='report')

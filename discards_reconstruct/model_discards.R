# model_discards.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/discards_reconstruct/model_discards.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(FLCore)

load("data/data.rda")

# DISCARDS ratio

meanratio <- mean(data[year %in% 2002:2006, ratio])

data[, predratio := landings * meanratio]

# D ~ L

mod00 <- glm(discards ~ log(landings),
  family = Gamma(link = "log"),
  data = data[year > 2001])

summary(mod00)

# D ~ L + R(1)

mod01 <- glm(discards ~ log(landings) + log(rec1),
  family = Gamma(link = "log"),
  data = data[year > 2001])

summary(mod01)

# D ~ L + R(1) + R(2)

mod02 <- glm(discards ~ log(landings) + log(rec2),
  family = Gamma(link = "log"),
  data = data[year > 2001])

summary(mod02)

# D ~ L + R(1,2)

cor(log(data$rec1), log(data$rec2), use = "complete.obs")

mod12 <- glm(discards ~ log(landings) + log(rec1) + log(rec2),
  family = Gamma(link = "log"),
  data = data[year > 2001])

summary(mod12)

# D ~ C + R

modR <- glm(discards ~ log(landings) + log(rec),
  family = Gamma(link = "log"),
  data = data[year > 2001])

summary(modR)

# COMPARE

AIC(mod00, mod01, mod02, mod12, modR)

mods <- list(Landings=mod00, LandingsR1=mod01, LandingsR2=mod02,
  LandingsR12=mod12, LandingsR=modR)

# PREDICT

preds <- lapply(list(mod00=mod00, mod01=mod01, mod02=mod02, mod12=mod12, modR=modR), 
  function(x) exp(predict(x, newdata=data)))

res <- cbind(data, as.data.frame(preds))

# SAVE
save(res, mods, file="model/discards.rda")

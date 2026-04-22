# model_gam.R - DESC
# /home/mosqu003/Active/sol274_ICES_WGNSSK/discards_reconstruct/model_gam.R

# Copyright (c) WMR, 2026.
# Author: Iago MOSQUEIRA <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

# XX {{{
# }}}


# GAM a-la AAP

library(data.table)
library(mgcv)

# 1. DATA

# Required columns:
# year: 1957–2006
# age: integer (e.g. 1–10)
# landings: numbers-at-age
# discards: numbers-at-age (NA before 2002)
# survey: index-at-age (NA before 1990)

dt <- data.table(model.frame(FLQuants(landings=landings.n(stk), discards=discards.n(stk),
  survey=window(index(indices$BTS), start=1957)), drop=TRUE))

# 2. PREP

dt[, has_discards := !is.na(discards)]
dt[, total_catch_obs := landings + discards]
dt[, prop_land := fifelse(
  has_discards,
  landings / (landings + discards),
  NA_real_
)]


# 🎯 3. Retention GAM (2002–2006)

dt_ret <- dt[year >= 2002 & year <= 2006 & !is.na(discards)]

gam_ret <- gam(
  cbind(landings, discards) ~ 
    s(age, k = 8) +
    s(year, k = 5) +
    ti(age, year, k = c(6,5)),
  family = binomial,
  method = "REML",
  data = dt_ret
)

# 📡 4. Survey GAM (1990–2006)

dt_srv <- dt[year >= 1990 & !is.na(survey)]

gam_srv <- gam(
  log(survey + 1e-6) ~ 
    s(age, k = 8) +
    s(year, k = 10) +
    ti(age, year, k = c(6,8)),
  method = "REML",
  data = dt_srv
)

# 🔗 5. Scale survey → total catch

dt_overlap <- dt[
  year >= 2002 & year <= 2006 &
  !is.na(total_catch_obs) & !is.na(survey)
]

dt_overlap[, survey_pred := exp(predict(gam_srv, newdata = dt_overlap))]

lm_scale <- lm(
  log(total_catch_obs + 1) ~ log(survey_pred),
  data = dt_overlap
)

# 🔮 6. Predict for all years

# Survey prediction
dt[, survey_pred := exp(predict(gam_srv, newdata = dt))]

# Total catch prediction
dt[, total_catch_pred := exp(
  predict(lm_scale, newdata = data.frame(
    survey_pred = survey_pred
  ))
)]

# Retention probability
dt[, p_land := predict(gam_ret, newdata = dt, type = "response")]

# ⚠️ 7. Fill pre-1990 (no survey years)
dt[, ratio := total_catch_pred / landings]

ratio_dt <- dt[year >= 1990 & is.finite(ratio),
               .(mean_ratio = mean(ratio, na.rm = TRUE)),
               by = age]
dt[ratio_dt, on = "age",
   total_catch_pred := fifelse(
     year < 1990,
     landings * mean_ratio,
     total_catch_pred
   )]

# 🧮 8. Reconstruct discards (1957–2001)
dt[, p_land := pmin(pmax(p_land, 0.05), 0.95)]

dt[, discards_pred := fifelse(
year <= 2001,
landings * (1 - p_land) / p_land,
discards
)]

dt[, discards_pred := pmax(discards_pred, 0)]

# 🔍 9. Validation (very important)

dt_val <- dt[year >= 2002 & year <= 2006]

plot(dt_val$discards, dt_val$discards_pred)
abline(0, 1, col = "red")

# ⚙️ Optional (but strongly recommended)

dt_ret[, cohort := year - age]

gam_ret <- gam(
  cbind(landings, discards) ~ 
    s(age, k = 8) +
    s(year, k = 5) +
    s(cohort, k = 8) +
    ti(age, year, k = c(6,5)),
  family = binomial,
  method = "REML",
  data = dt_ret
)




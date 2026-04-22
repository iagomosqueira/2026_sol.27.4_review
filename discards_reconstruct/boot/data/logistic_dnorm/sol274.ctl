#V3.30.24.1;_safe;_compile_date:_Sep 18 2025;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_13.2
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:_https://groups.google.com/g/ss3-forum_and_NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:_https://nmfs-ost.github.io/ss3-website/
#_Source_code_at:_https://github.com/nmfs-ost/ss3-source-code

#C control file for Sole 4 (1 fleet 2 surveys)
#_data_and_control_files: sol274.dat // sol274.ctl
1  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns (Growth Patterns, Morphs, Bio Patterns, GP are terms used interchangeably in SS3)
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Platoon_within/between_stdev_ratio (no read if N_platoons=1)
#_Cond sd_ratio_rd < 0: platoon_sd_ratio parameter required after movement params.
#_Cond  1 #vector_platoon_dist_(-1_in_first_val_gives_normal_approx)
#
4 # recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity; 4=none (only when N_GP*Nsettle*pop==1)
1 # not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
1 #  number of recruitment settlement assignments 
0 # unused option
#GPattern month  area  age (for each settlement assignment)
 1 1 1 0
#
#_Cond 0 # N_movement_definitions goes here if Nareas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
0 #_Nblock_Patterns
#_Cond 0 #_blocks_per_pattern 
# begin and end years of blocks
#
# controls for all timevary parameters 
1 #_time-vary parm bound check (1=warn relative to base parm bounds; 3=no bound check); Also see env (3) and dev (5) options to constrain with base bounds
#
# AUTOGEN
 1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen time-varying parms of this category; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: P_block=P_base*exp(TVP); 1: P_block=P_base+TVP; 2: P_block=TVP; 3: P_block=P_block(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=P_base*exp(TVP*env(y));  2: P(y)=P_base+TVP*env(y);  3: P(y)=f(TVP,env_Zscore) w/ logit to stay in min-max;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=dev(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  5: like 4 with logit transform to stay in base min-max
#_DevLinks(more):  21-25 keep last dev for rest of years
#
#_Prior_codes:  0=none; 6=normal; 1=symmetric beta; 2=CASAL's beta; 3=lognormal; 4=lognormal with biascorr; 5=gamma
#
# setup for M, growth, wt-len, maturity, fecundity, (hermaphro), recr_distr, cohort_grow, (movement), (age error), (catch_mult), sex ratio 
#_NATMORT
1 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=BETA:_Maunder_link_to_maturity;_6=Lorenzen_range
10 #_N_breakpoints
 0.5 1 2 3 4 5 6 7 8 10 # age(real) at M breakpoints
#

1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K; 4=not implemented
0.1 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (fixed at 0.2 in 3.24; value should approx initial Z; -999 replicates 3.24)
0  #_placeholder for future growth feature
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)

2 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
#_Age_Fecundity by growth pattern from wt-at-age.ss now invoked by read bodywt flag
3 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#

#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
# Sex: 1  BioPattern: 1  NatMort
 0.1 2.4 1.302 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_1_Fem_GP_1
 0.1 2.4 0.754 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_2_Fem_GP_1
 0.1 2.4 0.465 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_3_Fem_GP_1
 0.1 2.4 0.368 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_4_Fem_GP_1
 0.1 2.4 0.321 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_5_Fem_GP_1
 0.1 2.4 0.295 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_6_Fem_GP_1
 0.1 2.4 0.278 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_7_Fem_GP_1
 0.1 2.4 0.267 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_8_Fem_GP_1
 0.1 2.4 0.26 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_9_Fem_GP_1
 0.1 2.4 0.248 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_10_Fem_GP_1
# Sex: 1  BioPattern: 1  Growth
 0 20 4 4 10 0 -2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 10 70 70 20 10 0 -4 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.05 0.8 0.2 0.47 0.8 0 -4 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.05 0.5 0.2 0.5 0.8 0 -3 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.1 0.7 0.2 0.5 0.8 0 -3 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 4e-06 4e-06 0.8 0 -99 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 -3 4 3.05 3.0962 0.8 0 -99 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 0 6 0.13 2 0.8 0 -99 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -5 3 -4.149 -0.25 0.8 0 -99 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 1 0.8 0 -99 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0.8 0 -99 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Hermaphroditism
#  Recruitment Distribution 
#  Cohort growth dev base
 0.1 10 1 1 1 0 -1 0 0 0 0 0 0 0 # CohortGrowDev
#  Movement
#  Platoon StDev Ratio 
#  Age Error from parameters
#  catch multiplier
#  fraction female, by GP
 1e-06 0.999999 0.5 0.5 0.5 0 -99 0 0 0 0 0 0 0 # FracFemale_GP_1
#  M2 parameter for each predator fleet
#
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#

#_Spawner-Recruitment
3 #_Spawner-Recruitment; Options: 1=NA; 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm; 10=B-H_ab
0  # 0/1 to use steepness in initial equ recruitment calculation
 0 #  not_used
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
             5            25       	16        14.494             2            -6          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.1             1        0.6646        0.6646        0.0739             2         -1          0          0          0          0          0          0          0 # SR_BH_steep
             0             2        0.5384        0.5384        0.1328             2         -2          0          0          0          0          0          0          0 # SR_sigmaR
            -5             5             0             0             1             0         -1          0          0          0          0          0          0          0 # SR_regime
             0             1             0         0.456         0.054             0         -2          0          0          0          0          0          0          0 # SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1957 # first year of main recr_devs; early devs can precede this era
2024 # last year of main recr_devs; forecast devs start in following year
3 #_recdev phase 
1 # (0/1) to read 13 advanced options
 -8 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 2 #_recdev_early_phase
 -1 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1947.7   #_last_early_yr_nobias_adj_in_MPD 
 1953.7   #_first_yr_fullbias_adj_in_MPD 
 2024.0   #_last_yr_fullbias_adj_in_MPD 
 2032.4   #_first_recent_yr_nobias_adj_in_MPD 
 0.9524  #_max_bias_adj_in_MPD (1.0 to mimic pre-2009 models)
 0 #_period of cycles in recruitment (N parms read below)
 -5 #min rec_dev
 5 #max rec_dev
 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
# all recruitment deviations
#  1980E 1981E 1982E 1983E 1984E 1985E 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016F 2017F 2018F
#  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0
#
#Fishing Mortality info 
0.23 # F ballpark
-2008 # F ballpark year (neg value to disable)
4 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
2.3 # max F or harvest rate, depends on F_Method
# Read list of fleets that do F as parameter; unlisted fleets stay hybrid, bycatch fleets must be included with start_PH=1, high F fleets should switch early
# (A) fleet;
# (B) F_starting_value (ignored if start_PH=1 or reading from ss3.par);
# (C) start_PH for fleet's Fparms (99 to stay in hybrid, <0 to stay at starting value)
# Terminate list with -9999 for fleet
# or terminate with -9998 to invoke reading fleet-time specific F values after first reading N hybrid tune loops)
# (A) (B) (C)
 1 0.05 99 # Fleet
 4 0.05 1 # Discards
-9999 1 1 # end of list

#F_detail template: fleet year seas F_value catch_se phase
6 #_number of loops for hybrid tuning; 4 precise; 3 faster; 2 enough if switching to parms is enabled
#
#_initial_F_parms; for each fleet x season that has init_catch; nest season in fleet; count = 2
#_for unconstrained init_F, use an arbitrary initial catch and set lambda=0 for its logL
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
 0.001 1 0.110272 0.1 0.1 0 1 # InitF_seas_1_flt_1Fleet
 0 1 0.001 0.1 0.1 0 -1 # InitF_seas_1_flt_4Discards


# F rates by fleet
# Yr:  1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# Fleet 0.336548 0.684639 1.09867 2.29547 2.3 2.3 2.3 2.30027 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 2.3 3.05866e-05 0.265995 0.577156
#
#_Q_setup for fleets with cpue or survey or deviation data
#_1:  fleet number
#_2:  link type: 1=simple q; 2=mirror; 3=power (+1 parm); 4=mirror with scale (+1p); 5=offset (+1p); 6=offset & power (+2p)
#_     where power is applied as y = q * x ^ (1 + power); so a power value of 0 has null effect
#_     and with the offset included it is y = q * (x + offset) ^ (1 + power)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         2         1         0         1         0         1  #  BTS
         3         1         0         1         0         1  #  COAST
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -25            25      -2.47811         0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Acoustic(2)
             0             1           0           0.1           0.1           0         -3          0          0          0          0          0          0          0  #  Q_extraSD_Acoustic(2)
           -25            25       3.86604         0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Trapnet(3)
             0             1           0           0.1           0.1           0         -3          0          0          0          0          0          0          0  #  Q_extraSD_Trapnet(3)

#_no timevary Q parameters
#
#_size_selex_patterns
#Pattern:_0;  parm=0; selex=1.0 for all sizes
#Pattern:_1;  parm=2; logistic; with 95% width specification
#Pattern:_5;  parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_11; parm=2; selex=1.0  for specified min-max population length bin range
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6;  parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (mean over bin range)
#Pattern:_8;  parm=8; double_logistic with smooth transitions and constant above Linf option
#Pattern:_9;  parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2*special; non-parm len selex, read as N break points, then N selex parameters
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_2;  parm=6; double_normal with sel(minL) and sel(maxL), using joiners, back compatibile version of 24 with 3.30.18 and older
#Pattern:_25; parm=3; exponential-logistic in length
#Pattern:_27; parm=special+3; cubic spline in length; parm1==1 resets knots; parm1==2 resets all 
#Pattern:_42; parm=special+3+2; cubic spline; like 27, with 2 additional param for scaling (mean over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#_Pattern Discard Male Special
 0 0 0 0 # 1 Fleet
 0 0 0 0 # 2 BTS
 0 0 0 0 # 3 COAST
 0 0 0 0 # 4 Discards
#
#_age_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for ages 0 to maxage
#Pattern:_10; parm=0; selex=1.0 for ages 1 to maxage
#Pattern:_11; parm=2; selex=1.0  for specified min-max age
#Pattern:_12; parm=2; age logistic
#Pattern:_13; parm=8; age double logistic. Recommend using pattern 18 instead.
#Pattern:_14; parm=nages+1; age empirical
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_16; parm=2; Coleraine - Gaussian
#Pattern:_17; parm=nages+1; empirical as random walk  N parameters to read can be overridden by setting special to non-zero
#Pattern:_41; parm=2+nages+1; // like 17, with 2 additional param for scaling (mean over bin range)
#Pattern:_18; parm=8; double logistic - smooth transition
#Pattern:_19; parm=6; simple 4-parm double logistic with starting age
#Pattern:_20; parm=6; double_normal,using joiners
#Pattern:_26; parm=3; exponential-logistic in age
#Pattern:_27; parm=3+special; cubic spline in age; parm1==1 resets knots; parm1==2 resets all 
#Pattern:_42; parm=2+special+3; // cubic spline; with 2 additional param for scaling (mean over bin range)
#Age patterns entered with value >100 create Min_selage from first digit and pattern from remainder
#_Pattern Discard Male Special
 12 0 0 0 # 1 Fleet
 20 0 0 0 # 2 BTS
 20 0 0 0 # 3 COAST
 20 3 0 0 # 4 Discards

 #_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# 1   Fleet LenSelex
# 2   BTS LenSelex
# 3   COAST LenSelex
# 4   Discards LenSelex
# 1   Fleet AgeSelex
             0            20       2.24985            10             4           0.5          5          0          23          2009          2021          5          0          0  #  Age_inflection_Fleet(1)
            -4            30      0.736884             1             4           0.5          6          0          23          2009          2021          6          0          0  #  Age_95%width_Fleet(1)

  
# -1002 3 	-1000 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # No selection
 # -25	25 	 1 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Reference age 1
 # -15 	9 	 1.45 	-1 	-1 	0.01 	 4 	0 23	1957	2024	5 0 0 # Change to age 2
 # -15 	9 	 0.4 	-1 	-1 	0.01 	 4 	0 23	1957	2024	5 0 0 # Change to age 3
 # -15 	9 	 0.0 	-1 	-1 	0.01 	 4 	0 23	1957	2024	5 0 0 # Change to age 4
 # -5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 5
 # -5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 6
 # -5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 7
 # -5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 8
 # -5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 9
 # -5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 10
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 11
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 12
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 13
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 14
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 15
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 16
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 17
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 18
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 19
 #-5 	9 	 0.0 	-1 	-1 	0.01 	 -4 	0 0 0 0 0 0 0 # Change to age 20


# 2   BTS AgeSelex
0.0	9.9	2.0	2.0	1	0.05	4	0	0	0	0	0.5	0	0	#	PEAK	value
-5.0	3.0	-5.0	-5.0	1	0.05	4	0	0	0	0	0.5	0	0	#	TOP	logistic
-4.0	12.0	8.4	8.4	1	0.05	4	0	0	0	0	0.5	0	0	#	WIDTH	exp
-10.0	6.0	3.0	3.0	1	0.05	4	0	0	0	0	0.5	0	0	#	WIDTH	exp
-15.0	5.0	0.0	0.0	1	0.05	4	0	0	0	0	0.5	0	0	#	INIT	logistic
-5.0	15.0	0.9	0.9	1	0.05	4	0	0	0	0	0.5	0	0	#	FINAL	logistic




#         -1002             3          -500            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P1_BTS(2)
#           -25            25       3.47798            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P2_BTS(2)
#            -5             9      0.157304            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P3_BTS(2)
#            -5             9     -0.194408            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P4_BTS(2)
#            -5             9     0.0444615            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P5_BTS(2)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P6_BTS(2)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P7_BTS(2)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P8_BTS(2)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P9_BTS(2)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P10_BTS(2)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P11_BTS(2)


# 3   COAST AgeSelex
0.0	9.9	2.0	2.0	1	0.05	4	0	0	0	0	0.5	0	0	#	PEAK	value
-15.0	3.0	-5.0	-5.0	1	0.05	4	0	0	0	0	0.5	0	0	#	TOP	logistic
-30.0	12.0	5.9	5.9	1	0.05	4	0	0	0	0	0.5	0	0	#	WIDTH	exp
-2.0	6.0	0.3	0.3	1	0.05	4	0	0	0	0	0.5	0	0	#	WIDTH	exp
-15.0	5.0	0.8	0.8	1	0.05	4	0	0	0	0	0.5	0	0	#	INIT	logistic
-15.0	5.0	0.0	0.0	1	0.05	4	0	0	0	0	0.5	0	0	#	FINAL	logistic






#         -1002             3          -500            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P1_COAST(3)
#           -25            25     0.0361267    -0.0172979         1e-05            -6          4          0          0          0          0          0          0          0  #  AgeSel_P2_COAST(3)
#           -15             9      0.133383            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P3_COAST(3)
#           -15            15     -0.564221            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P4_COAST(3)
#           -15             9      0.213201            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P5_COAST(3)
#           -15             9      -4.68946            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P6_COAST(3)
#           -15             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P7_COAST(3)
#           -15             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P8_COAST(3)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P9_COAST(3)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P10_COAST(3)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P11_COAST(3)
# 4   Discards AgeSelex
0.0	9.9	2.0	2.0	1	0.05	4	0	0	0	0	0.5	0	0	#	PEAK	value
-15.0	3.0	-5.0	-5.0	1	0.05	4	0	0	0	0	0.5	0	0	#	TOP	logistic
-4.0	12.0	0.3	0.3	1	0.05	4	0	0	0	0	0.5	0	0	#	WIDTH	exp
-2.0	6.0	1.0	1.0	1	0.05	4	0	0	0	0	0.5	0	0	#	WIDTH	exp
-15.0	5.0	0.0	0.0	1	0.05	4	0	0	0	0	0.5	0	0	#	INIT	logistic
-5.0	5.0	0.2	0.2	1	0.05	4	0	0	0	0	0.5	0	0	#	FINAL	logistic



#         -1002             3          -500            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P1_Discards(4)
#           -25            25       15.3073            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P2_Discards(4)
#            -5             9       1.40051            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P3_Discards(4)
#            -5            15     -0.112175            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P4_Discards(4)
#            -5             9     -0.246583            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P5_Discards(4)
#            -5             9     -0.467616            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P6_Discards(4)
#            -5             9      -1.15578            -1            -1          0.01          4          0          0          0          0          0          0          0  #  AgeSel_P7_Discards(4)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P8_Discards(4)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P9_Discards(4)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P10_Discards(4)
#            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P11_Discards(4)


#_Dirichlet and/or MV Tweedie parameters for composition error
#_multiple_fleets_can_refer_to_same_parm;_but_list_cannot_have_gaps
            -5             5             5             0         1.813             6         -5          0          0          0          0          0          0          0  #  ln(DM_theta)_Age_P1
            -5             5      	 5             0         1.813             6          5          0          0          0          0          0          0          0  #  ln(DM_theta)_Age_P2
            -5             5      	 5             0         1.813             6          5          0          0          0          0          0          0          0  #  ln(DM_theta)_Age_P3
            -5             5             5             0         1.813             6         -5          0          0          0          0          0          0          0  #  ln(DM_theta)_Age_P4

##_no timevary selex parameters
#Annual deviations
#LO   HI   INIT   PRIOR    PR_SD   PR_type    PHASE
# 0.0001  20     5      0.02      0.5     0        -5            # PEAK	value_FLEET1_dev_se
#-0.99    0.99   0.00   0.89      0.5     0        -6            # PEAK	value_FLEET1_dev_autocorr
# 0.0001  20     5      0.02      0.5     0        -5            # PEAK	value_FLEET1_dev_se
#-0.99    0.99   0.00   0.89      0.5     0        -6            # PEAK	value_FLEET1_dev_autocorr
# 0.0001  20     5      0.02      0.5     0        -5            # PEAK	value_FLEET1_dev_se
#-0.99    0.99   0.00   0.89      0.5     0        -6            # PEAK	value_FLEET1_dev_autocorr

# 0.0001  20     5      0.02      0.5     0        -5            # PEAK	value_FLEET1_dev_se
#-0.99    0.99   0.00   0.89      0.5     0        -6            # PEAK	value_FLEET1_dev_autocorr
# 0.0001  20     5      0.02      0.5     0        -5            # PEAK	value_FLEET1_dev_se
#-0.99    0.99   0.00   0.89      0.5     0        -6            # PEAK	value_FLEET1_dev_autocorr
# 0.0001  20     5      0.02      0.5     0        -5            # PEAK	value_FLEET1_dev_se
#-0.99    0.99   0.00   0.89      0.5     0        -6            # PEAK	value_FLEET1_dev_autocorr

# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
        0.0001             2             2             2           0.5             6      -5  # AgeSel_P1_Fleet(1)_dev_se
        -0.99          0.99             0             0           0.5             6      -6  # AgeSel_P1_Fleet(1)_dev_autocorr
       0.0001             2           0.5           0.5           0.5             6      -5  # AgeSel_P2_Fleet(1)_dev_se
        -0.99          0.99             0             0           0.5             6      -6  # AgeSel_P2_Fleet(1)_dev_autocorr
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# deviation vectors for timevary parameters
#  base   base first block   block  env  env   dev   dev   dev   dev   dev
#  type  index  parm trend pattern link  var  vectr link _mnyr  mxyr phase  dev_vector
#      5     1     1     0     0     2     0     1     3  2006  2015    -1      0      0      0      0      0      0      0      0      0      0
#      5     2     3     0     0     2     0     2     3  2006  2015    -1      0      0      0      0      0      0      0      0      0      0
     #
# Input variance adjustments factors: 
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#_Factor  Fleet  Value_Francis_3thiterations_over_9
      5      1      1
      5      2      1
      5      3      1
 -9999   1    0  # terminator
#
4 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
#like_comp fleet  phase  value  sizefreq_method
#8 2 1 0 1
#5 2 1 0 1
-9999  1  1  1  1  #  terminator
#
# lambdas (for info only; columns are phases)
#  0 0 0 0 #_CPUE/survey:_1
#  1 1 1 1 #_CPUE/survey:_2
#  1 1 1 1 #_CPUE/survey:_3
#  1 1 1 1 #_CPUE/survey:_4
#  1 1 1 1 #_CPUE/survey:_5
#  1 1 1 1 #_agecomp:_1
#  1 1 1 1 #_agecomp:_2
#  1 1 1 1 #_agecomp:_3
#  1 1 1 1 #_agecomp:_4
#  1 1 1 1 #_agecomp:_5
#  1 1 1 1 #_init_equ_catch
#  1 1 1 1 #_recruitments
#  1 1 1 1 #_parameter-priors
#  1 1 1 1 #_parameter-dev-vectors
#  1 1 1 1 #_crashPenLambda
#  0 0 0 0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
 # 0 1 -1 5 1 5 1 -1 5 # placeholder for selex type, len/age, year, N selex bins, Growth pattern, N growth ages, NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999


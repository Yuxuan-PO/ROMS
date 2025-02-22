#!/bin/csh -f
#
# git $Id$
# svn $Id: job_psas_sen.sh 995 2020-01-10 04:01:28Z arango $
#######################################################################
# Copyright (c) 2002-2020 The ROMS/TOMS Group                         #
#   Licensed under a MIT/X style license                              #
#   See License_ROMS.txt                                              #
#######################################################################
#                                                                     #
# Strong/Weak constraint 4D-PSAS observation impact or sensitivity    #
# job script:                                                         #
#                                                                     #
# This script NEEDS to be run before any run:                         #
#                                                                     #
#   (1) It copies a new clean nonlinear model initial conditions      #
#       file. The nonlinear model is initialized from the             #
#       background or reference state.                                #
#   (2) It copies Lanczos vectors from previous 4D-PSAS run. They     #
#       are stored in 4D-Var data assimilation file.                  #
#   (3) It copies the adjoint sensitivy functional file for the       #
#       observation impact or sensitivity.                            #
#   (4) Specify model, initial conditions, boundary conditions, and   #
#       surface forcing error convariance input standard deviations   #
#       files.                                                        #
#   (5) Specify model, initial conditions, boundary conditions, and   #
#       surface forcing error convariance input/output normalization  #
#       factors files.                                                #
#   (6) Copy a clean copy of the observations NetCDF file.            #
#   (7) Create 4D-Var input script "psas.in" from template and        #
#       specify the error covariance standard deviation, error        #
#       covariance normalization factors, and observation files to    #
#       be used.                                                      #
#                                                                     #
#######################################################################

# Set path definition to one directory up in the tree.

 set Dir=`dirname ${PWD}`

# Set string manipulations perl script.

 set SUBSTITUTE=${ROMS_ROOT}/ROMS/Bin/substitute

# Copy nonlinear model initial conditions file.

 cp -p ${Dir}/Data/wc13_ini.nc wc13_ini.nc

# Copy Lanczos vectors from previous 4D-PSAS run. They are stored
# in 4D-Var data assimilation file.

 cp -p ${Dir}/PSAS/wc13_mod.nc wc13_lcz.nc

# Copy adjoint sensitivity functional.

 cp -p ${Dir}/Data/wc13_ads.nc wc13_ads.nc

# Set model, initial conditions, boundary conditions and surface
# forcing error covariance standard deviations files.

 set STDnameM=${Dir}/Data/wc13_std_m.nc
 set STDnameI=${Dir}/Data/wc13_std_i.nc
 set STDnameB=${Dir}/Data/wc13_std_b.nc
 set STDnameF=${Dir}/Data/wc13_std_f.nc

# Set model, initial conditions, boundary conditions and surface
# forcing error covariance normalization factors files.

 set NRMnameM=${Dir}/Data/wc13_nrm_m.nc
 set NRMnameI=${Dir}/Data/wc13_nrm_i.nc
 set NRMnameB=${Dir}/Data/wc13_nrm_b.nc
 set NRMnameF=${Dir}/Data/wc13_nrm_f.nc

# Set observations file.

 set OBSname=wc13_obs.nc

# Get a clean copy of the observation file.  This is really
# important since this file is modified.

 cp -p ${Dir}/Data/${OBSname} .

# Modify 4D-Var template input script and specify above files.

 set PSAS=psas.in
 if (-e $PSAS) then
   /bin/rm $PSAS
 endif
 cp s4dvar.in $PSAS

 $SUBSTITUTE $PSAS roms_std_m.nc $STDnameM
 $SUBSTITUTE $PSAS roms_std_i.nc $STDnameI
 $SUBSTITUTE $PSAS roms_std_b.nc $STDnameB
 $SUBSTITUTE $PSAS roms_std_f.nc $STDnameF
 $SUBSTITUTE $PSAS roms_nrm_m.nc $NRMnameM
 $SUBSTITUTE $PSAS roms_nrm_i.nc $NRMnameI
 $SUBSTITUTE $PSAS roms_nrm_b.nc $NRMnameB
 $SUBSTITUTE $PSAS roms_nrm_f.nc $NRMnameF
 $SUBSTITUTE $PSAS roms_obs.nc $OBSname
 $SUBSTITUTE $PSAS roms_hss.nc wc13_hss.nc
 $SUBSTITUTE $PSAS roms_lcz.nc wc13_lcz.nc
 $SUBSTITUTE $PSAS roms_mod.nc wc13_mod.nc
 $SUBSTITUTE $PSAS roms_err.nc wc13_err.nc

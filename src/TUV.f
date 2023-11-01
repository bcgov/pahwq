! Copyright 2023 National Center for Atmospheric Research
! 
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
! 
! http://www.apache.org/licenses/LICENSE-2.0
! 
! Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and limitations under the License.

      PROGRAM tuv
*-----------------------------------------------------------------------------*
*=    Tropospheric Ultraviolet-Visible (TUV) radiation model                 =*
*=    Version 5.4                                                            =*
*=    November 2018                                                          =*
*=    modified August 2023 with custom user input/output specific to the     =*
*=    output of underwater spectral irradiances and actinic fluxes, for      =*
*=    conditions set by user in external input file.  Interactive mode is    =*
*=    disabled - SM
*-----------------------------------------------------------------------------*
*= Developed by Sasha Madronich with important contributions from:           =*
*= Chris Fischer, Siri Flocke, Julia Lee-Taylor, Bernhard Meyer,             =*
*= Irina Petropavlovskikh,  Xuexi Tie, and Jun Zen.                          =*
*= Special thanks to Knut Stamnes and co-workers for the development of the  =*
*= Discrete Ordinates code, and to Warren Wiscombe and co-workers for the    =*
*= development of the solar zenith angle subroutine. Citations for the many  =*
*= data bases (e.g. extraterrestrial irradiances, molecular spectra) may be  =*
*= found in the data files headers and/or in the subroutines that read them. =*
*=              To contact the author, write to:                             =*
*= Sasha Madronich, NCAR/ACD, P.O.Box 3000, Boulder, CO, 80307-3000, USA  or =*
*= send email to:  sasha@ucar.edu  or tuv@acd.ucar.edu                       =*
*-----------------------------------------------------------------------------*
*= This program is free software; you can redistribute it and/or modify      =*
*= it under the terms of the GNU General Public License as published by the  =*
*= Free Software Foundation;  either version 2 of the license, or (at your   =*
*= option) any later version.                                                =*
*= The TUV package is distributed in the hope that it will be useful, but    =*
*= WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHANTIBI-  =*
*= LITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public     =*
*= License for more details.                                                 =*
*= To obtain a copy of the GNU General Public License, write to:             =*
*= Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.   =*
*-----------------------------------------------------------------------------*
*= Copyright (C) 1994-2023 by the University Corporation for Atmospheric     =*
*= Research, extending to all called subroutines, functions, and data unless =*
*= another source is specified.                                              =*
*-----------------------------------------------------------------------------*

      IMPLICIT NONE

* Include parameter file

      INCLUDE 'params'

* Wavelength grid:

      INTEGER nw, iw, nwint
      REAL wl(kw), wc(kw), wu(kw)
      REAL wstart, wstop

* Altitude grid

      INTEGER nz, nzm1, iz, izout
      REAL z(kz), zstart, zstop, zout

* Solar zenith angle and azimuth
* slant pathlengths in spherical geometry

      REAL sza(kt), zen, sznoon
      INTEGER nid(0:kz)
      REAL dsdh(0:kz,kz)

* Extra terrestrial solar flux and earth-Sun distance ^-2

      REAL f(kw), etf(kw)
      REAL esfact(kt)

* Ozone absorption cross section

      INTEGER mabs
      REAL o3xs(kz,kw)

* O2 absorption cross section

      REAL o2xs(kz,kw), o2xs1(kw)

* SO2 absorption cross section
     
      REAL so2xs(kw)

* NO2 absorption cross section
     
      REAL no2xs(kz,kw)

* Atmospheric optical parameters

      REAL tlev(kz), tlay(kz)
      REAL aircon(kz), aircol(kz), vcol(kz), scol(kz)
      REAL dtrl(kz,kw)
      REAL co3(kz)
      REAL dto3(kz,kw), dto2(kz,kw), dtso2(kz,kw), dtno2(kz,kw)
      REAL dtcld(kz,kw), omcld(kz,kw), gcld(kz,kw)
      REAL dtaer(kz,kw), omaer(kz,kw), gaer(kz,kw)
      REAL dtsnw(kz,kw), omsnw(kz,kw), gsnw(kz,kw)
      REAL albedo(kw)
      REAL dt_any(kz,kw), om_any(kz,kw), g_any(kz,kw)

* Spectral irradiance and actinic flux (scalar irradiance)

      REAL edir(kz), edn(kz), eup(kz)
      REAL sirrad(kz,kw)
      REAL fdir(kz), fdn(kz), fup(kz)
      REAL saflux(kz,kw)

* Spectral weighting functions and weighted radiation

      INTEGER ns, is
      REAL sw(ks,kw), rate(ks,kz), dose(ks)
      REAL drdw
      CHARACTER*50 slabel(ks)

* Photolysis coefficients (j-values)

      INTEGER nj, ij
      REAL sj(kj,kz,kw), valj(kj,kz)
      REAL djdw
      CHARACTER*50 jlabel(kj)
      INTEGER tpflag(kj)

**** Re-scaling factors (can be read from input file)
* New surface albedo and surface pressure (milli bar)
* Total columns of O3, SO2, NO2 (Dobson Units)
* Cloud optical depth, altitude of base and top
* Aerosol optical depth at 550 nm, single scattering albedo, Angstrom alpha

      REAL alsurf, psurf
      REAL o3_tc, so2_tc, no2_tc
      REAL taucld, zbase, ztop
      REAL tauaer, ssaaer, alpha

* Location: Lat and Lon (deg.), surface elev (km)
* Altitude, temperature and pressure for specific outputs

      REAL lat, lon
      REAL zaird, ztemp

* Time and/or solar zenith angle
      
      INTEGER iyear, imonth, iday
      INTEGER it, nt
      REAL t(kt), tstart, tstop
      REAL tmzone
      LOGICAL lzenit

* number of radiation streams

      INTEGER nstr

* input/output control

      LOGICAL intrct
      CHARACTER*6 inpfil, outfil

      INTEGER iout

      REAL dirsun, difdn, difup

      CHARACTER*1 again

* Save arrays for output:

      LOGICAL lirrad, laflux, lrates, ljvals, lmmech
      INTEGER isfix, ijfix, itfix, izfix, iwfix
      INTEGER nms, ims(ks), nmj, imj(kj)

      REAL svj_zj(kz,kj), svj_tj(kt,kj), svj_zt(kz,kt)
      REAL svr_zs(kz,ks), svr_ts(kt,ks), svr_zt(kz,kt)
      REAL svf_zw(kz,kw), svf_tw(kt,kw), svf_zt(kz,kt)
      REAL svi_zw(kz,kw), svi_tw(kt,kw), svi_zt(kz,kt)

* Planetary boundary layer height and pollutant concentrations

      INTEGER ipbl
      REAL zpbl
      REAL o3pbl, so2pbl, no2pbl, aod330

* WRF-Chem output control

      LOGICAL wrfchm

***** Surface waters (lakes, ocean)
*   sdom = absorption spectra by Dissolved Organic Matter (DOM) 
*   kvat = selected vertical attenuation coefficient (1/m, ln)

      INTEGER jdom
      CHARACTER*50 dlabel(kdom)
      REAL sdom(kdom,kw)
      REAL kvat

*     ydepth = depth in meters
*  spectral irradiances in water:
*     se_y = solar beam irradiance at ydepth (normalized)
*     de_y = diffuse irradiance at ydepth, sum over all angles (normalized)
*     sun_y(kw) = spectral irradiances of direct solar beam at ydepth
*     dif_y(kw) = spectral irradiance of diffuse downwelling radiation at ydepth
*     tot_y(kw) = total downwelling spectral irradiances at ydepth
     
      REAL ydepth
      REAL se_y, de_y, sf_y, df_y
      real sun_y(kw), dif_y(kw), tot_ey(kw, kt)
      real sun_f(kw), dif_f(kw), tot_fy(kw, kt)

      REAL se_av, sf_av, de_av, df_av
      real tot_eav(kw, kt), tot_fav(kw, kt)
      real tot_ea(kw, kt), tot_fa(kw,kt)
      
******Other user-defined variables here:

      REAL akv, bkv, ckv
      CHARACTER*50 fi
      LOGICAL L33, L34, L35, L36, L37, L38


* --- END OF DECLARATIONS ---------------------------------------------

* re-entry point

 1000 CONTINUE

* Open log file:

c      OPEN(UNIT=kout,FILE='tuvlog',STATUS='UNKNOWN')
      OPEN(UNIT=kout,FILE='../'//'tuvlog'//'.txt',STATUS='UNKNOWN')
      
* ___ SECTION 1: SIMPLE INPUT VARIABLES --------------------------------
******* Read simple input variables from a file:

* can read interactively (intrct = .TRUE.) 
* or in batch mode (intrct = .FALSE.)

c      intrct = .TRUE.
      intrct = .FALSE.
c      IF ( .NOT. intrct) inpfil = 'usrinp'

c      CALL rdinp(intrct, 
c     $     inpfil, outfil, nstr,   lat,    lon,    tmzone,
c     $     iyear,  imonth, iday,   zstart, zstop,  nz,
c     $     wstart, wstop,  nwint,  tstart, tstop,  nt,
c     $     lzenit, alsurf, psurf,  o3_tc,  so2_tc, no2_tc,
c     $     taucld, zbase,  ztop,   tauaer, ssaaer, alpha,
c     $     dirsun, difdn,  difup,  zout,   zaird,  ztemp,
c     $     lirrad, laflux, lmmech, lrates, isfix,  nms,
c     $     ljvals, ijfix,  nmj,    iwfix,  itfix,  izfix,
c     $     ims,    slabel, imj,    jlabel)

************* Can overwrite basic inputs here manually:
* Input and output files:
*   inpfil = input file name
*   outfil = output file name
* Radiative transfer scheme:
*   nstr = number of streams
*          If nstr < 2, will use 2-stream Delta Eddington
*          If nstr > 1, will use nstr-stream discrete ordinates
* Location (geographic):
*   lat = LATITUDE (degrees, North = positive)
*   lon = LONGITUDE (degrees, East = positive)
*   tmzone = Local time zone difference (hrs) from Universal Time (ut):  
*            ut = timloc - tmzone
* Date:
*   iyear = year (1950 to 2050)
*   imonth = month (1 to 12)
*   iday = day of month
* Time of day grid:
*   tstart = starting time, local hours
*   tstop = stopping time, local hours
*   nt = number of time steps
*   lzenit = switch for solar zenith angle (sza) grid rather than time 
*             grid. If lzenit = .TRUE. then 
*                tstart = first sza in deg., 
*                tstop = last sza in deg., 
*                nt = number of sza steps. 
*                esfact = 1. (Earth-sun distance = 1.000 AU)
* Vertical grid:
*   zstart = surface elevation above sea level, km
*   zstop = top of the atmosphere (exospheric), km
*   nz = number of vertical levels, equally spaced
*        (nz will increase by +1 if zout does not match altitude grid)
* Wavlength grid:
*   wstart = starting wavelength, nm
*   wstop  = final wavelength, nm
*   nwint = number of wavelength intervals, equally spaced
*           if nwint < 0, the standard atmospheric wavelength grid, not
*           equally spaced, from 120 to 735 nm, will be used. In this
*           case, wstart and wstop values are ignored.
* Surface condition:
*   alsurf = surface albedo, wavelength independent
*   psurf = surface pressure, mbar.  Set to negative value to use
*           US Standard Atmosphere, 1976 (USSA76)
* Column amounts of absorbers (in Dobson Units, from surface to space):
*          Vertical profile for O3 from USSA76.  For SO2 and NO2, vertical
*          concentration profile is 2.69e10 molec cm-3 between 0 and 
*          1 km above sea level, very small residual (10/largest) above 1 km.
*   o3_tc = ozone (O3)
*   so2_tc = sulfur dioxide (SO2)
*   no2_tc = nitrogen dioxide (NO2)
* Cloud, assumed horizontally uniform, total coverage, single scattering
*         albedo = 0.9999, asymmetry factor = 0.85, indep. of wavelength,
*         and also uniform vertically between zbase and ztop:
*   taucld = vertical optical depth, independent of wavelength
*   zbase = altitude of base, km above sea level
*   ztop = altitude of top, km above sea level
* Aerosols, assumed vertical provile typical of continental regions from
*         Elterman (1968):
*   tauaer = aerosol vertical optical depth at 550 nm, from surface to space. 
*           If negative, will default to Elterman's values (ca. 0.235 
*           at 550 nm).
*   ssaaer = single scattering albedo of aerosols, wavelength-independent.
*   alpha = Angstrom coefficient = exponent for wavelength dependence of 
*           tauaer, so that  tauaer1/tauaer2  = (w2/w1)**alpha.
* Directional components of radiation, weighting factors:
*   dirsun = direct sun
*   difdn = down-welling diffuse
*   difup = up-welling diffuse
*        e.g. use:
*        dirsun = difdn = 1.0, difup = 0 for total down-welling irradiance
*        dirsun = difdn = difup = 1.0 for actinic flux from all directions
*        dirsun = difdn = 1.0, difup = -1 for net irradiance
* Output altitude:
*   zout = altitude, km, for desired output.
*        If not within 1 m of altitude grid, an additional
*        level will be inserted and nz will be increased by +1.
*   zaird = air density (molec. cm-3) at zout.  Set to negative value for
*        default USSA76 value interpolated to zout.
*   ztemp = air temperature (K) at zout.  Set to negative value for
*        default USSA76 value interpolated to zout.
* Output options, logical switches:
*   lirrad = output spectral irradiance
*   laflux = output spectral actinic flux
*   lmmech = output for NCAR Master Mechanism use
*   lrates = output dose rates (UVB, UVA, CIE/erythema, etc.)
* Output options, integer selections:
*   isfix:  if > 0, output dose rate for action spectrum is=isfix, tabulated
*           for different times and altitudes.
*   ijfix:  if > 0, output j-values for reaction ij=ijfix, tabulated
*           for different times and altitudes.
*   iwfix:  if > 0, output spectral irradiance and/or spectral actinic
*           flux at wavelength iw=iwfix, tabulated for different times
*           and altitudes.
*   itfix:  if > 0, output spectral irradiance and/or spectral actinic
*           flux at time it=itfix, tabulated for different altitudes
*           and wavelengths.
*   izfix:  if > 0, output spectral irradiance and/or spectral actinic
*           flux at altitude iz=izfix, tabulated for different times
*           and wavelengths.
*   nms:    number of dose rates that will be reported. Selections must be 
*           made interactively, or by editing input file.
*   nmj:    number of j-values that will be reported. Selections must be 
*           made interactively, or by editing input file.
* The following default settings are also found in the input file 'defin1':

*initialize, can be overwritten by user's inputvalues file

      inpfil = 'usrinp'
      outfil = 'usrout'
      nstr = -2
      lat = 0.
      lon = 0.
      tmzone = 0.
      iyear = 2002
      imonth = 3
      iday = 21
      zstart = 0.
      zstop = 80.
      nz = 80
      wstart = 280.
      wstop = 700.
      nwint = 420
*     *
      tstart = 12.
      tstop = 23.
      nt = 12
      lzenit = .FALSE.
      alsurf = 0.1
      psurf = -999.
      o3_tc = 300.
      so2_tc = 0.
      no2_tc = 0.
      taucld = 0.
      zbase = 4.
      ztop = 5.
      tauaer = 0.
      ssaaer = 0.99
      alpha = 1.
      dirsun = 1.
      difdn = 1.
      difup = 0.
      zout = 0.
      zaird = -999.
      ztemp = -999.
      lirrad = .FALSE.
      laflux = .FALSE.
      lmmech = .FALSE.
      lrates = .FALSE.
      isfix = 0
*      nms cannot be set here
      ljvals = .FALSE.
      ijfix = 0
*      nmj cannot be set here
      iwfix = 0
      itfix = 0
      izfix = 0

* output & input files for aquatics:


      open(unit=kin, file='AQUA/inp_aq',status='OLD')

      read(kin,*) akv, bkv, ckv ! kvdom = a exp(-b(wvl - c))
      read(kin,*) ydepth
      read(kin,*) lat
      read(kin,*) lon
      read(kin,*) zstart
          zout = zstart
      read(kin,*) tmzone
      read(kin,*) iyear
      read(kin,*) imonth
      read(kin,*) iday
      read(kin,*) tstart
      read(kin,*) tstop
      read(kin,*) nt
      read(kin,*) alsurf
      read(kin,*) o3_tc
      read(kin,*) so2_tc
      read(kin,*) no2_tc
      read(kin,*) taucld
      read(kin,*) zbase
      read(kin,*) ztop
      read(kin,*) tauaer
      read(kin,*) ssaaer
      read(kin,*) alpha
      read(kin,*) wstart
      read(kin,*) wstop
      read(kin,*) nwint
      read(kin,*) nstr
      read(kin,*) L33
      read(kin,*) L34
      read(kin,*) L35
      read(kin,*) L36
      read(kin,*) L37
      read(kin,*) L38
      close(kin)
      
      if(L33) open(unit=33,file='AQUA/out_irrad_y',status='UNKNOWN')
      if(L34) open(unit=34,file='AQUA/out_aflux_y',status='UNKNOWN')
      if(L35) open(unit=35,file='AQUA/out_irrad_av',status='UNKNOWN')
      if(L36) open(unit=36,file='AQUA/out_aflux_av',status='UNKNOWN')
      if(L37) open(unit=37,file='AQUA/out_irrad_atm',status='UNKNOWN')
      if(L38) open(unit=38,file='AQUA/out_aflux_atm',status='UNKNOWN')
 
      IF(outfil .EQ. 'screen') THEN
         iout = 6
      ELSE
         iout = 30
      ENDIF         

      IF(nstr .LT. 2) THEN
         WRITE(kout,*) 'Delta-Eddington 2-stream radiative transfer' 
      ELSE
         WRITE(kout,*) 'Discrete ordinates ', 
     $        nstr, '-stream radiative transfer' 
      ENDIF

      WRITE(*,*) 'calculating....'

* ___ SECTION 2: SET GRIDS _________________________________________________

* altitudes (creates altitude grid, locates index for selected output, izout)

      CALL gridz(zstart, zstop, nz, z, zout, izout)
      IF(izfix .GT. 0) izout = izfix

* time/zenith (creates time/zenith angle grid, starting at tstart)

      CALL gridt(lat, lon, tmzone,
     $     iyear, imonth, iday,
     $     lzenit, tstart, tstop,
     $     nt, t, sza, sznoon, esfact)

* wavelength grid, user-set range and spacing. 
* NOTE:  Wavelengths are in vacuum, and therefore independent of altitude.
* To use wavelengths in air, see options in subroutine gridw

      CALL gridw(wstart, wstop, nwint,
     $     nw, wl, wc, wu)

* ___ SECTION 3: SET UP VERTICAL PROFILES OF TEMPERATURE, AIR DENSITY, and OZONE

***** Temperature vertical profile, Kelvin 
*   can overwrite temperature at altitude z(izout)

      CALL vptmp(nz,z, tlev,tlay)
      IF(ztemp .GT. nzero) tlev(izout) = ztemp

*****  Air density (molec cm-3) vertical profile 
*   can overwrite air density at altitude z(izout)

      CALL vpair(psurf, nz, z,
     $     aircon, aircol)
      IF(zaird .GT. nzero) aircon(izout) = zaird

*****
*! PBL pollutants will be added if zpbl > 0.
* CAUTIONS:  
* 1. The top of the PBL, zpbl in km, should be on one of the z-grid altitudes.
* 2. Concentrations, column increments, and optical depths
*       will be overwritten between surface and zpbl.
* 3. Inserting PBL constituents may change their total column amount.
* 4. Above pbl, the following are used:
*       for O3:  USSA or other profile
*       for NO2 and SO2: set to zero.
*       for aerosols: Elterman
* Turning on pbl will affect subroutines:
* vpo3, setno2, setso2, and setaer. See there for details

      zpbl = -999.
C      zpbl = 3.

* locate z-index for top of pbl

      ipbl = 0
      IF(zpbl. GT. 0.) THEN
         DO iz = 1, nz-1
            IF(z(iz+1) .GT. z(1) + zpbl*1.00001) GO TO 19
         ENDDO
 19      CONTINUE
         ipbl = iz - 1
         write(*,*) 'top of PBL index, height (km) ', ipbl, z(ipbl)

* specify pbl concentrations, in parts per billion

         o3pbl = 100.
         so2pbl = 10.
         no2pbl = 50.

* PBL aerosol optical depth at 330 nm
* (to change ssa and g of pbl aerosols, go to subroutine setair.f)

         aod330 = 0.8

      ENDIF

***** Ozone vertical profile

      CALL vpo3(ipbl, zpbl, o3pbl, 
     $       o3_tc, nz, z, aircol, co3)

* ___ SECTION 4: READ SPECTRAL DATA ____________________________

* read (and grid) extra terrestrial flux data:
      
      CALL rdetfl(nw,wl, f)

* read cross section data for 
*    O2 (will overwrite at Lyman-alpha and SRB wavelengths
*            see subroutine la_srb.f)
*    O3 (temperature-dependent)
*    SO2 
*    NO2

      nzm1 = nz - 1
      CALL rdo2xs(nw,wl, o2xs1)
      mabs = 1
      CALL rdo3xs(mabs,nzm1,tlay,nw,wl, o3xs)
      CALL rdso2xs(nw,wl, so2xs)
      CALL rdno2xs(nz,tlay,nw,wl, no2xs)

****** Spectral weighting functions 
* (Some of these depend on temperature T and pressure P, and therefore
*  on altitude z.  Therefore they are computed only after the T and P profiles
*  are set above with subroutines settmp and setair.)
* Photo-physical   set in swphys.f (transmission functions)
* Photo-biological set in swbiol.f (action spectra)
* Photo-chemical   set in swchem.f (cross sections x quantum yields)* Physical 
*   and biological weigthing functions are assumed to depend
*   only on wavelength.
* Chemical weighting functions (product of cross-section x quantum yield)
*   for many photolysis reactions are known to depend on temperature
*   and/or pressure, and therefore are functions of wavelength and altitude.
* Output:
* from swphys & swbiol:  sw(ks,kw) - for each weighting function slabel(ks)
* from swchem:  sj(kj,kz,kw) - for each reaction jlabel(kj)
* For swchem, need to know temperature and pressure profiles.

      CALL swphys(nw,wl,wc, ns,sw,slabel)
      CALL swbiol(nw,wl,wc, ns,sw,slabel)
c      CALL swchem(nw,wl,nz,tlev,aircon, nj,sj,jlabel,tpflag)

** Read other spectral data
* absorption coefficients for Dissolved Organic Matter (DOM) in surface waters
*     jdom = 1: generic DOM spectrum exponential fit 
*     jdom = 2: input table of DOM absorption
*     sdom(jdom,iw) = spectral vertical absorption coefficient.


      CALL swdom(nw,wl,wc, jdom,dlabel,sdom, fi, akv, bkv, ckv)

**** The following CALL is normally commented out.
* Subroutine newlst regenerates the list of weighting functions 
* (molecular and biological spectra) when new ones are added, to 
* update the default input files (defin1, defin2. etc.).  User
* input files, e.g. usrinp, should be similarly updated. 
* The program STOPS at the completion of newlst.
* If not in use, newlst.o can be safely removed from Makefile.

c      CALL newlst(ns,slabel,nj,jlabel)

**** Option for writing look-up tables of 
* (molecular cross sections x quantum yields) 
* for WRF-Chem, at selected temperatures and pressures. 
* STOPs after tables are written.

      wrfchm = .FALSE.
      IF (inpfil .EQ. 'defin5') wrfchm = .TRUE.
      IF (wrfchm) CALL wrflut(nw, wl, nz, tlev, aircon)

* ___ SECTION 5: SET ATMOSPHERIC OPTICAL DEPTH INCREMENTS _____________________

* Rayleigh optical depth increments:

      CALL odrl(nz, z, nw, wl, aircol, dtrl)
      
* O2 vertical profile and O2 absorption optical depths
*   For now, O2 densitiy assumed as 20.95% of air density, can be changed
*   in subroutine.
*   Optical depths in Lyman-alpha and SRB will be over-written
*   in subroutine la_srb.f

      CALL seto2(nz,z,nw,wl,aircol,o2xs1, dto2)

* Ozone optical depths

      CALL odo3(nz,z,nw,wl,o3xs,co3, dto3)

* SO2 vertical profile and optical depths

      CALL setso2(ipbl, zpbl, so2pbl,
     $     so2_tc, nz, z, nw, wl, so2xs,
     $     tlay, aircol,
     $     dtso2)

* NO2 vertical profile and optical depths

      CALL setno2(ipbl, zpbl, no2pbl, 
     $     no2_tc, nz, z, nw, wl, no2xs,
     $     tlay, aircol,
     $     dtno2)

* Cloud vertical profile, optical depths, single scattering albedo, asymmetry factor

      CALL setcld(taucld,zbase,ztop,
     $     nz,z,nw,wl,
     $     dtcld,omcld,gcld)

* Aerosol vertical profile, optical depths, single scattering albedo, asymmetry factor

      CALL setaer(ipbl, zpbl, aod330,
     $     tauaer, ssaaer, alpha,
     $     nz, z, nw, wl,
     $     dtaer, omaer, gaer)

* Snowpack physical and optical depths, single scattering albedo, asymmetry factor

      CALL setsnw(
     $     nz,z,nw,wl,
     $     dtsnw,omsnw,gsnw)

* Surface albedo

      CALL setalb(alsurf,nw,wl,
     $     albedo)

* Set any additional absorber or scatterer:
* Must populate dt_any(kz,kw), om_any(kz,kw), g_any(kz,kw) manually
* This allows user to put in arbitrary absorber or scatterer
* could write a subroutine, e.g.:
C      CALL setany(nz,z,nw,wl,aircol, dt_any,om_any, g_any)
* or write manually here.

      DO iz = 1, nz-1
         DO iw = 1, nw-1
c            dt_any(iz,iw) = 0.79*aircol(iz) * 2.e-17 ! N2 VUV absorption
            dt_any(iz,iw) = 0.
            om_any(iz,iw) = 0.
            g_any(iz,iw) = 0.
         ENDDO
      ENDDO


* ___ SECTION 6: TIME/SZA LOOP  _____________________________________

* Initialize any time-integrated quantities here

* Loop over time or solar zenith angle (zen):

      
      write(*,*) 'Date, Lat, Lon, Min_SZA'
      write(*,222) iyear,imonth,iday,lat,lon,sznoon
 222  format(i4,'/',i2,'/',i2,3(1x,F8.3))
      
* write headers:
      write(33,330) 'wl', 'wu', 'Kvat', (t(it), it = 1, nt)
      write(34,330) 'wl', 'wu', 'Kvat', (t(it), it = 1, nt)
      write(35,330) 'wl', 'wu', 'Kvat', (t(it), it = 1, nt)
      write(36,330) 'wl', 'wu', 'Kvat', (t(it), it = 1, nt)
      write(37,330) 'wl', 'wu', 'Kvat', (t(it), it = 1, nt)
      write(38,330) 'wl', 'wu', 'Kvat', (t(it), it = 1, nt)
 330  format(a2, 4x, a2, 4x, a4, 4x, 24(0pf9.1))
      write(33,331) (sza(it), it = 1, nt)
      write(34,331) (sza(it), it = 1, nt)
      write(35,331) (sza(it), it = 1, nt)
      write(36,331) (sza(it), it = 1, nt)
      write(37,331) (sza(it), it = 1, nt)
      write(38,331) (sza(it), it = 1, nt)
 331  format(16x, 'sza=',24(0pf9.2))

      DO 20, it = 1, nt

         zen = sza(it)

         WRITE(*,200) it, zen, esfact(it)
         WRITE(kout,200) it, zen, esfact(it)
 200     FORMAT('step = ', I4,' sza = ', F9.3, 
     $        ' Earth-sun factor = ', F10.7)

* correction for earth-sun distance

         DO iw = 1, nw - 1
            etf(iw) = f(iw) * esfact(it)
         ENDDO

* ____ SECTION 7: CALCULATE ZENITH ANGLE-DEPENDENT QUANTITIES __________

* slant path lengths for spherical geometry

         CALL sphers(nz,z,zen, dsdh,nid)
         CALL airmas(nz, dsdh,nid, aircol,vcol,scol)

* Recalculate effective O2 optical depth and cross sections for Lyman-alpha
* and Schumann-Runge bands, must know zenith angle
* Then assign O2 cross section to sj(1,*,*)

         CALL la_srb(nz,z,tlev,nw,wl,vcol,scol,o2xs1,
     $        dto2,o2xs)
         CALL sjo2(nz,nw,o2xs,1, sj)

* ____ SECTION 8: WAVELENGTH LOOP ______________________________________

* initialize for wavelength integration

         CALL zero2(rate,ks,kz)
         CALL zero2(valj,kj,kz)

***** Main wavelength loop:

         DO 10, iw = 1, nw-1

** monochromatic radiative transfer. Outputs are:
*  normalized irradiances     edir(iz), edn(iz), eup(iz) 
*  normalized actinic fluxes  fdir(iz), fdn(zi), fup(iz)
*  where 
*  dir = direct beam, dn = down-welling diffuse, up = up-welling diffuse

            CALL rtlink(nstr, nz,
     $           iw, albedo(iw), zen,
     $           dsdh,nid,
     $           dtrl,
     $           dto3,
     $           dto2,
     $           dtso2,
     $           dtno2,
     $           dtcld, omcld, gcld,
     $           dtaer,omaer,gaer,
     $           dtsnw,omsnw,gsnw,
     $           dt_any,om_any,g_any,
     $           edir, edn, eup, fdir, fdn, fup)

* Spectral irradiance, W m-2 nm-1
* for downwelling only, use difup = 0.

            DO iz = 1, nz
               sirrad(iz,iw) = etf(iw) * 
     $           (dirsun*edir(iz) + difdn*edn(iz) + difup*eup(iz))
            ENDDO

* Spectral actinic flux, quanta s-1 nm-1 cm-2, all directions:
*    units conversion:  1.e-4 * (wc*1e-9) / hc

            DO iz = 1, nz
               saflux(iz,iw) = etf(iw) * (1.e-13 * wc(iw) / hc) *
     $              (dirsun*fdir(iz) + difdn*fdn(iz) + difup*fup(iz))
            ENDDO

************ In-water radiation:
*   Input:  
*     ydepth, in meters, for which radiation field is desired
*     kvat = vertical attenuation coefficinet (1/m, ln) of DOM 
*     zen = solar zenith angle
*   Output from subroutine waters:
*     se_y = normalized solar beam irradiance at ydepth
*     de_y = normalized diffuse irradiance at ydepth  (sum over all angles)

            kvat = sdom(1,iw)
            CALL aquat(zen,kvat,ydepth, se_y,de_y, sf_y,df_y,
     $           se_av, de_av, sf_av, df_av)

* calculate spectral irradiances (W m-2 nm-1) in water at depth ydepth
* compute sun beam, diffuse, and total
* note under-water actinc fluxes are normalized to irradiance
            
            tot_ey(iw, it) = etf(iw) * (se_y * edir(1) + de_y * edn(1))
            tot_fy(iw, it) = etf(iw) * (sf_y * edir(1) + df_y * edn(1))

            tot_eav(iw, it) = etf(iw) * (se_av*edir(1) + de_av*edn(1))
            tot_fav(iw, it) = etf(iw) * (sf_av*edir(1) + df_av*edn(1))
            
*     store above-surface values:

            tot_ea(iw, it) = etf(iw) * (edir(1) + edn(1))
            tot_fa(iw, it) = etf(iw) * (fdir(1) + fdn(1))

*  to convert to quanta s-1 cm-2 nm-1, multiply by (1.e-13*wc(iw)/hc)

**** Save irradiances and actinic fluxes for standard output

            CALL saver1(it, itfix, iw, iwfix,  nz, izout,
     $           sirrad, saflux,
     $           svi_zw, svf_zw, svi_zt, svf_zt, svi_tw, svf_tw)

 10      CONTINUE

*^^^^^^^^^^^^^^^^ end wavelength loop

 20   CONTINUE

      do iw = 1, nw-1
         write(33,333) wl(iw),wu(iw), sdom(1,iw),
     $        (tot_ey(iw,it), it = 1, nt)
         write(34,333) wl(iw),wu(iw), sdom(1,iw),
     $        (tot_fy(iw,it), it = 1, nt)
         write(35,333) wl(iw),wu(iw), sdom(1,iw),
     $        (tot_eav(iw,it), it = 1, nt)
         write(36,333) wl(iw),wu(iw), sdom(1,iw),
     $        (tot_fav(iw,it), it = 1, nt)
         write(37,333) wl(iw),wu(iw), sdom(1,iw),
     $        (tot_ea(iw,it), it = 1, nt)
         write(38,333) wl(iw),wu(iw), sdom(1,iw),
     $        (tot_fa(iw,it), it = 1, nt)

      enddo

 333        format(2(0pf5.1,1x),1pe8.2,24(1x,1pe8.2))



* ____ SECTION 9: STANDARD OUTPUT ______________________________________________

c      call outpt1( outfil, iout, 
c     $     lirrad, laflux, lrates, ljvals, lmmech, lzenit,
c     $     nms, ims, nmj, imj,
c     $     nz, z, tlev, aircon, izout,
c     $     nw, wl, etf, iwfix,
c     $     nt, t, sza, itfix,
c     $     ns, slabel, isfix, nj, jlabel, ijfix,
c     $     svj_zj, svj_tj, svj_zt,
c     $     svr_zs, svr_ts, svr_zt,
c     $     svf_zw, svf_tw, svf_zt,
c     $     svi_zw, svi_tw, svi_zt )

 30   continue

*_______________________________________________________________________

      IF(intrct) THEN
         WRITE(*,*) 'do you want to do another calculation?'
         WRITE(*,*) 'y = yes'
         WRITE(*,*) 'any other key = no'
         READ(*,1001) again
 1001    FORMAT(A1)
         IF(again .EQ. 'y' .OR. again .EQ. 'Y') GO TO 1000
      ENDIF

      CLOSE(iout)
      CLOSE(kout)
      END




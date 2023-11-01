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


*=============================================================================*

      SUBROUTINE setalb(albnew,nw,wl,albedo)

*-----------------------------------------------------------------------------*
*=  PURPOSE:                                                                 =*
*=  Set the albedo of the surface.  The albedo is assumed to be Lambertian,  =*
*=  i.e., the reflected light is isotropic, and independent of direction     =*
*=  of incidence of light.  Albedo can be chosen to be wavelength dependent. =*
*-----------------------------------------------------------------------------*
*=  PARAMETERS:                                                              =*
*=  NW      - INTEGER, number of specified intervals + 1 in working       (I)=*
*=            wavelength grid                                                =*
*=  WL     - REAL, vector of lower limits of wavelength intervals in      (I)=*
*=           working wavelength grid                                         =*
*=  ALBEDO  - REAL, surface albedo at each specified wavelength           (O)=*
*-----------------------------------------------------------------------------*

      IMPLICIT NONE
      INCLUDE 'params'

* input: (wavelength working grid data)

      INTEGER nw
      REAL wl(kw)

      REAL albnew

* output:
      REAL albedo(kw)

* local:
      INTEGER iw
*_______________________________________________________________________

      DO 10, iw = 1, nw - 1
         albedo(iw) = albnew
   10 CONTINUE

* alternatively, can input wavelenght-dependent values if avaialble.
*_______________________________________________________________________

      RETURN
      END

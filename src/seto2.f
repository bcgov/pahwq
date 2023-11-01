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

      SUBROUTINE seto2(nz, z, nw, wl, cz, o2xs1, dto2)

*-----------------------------------------------------------------------------*
*=  PURPOSE:                                                                 =*
*=  Set up an altitude profile of air molecules.  Subroutine includes a      =*
*=  shape-conserving scaling method that allows scaling of the entire        =*
*=  profile to a given sea-level pressure.                                   =*
*-----------------------------------------------------------------------------*
*=  PARAMETERS:                                                              =*
*=  NZ      - INTEGER, number of specified altitude levels in the working (I)=*
*=            grid                                                           =*
*=  Z       - REAL, specified altitude working grid (km)                  (I)=*
*=  NW      - INTEGER, number of specified intervals + 1 in working       (I)=*
*=            wavelength grid                                                =*
*=  WL      - REAL, vector of lower limits of wavelength intervals in     (I)=*
*=            working wavelength grid                                        =*
*=            and each specified wavelength                                  =*
*=  CZ      - REAL, number of air molecules per cm^2 at each specified    (O)=*
*=            altitude layer                                                 =*
*-----------------------------------------------------------------------------*

      IMPLICIT NONE
      INCLUDE 'params'

* input: (grids)

      REAL wl(kw)
      REAL z(kz)
      INTEGER iw, nw
      INTEGER iz, nz
      REAL cz(kz)
      REAL o2xs1(kw)

* output:
*  O2 absorption optical depth per layer at each wavelength

      REAL dto2(kz,kw)

*_______________________________________________________________________
*  Assumes that O2 = 20.95 % of air density.  If desire different O2 
*    profile (e.g. for upper atmosphere) then can load it here.

      DO iz = 1, nz
         DO iw =1, nw - 1   
            dto2(iz,iw) = 0.2095 * cz(iz) * o2xs1(iw)
         ENDDO  
      ENDDO

*_______________________________________________________________________

      RETURN
      END

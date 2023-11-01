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

*_______________________________________________________________________

      SUBROUTINE wshift(mrefr, n, w, airden)

* Shift wavelength scale between air and vacuum.
* if mrefr = 1, shift input waveelengths in air to vacuum.
* if mrefr = -1, shift input wavelengths from vacuum to air
* if any other number, don't shift

      IMPLICIT none
      INCLUDE 'params'

* inputs

      INTEGER mrefr, n
      REAL w(n), airden

* output = modified w(n)

* internal

      INTEGER i
      REAL refrac
      EXTERNAL refrac

*_______________________________________________________________________


      IF(mrefr .EQ. 1) THEN
         DO i = 1, n
            w(i) = w(i) * refrac(w(i),airden)
         ENDDO
      ELSEIF(mrefr .EQ. -1) THEN
         DO i = 1, n
            w(i) = w(i) / refrac(w(i),airden)
         ENDDO
      ENDIF

      END
*_______________________________________________________________________
*_______________________________________________________________________

      FUNCTION refrac(w,airden)

      IMPLICIT NONE

* input vacuum wavelength, nm and air density, molec cm-3

      REAL w, airden

* output refractive index for standard air
* (dry air at 15 deg. C, 101.325 kPa, 0.03% CO2)

      REAL refrac

* internal

      REAL sig,  dum

* from CRC Handbook, originally from Edlen, B., Metrologia, 2, 71, 1966.
* valid from 200 nm to 2000 nm
* beyond this range, use constant value

      sig = 1.E3/w

      IF (w .LT. 200.) sig = 1.E3/200.
      IF (w .GT. 2000.) sig = 1.E3/2000.

      dum = 8342.13 + 2406030./(130. - sig*sig) + 
     $     15997./(38.9 - sig*sig)

* adjust to local air density

      dum = dum * airden/(2.69e19 * 273.15/288.15)

* index of refraction:

      refrac = 1. + 1.E-8 * dum

      RETURN
      END

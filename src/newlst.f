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

      SUBROUTINE newlst(ns,slabel,nj,jlabel)

* The only serve to print a list of the spectral weighting
* functions.  If new functions (e.g. action spectra, photo-reactions)
* are added, this list should be used to replace the list in the
* default input files (defin1, defin2, etc.).  The true/false toggle
* will be set to F, and should be changed manually to select weighting
* functions for output. Note that if many more functions are added, it
* may be necessary to increase the parameters ks and kj in the include
* file 'params'
* The program will stop after writing this list.
* Comment out these lines when not generating a new list.

      IMPLICIT NONE
      integer ns, is, nj, ij
      character*50 slabel(ns), jlabel(nj)

       OPEN(UNIT=50,FILE='spectra.list',STATUS='NEW')
       WRITE(50,500)

  500  FORMAT(5('='),1X,'Available spectral weighting functions:')
       DO is = 1, ns
          WRITE(50,505) is, slabel(is)
       ENDDO

       WRITE(50,510)
  510  FORMAT(5('='),1X,'Available photolysis reactions')
       DO ij = 1, nj
          WRITE(50,505) ij, jlabel(ij)
       ENDDO
  505  FORMAT('F',I3,1X,A50)

       WRITE(50,520)
  520  FORMAT(66('='))
       CLOSE (50)
       STOP
       RETURN
       END

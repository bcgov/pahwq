      SUBROUTINE swdom(nw,wl,wc, jdom,dlabel,sdom,
     $     fi, akv, bkv, ckv)

* by S.Madronich, Oct 2015.
* Purpose: load and w-grid the spectral absorption coefficient for waters (lakes, oceans)
* UNITS = 1/meter
* Can use either a generic equation (exponential decrease with wavelength)
* or measured DOM spectral absorption data from various groups and locations 
* e.g. Giles Lake from Craig Williamson, Priv comm. 2015.

      IMPLICIT NONE
      INCLUDE 'params'
      INTEGER nw, iw

      INTEGER jdom
      REAL sdom(kdom,kw)
      CHARACTER*50 dlabel(kdom), fi
      REAL akv, bkv, ckv

      INTEGER kdata
      PARAMETER(kdata = 1000)
      REAL x(kdata), y(kdata)
      INTEGER i, n, n1

      REAL wl(kw), wc(kw), yg(kw)
      INTEGER ierr


* generic absorption coefficients from
*  Bricaud A., Morel A. and Prieur L., Absorption by dissolved 
* organic matter of the sea (yellow substance) in the UV and 
* visible domains, Limnol. Oceanogr. 26, 43-53, 1981.
* The pre-exponential at 375 nmn is taken as 0.5/meter, estimated from the ranges 
* given in their Table 3: low 0.06, high 4.24, geometric mean = 0.5
* units are 1/meter

      jdom = 0

      jdom = jdom + 1
      dlabel(jdom) = 'kdom = a*exp(-b*(wvl- c))'
            DO iw = 1, nw-1
         sdom(jdom, iw) = akv * exp(-bkv*(wc(iw) - ckv))
      ENDDO


* get absorption coefficient from simple equation

      jdom = jdom + 1
      dlabel(jdom) = 'generic, Bricaud et al. 1981'
      DO iw = 1, nw-1
         sdom(jdom, iw) = 0.5 * exp(-0.015*(wc(iw) - 375.))
      ENDDO

* get absorption coefficient from user-specified data file:

      jdom = jdom + 1
      fi = 'AQUA/test_abs.dat'
      dlabel(jdom) = fi

      OPEN(unit=kin,file=fi,status='old')
      DO i = 1, kdata
         READ(kin,*,end=99) x(i), y(i)
      ENDDO
 99   CONTINUE
      n = i-1
      CLOSE(kin)

      n1 = n
      CALL terint(nw,wl,yg, n1,x,y, 1,0)
      DO iw = 1, nw-1
         sdom(jdom,iw) = yg(iw)
      ENDDO

**********************
**********************
      RETURN
      END
      

# Makefile for TUV 5.0
# Use with disort (discrete ordinate), or ps2str (2 stream approximation,
# pseudo-spherical correction)
#----------
# EXC      : name of executable
# INCLUDES : required include files
# USE_INCL : object files referencing include file (params)
# FOBJS    : all required object files that do not use the include file
#

EXC = tuv

INCLUDES = params

USE_INCL = TUV.o \
           grids.o \
           rdinp.o rdetfl.o rdxs.o \
           swphys.o swbiol.o swchem.o rxn.o qys.o \
           wshift.o \
	   vpair.o vptmp.o vpo3.o \
	   odrl.o odo3.o \
           setaer.o setalb.o setcld.o setsnw.o \
           setno2.o seto2.o setso2.o \
           sphers.o  \
	   la_srb.o \
           rtrans.o \
	   savout.o \
           newlst.o \
           wrflut.o \
           aquat.o \
           swdom.o

FOBJS = numer.o functs.o orbit.o terint.o

#----------
# FC   : FORTRAN compiler
#        Linux users:  try FC = g77
#        Cray users :  try FC = f90
FC = gfortran

# FFLAGS : command line options to compiler call (if not set, default is
#          probably some basic optimization level)
# CRAN sets '-pedantic' so some extra warnings are emitted, but are not a problem
# FFLAGS =

# LIBS  : libraries required
# LIBS=

# Tell where to find libpcre2-8, especially on GitHub Actions
LDFLAGS=`pkg-config libpcre2-8 --libs-only-L`

#----------
# make the executable and copy to ../inst/bin, then remove it from src/
$(EXC):		$(FOBJS) $(USE_INCL)
		$(FC) $(FFLAGS) $(FOBJS) $(USE_INCL) $(LDFLAGS) $(LIBS) -o $@ && \
		mkdir -p ../inst/bin && \
		cp $@ ../inst/bin/ && \
		rm -f $@

$(USE_INCL):	$(INCLUDES)

.PHONY: clean

clean:
		rm -f core $(EXC) $(USE_INCL) $(FOBJS)

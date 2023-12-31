% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ptlm.R
\name{nlc50}
\alias{nlc50}
\title{Calculate the NLC50 value for a PAH or HAC using the Target Lipid Model (TLM)}
\usage{
nlc50(chemical, slope = -0.94, HC5 = 9.3, dc_pah = -0.364, dc_hac = -0.471)
}
\arguments{
\item{chemical}{The chemical (a HAC or PAH) of interest}

\item{slope}{The slope in Equation 1 in McGrath et al. 2018. The default
value is -0.94, which is taken from Table 3 in McGrath et al. 2018. It
is not recommended to adjust this without good justification.}

\item{HC5}{The 5th percentile of the SSD of critical body burdens predicted
to be hazardous for no more than 5\% of the species. Default value is 9.3
umol/g, which was calculated using Equation 3 in McGrath et al 2018. It is
not recommended to adjust this without good justification.}

\item{dc_pah}{Chemical class correction (Δc) for PAHs, as reported in McGrath et al. 2018.}

\item{dc_hac}{Chemical class correction (Δc) for HACs, as reported in McGrath et al. 2021.}
}
\value{
NLC50 value, in ug/L
}
\description{
This uses the equation and default values from McGrath et al. 2018.
}
\examples{
nlc50("anthracene")
}
\references{
McGrath, J.A., Fanelli, C.J., Di Toro, D.M., Parkerton, T.F., Redman, A.D.,
Paumen, M.L., Comber, M., Eadsforth, C.V. and den Haan, K. (2018),
Re-evaluation of target lipid model–derived HC5 predictions for hydrocarbons.
Environ Toxicol Chem, 37: 1579-1593. https://doi.org/10.1002/etc.4100

McGrath, J., Getzinger, G., Redman, A.D., Edwards, M., Martin Aparicio, A.
and Vaiopoulou, E. (2021), Application of the Target Lipid Model to Assess
Toxicity of Heterocyclic Aromatic Compounds to Aquatic Organisms. Environ
Toxicol Chem, 40: 3000-3009. https://doi.org/10.1002/etc.5194
}

# setup_tuv_options() works with minimal specifications

    Code
      print(setup_tuv_options(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_km = 0.342, DOC = 5, date = "2023-06-21", write = FALSE))
    Output
       [1] "20.11 0.018   305 ! a,b,c for: kvdom = a exp(-b(wvl-c)). ACT: a = kd(305), b = Sk, c = wavelength, wvl = 305"
       [2] "0.25                 ! ydepth, m"                                                                            
       [3] "49.601632                     ! lat, negative S of Equator"                                                  
       [4] "-119.605862                     ! lon, negative W of Greenwich (zero) meridian"                              
       [5] "0.342                 ! surface elevation, km above sea level"                                               
       [6] "0                   ! timezone: Local Time - UTC"                                                            
       [7] "2023                    ! iyear"                                                                             
       [8] "6                   ! imonth"                                                                                
       [9] "21                     ! iday"                                                                               
      [10] "0                  ! tstart, hours local time"                                                               
      [11] "23                   ! tstop, hours local time"                                                              
      [12] "24                  ! number of time steps"                                                                  
      [13] "0.07                  ! surface albedo"                                                                      
      [14] "300                   ! o3_tc  ozone column, Dobson Units (DU)"                                              
      [15] "0                  ! so2_tc SO2 column, DU"                                                                  
      [16] "0                  ! no2_tc NO2 column, DU"                                                                  
      [17] "0                  ! taucld - cloud optical depth"                                                           
      [18] "4                   ! zbase - cloud base, km"                                                                
      [19] "5                    ! ztop - cloud top, km"                                                                 
      [20] "0.235                  ! tauaer - aerosol optical depth at 550 nm"                                           
      [21] "0.99                  ! ssaaer - aerosol single scattering albedo"                                           
      [22] "1                   ! alpha - aerosol Angstrom exponent"                                                     
      [23] "279.5               ! starting wavelength, nm"                                                               
      [24] "400.5                 ! end wavelength, nm"                                                                  
      [25] "121               ! number of wavelength intervals"                                                          
      [26] "-2                    ! nstr, use -2 for fast, 4 for slightly more accurate"                                 
      [27] "T             ! out_irrad_y, T/F, planar spectral irradiance at ydepth"                                      
      [28] "T             ! out_aflux_y, T/F, scalar spectral irradiance (actinic flux)  at depth"                       
      [29] "T           ! out_irrad_ave, T/F, planar irrad., averaged 0-ydepth"                                          
      [30] "T           ! out_aflux_ave, T/F, scalar, ave 0-ydepth"                                                      
      [31] "T           ! out_irrad_atm, T/F, planar, in atmosphere"                                                     
      [32] "T           ! out_aflux_atm, T/F, scalar, in atmosphere"                                                     

# setup_tuv_options errors without required arguments

    Code
      setup_tuv_options()
    Condition
      Error:
      ! date must be specified

---

    Code
      setup_tuv_options(date = "2023-10-24")
    Condition
      Error:
      ! DOC must be numeric

---

    Code
      setup_tuv_options(date = "2023-10-24", DOC = 5)
    Condition
      Error:
      ! Missing required fields: depth_m, lat, lon, elev_km


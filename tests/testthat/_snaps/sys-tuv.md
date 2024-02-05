# set_tuv_aq_params() works with minimal specifications

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, DOC = 5, date = "2023-06-21", write = FALSE))
    Output
       [1] "20.11 0.018 305 ! a,b,c for: kvdom = a exp(-b(wvl-c)). a = kd(305), b = Sk, c = wavelength, wvl = 305"
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
      [14] "359.937                   ! o3_tc  ozone column, Dobson Units (DU)"                                   
      [15] "0                  ! so2_tc SO2 column, DU"                                                           
      [16] "0                  ! no2_tc NO2 column, DU"                                                           
      [17] "0                  ! taucld - cloud optical depth"                                                    
      [18] "4                   ! zbase - cloud base, km"                                                         
      [19] "5                    ! ztop - cloud top, km"                                                          
      [20] "0.0641989811085006                  ! tauaer - aerosol optical depth at 550 nm"                       
      [21] "0.99                  ! ssaaer - aerosol single scattering albedo"                                    
      [22] "1                   ! alpha - aerosol Angstrom exponent"                                              
      [23] "279.5               ! starting wavelength, nm"                                                        
      [24] "500.5                 ! end wavelength, nm"                                                           
      [25] "221               ! number of wavelength intervals"                                                   
      [26] "-2                    ! nstr, use -2 for fast, 4 for slightly more accurate"                          
      [27] "T             ! out_irrad_y, T/F, planar spectral irradiance at ydepth"                               
      [28] "T             ! out_aflux_y, T/F, scalar spectral irradiance (actinic flux)  at depth"                
      [29] "T           ! out_irrad_ave, T/F, planar irrad., averaged 0-ydepth"                                   
      [30] "T           ! out_aflux_ave, T/F, scalar, ave 0-ydepth"                                               
      [31] "T           ! out_irrad_atm, T/F, planar, in atmosphere"                                              
      [32] "T           ! out_aflux_atm, T/F, scalar, in atmosphere"                                              

# set_tuv_aq_params errors without required arguments

    Code
      set_tuv_aq_params()
    Condition
      Error:
      ! date must be specified

---

    Code
      set_tuv_aq_params(date = "2023-10-24")
    Condition
      Error:
      ! You must set either `DOC` or `Kd_ref` (optionally with `Kd_wvl`), but not both.

---

    Code
      set_tuv_aq_params(date = "2023-10-24", DOC = 5)
    Condition
      Error:
      ! 'lon' must be a numeric value between -140 and -53

# set_tuv_aq_params works with o3_tc and tauaer set to 'default'

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, DOC = 5, date = "2023-06-21", o3_tc = "default", tauaer = "default",
        write = FALSE))
    Output
       [1] "20.11 0.018 305 ! a,b,c for: kvdom = a exp(-b(wvl-c)). a = kd(305), b = Sk, c = wavelength, wvl = 305"
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
      [24] "500.5                 ! end wavelength, nm"                                                           
      [25] "221               ! number of wavelength intervals"                                                   
      [26] "-2                    ! nstr, use -2 for fast, 4 for slightly more accurate"                          
      [27] "T             ! out_irrad_y, T/F, planar spectral irradiance at ydepth"                               
      [28] "T             ! out_aflux_y, T/F, scalar spectral irradiance (actinic flux)  at depth"                
      [29] "T           ! out_irrad_ave, T/F, planar irrad., averaged 0-ydepth"                                   
      [30] "T           ! out_aflux_ave, T/F, scalar, ave 0-ydepth"                                               
      [31] "T           ! out_irrad_atm, T/F, planar, in atmosphere"                                              
      [32] "T           ! out_aflux_atm, T/F, scalar, in atmosphere"                                              

# correct combinations of Kd_ref, Kd_wvl, DOC

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, Kd_ref = 40, date = "2023-06-21", write = FALSE))
    Output
       [1] "40 0.018 305 ! a,b,c for: kvdom = a exp(-b(wvl-c)). a = kd(305), b = Sk, c = wavelength, wvl = 305"
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
      [14] "359.937                   ! o3_tc  ozone column, Dobson Units (DU)"                                
      [15] "0                  ! so2_tc SO2 column, DU"                                                        
      [16] "0                  ! no2_tc NO2 column, DU"                                                        
      [17] "0                  ! taucld - cloud optical depth"                                                 
      [18] "4                   ! zbase - cloud base, km"                                                      
      [19] "5                    ! ztop - cloud top, km"                                                       
      [20] "0.0641989811085006                  ! tauaer - aerosol optical depth at 550 nm"                    
      [21] "0.99                  ! ssaaer - aerosol single scattering albedo"                                 
      [22] "1                   ! alpha - aerosol Angstrom exponent"                                           
      [23] "279.5               ! starting wavelength, nm"                                                     
      [24] "500.5                 ! end wavelength, nm"                                                        
      [25] "221               ! number of wavelength intervals"                                                
      [26] "-2                    ! nstr, use -2 for fast, 4 for slightly more accurate"                       
      [27] "T             ! out_irrad_y, T/F, planar spectral irradiance at ydepth"                            
      [28] "T             ! out_aflux_y, T/F, scalar spectral irradiance (actinic flux)  at depth"             
      [29] "T           ! out_irrad_ave, T/F, planar irrad., averaged 0-ydepth"                                
      [30] "T           ! out_aflux_ave, T/F, scalar, ave 0-ydepth"                                            
      [31] "T           ! out_irrad_atm, T/F, planar, in atmosphere"                                           
      [32] "T           ! out_aflux_atm, T/F, scalar, in atmosphere"                                           

---

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, Kd_ref = 40, Kd_wvl = 280, date = "2023-06-21", write = FALSE))
    Output
       [1] "40 0.018 280 ! a,b,c for: kvdom = a exp(-b(wvl-c)). a = kd(305), b = Sk, c = wavelength, wvl = 305"
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
      [14] "359.937                   ! o3_tc  ozone column, Dobson Units (DU)"                                
      [15] "0                  ! so2_tc SO2 column, DU"                                                        
      [16] "0                  ! no2_tc NO2 column, DU"                                                        
      [17] "0                  ! taucld - cloud optical depth"                                                 
      [18] "4                   ! zbase - cloud base, km"                                                      
      [19] "5                    ! ztop - cloud top, km"                                                       
      [20] "0.0641989811085006                  ! tauaer - aerosol optical depth at 550 nm"                    
      [21] "0.99                  ! ssaaer - aerosol single scattering albedo"                                 
      [22] "1                   ! alpha - aerosol Angstrom exponent"                                           
      [23] "279.5               ! starting wavelength, nm"                                                     
      [24] "500.5                 ! end wavelength, nm"                                                        
      [25] "221               ! number of wavelength intervals"                                                
      [26] "-2                    ! nstr, use -2 for fast, 4 for slightly more accurate"                       
      [27] "T             ! out_irrad_y, T/F, planar spectral irradiance at ydepth"                            
      [28] "T             ! out_aflux_y, T/F, scalar spectral irradiance (actinic flux)  at depth"             
      [29] "T           ! out_irrad_ave, T/F, planar irrad., averaged 0-ydepth"                                
      [30] "T           ! out_aflux_ave, T/F, scalar, ave 0-ydepth"                                            
      [31] "T           ! out_irrad_atm, T/F, planar, in atmosphere"                                           
      [32] "T           ! out_aflux_atm, T/F, scalar, in atmosphere"                                           

---

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, Kd_wvl = 280, DOC = 5, date = "2023-06-21", write = FALSE))
    Message
      `Kd_wvl` value is ignored because `DOC` is supplied and `Kd_ref` is not.
    Output
       [1] "20.11 0.018 305 ! a,b,c for: kvdom = a exp(-b(wvl-c)). a = kd(305), b = Sk, c = wavelength, wvl = 305"
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
      [14] "359.937                   ! o3_tc  ozone column, Dobson Units (DU)"                                   
      [15] "0                  ! so2_tc SO2 column, DU"                                                           
      [16] "0                  ! no2_tc NO2 column, DU"                                                           
      [17] "0                  ! taucld - cloud optical depth"                                                    
      [18] "4                   ! zbase - cloud base, km"                                                         
      [19] "5                    ! ztop - cloud top, km"                                                          
      [20] "0.0641989811085006                  ! tauaer - aerosol optical depth at 550 nm"                       
      [21] "0.99                  ! ssaaer - aerosol single scattering albedo"                                    
      [22] "1                   ! alpha - aerosol Angstrom exponent"                                              
      [23] "279.5               ! starting wavelength, nm"                                                        
      [24] "500.5                 ! end wavelength, nm"                                                           
      [25] "221               ! number of wavelength intervals"                                                   
      [26] "-2                    ! nstr, use -2 for fast, 4 for slightly more accurate"                          
      [27] "T             ! out_irrad_y, T/F, planar spectral irradiance at ydepth"                               
      [28] "T             ! out_aflux_y, T/F, scalar spectral irradiance (actinic flux)  at depth"                
      [29] "T           ! out_irrad_ave, T/F, planar irrad., averaged 0-ydepth"                                   
      [30] "T           ! out_aflux_ave, T/F, scalar, ave 0-ydepth"                                               
      [31] "T           ! out_irrad_atm, T/F, planar, in atmosphere"                                              
      [32] "T           ! out_aflux_atm, T/F, scalar, in atmosphere"                                              

---

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, Kd_ref = 40, DOC = 5, date = "2023-06-21", write = FALSE))
    Condition
      Error:
      ! You must set either `DOC` or `Kd_ref` (optionally with `Kd_wvl`), but not both.

---

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, Kd_ref = 40, DOC = 5, date = "2023-06-21", write = FALSE))
    Condition
      Error:
      ! You must set either `DOC` or `Kd_ref` (optionally with `Kd_wvl`), but not both.

---

    Code
      print(set_tuv_aq_params(depth_m = 0.25, lat = 49.601632, lon = -119.605862,
        elev_m = 342, Kd_wvl = 280, date = "2023-06-21", write = FALSE))
    Condition
      Error:
      ! You must set either `DOC` or `Kd_ref` (optionally with `Kd_wvl`), but not both.


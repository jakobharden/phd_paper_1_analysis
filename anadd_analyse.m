## Analyse signals sequences and export results to TeX files (technical validation)
##
## Usage: anadd_analyse()
##
## Note: This program allows to reproduce the analysis results shown in the manuscript in section 'Technical validation'.
##
## see also: anadd_dsdefs, quantile, tex_struct_export, hgsave, saveas
##
## Copyright 2025 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
## License: MIT
## This file is part of the PhD thesis of Jakob Harden.
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
## documentation files (the “Software”), to deal in the Software without restriction, including without 
## limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
## the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
## 
## THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
## THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##
function anadd_analyse()
  
  ## load data set definition data structure
  [dsd, ap] = anadd_dsdefs();
  
  ## create analysis result directories
  if (exist(ap.paths.expbin, 'dir') != 7)
    mkdir(ap.paths.expbin);
  endif
  if (exist(ap.paths.expbin, 'dir') != 7)
    mkdir(ap.paths.exptex);
  endif
  
  ## analyse signal sequences and export results
  anadd_analyse_analyzeplot(ap, dsd, 1, 1); # test series 5, air, D = 25mm, primary channel, longitudinal
  anadd_analyse_analyzeplot(ap, dsd, 2, 1); # test series 5, air, D = 50mm, primary channel, longitudinal
  anadd_analyse_analyzeplot(ap, dsd, 3, 1); # test series 5, air, D = 70mm, primary channel, longitudinal
  anadd_analyse_analyzeplot(ap, dsd, 4, 1); # test series 6, water, D = 25mm, primary channel, longitudinal
  anadd_analyse_analyzeplot(ap, dsd, 5, 1); # test series 6, water, D = 50mm, primary channel, longitudinal
  anadd_analyse_analyzeplot(ap, dsd, 6, 1); # test series 6, water, D = 70mm, primary channel, longitudinal
  anadd_analyse_analyzeplot(ap, dsd, 7, 1); # test series 7, aluminium cylinder, D = 50mm, primary channel, longitudinal
  anadd_analyse_analyzeplot(ap, dsd, 7, 2); # test series 7, aluminium cylinder, D = 50mm, secondary channel, transverse
  
endfunction

function anadd_analyse_analyzeplot(p_ap, p_dsd, p_gid, p_cn)
  ## Export analysis results to GNU Octave binary and TeX file
  ##
  ## p_ap  ... analysis parameter structure, <struct_anadp_param>
  ## p_dsd ... data set definition data structure, <struct_anadd_dsdefs>
  ## p_gid ... data set group id, group of data sets, <uint>
  ## p_cn  ... channel number (1 = primary/compression wave, 2 = secondary/shear wave), <uint>
  
  ## analyse signal sequence
  [ds, fh] = anadd_analyse_signalsequence(p_ap, p_dsd, p_gid, p_cn);
  
  ## get file name without extension (= variable name for the TeX export)
  ## append channel name character (lower case) to data set group name
  fn = sprintf('%s_%s', p_dsd.gdefs(p_gid).gname, p_dsd.cn_char_lc{p_cn});
  
  ## save data structure, binary GNU Octave file
  if (p_ap.post.save_bin)
    fpbin = fullfile(p_ap.paths.expbin, sprintf('%s.oct', fn));
    save('-binary', fpbin, 'ds');
  endif
  
  ## export data structure, TeX file
  if (p_ap.post.save_tex)
    fptex = fullfile(p_ap.paths.exptex, fn);
    errcode = tex_struct_export(ds, fn, fptex);
  endif
  
  ## save figure
  if (p_ap.post.save_fig)
    fpfig = fullfile(p_ap.paths.expbin, sprintf('%s.ofig', fn));
    fppng = fullfile(p_ap.paths.expbin, sprintf('%s.png', fn));
    hgsave(fh, fpfig);
    saveas(fh, fppng, 'png');
  endif
  
endfunction

function [r_di, r_tm, r_hu, r_cs] = anadd_analyse_paramuncert(p_ds, p_cn, p_mid, p_ap)
  ## Evaluate computation parameters and their respective uncertainty
  ##
  ## p_ds  ... data set structure, <struct>
  ## p_cn  ... channel number (1 = primary/compression wave, 2 = secondary/shear wave), <uint>
  ## p_mid ... reference material id, <uint>
  ## p_ap  ... analysis parameter structure, <struct_anadp_param>
  ## r_di  ... return: ultrasonic measuring distance and uncertainty, meter, [dist, dist_low, dist_high], [<dbl>, <dbl>, <dbl>]
  ## r_tm  ... return: environment temperature and uncertainty, degCelsius, [temp, temp_low, temp_high], [<dbl>, <dbl>, <dbl>]
  ## r_hu  ... return: environment humidity (relative) and uncertainty, percent, [humid, humid_low, humid_high], [<dbl>, <dbl>, <dbl>]
  ## r_cs  ... return: speed-of-sound and uncertainty, meter/Second, [cs, cs_high, cs_low], [<dbl>, <dbl>, <dbl>]
  
  ## ultrasonic measuring distance
  r_di = zeros(1, 3);
  switch (p_cn)
    case 1
      ## channel 1, compression wave, longitudinal
      r_di(1) = p_ds.tst.s04.d04.v; # read distance from data set, mm, middle value
    case 2
      ## channel 2, shear wave, transverse
      r_di(1) = p_ds.tst.s05.d04.v; # read distance from data set, mm, middle value
  endswitch
  ## procedural and measurement uncertainties
  switch (p_mid)
    case 1
      ## air
      r_di(2) = r_di(1) + p_ap.air_umd_uncert(1) + p_ap.dist_uncert(1); # mm, lower limit
      r_di(3) = r_di(1) + p_ap.air_umd_uncert(2) + p_ap.dist_uncert(1); # mm, upper limit
    case 2
      ## water
      r_di(2) = r_di(1) + p_ap.water_umd_uncert(1) + p_ap.dist_uncert(1); # mm, lower limit
      r_di(3) = r_di(1) + p_ap.water_umd_uncert(2) + p_ap.dist_uncert(1); # mm, upper limit
    case 3
      ## aluminium cylinder
      r_di(2) = r_di(1) + p_ap.alu_umd_uncert(1) + p_ap.dist_uncert(1); # mm, lower limit
      r_di(3) = r_di(1) + p_ap.alu_umd_uncert(2) + p_ap.dist_uncert(1); # mm, upper limit
  endswitch
  r_di /= 1000; # convert mm to m
  
  ## temperature
  r_tm = zeros(1, 3);
  r_tm(1) = p_ds.tst.s09.d02.v; # read environment temperature from data set, deg Celsius, middle value
  r_tm(2) = r_tm(1) + p_ap.temp_uncert(1);, # deg Celsius, lower limit
  r_tm(3) = r_tm(1) + p_ap.temp_uncert(2); # deg Celsius, upper limit
  
  ## humidity
  delta_temp = abs(p_ap.humid_stdtemp - r_tm(1)); # difference to standard temperature
  r_hu = zeros(1, 3);
  r_hu(1) = p_ds.tst.s09.d03.v; # read environment humidity from data set, %, middle value
  r_hu(2) = r_hu(1) + p_ap.humid_uncert(1) + p_ap.humid_uncert_rel(1) * delta_temp; # %, lower limit
  r_hu(3) = r_hu(1) + p_ap.humid_uncert(2) + p_ap.humid_uncert_rel(2) * delta_temp; # %, upper limit
  
  ## speed of sound
  r_cs = zeros(1, 3);
  switch (p_mid)
    case 1
      ## air (longitudinal, compression wave)
      ## 2-dimensional interpolation using values from literature
      r_cs = interp2(p_ap.speed_air_humid, p_ap.speed_air_temp, p_ap.speed_air_cs, r_hu, r_tm, 'linear');
    case 2
      ## water (longitudinal, compression wave)
      ## 1-dimensional interpolation using values from literature
      r_cs = interp1(p_ap.speed_water_temp, p_ap.speed_water_cs, r_tm, 'linear');
    case 3
      ## aluminium cylinder
      ## Reference: Garrett, Steven L. 2020. Understanding Acoustics : An Experimentalist’s View of Sound and Vibration. 2nd edition.
      ##            https://link.springer.com/book/10.1007/978-3-030-44787-8 (open access)
      ##            page: 187
      ## weight
      wght = zeros(1, 3);
      wght(1) = p_ds.tst.s02.d02.v; # gram, measurement, middle value
      wght(2) = wght(1) + p_ap.wght_uncert(1); # gram, lower limit
      wght(3) = wght(1) + p_ap.wght_uncert(2); # gram, upper limit
      ## diameter
      dia = zeros(1, 3);
      dia(1) = p_ds.tst.s02.d03.v; # mm, measurement, middle value
      dia(2) = dia(1) + p_ap.dist_uncert(1); # mm, lower limit
      dia(3) = dia(1) + p_ap.dist_uncert(2); # mm, upper limit
      ## height
      hgt = zeros(1, 3);
      hgt(1) = p_ds.tst.s02.d04.v; # mm, measurement, middle value
      hgt(2) = hgt(1) + p_ap.dist_uncert(1); # mm, lower limit
      hgt(3) = hgt(2) + p_ap.dist_uncert(2); # mm, upper limit
      ## volume, v = d^2 * pi / 4 * h
      vol = dia.^2 .* hgt * pi / (4 * 1000); # cm^3, middle value, lower limit, upper limit
      ## density, rho = m / v
      rho = zeros(1, 3);
      rho(1) = wght(1) / vol(1); # density, g/cm^3, middle value
      rho(2) = wght(2) / vol(3); # density, g/cm^3, lower limit
      rho(3) = wght(3) / vol(2); # density, g/cm^3, upper limit
      ## Poisson ratio, nu = E / (2 * G) - 1
      Emod = [mean(p_ap.alu_emod), p_ap.alu_emod(1), p_ap.alu_emod(2)]; # Young's modulus, GPa, middle value, lower limit, upper limit
      Gmod = [mean(p_ap.alu_gmod), p_ap.alu_gmod(1), p_ap.alu_gmod(2)]; # shear modulus, GPa, middle value, lower limit, upper limit
      nu = Emod ./ (2 * Gmod) - 1; # Poisson ratio, middle value, lower limit, upper limit
      switch (p_cn)
        case 1
          ## longitudinal, compression wave, channel 1
          ## c = sqrt((E * (1 - nu)) / (rho * (1 + nu) * (1 - 2 * nu)))
          r_cs(1) = sqrt(Emod(1) * (1 - nu(1)) / (rho(1) * (1 + nu(1)) * (1 - 2 * nu(1)))); # m/Sec, middle value
          r_cs(2) = sqrt(Emod(2) * 1e6 * (1 - nu(2)) / (rho(3) * (1 + nu(2)) * (1 - 2 * nu(2)))); # m/Sec, lower limit
          r_cs(3) = sqrt(Emod(3) * 1e6 * (1 - nu(3)) / (rho(2) * (1 + nu(3)) * (1 - 2 * nu(3)))); # m/Sec, upper limit
        case 2
          ## transverse, shear wave, channel 2
          ## c = sqrt(G / rho)
          r_cs(1) = sqrt(Gmod(1) * 1e6 / rho(1)); # m/Sec, middle value
          r_cs(2) = sqrt(Gmod(2) * 1e6 / rho(3)); # m/Sec, lower limit
          r_cs(3) = sqrt(Gmod(3) * 1e6 / rho(2)); # m/Sec, upper limit
      endswitch
  endswitch
  
endfunction


function [r_n0, r_n1, r_n2, r_n3, r_cp0, r_cp1, r_cp2, r_cp3] = anadd_analyse_charpoints(p_ap, p_ds, p_cn, p_umd, p_cs)
  ## Get signal sample indices and sample index ranges of characteristic points
  ##
  ## p_ap  ... analysis parameter structure, <struct_anadp_param>
  ## p_ds  ... data set structure, <struct>
  ## p_cn  ... channel number (1 = primary/compression wave, 2 = secondary/shear wave), <uint>
  ## p_umd ... ultrasonic measuring distance with uncertainties [umd_mid, umd_low, umd_high], [<dbl>, <dbl>, <dbl>]
  ## p_cs  ... speed of sound with uncertainties [c_mid, c_low, c_high], [<dbl>, <dbl>, <dbl>]
  ## r_n0  ... return: sample index of trigger point, <uint>
  ## r_n1  ... return: sample index of onset point of electromagnetic response section (ERS), <uint>
  ## r_n2  ... return: sample index of end point of electromagnetic response section (ERS), <uint>
  ## r_n3  ... return: sample index of last point to be displayed/plotted, <uint>
  ## r_cp0 ... return: trigger-delay in uSec, char. point 0, pulse excitation event, [mid, lower_limit, upper_limit], [<dbl>]
  ## r_cp1 ... return: time-of-flight in uSec, char. point 1, first appearance of sound wave, [mid, lower_limit, upper_limit], [<dbl>]
  ## r_cp2 ... return: time-of-flight in uSec, char. point 2, first reflection of sound wave, [mid, lower_limit, upper_limit], [<dbl>]
  ## r_cp3 ... return: time-of-flight in uSec, char. point 3, second reflection of sound wave, [mid, lower_limit, upper_limit], [<dbl>]
  ##
  ## Note: characteristic points are: zero time (trigger event), first appearance of the wave, first/second reflection of the wave
  
  ## get trigger point sample index, samples
  switch (p_cn)
    case 1
      ## channel 1, compression wave
      subds = p_ds.tst.s06;
    case 2
      ## channel 2, shear wave
      subds = p_ds.tst.s07;
  endswitch
  
  ## swap min/max of speed-of-sound for the division
  p_cs([2, 3]) = p_cs([3, 2]);
  
  ## get sampling rate, number of samples per second
  sr = subds.d07.v; # Hz
  
  ## offset between zero-point (t = 0) and beginning of electromagnetic response section => trigger-delay
  ers_start = [p_ap.ers_delay, p_ap.ers_delay + p_ap.ers_delay_uncert(1), p_ap.ers_delay + p_ap.ers_delay_uncert(2)]; # samples
  
  ## zero point sample index (t = 0)
  r_n0 = subds.d09.v + 1; # samples
  
  ## start sample index of ERS, middle value
  r_n1 = r_n0 + p_ap.ers_delay - 1; # samples
  
  ## end sample index of ERS, middle value
  r_n2 = r_n0 + p_ap.ers_delay + p_ap.ers_length - 1; # samples
  
  ## estimate sample index for the end of the oscillation after the second reflection (approx. 6 * time-of-flight)
  r_n3 = floor(p_umd(3) * 6 / p_cs(2) * sr) + r_n1; # samples
  r_n3 = min([r_n3, size(subds.d13.v, 1)]); # samples, limitend sample index to signal length (avoid index overrun)
  
  ## time offset to the beginning of the eletromagnetic response section, trigger delay
  delta_t = ers_start / sr; # Seconds
  
  ## zero-time considering the trigger delay
  r_cp0 = ones(1, 3) .* delta_t * 1e6; # MicroSeconds
  
  ## estimate time-of-flight based on speed of sound and ultrasonic measuring distance
  r_cp1 = (p_umd ./ p_cs .+ delta_t) * 1e6; # MicroSeconds
  
  ## estimate time-of-flight of the first incoming reflection
  r_cp2 = (3 * p_umd ./ p_cs .+ delta_t) * 1e6; # MicroSeconds
  
  ## estimate time-of-flight of the second incoming reflection
  r_cp3 = (5 * p_umd ./ p_cs .+ delta_t) * 1e6; # MicroSeconds
  
endfunction


function [r_ds, r_fh] = anadd_analyse_signalsequence(p_ap, p_dsd, p_gid, p_cn)
  ## Analyse signal sets
  ##
  ## p_ap  ... analysis parameter structure, <struct>
  ## p_dsd ... data set definition structure, <struct>
  ## p_gid ... data set group id, <uint>
  ## p_cn  ... channel number (1 = primary/compression wave, 2 = secondary/shear wave), <uint>
  ## r_ds  ... return: analysis result data structure, <struct_anadp_analysis>
  ## r_fh  ... return: figure handle, <uint>
  
  ## group definition
  gdef = p_dsd.gdefs(p_gid);
  
  ## data set definitions of current group
  dsdefs = p_dsd.dsdefs(gdef.dsidx);
  
  ## group file path
  fpgrp = p_dsd.fplist{gdef.mid};
  
  ## loop over data sets
  for k = 1 : numel(gdef.dsidx)
    dsdef = dsdefs(k);
    ## data set file path
    dsfp = fullfile(p_dsd.fplist{dsdef.mid}, sprintf('%s.oct', dsdef.dsname));
    ds = load(dsfp, 'dataset').dataset;
    switch (p_cn)
      case 1
        ## channel 1, compression wave
        subds = ds.tst.s06;
      case 2
        ## channel 2, shear wave
        subds = ds.tst.s07;
    endswitch
    ## get data that is constant for the entire group of data sets
    ## note: all tests included in a reference test series were performed at same temperature and humidity
    if (k == 1)
      ## evaluate computation parameters and their respective uncertainties
      [DU, TU, HU, CU] = anadd_analyse_paramuncert(ds, p_cn, gdef.mid, p_ap);
      ## evaluate sample indices of characteristic points
      [n0, n1, n2, n3, cp0, cp1, cp2, cp3] = anadd_analyse_charpoints(p_ap, ds, p_cn, DU, CU);
      ## signal sample time signatures, convert unit to MicroSeconds
      tt = subds.d12.v(1:16348) * 1e6;
      ## initialise signal amplitude matrix
      xx = [];
    endif
    ## signal magnitude matrix, all signals
    xx_k = subds.d13.v(1:16348, :);
    ## concatenate magnitude matrices of data sets
    xx = [xx, xx_k];
  endfor
  
  ## number of samples
  Nsmp = size(xx, 1);
  
  ## sample index
  nn = transpose(linspace(1, Nsmp, Nsmp));
  
  ## ensemble average of signal amplitudes
  mm_ens = mean(xx, 2);
  
  ## setup signal ensemble average table, extrema
  emax = p_ap.post.maxarraylen; # maximum number of samples used to decimate arrays
  ## decimate arrays for display
  nn_d = anadd_analyse_decimatearray(emax, nn(n0 : n3), 'index05'); # centre sample index of down sampling intervals
  tt_d = anadd_analyse_decimatearray(emax, tt(n0 : n3), 'index05'); # centre time signature of down sampling intervals
  mm_ens_d = anadd_analyse_decimatearray(emax, mm_ens(n0 : n3), 'value'); # ensemble average of signal sequence
  stab = [nn_d, tt_d, mm_ens_d]; # setup table for display
  ## extrema
  ss_min = min(mm_ens); # minimum
  ss_max = max(mm_ens); # maximum
  
  ## deviation, subtract ensemble average from signal sequence
  dd = xx - mm_ens;
  
  ## deviation table, extrema
  devmin = min(dd, [], 2); # minimum deviation
  devq25 = quantile(dd, 0.25, 2); # deviation' 0.25-quantile, first quartile
  devmean = mean(dd, 2); # mean deviation
  devq75 = quantile(dd, 0.75, 2); # deviation' 0.75-quantile value, third quartile
  devmax = max(dd, [], 2); # maximum deviation
  ## decimate arrays for display
  devmin_d = anadd_analyse_decimatearray(emax, devmin(n0 : n3), 'value');
  devq25_d = anadd_analyse_decimatearray(emax, devq25(n0 : n3), 'value');
  devmean_d = anadd_analyse_decimatearray(emax, devmean(n0 : n3), 'value');
  devq75_d = anadd_analyse_decimatearray(emax, devq75(n0 : n3), 'value');
  devmax_d = anadd_analyse_decimatearray(emax, devmax(n0 : n3), 'value');
  dtab = [nn_d, tt_d, devmin_d, devq25_d, devmean_d, devq75_d, devmax_d]; # setup table for display
  ## extrema
  dd_min = min(min(dd(n2 : n3, :))); # minimum
  dd_max = max(max(dd(n2 : n3, :))); # maximum
  
  ##----------------------------------------------------------------------------------------------------------------------------------------
  ## everything beyond this line is related to data export and plotting
  
  ## initialise analysis data structure
  r_ds.obj = 'struct_anadp_analysis';
  r_ds.ver = uint16([1, 0]);
  r_ds.ana_gid = p_gid;
  r_ds.ana_mat = p_dsd.mattypes{gdef.mid};
  r_ds.ana_chn = p_dsd.cn_long{p_cn};
  r_ds.ana_umd = gdef.par1;
  ## characteristic points, time-of-flight
  r_ds.t0 = struct_objdata('t0', 'dbl', cp0(1), '\mu\text{Sec}', 'time, pulse trigger event');
  r_ds.t0a = struct_objdata('t0a', 'dbl', cp0(2), '\mu\text{Sec}', 'time, pulse trigger event, lower limit');
  r_ds.t0b = struct_objdata('t0b', 'dbl', cp0(3), '\mu\text{Sec}', 'time, pulse trigger event, upper limit');
  r_ds.t1 = struct_objdata('t1', 'dbl', cp1(1), '\mu\text{Sec}', 'time-of-flight, first appearance of wave');
  r_ds.t1a = struct_objdata('t1a', 'dbl', cp1(2), '\mu\text{Sec}', 'time-of-flight, first appearance of wave, lower limit');
  r_ds.t1b = struct_objdata('t1b', 'dbl', cp1(3), '\mu\text{Sec}', 'time-of-flight, first appearance of wave, upper limit');
  r_ds.t2 = struct_objdata('t2', 'dbl', cp2(1), '\mu\text{Sec}', 'time-of-flight, first reflection of wave');
  r_ds.t2a = struct_objdata('t2a', 'dbl', cp2(2), '\mu\text{Sec}', 'time-of-flight, first reflection of wave, lower limit');
  r_ds.t2b = struct_objdata('t2b', 'dbl', cp2(3), '\mu\text{Sec}', 'time-of-flight, first reflection of wave, upper limit');
  r_ds.t3 = struct_objdata('t3', 'dbl', cp3(1), '\mu\text{Sec}', 'time-of-flight, second reflection of wave');
  r_ds.t3a = struct_objdata('t3a', 'dbl', cp3(2), '\mu\text{Sec}', 'time-of-flight, second reflection of wave, lower limit');
  r_ds.t3b = struct_objdata('t3b', 'dbl', cp3(3), '\mu\text{Sec}', 'time-of-flight, second reflection of wave, upper limit');
  ## ultrasonic measuring distance
  r_ds.umd = struct_objdata('umd', 'dbl', DU(1) * 1000, '\text{mm}', 'ultrasonic measuring distance');
  r_ds.umda = struct_objdata('umda', 'dbl', DU(2) * 1000, '\text{mm}', 'ultrasonic measuring distance, lower limit');
  r_ds.umdb = struct_objdata('umdb', 'dbl', DU(3) * 1000, '\text{mm}', 'ultrasonic measuring distance, upper limit');
  ## speed of sound
  r_ds.cs = struct_objdata('cs', 'dbl', CU(1), 'm/Sec', 'speed of sound');
  r_ds.csa = struct_objdata('csa', 'dbl', CU(3), 'm/Sec', 'speed of sound, lower limit');
  r_ds.csb = struct_objdata('csb', 'dbl', CU(2), 'm/Sec', 'speed of sound, upper limit');
  ## environment temperature
  r_ds.tm = struct_objdata('tm', 'dbl', TU(1), '{}^{\circ} \text{Celsius}', 'environment temperature');
  r_ds.tma = struct_objdata('tma', 'dbl', TU(2), '{}^{\circ} \text{Celsius}', 'environment temperature, lower limit');
  r_ds.tmb = struct_objdata('tmb', 'dbl', TU(3), '{}^{\circ} \text{Celsius}', 'environment temperature, upper limit');
  ## humidity
  r_ds.hu = struct_objdata('hu', 'dbl', HU(1), '\%', 'humidity');
  r_ds.hua = struct_objdata('hua', 'dbl', HU(2), '\%', 'humidity, lower limit');
  r_ds.hub = struct_objdata('hub', 'dbl', HU(3), '\%', 'humidity, upper limit');
  ## signal table
  r_ds.stab = struct_objdata('stab', 'dbl_mat', stab, '\text{V}', 'signal table, c1=sample index, c2=time signature, c3=ensemble average');
  r_ds.stabxlbl = struct_objdata('stabxlbl', 'str', 'Time', '\mu\text{Sec}', 'signal table, x axis label and unit');
  r_ds.stabylbl = struct_objdata('stabylbl', 'str', 'Amplitude', '\text{V}', 'signal table, y axis label and unit');
  r_ds.stabmin = struct_objdata('stabmin', 'dbl', ss_min, '\text{V}', 'signal table, minimum');
  r_ds.stabmax = struct_objdata('stabmax', 'dbl', ss_max, '\text{V}', 'signal table, maximum');
  ## deviation table
  r_ds.dtab = struct_objdata('dtab', 'dbl_mat', dtab, '\text{V}', ...
    'deviation table, c1=sample index, c2=time signature, c3=min, c4=q25, c5=mean, c6=q75, c7=max');
  r_ds.dtabxlbl = struct_objdata('dtabxlbl', 'str', 'Time', '\mu\text{Sec}', 'deviation table, x axis label and unit');
  r_ds.dtabylbl = struct_objdata('dtabylbl', 'str', 'Deviation', '\text{V}', 'deviation table, y axis label and unit');
  r_ds.dtabmin = struct_objdata('dtabmin', 'dbl', dd_min, '\text{V}', 'deviation table, minimum');
  r_ds.dtabmax = struct_objdata('dtabmax', 'dbl', dd_max, '\text{V}', 'deviation table, maximum');
  ## license information
  r_ds.license_info = struct_objattrib('license', p_ap.info_license, 'license information');
  ## author information
  r_ds.author_info = struct_objattrib('author', p_ap.info_author, 'author information');
  
  ## plot results
  r_fh = figure('name', 'ensemble average and deviation', 'position', [100, 100, 800, 800 / 1.62]);
  ##
  ## subplot 1, ensemble average of signal
  sh1 = subplot(2, 1, 1);
  set(sh1, 'tickdir', 'out');
  xlim(sh1, [r_ds.stab.v(1, 2), r_ds.stab.v(end, 2)]);
  ylim(sh1, [r_ds.stabmin.v, r_ds.stabmax.v] * 1.05);
  hold(sh1, 'on');
  fill(sh1, [r_ds.t0a.v, r_ds.t0b.v, r_ds.t0b.v, r_ds.t0a.v], [r_ds.stabmin.v, r_ds.stabmin.v, r_ds.stabmax.v, r_ds.stabmax.v], [0.8, 0.8, 0.8], ...
    'handlevisibility', 'off', 'edgecolor', 'none'); # uncertainty range, trigger event
  fill(sh1, [r_ds.t1a.v, r_ds.t1b.v, r_ds.t1b.v, r_ds.t1a.v], [r_ds.stabmin.v, r_ds.stabmin.v, r_ds.stabmax.v, r_ds.stabmax.v], [0.8, 0.8, 0.8], ...
    'handlevisibility', 'off', 'edgecolor', 'none'); # uncertainty range, first appearance of wave
  fill(sh1, [r_ds.t2a.v, r_ds.t2b.v, r_ds.t2b.v, r_ds.t2a.v], [r_ds.stabmin.v, r_ds.stabmin.v, r_ds.stabmax.v, r_ds.stabmax.v], [0.8, 0.8, 0.8], ...
    'handlevisibility', 'off', 'edgecolor', 'none'); # uncertainty range, first reflection
  fill(sh1, [r_ds.t3a.v, r_ds.t3b.v, r_ds.t3b.v, r_ds.t3a.v], [r_ds.stabmin.v, r_ds.stabmin.v, r_ds.stabmax.v, r_ds.stabmax.v], [0.8, 0.8, 0.8], ...
    'handlevisibility', 'off', 'edgecolor', 'none'); # uncertainty range, second reflection
  plot(sh1, r_ds.stab.v([1,end], 2), [0, 0], 'color', [0.8, 0.8, 0.8], 'linewidth', 0.5, 'handlevisibility', 'off'); # x axis
  plot(sh1, r_ds.stab.v(:, 2), r_ds.stab.v(:, 3), 'color', [0.654902, 0.027451, 0.254902], 'linewidth', 2); # ensemble average
  text(sh1, r_ds.t0b.v, r_ds.stabmax.v, ' t_0', 'horizontalalignment', 'left', 'verticalalignment', 'top'); # trigger event
  text(sh1, r_ds.t1b.v, r_ds.stabmax.v, ' t_1', 'horizontalalignment', 'left', 'verticalalignment', 'top'); # first wave' appearance
  text(sh1, r_ds.t2b.v, r_ds.stabmax.v, ' t_2', 'horizontalalignment', 'left', 'verticalalignment', 'top'); # first reflection
  text(sh1, r_ds.t3b.v, r_ds.stabmax.v, ' t_3', 'horizontalalignment', 'left', 'verticalalignment', 'top'); # second reflection
  hold(sh1, 'off');
  title(sh1, sprintf('Ensemble average M\nMaterial = %s, %s, D = %d mm', r_ds.ana_mat, r_ds.ana_chn, r_ds.ana_umd));
  ylabel(sh1, sprintf('%s [%s]', r_ds.stabylbl.v, 'V'));
  ##
  ## subplot 2, deviation from ensemble average of signal set
  fill_x = [r_ds.dtab.v(:, 2); flip(r_ds.dtab.v(:, 2))];
  fill_minmax = [r_ds.dtab.v(:, 3); flip(r_ds.dtab.v(:, 7))];
  fill_q25q75 = [r_ds.dtab.v(:, 4); flip(r_ds.dtab.v(:, 6))];
  fill_bcol1 = [0.4471, 0.6235, 0.8118]; # background color 2, middle blue
  fill_bcol2 = [0.7059, 0.7804, 0.8627]; # background color 1, light blue
  line_fcol = [0, 0, 1]; # foreground color, dark blue
  sh2 = subplot(2, 1, 2);
  set(sh2, 'tickdir', 'out');
  xlim(sh2, [r_ds.dtab.v(1, 2), r_ds.dtab.v(end, 2)]);
  ylim(sh2, [r_ds.dtabmin.v, r_ds.dtabmax.v] * 1.05);
  hold(sh2, 'on');
  fill(sh2, fill_x, fill_minmax, fill_bcol1, 'displayname', 'MIN/MAX', 'edgecolor', 'none');
  fill(sh2, fill_x, fill_q25q75, fill_bcol2, 'displayname', 'Q_{0.25}/Q_{0.75}', 'edgecolor', 'none');
  plot(sh2, r_ds.dtab.v(:, 2), r_ds.dtab.v(:, 5), 'color', line_fcol, 'linewidth', 2, 'handlevisibility', 'off');
  hold(sh2, 'off');
  title(sh2, 'Deviation R from ensemble average M');
  xlabel(sh2, sprintf('%s [%s]', r_ds.dtabxlbl.v, '\muSec'));
  ylabel(sh2, sprintf('%s [%s]', r_ds.dtabylbl.v, 'V'));
  legend(sh2, 'box', 'off', 'numcolumns', 2, 'orientation', 'horizontal');
  ##
  ## annotation, license information
  annotation(r_fh, 'textbox', [0.01, 0.01, 1, 0.1], 'string', p_ap.info_license_short, 'edgecolor', 'none', 'fontsize', 8);
  
endfunction


function [r_arr] = anadd_analyse_decimatearray(p_emax, p_arr, p_mod)
  ## Decimate array for display
  ##
  ## p_emax ... maximum number of elements of output array, <uint>
  ## p_arr  ... input array, column vector, [<dbl>]
  ## r_arr  ... output array, column vector, [<dbl>]
  ## p_mod  ... mode, 'index0', 'index05', 'index1' or 'value', <str>
  ##
  ## Note: decimation is splitting the input array into intervals (N_int <= p_emax) and returns the extremum of that intervals
  
  ## array size
  N = length(p_arr);
  
  ## down sampling ratio, number of intervals
  dsrat = max([1, ceil(N / p_emax)]);
  Nint = floor(N / dsrat);
  
  ## determine interval limits
  nn0 = floor(linspace(1, N + 1, Nint + 1));
  nn1 = nn0(1 : end - 1);
  nn2 = nn0(2 : end) - 1;
  ii = [nn1(:), nn2(:)];
  
  ## check mode
  switch (p_mod)
    case 'index0'
      ## decimate index, return lower interval limits
      r_arr = p_arr(nn1);
    case 'index1'
      ## decimate index, return upper interval limits
      r_arr = p_arr(nn2);
    case 'index05'
      ## decimate index, return interval center
      a1 = p_arr(nn1);
      a2 = p_arr(nn2);
      r_arr = mean([a1, a2], 2);
    otherwise
      ## decimate value, return interval extrema
      r_arr = zeros(Nint, 1);
      for k = 1 : Nint
        rng_k = ii(k, 1) : ii(k, 2);
        data_k = p_arr(rng_k);
        max_k = max(data_k);
        min_k = min(data_k);
        if (abs(min_k) > max_k)
          r_arr(k) = min_k;
        else
          r_arr(k) = max_k;
        endif
      endfor
  endswitch
  
endfunction

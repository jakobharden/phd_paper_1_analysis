## Setup dataset and group definition data structure
##
## Usage: [r_ds, r_ap] = anadd_dsdefs()
##
## r_ds ... return: dataset and group definition data structure, <struct_anadd_dsdefs>
## r_ap ... return: analysis parameter structure, <struct_anadp_param>
##
## see also: anadd_param
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
function [r_ds, r_ap] = anadd_dsdefs()
  
  ## load analysis parameter structure, export to TeX file
  r_ap = anadd_param('export-texfile');
  
  ## init dataset definition data structure
  r_ds.obj = 'struct_anadd_dsdefs';
  r_ds.ver = uint16([1, 0]);
  
  ## setup file path list
  r_ds.fplist = {...
    fullfile(r_ap.paths.dssrc, r_ap.paths.ts5oct), ...
    fullfile(r_ap.paths.dssrc, r_ap.paths.ts6oct), ...
    fullfile(r_ap.paths.dssrc, r_ap.paths.ts7oct)};
    
  ## setup material types
  r_ds.mattypes = {...
    'air', ...
    'water', ...
    'alucyl', ...
    };
    
  ## channel name lists (compression- and shear wave)
  r_ds.cn_long = {'Primary wave', 'Secondary wave'};
  r_ds.cn_short = {'P-wave', 'S-wave'};
  r_ds.cn_char_uc = {'P', 'S'};
  r_ds.cn_char_lc = {'P', 'S'};
  
  ## setup dataset definition list
  dsl = [];
  ## air
  mid = 1;
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d25_b16_v800', 25, 16, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d25_b24_v800', 25, 24, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d25_b33_v800', 25, 33, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d25_b50_v800', 25, 50, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d50_b16_v800', 50, 16, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d50_b24_v800', 50, 24, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d50_b33_v800', 50, 33, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d50_b50_v800', 50, 50, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d70_b16_v800', 70, 16, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d70_b24_v800', 70, 24, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d70_b33_v800', 70, 33, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts5_d70_b50_v800', 70, 50, 800)];
  ## water
  mid = 2;
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d25_b16_v800', 25, 16, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d25_b24_v800', 25, 24, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d25_b33_v800', 25, 33, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d25_b50_v800', 25, 50, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d50_b16_v800', 50, 16, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d50_b24_v800', 50, 24, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d50_b33_v800', 50, 33, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d50_b50_v800', 50, 50, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d70_b16_v800', 70, 16, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d70_b24_v800', 70, 24, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d70_b33_v800', 70, 33, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts6_d70_b50_v800', 70, 50, 800)];
  ## aluminium cylinder
  mid = 3;
  dsl = [dsl, hlp_dsdef(mid, 'ts7_d50_b16_v800', 50, 16, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts7_d50_b24_v800', 50, 24, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts7_d50_b33_v800', 50, 33, 800)];
  dsl = [dsl, hlp_dsdef(mid, 'ts7_d50_b50_v800', 50, 50, 800)];
  ## add group definitions to structure
  r_ds.dsdefs = dsl;
  
  ## setup dataset group definition list
  dsgl = [];
  ## air
  mid = 1;
  dsgl = [dsgl, hlp_make_grpdef(mid, 'air_d25_v800', [ 1, 2, 3, 4], 25, [], 800)]; # id = 1, D = 25 mm
  dsgl = [dsgl, hlp_make_grpdef(mid, 'air_d50_v800', [ 5, 6, 7, 8], 50, [], 800)]; # id = 2, D = 50 mm
  dsgl = [dsgl, hlp_make_grpdef(mid, 'air_d70_v800', [ 9,10,11,12], 70, [], 800)]; # id = 3, D = 70 mm
  ## water
  mid = 2;
  dsgl = [dsgl, hlp_make_grpdef(mid, 'water_d25_v800', [13,14,15,16], 25, [], 800)]; # id = 5, D = 25 mm
  dsgl = [dsgl, hlp_make_grpdef(mid, 'water_d50_v800', [17,18,19,20], 50, [], 800)]; # id = 6, D = 50 mm
  dsgl = [dsgl, hlp_make_grpdef(mid, 'water_d70_v800', [21,22,23,24], 70, [], 800)]; # id = 7, D = 70 mm
  ## aluminium cylinder
  mid = 3;
  dsgl = [dsgl, hlp_make_grpdef(mid, 'alucyl_d50_v800', [25,26,27,28], 50, [], 800)]; # id = 9, D = 50 mm
  ## add group definitions to structure
  r_ds.gdefs = dsgl;
  
endfunction

function [r_ds] = hlp_dsdef(p_id, p_dn, p_p1, p_p2, p_p3)
  # Create dataset definition
  ##
  ## p_id ... material id, <uint>
  ## p_gn ... dataset name, <str>
  ## p_p1 ... dataset parameter 1, <uint>
  ## p_p2 ... dataset parameter 2, <uint>
  ## p_p3 ... dataset parameter 3, <uint>
  ## r_ds ... return: dataset definition structure, <struct_ddef>
  
  r_ds.obj = 'struct_ddef';
  r_ds.ver = int16([1, 0]);
  r_ds.mid = p_id;
  r_ds.dsname = p_dn;
  r_ds.par1 = p_p1;
  r_ds.par2 = p_p2;
  r_ds.par3 = p_p3;
  
endfunction

function [r_ds] = hlp_make_grpdef(p_id, p_gn, p_di, p_p1, p_p2, p_p3)
  ## Create dataset group definition
  ##
  ## p_id ... material id, <uint>
  ## p_gn ... group name, <str>
  ## p_di ... dataset index array, [<uint>]
  ## p_p1 ... group parameter 1, <uint>
  ## p_p2 ... group parameter 2, <uint>
  ## p_p3 ... group parameter 3, <uint>
  ## r_ds ... return: dataset group definition structure, <struct_gdef>
  
  r_ds.obj = 'struct_gdef';
  r_ds.ver = int16([1, 0]);
  r_ds.mid = p_id;
  r_ds.gname = p_gn;
  r_ds.dsidx = p_di;
  r_ds.par1 = p_p1;
  r_ds.par2 = p_p2;
  r_ds.par3 = p_p3;
  
endfunction

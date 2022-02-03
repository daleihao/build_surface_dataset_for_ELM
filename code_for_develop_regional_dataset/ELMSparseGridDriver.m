% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% - Creates a CLM45 surface dataset and domain netcdf files in an
%   unstrustured grid format for a list sites given by latitude/longitude.
% 
% - The script uses already existing CLM45 surface datasets and create
%   new dataset by finding nearest neighbor for each site.
%
% INPUT:
%       fname = Configuration file name.
%
% EXAMPLE:
%  # Download data
%  mkdir clm-netcdf
%  svn export https://svn-ccsm-inputdata.cgd.ucar.edu/trunk/inputdata/lnd/clm2/surfdata_map/surfdata_1.9x2.5_simyr2000_c141219.nc clm-netcdf/surfdata_1.9x2.5_simyr2000_c141219.nc
%  svn export https://svn-ccsm-inputdata.cgd.ucar.edu/trunk/inputdata/share/domains/domain.clm/domain.lnd.fv1.9x2.5_USGS.110713.nc clm-netcdf/domain.lnd.fv1.9x2.5_USGS.110713.nc 
%
%  # Run matlab script
%  CLM45SparseGridDriver('82x1_sparse_grid/82x1_sparse_grid.cfg')
%
% Gautam Bisht (gbisht@lbl.gov)
% 05-28-2015
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function [fsurdat, fdomain] = ELMSparseGridDriver(cfg)

disp('1) Reading latitude/longitude @ cell centroid')

lon = (cfg.lon_left+cfg.res_h/2):cfg.res_h: (cfg.lon_right-cfg.res_h/2);
lat = (cfg.lat_top-cfg.res_v/2):-cfg.res_v: (cfg.lat_bottom+cfg.res_v/2);
[long_region,lati_region]=meshgrid(lon,lat);


long_region = (flipud(long_region))';
lati_region = (flipud(lati_region))';

disp('2) Computing latitude/longitude @ cell vertex')
[latv,lonv] = ComputeLatLonAtVertex(lati_region,long_region, cfg.res_v, cfg.res_h);

disp('3) Creating ELM surface dataset')
fsurdat = CreateELMUgridSurfdat(lati_region, long_region, ...
                              cfg.clm_gridded_surfdata_filename, ...
                              cfg.out_netcdf_dir, ...
                              cfg.clm_usrdat_name, ...
                              cfg.set_natural_veg_frac_to_one);

disp('4) Creating ELM domain')
fdomain = CreateELMUgridDomain(lati_region, long_region, ...
                             latv, lonv, ...
                             cfg.clm_gridded_domain_filename, ...
                             cfg.out_netcdf_dir, ...
                             cfg.clm_usrdat_name);

disp('5) Creating ELM topo dataset')
CreateELMUgridTopodata(lati_region, long_region, ...
                              cfg.clm_gridded_topodata_filename, ...
                              cfg.out_netcdf_dir, ...
                              cfg.clm_usrdat_name,...
                              cfg.is_0_360);
                                               


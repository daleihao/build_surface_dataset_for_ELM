%% define directory
originalDir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/E3SM/script_for_clm_sparse_grid/clm-netcdf/';
cfg.clm_gridded_domain_filename = [originalDir 'domain.lnd.fv0.47x0.63_gx1v7.180521.nc'];
cfg.clm_gridded_surfdata_filename = [originalDir 'surfdata_0.47x0.63_16pfts_Irrig_CMIP6_simyr2000_c180508.nc'];

topDir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/proposal_&_code/UCLA_3D_Topo_Data/UCLA_3D_Topo_Data/';
cfg.clm_gridded_topodata_filename = [topDir 'topo_3d_0.47x0.63_c150322.nc'];

cfg.out_netcdf_dir = "ABOVE/";

cfg.set_natural_veg_frac_to_one = 0;
%% define parameter

cfg.res_h = 0.5;
cfg.res_v = 0.5;

lat_tops = [75];
lat_bottoms = [52];
lon_lefts = [360-169];
lon_rights = [360-100];

for i = 1:1
    cfg.lat_top = lat_tops(i);
    cfg.lat_bottom = lat_bottoms(i);
    cfg.lon_left = lon_lefts(i);
    cfg.lon_right = lon_rights(i);

    cfg.clm_usrdat_name = 'ABOVE_05_v3';
    
    ELMSparseGridDriver(cfg)
end
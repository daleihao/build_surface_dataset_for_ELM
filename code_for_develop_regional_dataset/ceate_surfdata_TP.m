%% define directory
originalDir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/E3SM/script_for_clm_sparse_grid/clm-netcdf/';
cfg.clm_gridded_domain_filename = [originalDir 'domain.lnd.r0125_gx1v6.191017.nc'];
cfg.clm_gridded_surfdata_filename = [originalDir 'surfdata_0.125x0.125_simyr2010_c191025.nc'];

topDir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/proposal_&_code/UCLA_3D_Topo_Data/UCLA_3D_Topo_Data/';
cfg.clm_gridded_topodata_filename = [topDir 'topo_3d_0.125x0.125.nc'];

cfg.out_netcdf_dir = "TP/";

cfg.set_natural_veg_frac_to_one = 0;
%% define parameter

cfg.res_h = 0.125;
cfg.res_v = 0.125;

lat_tops = [41];
lat_bottoms = [22];
lon_lefts = [65];
lon_rights = [108];

for i = 1:1
    cfg.lat_top = lat_tops(i);
    cfg.lat_bottom = lat_bottoms(i);
    cfg.lon_left = lon_lefts(i);
    cfg.lon_right = lon_rights(i);

    cfg.clm_usrdat_name = 'TP_0125';
    
    ELMSparseGridDriver(cfg)
end
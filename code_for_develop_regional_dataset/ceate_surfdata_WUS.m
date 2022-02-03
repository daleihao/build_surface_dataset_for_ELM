%% define directory
originalDir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/E3SM/writting/Snow_evaluation/ELM/';
cfg.clm_gridded_domain_filename = [originalDir 'domain.lnd.nldas2_0224x0464_c110415.nc'];
cfg.clm_gridded_surfdata_filename = [originalDir 'surfdata_nldas2_simyr2000_c181207.nc'];

topDir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/proposal_&_code/UCLA_3D_Topo_Data/UCLA_3D_Topo_Data/';
cfg.clm_gridded_topodata_filename = [topDir 'topo_3d_0.125x0.125.nc'];

cfg.out_netcdf_dir = "C:/Users/haod776/OneDrive - PNNL/Documents/work/E3SM/writting/Snow_evaluation/ELM/WUS_surface_data/";

cfg.set_natural_veg_frac_to_one = 0;
%% define parameter

cfg.res_h = 0.125;
cfg.res_v = 0.125;

lat_tops = [50];
lat_bottoms = [32];
lon_lefts = [235];
lon_rights = [256];

for i = 1:1
    cfg.lat_top = lat_tops(i);
    cfg.lat_bottom = lat_bottoms(i);
    cfg.lon_left = lon_lefts(i);
    cfg.lon_right = lon_rights(i);
    cfg.is_0_360 = 1;
    cfg.clm_usrdat_name = 'WUS_0125';
    
    ELMSparseGridDriver(cfg)
end
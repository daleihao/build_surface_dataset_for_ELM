% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Creates an unstructured landuse timeseries netCDF file for CLM45.
%
% INPUT:
%       lati_region = Vector containing latitude @ cell-center.
%       long_region = Vector containing longitude @ cell-center.
%       landuse_timeseries_filename = Gridded landuse timeseries netcdf
%       out_netcdf_dir = Directory where CLM surface dataset will be saved
%       clm_usrdat_name = User defined name for CLM dataset
%       set_natural_veg_frac_to_one =
%
% Gautam Bisht (gbisht@lbl.gov)
% 10-02-2018
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function fname_out = CreateELMUgridLanduseTimeseries(lati_region, long_region, ...
                                      landuse_timeseries_filename, ...
                                      out_netcdf_dir, ...
                                      clm_usrdat_name, ...
                                      set_natural_veg_frac_to_one)


fname_out = sprintf('%s/landuse.timeseries_%s_%s.nc',out_netcdf_dir,clm_usrdat_name,datestr(now, 'cyymmdd'));
disp(['  landuse_filename: ' fname_out])

% % Check if the file is available
% [s,~]=system(['ls ' landuse_timeseries_filename]);
% 
% if (s ~= 0)
%    error(['File not found: ' landuse_timeseries_filename]);
% end

ncid_inp = netcdf.open(landuse_timeseries_filename,'NC_NOWRITE');
ncid_out = netcdf.create(fname_out,'NC_CLOBBER');

info_inp = ncinfo(landuse_timeseries_filename);

[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid_inp);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
%                           Define dimensions
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dimid(1:ndims) = -1;
lonlat_found = 0;

for idim = 1:ndims
    [dimname, dimlen] = netcdf.inqDim(ncid_inp,idim-1);
    %disp(['Inp: Dimension name:' dimname])
    
    switch dimname
        case {'lsmlon','lsmlat'}
            if (strcmp(dimname,'lsmlat'))
                dimlen = size(lati_region, 2);
                dimid(idim) = netcdf.defDim(ncid_out,dimname,dimlen);
            else
                dimlen = size(lati_region, 1);
                dimid(idim) = netcdf.defDim(ncid_out,dimname,dimlen);
            end
        case 'time'
            %disp(['Out: Dimension name:' dimname])
            dimid(idim) = netcdf.defDim(ncid_out,dimname,netcdf.getConstant('NC_UNLIMITED'));
        otherwise
            %disp(['Out: Dimension name:' dimname])
            for ii=1:length(info_inp.Dimensions)
                if (strcmp(info_inp.Dimensions(ii).Name,dimname) == 1)
                    [dimname, dimlen] = netcdf.inqDim(ncid_inp,ii-1);
                end
            end
            dimid(idim) = netcdf.defDim(ncid_out,dimname,dimlen);
    end
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
%                           Define variables
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
for ivar = 1:nvars
    [varname,xtype,dimids,natts] = netcdf.inqVar(ncid_inp,ivar-1);
    %disp(['varname : ' varname ' ' num2str(dimids)])
    varid(ivar) = netcdf.defVar(ncid_out,varname,xtype,dimids);
    varnames{ivar} = varname;
    %disp([num2str(ivar) ') varname : ' varname ' ' num2str(dimids)])
    
    for iatt = 1:natts
        attname = netcdf.inqAttName(ncid_inp,ivar-1,iatt-1);
        attvalue = netcdf.getAtt(ncid_inp,ivar-1,attname);
        
        netcdf.putAtt(ncid_out,ivar-1,attname,attvalue);
    end
    
end



varid = netcdf.getConstant('GLOBAL');

[~,user_name]=system('echo $USER');
netcdf.putAtt(ncid_out,varid,'Created_by' ,user_name(1:end-1));
netcdf.putAtt(ncid_out,varid,'Created_on' ,datestr(now,'ddd mmm dd HH:MM:SS yyyy '));
netcdf.endDef(ncid_out);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Find the nearest neighbor index for (long_region,lati_xy) within global
% dataset
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Get Lat/Lon for global 2D grid.
for ivar = 1:length(varnames)
    if(strcmp(varnames{ivar},'LATIXY'))
        latixy = netcdf.getVar(ncid_inp,ivar-1);
    end
    if(strcmp(varnames{ivar},'LONGXY'))
        longxy = netcdf.getVar(ncid_inp,ivar-1);
    end
end

% read in global pft mask 1=valid 0=invalid
pftmask = ncread(landuse_timeseries_filename,'PFTDATA_MASK');

% mark invalid gridcells as [lon, lat] [-9999, -9999]
% latixy(pftmask==0)=-9999;
% longxy(pftmask==0)=-9999;

% allocate memoery
ii_idx = zeros(size(long_region));
jj_idx = zeros(size(long_region));

% find the index
for ii=1:size(long_region,1)
    for jj=1:size(long_region,2)
        dist = (longxy - long_region(ii,jj)).^2 + (latixy - lati_region(ii,jj)).^2;
        [nearest_cell_i_idx, nearest_cell_j_idx] = find( dist == min(min(dist)));
        if (length(nearest_cell_i_idx) > 1)
            disp(['  WARNING: Site with (lat,lon) = (' sprintf('%f',lati_region(ii,jj)) ...
                sprintf(',%f',long_region(ii,jj)) ') has more than one cells ' ...
                'that are equidistant.' char(10) ...
                '           Picking the first closest grid cell.']);
            for kk = 1:length(nearest_cell_i_idx)
                disp(sprintf('\t\tPossible grid cells: %f %f', ...
                    latixy(nearest_cell_i_idx(kk),nearest_cell_j_idx(kk)), ...
                    longxy(nearest_cell_i_idx(kk),nearest_cell_j_idx(kk))));
            end
        end
        ii_idx(ii,jj) = nearest_cell_i_idx(1);
        jj_idx(ii,jj) = nearest_cell_j_idx(1);
    end
end


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
%                           Copy variables
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
for ivar = 1:nvars
    
    %disp(varnames{ivar})
    [varname,vartype,vardimids,varnatts]=netcdf.inqVar(ncid_inp,ivar-1);
    data = netcdf.getVar(ncid_inp,ivar-1);
    switch varname
        case {'LATIXY'}
            netcdf.putVar(ncid_out,ivar-1,lati_region);
        case {'LONGXY'}
            netcdf.putVar(ncid_out,ivar-1,long_region);
        otherwise
            
            switch length(vardimids)
                case 0
                    netcdf.putVar(ncid_out,ivar-1,data);
                case 1
                    data = 0;
                    netcdf.putVar(ncid_out,ivar-1,0,length(data),data);
                case 2
                    if (min(vardimids) == 0)
                        data_2d = zeros(size(long_region));
                        for ii=1:size(long_region,1)
                            for jj=1:size(long_region,2)
                                data_2d(ii,jj) = data(ii_idx(ii,jj),jj_idx(ii,jj));
                            end
                        end
                        
                             
                        
                        data_2d = PerformFractionCoverCheck(varname, data_2d,...
                            set_natural_veg_frac_to_one);
                        
                        netcdf.putVar(ncid_out,ivar-1,data_2d);                        
                    else
                        netcdf.putVar(ncid_out,ivar-1,data);
                    end
                case 3
                    if (min(vardimids) == 0)
                        nx = size(long_region,1);
                        ny = size(long_region,2);
                        nz = size(data,3);
                        data_3d = zeros(nx,ny,nz);
                        for ii = 1:nx
                            for jj = 1:ny
                                for kk = 1:nz
                                    data_3d(ii,jj,kk) = data(ii_idx(ii,jj),jj_idx(ii,jj),kk);
                                end
                            end
                        end
                        data_3d = PerformFractionCoverCheck(varname, data_3d,...
                            set_natural_veg_frac_to_one);

                        netcdf.putVar(ncid_out,ivar-1,data_3d);
                    else
                        netcdf.putVar(ncid_out,ivar-1,data);
                    end
                case 4
                    if (min(vardimids) == 0)
                        nx = size(long_region,1);
                        ny = size(long_region,2);
                        nz = size(data,3);
                        na = size(data,4);
                        data_4d = zeros(nx,ny,nz,na);
                        for ii = 1:nx
                            for jj = 1:ny
                                for kk = 1:nz
                                    for ll = 1:na
                                        data_4d(ii,jj,kk,ll) = data(ii_idx(ii,jj),jj_idx(ii,jj),kk,ll);
                                    end
                                end
                            end
                        end
                                  
                        netcdf.putVar(ncid_out,ivar-1,zeros(length(size(data_4d)),1)',size(data_4d),data_4d);
                    else
                        netcdf.putVar(ncid_out,ivar-1,data);
                    end
                otherwise
                    disp('error')
            end
    end
end

% close files
netcdf.close(ncid_inp);
netcdf.close(ncid_out);
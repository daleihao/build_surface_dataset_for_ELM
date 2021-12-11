%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% code to generate the surface data for ELM
%% Author: Dalei Hao
%% Date: 12/10/2021

clc;
clear all;
close all;

%% import surface variables
load('LAISAI_1km.mat');
load('LCELM_1km.mat');
load('Soil_1km.mat');
load('Top_1km.mat');

LAIs = nan([size(LAI_1_Data), 12]);
LAIs(:,:,1) = LAI_1_Data;
LAIs(:,:,2) = LAI_2_Data;
LAIs(:,:,3) = LAI_3_Data;
LAIs(:,:,4) = LAI_4_Data;
LAIs(:,:,5) = LAI_5_Data;
LAIs(:,:,6) = LAI_6_Data;
LAIs(:,:,7) = LAI_7_Data;
LAIs(:,:,8) = LAI_8_Data;
LAIs(:,:,9) = LAI_9_Data;
LAIs(:,:,10) = LAI_10_Data;
LAIs(:,:,11) = LAI_11_Data;
LAIs(:,:,12) = LAI_12_Data;

SAIs = nan([size(SAI_1_Data), 12]);
SAIs(:,:,1) = SAI_1_Data;
SAIs(:,:,2) = SAI_2_Data;
SAIs(:,:,3) = SAI_3_Data;
SAIs(:,:,4) = SAI_4_Data;
SAIs(:,:,5) = SAI_5_Data;
SAIs(:,:,6) = SAI_6_Data;
SAIs(:,:,7) = SAI_7_Data;
SAIs(:,:,8) = SAI_8_Data;
SAIs(:,:,9) = SAI_9_Data;
SAIs(:,:,10) = SAI_10_Data;
SAIs(:,:,11) = SAI_11_Data;
SAIs(:,:,12) = SAI_12_Data;

LCs = LC_ELM_Data;

Clays = nan([size(clay_0_5), 6]);
Clays(:,:,1) = clay_0_5;
Clays(:,:,2) = clay_5_15;
Clays(:,:,3) = clay_15_30;
Clays(:,:,4) = clay_30_60;
Clays(:,:,5) = clay_60_100;
Clays(:,:,6) = clay_100_200;

Sands = nan([size(sand_0_5), 6]);
Sands(:,:,1) = sand_0_5;
Sands(:,:,2) = sand_5_15;
Sands(:,:,3) = sand_15_30;
Sands(:,:,4) = sand_30_60;
Sands(:,:,5) = sand_60_100;
Sands(:,:,6) = sand_100_200;

Doms = nan([size(dom_0_5), 6]);
Doms(:,:,1) = dom_0_5;
Doms(:,:,2) = dom_5_15;
Doms(:,:,3) = dom_15_30;
Doms(:,:,4) = dom_30_60;
Doms(:,:,5) = dom_60_100;
Doms(:,:,6) = dom_100_200;


%% remove nan value
LAIs(LAIs<0) = nan;
SAIs(SAIs<0) = nan;
Clays(Clays<0) = nan;
Doms(Doms<0) = nan;
Sands(Sands<0) = nan;

%% soil depth definitation
z_new = 0.025 *(exp(0.5*((1:10)-0.5))-1);
z_old = [2.5 10 22.5 45 80 150]/100;


%% define ELM variables
[rows, cols] = size(clay_0_5);
PCT_LAKE = zeros(rows, cols);
PCT_NATVEG = zeros(rows, cols);
PCT_URBAN= zeros(rows, cols, 3);
PCT_WETLAND= zeros(rows, cols);
PCT_GLACIER= zeros(rows, cols);
PCT_NAT_PFT = zeros(rows, cols, 17);

MONTHLY_LAI = zeros(rows, cols, 17, 12);
MONTHLY_SAI = zeros(rows, cols, 17, 12);

PCT_CLAY = zeros(rows, cols,10);
PCT_SAND = zeros(rows, cols,10);
ORGANIC = zeros(rows, cols,10);

%% get values
for row_i = 1:rows
    tic
    for  col_i = 1:cols
        %% LAI
        LAI_i = squeeze(LAIs(row_i,col_i,:));
        SAI_i = squeeze(SAIs(row_i,col_i,:));
        LC_i = LCs(row_i,col_i);
        
        if LC_i<16 && (LC_i<13 || LC_i>14)
            MONTHLY_LAI(row_i,col_i, LC_i + 1, :) =LAI_i;
            MONTHLY_SAI(row_i,col_i, LC_i + 1, :) = SAI_i;
        elseif LC_i>=13 && LC_i<=14
            MONTHLY_LAI(row_i,col_i, 13 + 1, :) =LAI_i;
            MONTHLY_SAI(row_i,col_i, 13 + 1, :) = SAI_i;
            MONTHLY_LAI(row_i,col_i, 14 + 1, :) =LAI_i;
            MONTHLY_SAI(row_i,col_i, 14 + 1, :) = SAI_i;
        end
        
        %% pft
        if LC_i<16 && (LC_i<13 || LC_i>14)
            PCT_NATVEG(row_i,col_i) = 100;
            PCT_NAT_PFT(row_i,col_i, LC_i+1) = 100;
        elseif LC_i>=13 && LC_i<=14
            PCT_NATVEG(row_i,col_i) = 100;
            PCT_NAT_PFT(row_i,col_i, 13+1) = 1-(LC_i - 13);
            PCT_NAT_PFT(row_i,col_i, 14+1) = LC_i - 13;
        elseif LC_i == 16 %wetland
            PCT_WETLAND(row_i,col_i) = 100;
            PCT_NAT_PFT( row_i,col_i, 1) = 100;
        elseif LC_i == 17 %urban
            PCT_URBAN(row_i,col_i, 3) = 100;
            PCT_NAT_PFT( row_i,col_i, 1) = 100;
        elseif LC_i == 18 %lake
            PCT_LAKE(row_i,col_i) = 100;
            PCT_NAT_PFT( row_i,col_i, 1) = 100;
        elseif LC_i == 19 %glacier
            PCT_GLACIER(row_i,col_i) = 100;
            PCT_NAT_PFT( row_i,col_i, 1) = 100;
        end
        
        %% soil
        clay_old = squeeze(Clays(row_i,col_i,:));
        sand_old = squeeze(Sands(row_i,col_i,:));
        dom_old = squeeze(Doms(row_i,col_i,:));
        
        PCT_CLAY(row_i,col_i, :) = interp1(z_old, clay_old, z_new,'linear', 'extrap');
        PCT_SAND(row_i,col_i,:) = interp1(z_old, sand_old, z_new,'linear', 'extrap');
        ORGANIC(row_i,col_i,:) = interp1(z_old, dom_old, z_new,'linear', 'extrap');
    end
    toc
end

%% Topographic parameters elevation, slope and std_elev
TOPO = meanelevation;
SLOPE = slope;
STD_ELEV = stdelevation;


%% remove nan values
MONTHLY_LAI(MONTHLY_LAI<0) = 0;
MONTHLY_SAI(MONTHLY_SAI<0) = 0;

PCT_CLAY(PCT_CLAY<0) = 0;
PCT_SAND(PCT_SAND<0) = 0;
ORGANIC(ORGANIC<0) = 0;

PCT_LAKE(PCT_LAKE<0) = 0;
PCT_NATVEG(PCT_NATVEG<0) = 0;
PCT_URBAN(PCT_URBAN<0)= 0;
PCT_WETLAND(PCT_WETLAND<0)= 0;
PCT_NAT_PFT(PCT_NAT_PFT<0) = 0;

TOPO(TOPO<0) = 0;
SLOPE(SLOPE<0) = 0;
STD_ELEV(STD_ELEV<0) = 0;

%% save data into .mat file
save('variables_ELM.mat','MONTHLY_LAI','MONTHLY_SAI',...
    'PCT_CLAY','PCT_SAND','ORGANIC',...
    'PCT_LAKE','PCT_NATVEG','PCT_URBAN','PCT_WETLAND','PCT_NAT_PFT',...
    'TOPO','SLOPE','STD_ELEV');

%% transplot data (dimension order difference in matlab and .nc file)
for month_i = 1:12
    for pft_i = 1:17
        MONTHLY_LAI(:,:,pft_i,month_i) = ((squeeze(MONTHLY_LAI(:,:,pft_i,month_i))))';
        MONTHLY_SAI(:,:,pft_i,month_i) = ((squeeze(MONTHLY_SAI(:,:,pft_i,month_i))))';
    end
end
for level_i = 1:10
    PCT_CLAY(:,:,level_i) = ((squeeze(PCT_CLAY(:,:,level_i))))';
    PCT_SAND(:,:,level_i)  = ((squeeze(PCT_SAND(:,:,level_i))))';
    ORGANIC(:,:,level_i)  = ((squeeze(ORGANIC(:,:,level_i))))';
end

PCT_LAKE = ((PCT_LAKE))';
PCT_NATVEG = ((PCT_NATVEG))';
PCT_WETLAND = ((PCT_WETLAND))';

for urban_i = 1:3
    PCT_URBAN(:,:,urban_i) = ((squeeze(PCT_URBAN(:,:,urban_i))))';
end

for pft_i = 1:17
    PCT_NAT_PFT(:,:,pft_i) = ((squeeze(PCT_NAT_PFT(:,:,pft_i))))';
end

TOPO = ((TOPO))';
SLOPE = ((SLOPE))';
STD_ELEV = ((STD_ELEV))';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% modify file by replacing surface variables
filename = 'surfacedata_ELM.nc';
info = ncinfo(filename);

%% load data
ncid = netcdf.open(filename,'WRITE');

%% PFT including C3/C4
varname = "PCT_LAKE";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_LAKE;
netcdf.putVar(ncid,varid,my_vardata);

varname = "PCT_NAT_PFT";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_NAT_PFT;
netcdf.putVar(ncid,varid,my_vardata);

varname = "PCT_NATVEG";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_NATVEG;
netcdf.putVar(ncid,varid,my_vardata);

varname = "PCT_URBAN";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_URBAN;
netcdf.putVar(ncid,varid,my_vardata);

varname = "PCT_WETLAND";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_WETLAND;
netcdf.putVar(ncid,varid,my_vardata);

varname = "PCT_GLACIER";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_GLACIER;
netcdf.putVar(ncid,varid,my_vardata);

%% LAI and SAI
varname = "MONTHLY_LAI";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = MONTHLY_LAI;
netcdf.putVar(ncid,varid,my_vardata);

varname = "MONTHLY_SAI";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = MONTHLY_SAI;
netcdf.putVar(ncid,varid,my_vardata);

%% soil texture
varname = "PCT_CLAY";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_CLAY;
netcdf.putVar(ncid,varid,my_vardata);

varname = "PCT_SAND";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = PCT_SAND;
netcdf.putVar(ncid,varid,my_vardata);

%% soil organic matter
varname = "ORGANIC";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = ORGANIC;
netcdf.putVar(ncid,varid,my_vardata);

%% top parameters
varname = "TOPO";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = TOPO;
netcdf.putVar(ncid,varid,my_vardata);

varname = "SLOPE";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = SLOPE;
netcdf.putVar(ncid,varid,my_vardata);

varname = "STD_ELEV";
varid = netcdf.inqVarID(ncid,varname);
my_vardata = STD_ELEV;
netcdf.putVar(ncid,varid,my_vardata);

%% close
netcdf.close(ncid);


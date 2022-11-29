%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% code to generate the surface variables needed in ELM surface data
%% Author: Dalei Hao
%% Date: 12/10/2021

clc;
clear all;
close all;

%% import pft data: IGBP for SAI calculation
LCData = double(geotiffread('pft/TOP2_LC_IGBP_2005_mode.tif'));

%% LAI & SAI
scale_LAI = 0.1;
LAI_1_Data = double(geotiffread('LAI/TOP2_LAI_1.tif'))*scale_LAI;
LAI_2_Data = double(geotiffread('LAI/TOP2_LAI_2.tif'))*scale_LAI;
LAI_3_Data = double(geotiffread('LAI/TOP2_LAI_3.tif'))*scale_LAI;
LAI_4_Data = double(geotiffread('LAI/TOP2_LAI_4.tif'))*scale_LAI;
LAI_5_Data = double(geotiffread('LAI/TOP2_LAI_5.tif'))*scale_LAI;
LAI_6_Data = double(geotiffread('LAI/TOP2_LAI_6.tif'))*scale_LAI;
LAI_7_Data = double(geotiffread('LAI/TOP2_LAI_7.tif'))*scale_LAI;
LAI_8_Data = double(geotiffread('LAI/TOP2_LAI_8.tif'))*scale_LAI;
LAI_9_Data = double(geotiffread('LAI/TOP2_LAI_9.tif'))*scale_LAI;
LAI_10_Data = double(geotiffread('LAI/TOP2_LAI_10.tif'))*scale_LAI;
LAI_11_Data = double(geotiffread('LAI/TOP2_LAI_11.tif'))*scale_LAI;
LAI_12_Data = double(geotiffread('LAI/TOP2_LAI_12.tif'))*scale_LAI;

% calculate SAI
% from Table 2 in Zeng et al., 2002, Coupling of the Common Land Model to the NCAR Community Climate Model
LUT_SAI = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
    0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.0 0.0 0.25 0 0.5
    1 1 1 1 1 1 1 1 1 1 1 0.1 0.1 0.5 0 1];

SAI_1_Data = nan(size(LAI_1_Data));
SAI_2_Data = nan(size(LAI_1_Data));
SAI_3_Data = nan(size(LAI_1_Data));
SAI_4_Data = nan(size(LAI_1_Data));
SAI_5_Data = nan(size(LAI_1_Data));
SAI_6_Data = nan(size(LAI_1_Data));
SAI_7_Data = nan(size(LAI_1_Data));
SAI_8_Data = nan(size(LAI_1_Data));
SAI_9_Data = nan(size(LAI_1_Data));
SAI_10_Data = nan(size(LAI_1_Data));
SAI_11_Data = nan(size(LAI_1_Data));
SAI_12_Data = nan(size(LAI_1_Data));

[rows, cols] = size(SAI_1_Data);
for row = 1:rows
    for col = 1:cols
        pft_i = LCData(row, col);
        
        if pft_i<1 || pft_i>16 || pft_i==15
            SAI_1_Data(row, col) =0;
            SAI_2_Data(row, col) =0;
            SAI_3_Data(row, col) =0;
            SAI_4_Data(row, col) =0;
            SAI_5_Data(row, col) =0;
            SAI_6_Data(row, col) =0;
            SAI_7_Data(row, col) =0;
            SAI_8_Data(row, col) =0;
            SAI_9_Data(row, col) =0;
            SAI_10_Data(row, col) =0;
            SAI_11_Data(row, col) =0;
            SAI_12_Data(row, col) =0;
        else
            
            alpha = LUT_SAI(2, pft_i);
            Ls_min = LUT_SAI(3, pft_i);
            
            % 2
            Ls_n_1 = Ls_min;
            LAI_n_1 = LAI_1_Data(row, col);
            LAI_n = LAI_2_Data(row, col);
            SAI_2_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 3
            Ls_n_1 = SAI_2_Data(row, col);
            LAI_n_1 = LAI_2_Data(row, col);
            LAI_n = LAI_3_Data(row, col);
            SAI_3_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 4
            Ls_n_1 = SAI_3_Data(row, col);
            LAI_n_1 = LAI_3_Data(row, col);
            LAI_n = LAI_4_Data(row, col);
            SAI_4_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 5
            Ls_n_1 = SAI_4_Data(row, col);
            LAI_n_1 = LAI_4_Data(row, col);
            LAI_n = LAI_5_Data(row, col);
            SAI_5_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 6
            Ls_n_1 = SAI_5_Data(row, col);
            LAI_n_1 = LAI_5_Data(row, col);
            LAI_n = LAI_6_Data(row, col);
            SAI_6_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 7
            Ls_n_1 = SAI_6_Data(row, col);
            LAI_n_1 = LAI_6_Data(row, col);
            LAI_n = LAI_7_Data(row, col);
            SAI_7_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 8
            Ls_n_1 = SAI_7_Data(row, col);
            LAI_n_1 = LAI_7_Data(row, col);
            LAI_n = LAI_8_Data(row, col);
            SAI_8_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 9
            Ls_n_1 = SAI_8_Data(row, col);
            LAI_n_1 = LAI_8_Data(row, col);
            LAI_n = LAI_9_Data(row, col);
            SAI_9_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 10
            Ls_n_1 = SAI_9_Data(row, col);
            LAI_n_1 = LAI_9_Data(row, col);
            LAI_n = LAI_10_Data(row, col);
            SAI_10_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 11
            Ls_n_1 = SAI_10_Data(row, col);
            LAI_n_1 = LAI_10_Data(row, col);
            LAI_n = LAI_11_Data(row, col);
            SAI_11_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 12
            Ls_n_1 = SAI_11_Data(row, col);
            LAI_n_1 = LAI_11_Data(row, col);
            LAI_n = LAI_12_Data(row, col);
            SAI_12_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);
            % 1
            Ls_n_1 = SAI_12_Data(row, col);
            LAI_n_1 = LAI_12_Data(row, col);
            LAI_n = LAI_1_Data(row, col);
            SAI_1_Data(row, col) = max(alpha * Ls_n_1 + max(LAI_n_1 - LAI_n,0) ,Ls_min);           
        end
    end
end

save('LAISAI_1km.mat', 'LAI_1_Data','SAI_1_Data',...
    'LAI_2_Data','SAI_2_Data',...
    'LAI_3_Data','SAI_3_Data',...
    'LAI_4_Data','SAI_4_Data',...
    'LAI_5_Data','SAI_5_Data',...
    'LAI_6_Data','SAI_6_Data',...
    'LAI_7_Data','SAI_7_Data',...
    'LAI_8_Data','SAI_8_Data',...
    'LAI_9_Data','SAI_9_Data',...
    'LAI_10_Data','SAI_10_Data',...
    'LAI_11_Data','SAI_11_Data',...
    'LAI_12_Data','SAI_12_Data');

%% soil texture and soil organic matter
doms = double(imread('soil/TOP2_ocd.tif'))/0.58/10;
sands = double(imread('soil/TOP2_sand.tif'))/10;
silts = double(imread('soil/TOP2_silt.tif'))/10;
clays = double(imread('soil/TOP2_clay.tif'))/10;

dom_0_5 =  squeeze(doms(:,:,1));
dom_5_15 =  squeeze(doms(:,:,2));
dom_15_30 =  squeeze(doms(:,:,3));
dom_30_60 =  squeeze(doms(:,:,4));
dom_60_100 =  squeeze(doms(:,:,5));
dom_100_200 =  squeeze(doms(:,:,6));

silt_0_5 =  squeeze(silts(:,:,1));
silt_5_15 =  squeeze(silts(:,:,2));
silt_15_30 =  squeeze(silts(:,:,3));
silt_30_60 =  squeeze(silts(:,:,4));
silt_60_100 =  squeeze(silts(:,:,5));
silt_100_200 =  squeeze(silts(:,:,6));

sand_0_5 =  squeeze(sands(:,:,1));
sand_5_15 =  squeeze(sands(:,:,2));
sand_15_30 =  squeeze(sands(:,:,3));
sand_30_60 =  squeeze(sands(:,:,4));
sand_60_100 =  squeeze(sands(:,:,5));
sand_100_200 =  squeeze(sands(:,:,6));

clay_0_5 =  squeeze(clays(:,:,1));
clay_5_15 =  squeeze(clays(:,:,2));
clay_15_30 =  squeeze(clays(:,:,3));
clay_30_60 =  squeeze(clays(:,:,4));
clay_60_100 =  squeeze(clays(:,:,5));
clay_100_200 =  squeeze(clays(:,:,6));

dom_0_5(dom_0_5<0) = nan;
dom_5_15(dom_5_15<0) = nan;
dom_15_30(dom_15_30<0) = nan;
dom_30_60(dom_30_60<0) = nan;
dom_60_100(dom_60_100<0) = nan;
dom_100_200(dom_100_200<0) = nan;

clay_0_5(clay_0_5<0) = nan;
clay_5_15(clay_5_15<0) = nan;
clay_15_30(clay_15_30<0) = nan;
clay_30_60(clay_30_60<0) = nan;
clay_60_100(clay_60_100<0) = nan;
clay_100_200(clay_100_200<0) = nan;


silt_0_5(silt_0_5<0) = nan;
silt_5_15(silt_5_15<0) = nan;
silt_15_30(silt_15_30<0) = nan;
silt_30_60(silt_30_60<0) = nan;
silt_60_100(silt_60_100<0) = nan;
silt_100_200(silt_100_200<0) = nan;

sand_0_5(sand_0_5<0) = nan;
sand_5_15(sand_5_15<0) = nan;
sand_15_30(sand_15_30<0) = nan;
sand_30_60(sand_30_60<0) = nan;
sand_60_100(sand_60_100<0) = nan;
sand_100_200(sand_100_200<0) = nan;

save('Soil_1km.mat', 'dom_0_5','dom_5_15',...
    'dom_15_30','dom_30_60',...
    'dom_60_100','dom_100_200',...
    'sand_0_5','sand_5_15',...
    'sand_15_30','sand_30_60',...
    'sand_60_100','sand_100_200',...
    'clay_0_5','clay_5_15',...
    'clay_15_30','clay_30_60',...
    'clay_60_100','clay_100_200',...
    'silt_0_5','silt_5_15',...
    'silt_15_30','silt_30_60',...
    'silt_60_100','silt_100_200');

%% Atmosphere
%% Climate & SAI
scale_Climate = 0.1;
Climate_1_Data = double(geotiffread('climate/TOP2_WorldClim_1.tif'));
Climate_2_Data = double(geotiffread('climate/TOP2_WorldClim_2.tif'));
Climate_3_Data = double(geotiffread('climate/TOP2_WorldClim_3.tif'));
Climate_4_Data = double(geotiffread('climate/TOP2_WorldClim_4.tif'));
Climate_5_Data = double(geotiffread('climate/TOP2_WorldClim_5.tif'));
Climate_6_Data = double(geotiffread('climate/TOP2_WorldClim_6.tif'));
Climate_7_Data = double(geotiffread('climate/TOP2_WorldClim_7.tif'));
Climate_8_Data = double(geotiffread('climate/TOP2_WorldClim_8.tif'));
Climate_9_Data = double(geotiffread('climate/TOP2_WorldClim_9.tif'));
Climate_10_Data = double(geotiffread('climate/TOP2_WorldClim_10.tif'));
Climate_11_Data = double(geotiffread('climate/TOP2_WorldClim_11.tif'));
Climate_12_Data = double(geotiffread('climate/TOP2_WorldClim_12.tif'));

Tavg_1 = squeeze(Climate_1_Data(:,:,1))*scale_Climate;
Tavg_2 = squeeze(Climate_2_Data(:,:,1))*scale_Climate;
Tavg_3 = squeeze(Climate_3_Data(:,:,1))*scale_Climate;
Tavg_4 = squeeze(Climate_4_Data(:,:,1))*scale_Climate;
Tavg_5 = squeeze(Climate_5_Data(:,:,1))*scale_Climate;
Tavg_6 = squeeze(Climate_6_Data(:,:,1))*scale_Climate;
Tavg_7 = squeeze(Climate_7_Data(:,:,1))*scale_Climate;
Tavg_8 = squeeze(Climate_8_Data(:,:,1))*scale_Climate;
Tavg_9 = squeeze(Climate_9_Data(:,:,1))*scale_Climate;
Tavg_10 = squeeze(Climate_10_Data(:,:,1))*scale_Climate;
Tavg_11 = squeeze(Climate_11_Data(:,:,1))*scale_Climate;
Tavg_12 = squeeze(Climate_12_Data(:,:,1))*scale_Climate;


Tmin_1 = squeeze(Climate_1_Data(:,:,2))*scale_Climate;
Tmin_2 = squeeze(Climate_2_Data(:,:,2))*scale_Climate;
Tmin_3 = squeeze(Climate_3_Data(:,:,2))*scale_Climate;
Tmin_4 = squeeze(Climate_4_Data(:,:,2))*scale_Climate;
Tmin_5 = squeeze(Climate_5_Data(:,:,2))*scale_Climate;
Tmin_6 = squeeze(Climate_6_Data(:,:,2))*scale_Climate;
Tmin_7 = squeeze(Climate_7_Data(:,:,2))*scale_Climate;
Tmin_8 = squeeze(Climate_8_Data(:,:,2))*scale_Climate;
Tmin_9 = squeeze(Climate_9_Data(:,:,2))*scale_Climate;
Tmin_10 = squeeze(Climate_10_Data(:,:,2))*scale_Climate;
Tmin_11 = squeeze(Climate_11_Data(:,:,2))*scale_Climate;
Tmin_12 = squeeze(Climate_12_Data(:,:,2))*scale_Climate;

Tmax_1 = squeeze(Climate_1_Data(:,:,3))*scale_Climate;
Tmax_2 = squeeze(Climate_2_Data(:,:,3))*scale_Climate;
Tmax_3 = squeeze(Climate_3_Data(:,:,3))*scale_Climate;
Tmax_4 = squeeze(Climate_4_Data(:,:,3))*scale_Climate;
Tmax_5 = squeeze(Climate_5_Data(:,:,3))*scale_Climate;
Tmax_6 = squeeze(Climate_6_Data(:,:,3))*scale_Climate;
Tmax_7 = squeeze(Climate_7_Data(:,:,3))*scale_Climate;
Tmax_8 = squeeze(Climate_8_Data(:,:,3))*scale_Climate;
Tmax_9 = squeeze(Climate_9_Data(:,:,3))*scale_Climate;
Tmax_10 = squeeze(Climate_10_Data(:,:,3))*scale_Climate;
Tmax_11 = squeeze(Climate_11_Data(:,:,3))*scale_Climate;
Tmax_12 = squeeze(Climate_12_Data(:,:,3))*scale_Climate;

Prec_1 = squeeze(Climate_1_Data(:,:,4));
Prec_2 = squeeze(Climate_2_Data(:,:,4));
Prec_3 = squeeze(Climate_3_Data(:,:,4));
Prec_4 = squeeze(Climate_4_Data(:,:,4));
Prec_5 = squeeze(Climate_5_Data(:,:,4));
Prec_6 = squeeze(Climate_6_Data(:,:,4));
Prec_7 = squeeze(Climate_7_Data(:,:,4));
Prec_8 = squeeze(Climate_8_Data(:,:,4));
Prec_9 = squeeze(Climate_9_Data(:,:,4));
Prec_10 = squeeze(Climate_10_Data(:,:,4));
Prec_11 = squeeze(Climate_11_Data(:,:,4));
Prec_12 = squeeze(Climate_12_Data(:,:,4));


%% calculate Tc Tw
Tbase = 5;
Tavg_all = nan([size(Tavg_1), 12]);
Tavg_all(:,:,1) = Tavg_1;
Tavg_all(:,:,2) = Tavg_2;
Tavg_all(:,:,3) = Tavg_3;
Tavg_all(:,:,4) = Tavg_4;
Tavg_all(:,:,5) = Tavg_5;
Tavg_all(:,:,6) = Tavg_6;
Tavg_all(:,:,7) = Tavg_7;
Tavg_all(:,:,8) = Tavg_8;
Tavg_all(:,:,9) = Tavg_9;
Tavg_all(:,:,10) = Tavg_10;
Tavg_all(:,:,11) = Tavg_11;
Tavg_all(:,:,12) = Tavg_12;

% coldest month
Tc = nanmin(Tavg_all, [], 3);
% warmest month
Tw = nanmax(Tavg_all, [], 3);

GDD_1 = (Tmax_1 + Tmin_1)/2  - Tbase;
GDD_2 = (Tmax_2 + Tmin_2)/2  - Tbase;
GDD_3 = (Tmax_3 + Tmin_3)/2  - Tbase;
GDD_4 = (Tmax_4 + Tmin_4)/2  - Tbase;
GDD_5 = (Tmax_5 + Tmin_5)/2  - Tbase;
GDD_6 = (Tmax_6 + Tmin_6)/2  - Tbase;
GDD_7 = (Tmax_7 + Tmin_7)/2  - Tbase;
GDD_8 = (Tmax_8 + Tmin_8)/2  - Tbase;
GDD_9 = (Tmax_9 + Tmin_9)/2  - Tbase;
GDD_10 = (Tmax_10 + Tmin_10)/2  - Tbase;
GDD_11 = (Tmax_11 + Tmin_11)/2  - Tbase;
GDD_12 = (Tmax_12 + Tmin_12)/2  - Tbase;

GDD_1(GDD_1<0) = 0;
GDD_2(GDD_2<0) = 0;
GDD_3(GDD_3<0) = 0;
GDD_4(GDD_4<0) = 0;
GDD_5(GDD_5<0) = 0;
GDD_6(GDD_6<0) = 0;
GDD_7(GDD_7<0) = 0;
GDD_8(GDD_8<0) = 0;
GDD_9(GDD_9<0) = 0;
GDD_10(GDD_10<0) = 0;
GDD_11(GDD_11<0) = 0;
GDD_12(GDD_12<0) = 0;

GDD = GDD_1*31 + GDD_2*28 + GDD_3*31 + GDD_4*30 + GDD_5*31 + GDD_6*30 + ...
    GDD_7*31 + GDD_8*31 + GDD_9*30 + GDD_10*31 + GDD_11*30 + GDD_12*31;

Pann = Prec_1 + Prec_2 + Prec_3 + ...
    Prec_4 + Prec_5 + Prec_6 +...
    Prec_7 + Prec_8 + Prec_9 +...
    Prec_10 + Prec_11 + Prec_12;

%% Winter northern hemisphere 11-4
Pwin = Prec_11 + Prec_12 + Prec_1 + Prec_2 + Prec_3 + Prec_4;

%% build PFT data reference: Table 3 in Landscapes as patches of plant functional types: An integrating concept for climate and ecosystem models
%% PFT
LCData = double(geotiffread('pft/TOP2_LC_2005_mode.tif'));

LC_ELM_Data = nan(size(LCData));
[rows, cols] = size(SAI_1_Data);
for row = 1:rows
    for col = 1:cols
        pft_i = LCData(row, col);
        if pft_i == 0
            LC_ELM_Data(row, col) = 18; % lake 18
        elseif pft_i == 1
            if Tc(row, col) >-19 && GDD(row, col)>1200
                LC_ELM_Data(row, col) = 1;
            else
                LC_ELM_Data(row, col) = 2;
            end
        elseif pft_i == 3
            LC_ELM_Data(row, col) = 3;
        elseif pft_i == 2
            if Tc(row, col) >15.5
                LC_ELM_Data(row, col) = 4;
            else
                LC_ELM_Data(row, col) = 5;
            end
        elseif pft_i==4
            if Tc(row, col) >15.5
                LC_ELM_Data(row, col) = 6;
            elseif Tc(row, col) >-15 && Tc(row, col)<=15.5 && GDD(row, col)>1200
                LC_ELM_Data(row, col) = 7;
            else
                LC_ELM_Data(row, col) = 8;
            end
        elseif pft_i==5
            if Tc(row, col) >-19 && GDD(row, col)>1200 && Pann(row, col)>520 && Pwin(row, col)>2/3*Pann(row, col)
                LC_ELM_Data(row, col) = 9;
            elseif Tc(row, col) >-19 && GDD(row, col)>1200 && (Pann(row, col)<=520 || Pwin(row, col)<= 2/3*Pann(row, col))
                LC_ELM_Data(row, col) = 10;
            else
                LC_ELM_Data(row, col) = 11;
            end
        elseif pft_i==6 % grass
            if GDD(row, col)<1000
                LC_ELM_Data(row, col) = 12;
            else %% C3/C4 fraction based on section 3.4 at Still et al. (2003)
                Prec_tmp = [Prec_1(row, col) Prec_2(row, col) Prec_3(row, col) Prec_4(row, col) Prec_5(row, col) Prec_6(row, col) ...
                    Prec_7(row, col) Prec_8(row, col) Prec_9(row, col) Prec_10(row, col) Prec_11(row, col) Prec_12(row, col) ];
                Tavg_tmp = squeeze(Tavg_all(row, col, :))';
                LAI_tmp = [LAI_1_Data(row, col) LAI_2_Data(row, col) LAI_3_Data(row, col) LAI_4_Data(row, col) LAI_5_Data(row, col) LAI_6_Data(row, col) ...
                    LAI_7_Data(row, col) LAI_8_Data(row, col) LAI_9_Data(row, col) LAI_10_Data(row, col) LAI_11_Data(row, col) LAI_12_Data(row, col) ];
                frac_tmp = nansum(LAI_tmp(Prec_tmp>=25 & Tavg_tmp>=22))/nansum(LAI_tmp(Prec_tmp>=25)); % different from Still et al. (2003), we use LAI rather than NDVI. Specifically, the C4 fraction of a grid cell was weighted by the sum of NDVI values in C4 climate months divided by the sum of NDVI values during the entiregrowing season.
                
                if isnan(frac_tmp) || frac_tmp<0
                    frac_tmp = 0;
                elseif frac_tmp>1
                    frac_tmp = 1;
                end
                LC_ELM_Data(row, col) = 13 + frac_tmp; % 13 + C4 fraction
            end
        elseif pft_i == 7 || pft_i == 8 % crop
            LC_ELM_Data(row, col) = 15;
        elseif pft_i == 9
            LC_ELM_Data(row, col) = 17;% urban 17
        elseif pft_i == 10
            LC_ELM_Data(row, col) = 19;% glacier 19
        elseif pft_i == 11
            LC_ELM_Data(row, col) = 0;% bare land 0
        end
    end
end
%0 bare soil
%1 NETT
%2 NEBT
%3 NDBT
%4 BETroT
%5 BETemT
%6 BDTroT
%7 BDTemT
%8 BDBT
%9 BES
%10 BDTS
%11 BDBS
%12 C3ARCTIC
%13 C3_no_GTASS
%14 C4_nO_GTASS
%15 C3_CROP
%16 wetland
%17 urban
%18 lake
%19 glacier
save('LCELM_1km.mat', 'LC_ELM_Data');

%% Topography data
meanelevation = double(imread('elevation/TOP2_mean_of_Elevation.tif'));
stdelevation = double(imread('elevation/TOP2_std_of_Elevation.tif'));

meanelevation_ext = double(imread('topographic_factor/TOP2_mean_of_Elevation_larger_ROI.tif'));
% topographic factors
slope = double(imread('topographic_factor/TOP2_Slope.tif'));
aspect = double(imread('topographic_factor/TOP2_Aspect.tif'));
SVF = double(imread('topographic_factor/TOP2_SVF.tif'));
Horizon_0 = double(imread('topographic_factor/TOP2_Horizon_angle_0.tif'));
Horizon_45 = double(imread('topographic_factor/TOP2_Horizon_angle_45.tif'));
Horizon_90 = double(imread('topographic_factor/TOP2_Horizon_angle_90.tif'));
Horizon_135 = double(imread('topographic_factor/TOP2_Horizon_angle_135.tif'));
Horizon_180 = double(imread('topographic_factor/TOP2_Horizon_angle_180.tif'));
Horizon_225 = double(imread('topographic_factor/TOP2_Horizon_angle_225.tif'));
Horizon_270 = double(imread('topographic_factor/TOP2_Horizon_angle_270.tif'));
Horizon_315 = double(imread('topographic_factor/TOP2_Horizon_angle_315.tif'));

%% clip topographic factors to the ROI (2400 2760) -> (2160 2520)
rows_roi = [(120+1):(2400-120)];
cols_roi = [(120+1):(2760-120)];
meanelevation_ext = meanelevation_ext(rows_roi, cols_roi); % compare with meanelevation for check

slope= slope(rows_roi, cols_roi);
aspect= aspect(rows_roi, cols_roi);
SVF= SVF(rows_roi, cols_roi);
Horizon_0 = Horizon_0(rows_roi, cols_roi);
Horizon_45 = Horizon_45(rows_roi, cols_roi);
Horizon_90 = Horizon_90(rows_roi, cols_roi);
Horizon_135 = Horizon_135(rows_roi, cols_roi);
Horizon_180 = Horizon_180(rows_roi, cols_roi);
Horizon_225 = Horizon_225(rows_roi, cols_roi);
Horizon_270 = Horizon_270(rows_roi, cols_roi);
Horizon_315 = Horizon_315(rows_roi, cols_roi);

save('TOP_1km.mat', 'meanelevation','stdelevation',...
    'slope','aspect','SVF',...
    'Horizon_0','Horizon_45','Horizon_90','Horizon_135',...
    'Horizon_180','Horizon_225','Horizon_270','Horizon_315');

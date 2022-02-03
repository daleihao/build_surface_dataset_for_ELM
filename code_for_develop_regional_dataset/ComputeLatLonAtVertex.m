% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Computes latitude/longitude at vertices of grid cells.
% Only supports quadrilateral grid cells.
%
% INPUT:
%       lon  = Vector containing longitude @ cell-center.
%       lat  = Vector containing latitude @ cell-center.
%       dlat = Latitudinal grid spacing
%       dlon = Longitudinal grid spacing
%
% OUTPUT:
%       latv = Vector containing latitude @ cell-vertex.
%       lonv = Vector containing longitude @ cell-vertex.
%
% Gautam Bisht (gbisht@lbl.gov)
% 05-28-2015
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [latv,lonv] = ComputeLatLonAtVertex(lat, lon, dlat, dlon)

size_1 = size(lat, 1);
size_2 = size(lat, 2);

latv = zeros(4, size_1, size_2);
lonv = zeros(4, size_1, size_2);

for ii = 1:size_1
    for jj = 1:size_2
        lonv(:, ii,jj) = [lon(ii,jj)-dlon/2 lon(ii,jj)+dlon/2 lon(ii,jj)+dlon/2 lon(ii,jj)-dlon/2];
        latv(:, ii,jj) = [lat(ii,jj)-dlat/2 lat(ii,jj)-dlat/2 lat(ii,jj)+dlat/2 lat(ii,jj)+dlat/2];
    end
end

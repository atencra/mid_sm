function [info_extrap] = info_extrapolate(fraction, ifrac_mtx)
% info_extrapolate - extrapolated information values from data fractions.
%
% [info_extrap] = info_extrapolate(fraction, ifrac_mtx, ifrac_mn)
% -----------------------------------------------------------------------
%
% Find asymptotic information values using linear fit. We plot information
% vs. 1/fraction, where fraction is a vector of data set size
% percentages. Example: fraction = [90 92.5 95 97.5 100]. 
%
% We fit a line to the information values versus the inverse of the data
% fraction. The y-intercept of the line represents the information value
% that would be present for infinite data set size. This y-intercept value
% is the extrapolated information value. 
%
% Input arguments:
%
% fraction : the fractions of the data that were used. Usually something
% like [80 85 90 92.5 95 97.5 100]
%
% ifrac_mtx : matrix of information values for each series to be estimated.
% If ifrac_mtx is Nxlength(fraction), then N extrapolated values will
% be returned. 
%
% length(fraction) must equal size(ifrac_mtx,2).
%
%
% Output arguments:
%
% info_extrap : extrapolated information values. A vector if ifrac_mtx
% has more than 1 row.
%
%

fprintf('\nRunning info_extrapolate ...\n');

x = 1./fraction;

[nrows, ncols] = size(ifrac_mtx);
info_extrap = zeros(1,nrows);

for i = 1:nrows
    y = ifrac_mtx(i,:);
    p = polyfit(x,y,1);
    info_extrap(i) = p(2);
    %figure; plot(x, y, 'ko');ylim([0 1.1*max(y)]); pause;
end


return;











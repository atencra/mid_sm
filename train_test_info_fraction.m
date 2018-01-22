function [ifraction] = train_test_info_fraction(xbins, locator, x, fraction)
%train_test_info_fraction - Data fraction information for a filter
%
% [ifraction] = train_test_info_fraction(xbins, locator, x, fraction)
% -------------------------------------------------------------------
%
% xbins{i} : cell array of vectors, where each vector contains the 
% bin centers for probability histograms. Obtained from proj_prob_dist.m
%
% locator : Tells if there was a spike at a given trial. Cell array 
% with 4 elements. Each element is a vector.
%
% x : 1x4 cell array. Each element holds the projection values onto
% a filter.
%
% fraction : vector of data fractions. Example: [80 85 90 92.5 95 97.5 100]
%
% ifraction : 4xlength(fraction) cell array. Each "row" holds the
% information estimates for a given data fraction. For each data fraction,
% five estimates of the information are made.
%
% caa 3/13/09

if ( ~iscell(xbins) & ~iscell(locator) & ~iscell(x) )
    xbins = {xbins};
    locator = {locator};
    x = {x};
end

fprintf('\nRunning train_test_info_fraction ...\n');


% We have four data sets. length(x) = 4, with x a cell array.

% For one of the data sets, we need to get the information fractions
% for 75, 80, 85, 90, 95, and 100 percent of the data.

% So we need two loops: one for data set number, and one for data fraction

% As output we'll use a cell array that is 4xlength(fraction),
% where


ifraction = cell( length(x), length(fraction) );

for i = 1:length(x)

   fprintf('\nJacknife #%.0f\n', i); 

   for j = 1:length(fraction)

        fprintf('Fraction = %.2f\n', fraction(j)); 

        [ifrac] = info_fraction( xbins{i}, x{i}, locator{i}, fraction(j) );

        ifraction{i}{j} = ifrac;

   end % (for j)

end % (for i)

return;










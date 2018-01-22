function [ifraction] = train_test_info_fraction_2d(x1binedges, x2binedges, locator, x1, x2, fraction)
%train_test_info_fraction_2d - Data fraction information for MID1 and MID2
%
% [ifraction] = train_test_info_fraction_2d(x1binedges, x2binedges, locator, x1, x2, fraction)
% ---------------------------------------------------------------------------
%
% x1binedges, x2binedges : cell array of vectors. Each vector holds the 
% bin edges for binning mid1, mid2 probability distributions.
%
% locator : Tells if there was a spike at a given trial. Cell array 
% with 4 elements. Each element is a vector.
%
% x1 : 1x4 cell array. Each element holds the projection values onto
% the first MID.
%
% x2 : 1x4 cell array. Each element holds the projection values onto
% the second MID.
%
% fraction : vector of data fractions. Example: [80 85 90 92.5 95 97.5 100]
%
% ifraction : 4xlength(fraction) cell array. Each "row" holds the
% information estimates for a given data fraction. For each data fraction,
% five estimates of the information are made.
%
% caa 3/13/09

fprintf('\nRunning train_test_info_fraction_2d ...\n');


% We have four data sets. length(x) = 4, with x a cell array.

% For one of the data sets, we need to get the information fractions
% for 75, 80, 85, 90, 95, and 100 percent of the data.

% So we need two loops: one for data set number, and one for data fraction

% As output we'll use a cell array that is 4xlength(fraction),
% where


ifraction = cell( length(x1), length(fraction) );

for i = 1:length(x1)

   for j = 1:length(fraction)

      [ifrac] = info_fraction(x1binedges{i}, x1{i}, locator{i}, fraction(j), ... 
                              x2binedges{i}, x2{i} );

      ifraction{i}{j} = ifrac;

   end % (for j)

end % (for i)

return;










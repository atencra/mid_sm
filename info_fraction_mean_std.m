function [info_frac_mn, info_frac_std, info_mtx, info_mtx_total] = ...
    info_fraction_mean_std(fraction, info_fraction)
%info_fraction_mean_std - mean, stand dev of information fraction calculations
%
% Information values were calculated for different fraction of the data for
% each of 4 training or test data sets. For each fraction, 5 randomized 
% estimates of information were calculated. This function takes the mean 
% of the 5 estimates. It also takes another mean, this time across the 4 
% data sets.
%
% [info_frac_mn, info_frac_std, info_mtx] = info_fraction_mean_std(fraction, info_fraction)
% ----------------------------------------------------------------------------------------------------
% fraction : proportions of the data used. A vector like [80 90 95 97.5
% 100], or something similar.
%
% info_fraction : 4xlength(fraction) cell array. Information calculations 
% for the 4 different data sets, with 5 information estimates for each
% data fraction. Thus, each element of info_fraction is a 1x5 vector.
%
% info_frac_mn : mean information values across the 4 data sets for each
% data fraction. A vector of length(fraction).
%
% info_frac_std : same as info_frac_mn, except for standard deviation.
%
% info_mtx : 4xlength(fraction) matrix of information values. Each element
% represents the mean of 5 information values for a given data fraction.
% Each row represent one of the 4 data sets.
%
% caa 3/13/09

fprintf('\nRunning info_fraction_mean_std ...\n');



if iscell(info_fraction)

    if ( length(fraction) ~= size(info_fraction,2) )
       error('fraction and size(info_fraction,2) do not match.');
    end

    info_mtx = zeros( size(info_fraction,1), size(info_fraction,2) );

    info_mtx_total = [];

    for i = 1:size(info_fraction,1) % for each data set

       for j = 1:size(info_fraction,2) % for each fraction of the data

          temp = info_fraction{i}{j};

          info_mtx_total = [info_mtx_total; i temp];

          info_mtx(i, j) = mean(temp);

       end % (for j)

    end % (for i)

elseif isstruct(info_fraction)

    info_mtx = zeros( length(info_fraction), length(info_fraction(1).fraction) );

    info_mtx_total = [];

    for i = 1:length(info_fraction)

       for j = 1:length(info_fraction(1).fraction)

          temp = info_fraction(i).ifrac(j).iplugin_reps;

          info_mtx_total = [info_mtx_total; i info_fraction(i).fraction(j) temp];

          info_mtx(i, j) = mean(temp);

       end % (for j)

    end % (for i)

else

    error('Unknown data type.')

end

info_frac_mn = mean( info_mtx, 1 );
info_frac_std = std( info_mtx, 0, 1 );

return;







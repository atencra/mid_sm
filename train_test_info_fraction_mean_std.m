function [info_frac_mn, info_frac_std, info_mtx] = train_test_info_fraction_mean_std(fraction, ifraction)
%train_test_info_fraction_mean_std - mean, standard dev of information 
% data fraction calculations.
%
% Information values were calculated for different fraction of the data for
% each of 4 training or test data sets. For each fraction, 5 randomized 
% estimates of information were calculated. This function takes the mean 
% of the 5 estimates. It also takes another mean, this time across the 4 
% data sets.
%
% [info_frac_mn, info_frac_std, info_mtx] = train_test_info_fraction_mean_std(fraction, ifraction)
% ----------------------------------------------------------------------------------------------------
% fraction : proportions of the data used. A vector like [80 90 95 97.5
% 100], or something similar.
%
% ifraction : 4xlength(fraction) cell array. Information calculations 
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

fprintf('\nRunning train_test_info_fraction_mean_std ...\n');


if ( length(fraction) ~= size(ifraction,2) )
   error('fraction and size(info_fraction,2) do not match.');
end


info_mtx = zeros( size(ifraction,1), size(ifraction,2) );

for i = 1:size(ifraction,1) % for each data set

   for j = 1:size(ifraction,2) % for each fraction of the data

      temp = ifraction{i}{j};

      info_mtx(i, j) = mean(temp.ifrac.iplugin_reps);

   end % (for j)

end % (for i)

info_frac_mn = mean( info_mtx, 1 );
info_frac_std = std( info_mtx, 0, 1 );

return;







function [proj] = sm_mid_filter_stimulus_locator_to_projections(data, stimulus, locator)
% sm_mid_filter_stimulus_locator_to_fio_resample Resampled nonlinearities 
%
% [proj] = sm_mid_filter_stimulus_locator_to_projections(data, stimulus, locator)
% ------------------------------------------------------------------------
%
% data : struct holding filter and nonlinearity data.
%
% stimulus : the entire ripple stimulus envelope file as one matrix. Usually stored in
%       a file such as: 
%
%               'D:\stimuli\20031124\dmr-50flo-40000fhi-4SM-500TM-40db-48DF-21min_DFt2_DFf8-matrix.mat
%
% locator : binned spike train. length(locator) == size(stimulus,2)
%
%
% fio : struct with resampled nonlinearities for sta, mid1, and mid2.
%
% caa 3/5/18

library('mid_sm');

narginchk(3,3);

proj = data;

x0 = data.x0;
numtbins = data.nt_filter;
numfbins = data.nf_filter;

index_freq = (x0):(numfbins-1+x0);

nreps = 100;

percent = 95;

%--------------------------------------------------------------------
%   STA Filter from MID Code
%--------------------------------------------------------------------

fprintf('\nSTA\n');

sta{1} = reshape( data.filter_matrix_sta(:,1), numfbins, numtbins );
sta{2} = reshape( data.filter_matrix_sta(:,2), numfbins, numtbins );
sta{3} = reshape( data.filter_matrix_sta(:,3), numfbins, numtbins );
sta{4} = reshape( data.filter_matrix_sta(:,4), numfbins, numtbins );

[x0train, x0test, x0train_locator, x0test_locator] = ...
   sm_train_test_projection(sta, locator, stimulus, index_freq);

proj.sta = sta;
proj.x0train = x0train;
proj.x0test = x0test;
proj.x0train_locator = x0train_locator;
proj.x0test_locator = x0test_locator;



%--------------------------------------------------------------------
%   MID1 Filter from MID Code
%--------------------------------------------------------------------

fprintf('\nMID1\n');

mid1{1} = reshape( data.filter_matrix_test2_v1(:,1), numfbins, numtbins );
mid1{2} = reshape( data.filter_matrix_test2_v1(:,2), numfbins, numtbins );
mid1{3} = reshape( data.filter_matrix_test2_v1(:,3), numfbins, numtbins );
mid1{4} = reshape( data.filter_matrix_test2_v1(:,4), numfbins, numtbins );

[x1train, x1test, x1train_locator, x1test_locator] = ...
   sm_train_test_projection(mid1, locator, stimulus, index_freq);

proj.mid1 = mid1;
proj.x1train = x1train;
proj.x1train_locator = x1train_locator;
proj.x1test = x1test;
proj.x1test_locator = x1test_locator;



%--------------------------------------------------------------------
%   MID2 Filter from MID Code
%--------------------------------------------------------------------

fprintf('\nMID2\n');

mid2{1} = reshape( data.filter_matrix_test2_v2(:,1), numfbins, numtbins );
mid2{2} = reshape( data.filter_matrix_test2_v2(:,2), numfbins, numtbins );
mid2{3} = reshape( data.filter_matrix_test2_v2(:,3), numfbins, numtbins );
mid2{4} = reshape( data.filter_matrix_test2_v2(:,4), numfbins, numtbins );

[x2train, x2test, x2train_locator, x2test_locator] = ...
   sm_train_test_projection(mid2, locator, stimulus, index_freq);

proj.mid2 = mid2;
proj.x2train = x2train;
proj.x2train_locator = x2train_locator;
proj.x2test = x2test;
proj.x2test_locator = x2test_locator;


return;











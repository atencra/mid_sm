function [fio] = sm_mid_proj_to_fio_resample(proj)
% sm_mid_filter_stimulus_locator_to_fio_resample Resampled nonlinearities 
%
% [fio] = sm_mid_proj_to_fio_resample(proj)
% ------------------------------------------------------------------------
%
% proj : struct holding filter and nonlinearity data.
%
% fio : struct with resampled nonlinearities for sta, mid1, and mid2.
%
% caa 3/5/18

library('mid_sm');

narginchk(1,1);

fio = proj;

fields = {...
'sta', ...
'x0train', ...
'x0test', ...
'x0train_locator', ...
'x0test_locator', ...
'mid1', ...
'x1train', ...
'x1test', ...
'x1train_locator', ...
'x1test_locator', ...
'mid2', ...
'x2train', ...
'x2test', ...
'x2train_locator', ...
'x2test_locator'};

fio = rmfield(fio, fields);

x0 = proj.x0;
numtbins = proj.nt_filter;
numfbins = proj.nf_filter;

index_freq = (x0):(numfbins-1+x0);

nreps = 50;

percent = 95;

%--------------------------------------------------------------------
%   STA Filter from MID Code
%--------------------------------------------------------------------

fprintf('\nSTA\n');

sta{1} = reshape( proj.filter_matrix_sta(:,1), numfbins, numtbins );
sta{2} = reshape( proj.filter_matrix_sta(:,2), numfbins, numtbins );
sta{3} = reshape( proj.filter_matrix_sta(:,3), numfbins, numtbins );
sta{4} = reshape( proj.filter_matrix_sta(:,4), numfbins, numtbins );

sta = proj.sta;
x0train = proj.x0train;
x0train_locator = proj.x0train_locator;
x0test = proj.x0train;
x0test_locator = proj.x0test_locator;

sta_fio_training_set = fio_1d_resample(x0train, x0train_locator, nreps, percent);



%sm_plot_filters_nonlinearities(sta, x0bins, pspk, pspkx0, 'STA Analysis');

%plot_filters_nonlinearities_resample(sta, x0bins_resample, pspk_resample, pspkx0_resample, 'STA Analysis');

fio.sta = sta;
fio.sta_fio_resample = sta_fio_training_set;



%sm_plot_filters_nonlinearities(sta, x0bins, pspk, pspkx0, 'STA Analysis');

%plot_filters_nonlinearities_resample(sta, x0bins_resample, pspk_resample, pspkx0_resample, 'STA Analysis');






%--------------------------------------------------------------------
%   MID1 Filter from MID Code
%--------------------------------------------------------------------

fprintf('\nMID1\n');

mid1{1} = reshape( proj.filter_matrix_test2_v1(:,1), numfbins, numtbins );
mid1{2} = reshape( proj.filter_matrix_test2_v1(:,2), numfbins, numtbins );
mid1{3} = reshape( proj.filter_matrix_test2_v1(:,3), numfbins, numtbins );
mid1{4} = reshape( proj.filter_matrix_test2_v1(:,4), numfbins, numtbins );


mid1 = proj.mid1;
x1train = proj.x1train;
x1train_locator = proj.x1train_locator;
x1test = proj.x1train;
x1test_locator = proj.x1test_locator;

mid1_fio_training_set = fio_1d_resample(x1train, x1train_locator, nreps, percent);

fio.mid1 = mid1;
fio.mid1_fio_resample = mid1_fio_training_set;




%--------------------------------------------------------------------
%   MID2 Filter from MID Code
%--------------------------------------------------------------------

fprintf('\nMID2\n');

mid2{1} = reshape( proj.filter_matrix_test2_v2(:,1), numfbins, numtbins );
mid2{2} = reshape( proj.filter_matrix_test2_v2(:,2), numfbins, numtbins );
mid2{3} = reshape( proj.filter_matrix_test2_v2(:,3), numfbins, numtbins );
mid2{4} = reshape( proj.filter_matrix_test2_v2(:,4), numfbins, numtbins );


mid2 = proj.mid2;
x2train = proj.x2train;
x2train_locator = proj.x2train_locator;
x2test = proj.x2train;
x2test_locator = proj.x2test_locator;

mid2_fio_training_set = fio_1d_resample(x2train, x2train_locator, nreps, percent);

fio.mid2 = mid2;
fio.mid2_fio_resample = mid2_fio_training_set;



%--------------------------------------------------------------------
%   MID1 and MID2 Information
%--------------------------------------------------------------------

fprintf('\nMID1 and MID2\n');

mid12_fio_training_set = fio_2d_resample(x1train, x2train, x1train_locator, nreps, percent);

fio.mid12_fio_resample = mid12_fio_training_set;


fprintf('Successful run.\n');

return;




function fio_training_set = fio_1d_resample(projections, locator, nreps, percent)

if length(projections) ~= 4
    error('Need 4 training set projection distributions.');
end


if length(locator) ~= 4
    error('Need 4 training set locator distributions.');
end




for i = 1:length(projections)

    training_set_projections = projections{i};
    training_set_locator = locator{i};

    training_set_xbins = {};
    training_set_pspk = {};
    training_set_px = {};
    training_set_pxspk = {};
    training_set_pspkx = {};

    rand('state', 1);

    fprintf('Training set #%.0f/%.0f\n', i, length(projections));

    for j = 1:nreps

        fprintf('Rep #%.0f/%.0f\n', j, nreps);

        nsamples = length(training_set_projections);
        nsamples_subset = floor(percent/100 * nsamples);
        index_rand = round( 1 + (nsamples-1)*rand(1, nsamples_subset) );
        projections_subset = training_set_projections(index_rand);
        locator_subset = training_set_locator(index_rand);

        [xbins_subset, pspk_subset, px_subset, pxspk_subset, pspkx_subset] = ...
            sm_nonlinearity_projections_1d(projections_subset, locator_subset);
        
        training_set_xbins{j} = xbins_subset;
        training_set_pspk{j} = pspk_subset;
        training_set_px{j} = px_subset;
        training_set_pxspk{j} = pxspk_subset;
        training_set_pspkx{j} = pspkx_subset;

        clear('xbins_subset', 'pspk_subset', 'px_subset', 'pxspk_subset', 'pspkx_subset');

    end % (for j)

    fio_training_set(i).nreps = nreps;
    fio_training_set(i).percent = percent;
    fio_training_set(i).index_rand = index_rand;
    fio_training_set(i).xbins = training_set_xbins;
    fio_training_set(i).pspk = training_set_pspk;
    fio_training_set(i).px = training_set_px;
    fio_training_set(i).pxspk = training_set_pxspk;
    fio_training_set(i).pspkx = training_set_pspkx;


end % (for i)

return 







function fio_training_set = fio_2d_resample(projections1, projections2, locator, nreps, percent)

if length(projections1) ~= 4
    error('Need 4 mid1 training set projection distributions.');
end


if length(projections2) ~= 4
    error('Need 4 mid2 training set projection distributions.');
end


if length(locator) ~= 4
    error('Need 4 training set locator distributions.');
end




for i = 1:length(projections1)

    training_set_projections1 = projections1{i};
    training_set_projections2 = projections2{i};
    training_set_locator = locator{i};

    if ( length(training_set_projections1) ~= length(training_set_projections2) )
        error(sprintf('Need same number of mid1 and mid2 projections in rep #%.0f', i));
    end

    training_set_x1edges = {};
    training_set_x2edges = {};
    training_set_pspk = {};
    training_set_px1x2 = {};
    training_set_px1x2spk = {};
    training_set_pspkx1x2 = {};

    rand('state', 1);

    for j = 1:nreps

        fprintf('Training set #%.0f/%.0f, Rep #%.0f/%.0f\n', i, length(projections1), j, nreps);

        nsamples = length(training_set_projections1);
        nsamples_subset = floor(percent/100 * nsamples);
        index_rand = round( 1 + (nsamples-1)*rand(1, nsamples_subset) );

        xprior1_subset = training_set_projections1(index_rand);
        xprior2_subset = training_set_projections2(index_rand);
        locator_subset = training_set_locator(index_rand);

        [x1edges, x2edges, pspk, px1x2, px1x2spk, pspkx1x2] = ...
            sm_nonlinearity_projections_2d(locator_subset, xprior1_subset, xprior2_subset);
        
        training_set_x1edges{j} = x1edges;
        training_set_x2edges{j} = x2edges;
        training_set_pspk{j} = pspk;
        training_set_px1x2{j} = px1x2;
        training_set_px1x2spk{j} = px1x2spk;
        training_set_pspkx1x2{j} = pspkx1x2;

        clear('x1edges', 'x2edges', 'pspk', 'px1x2', 'px1x2spk', 'pspkx1x2');

    end % (for j)

    fio_training_set(i).nreps = nreps;
    fio_training_set(i).percent = percent;
    fio_training_set(i).index_rand = index_rand;
    fio_training_set(i).x1edges = training_set_x1edges;
    fio_training_set(i).x2edges = training_set_x2edges;
    fio_training_set(i).pspk = training_set_pspk;
    fio_training_set(i).px1x2 = training_set_px1x2;
    fio_training_set(i).px1x2spk = training_set_px1x2spk;
    fio_training_set(i).pspkx1x2 = training_set_pspkx1x2;

end % (for i)

return 









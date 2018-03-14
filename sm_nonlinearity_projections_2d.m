function [x1edges, x2edges, pspk, px1x2, px1x2spk, pspkx1x2] = ...
    sm_nonlinearity_projections_2d(locator, x1prior, x2prior)
%proj_prob_dist_2d - 2D probability distributions for projection values
%
% For each training data set, we caclulate the probability of a spike, 
% the probability of a projection without respect to a spike, the 
% probability of a projection when a spike occurs, and the probability of
% a spike given a projection value. This last distribution is the 
% nonlinearity for a neuron.
%
% [xbins, pspk, px1x2, px1x2spk, pspkx1x2] = proj_prob_dist_2d(xtrain_locator, xtrain_mid1, xtrain_mid2)
% ------------------------------------------------------------------------
%
% Input arguments:
%
% xtrain_locator : 1x4 cell array. The locator for each training set. A
% locator is vector whose length is as long as the number of trials in
% a training set. Elements in locator are >= 0, depending on how many 
% spikes occurred during a given trial.
%
% xtrain_mid1 : 1x4 cell array. Each element represents the projection values
% onto one of the training set mid1 filters.
% 
% xtrain_mid2 : 1x4 cell array. Each element represents the projection values
% onto one of the training set mid2 filters.
%
%
% Output arguments:
%
% x1binedges, x2binedges : cell array of bin edge values used to bin the
% probability distributions for mid1 and mid2. 
%
% pspk : 1x4 cell array. Each element is the probability of a spike 
% during one of the training sets.
%
% px : 1x4 cell array. An element is the probability of a projection 
% value for a training set. 
%
% pxspk : 1x4 cell array. An element is the probability of a projection 
% value given a spike for a training set. 
% 
% pspkx : 1x4 cell array. An element is the probability of a spike
% given a projection for a training set. 
%
% caa 3/11/09



% Get probability distributions for training data sets

% We need to get: p(spk), p(x), p(x|spk), and p(spk|x)

nbinedges = 16;


% Probability of a spike in a given trial
nspikes = sum(locator);
pspk = nspikes / length(locator); % probability of a spike


% MID1 : Normalize projection values to mean, sd of prior
mean1_prior = mean(x1prior);
std1_prior = std(x1prior);

x1 = (x1prior - mean1_prior) ./ std1_prior;
x1spk = x1( locator > 0 ); % values corresponding to a spike


% MID2 : Normalize projection values to mean, sd of prior
mean2_prior = mean(x2prior);
std2_prior = std(x2prior);

x2 = (x2prior - mean2_prior) ./ std2_prior;
x2spk = x2( locator > 0 ); % values corresponding to a spike


% Combine the data into a matrix:
x1x2 = [x1(:) x2(:)];
x1x2spk = [x1spk(:) x2spk(:)];

x1min = min(min([prctile(x1, [1]) prctile(x1spk, [1])]));
x1max = max(max([prctile(x1, [99]) prctile(x1spk, [99])]));
x1edges = linspace(x1min, x1max, nbinedges);

x2min = min(min([prctile(x2, [1]) prctile(x2spk, [1])]));
x2max = max(max([prctile(x2, [99]) prctile(x2spk, [99])]));
x2edges = linspace(x2min, x2max, nbinedges);

nx1x2spk = sm_hist2d(x1x2spk, x1edges, x2edges);
px1x2spk = nx1x2spk ./ sum(sum(nx1x2spk));

nx1x2 = sm_hist2d(x1x2, x1edges, x2edges);
px1x2 = nx1x2 ./ sum(sum(nx1x2)) + eps;

pspkx1x2 = pspk .* px1x2spk ./ px1x2;


return;









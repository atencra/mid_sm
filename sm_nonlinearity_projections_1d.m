function [xbins, pspk, px, pxspk, pspkx] = sm_nonlinearity_projections_1d(xprior, locator)
%proj_prob_dist - Probability distributions for projection values
%
% For each training data set, we caclulate the probability of a spike, 
% the probability of a projection without respect to a spike, the 
% probability of a projection when a spike occurs, and the probability of
% a spike given a projection value. This last distribution is the 
% nonlinearity for a neuron.
%
% [xbins, pspk, px, pxspk, pspkx] = sm_proj_prob_dist_resample(xtrain, xtrain_locator)
% ------------------------------------------------------------------------
%
% Input arguments:
%
% xtrain : 1x4 cell array. Each element represents the projection values
% onto one of the training set filters.
% 
% xtrain_locator : 1x4 cell array. The locator for each training set. A
% locator is vector whose length is as long as the number of trials in
% a training set. Elements in locator are >= 0, depending on how many 
% spikes occurred during a given trial.
%
% Output arguments:
%
% xbins : the values at which the probability distributions are binned.
% Values of xbins are usually -7:7. These represent normalized units,
% since the projections are normalized relative to the mean and standard
% deviation of the probability of projection without regard to a spike.
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
% caa 9/11/09



% Get probability distributions for training data sets

% We need to get: p(spk), p(x), p(x|spk), and p(spk|x)


%for i = 1:length(xtrain)

%locator = xtrain_locator{i};
%xprior = xtrain{i};

%locator = xtrain_locator;
%xprior = xtrain;


% Probability of a spike in a given trial
nspikes = sum(locator);
pspk_temp = nspikes / length(locator); % probability of a spike

% Normalize projection values to mean, sd of prior
mean_prior = mean(xprior);
std_prior = std(xprior);

x = (xprior - mean_prior) ./ std_prior;
xspk = x( locator > 0 ); % values corresponding to a spike


xprc_low = prctile(x, [1]);
xspkprc_low = prctile(xspk, [1]);

xprc_hi = prctile(x, [99]);
xspkprc_hi = prctile(xspk, [99]);

xbins_low = min(min([xprc_low xspkprc_low]));
xbins_hi = max(max([xprc_hi xspkprc_hi]));

xbins_edges = linspace(xbins_low, xbins_hi, 16);
xbins_centers = edge2center(xbins_edges);

nx = hist(x, xbins_centers);
px_temp = nx ./ sum(nx);
px_temp = px_temp(:);

nxspk = hist(xspk, xbins_centers);
pxspk_temp = nxspk ./ sum( nxspk ); % p(x|spk)
pxspk_temp = pxspk_temp(:);

pspkx_temp = pspk_temp .* pxspk_temp ./ px_temp; % p(spk|x)


xbins = xbins_centers;
pspk = pspk_temp;
px = px_temp;
pxspk = pxspk_temp;
pspkx = pspkx_temp;

%end % (for)

return;




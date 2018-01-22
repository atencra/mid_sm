function [xtrain, xtest, xtrain_locator, xtest_locator] = train_test_projection(filters, locator, stimulus, index_freq)
% train_test_projection - projection for training and test data sets
%
% Calculates all projections onto filters over the entire stimulus
% duration. Each filter was calculated from 1 of the 4 training sets.
%
% [xtrain, xtest, xtrain_locator, xtest_locator] = ...
%     train_test_projection(filters, locator, stimulus, index_freq)
%
% Input arguments:
%
% filters : 1x4 cell array. Each element is a filter for one of the 
% training sets. The filter is a matrix.
%
% locator : a vector that describes whether a spike occurred during each
% of the stimulus trials. Values are >= 0.
%
% stimulus : the entire stimulus that was played to the neuron. It is
% an nf x ntrials size matrix. nf represents the number for frequencies
% in the stimulus. ntrials is the total number of time trials.
%
% index_freq : selects the frequencies in stimulus to use for calculating
% the projection values. The MID code only uses 25 stimuli, so we need
% to extract the right frequencies.
%
% 
% Output arguments:
%
% xtrain : 1x4 cell array. Each element holds the projection values onto
% a filter for the training set.
%
% xtest : same as xtrain, except the projection are for the test data set.
%
% xtrain_locator : 1x4 cell array. Each element is the locator for one of
% the training sets.
%
% xtest_locator : same as xtrain_locator, except for the test data set.
%
%
% This function calls the following two functions: training_set_indices
% and test_set_indices
%
% caa 9/13/09


fprintf('\nRunning train_test_projection ...\n\n');


ntrials = length(locator);

[itrain1, itrain2, itrain3, itrain4] = training_set_indices(ntrials);
[itest1, itest2, itest3, itest4] = test_set_indices(ntrials);

% Prior distribution of projection values for test set spikes the 
% onto training set STA


% Project all trials onto filter to get the prior distribution.
% This distribution will include the training set projections and the
% test set projections. All trials will have a projection value
% associated with them.


% Find the prior projection values for all filters at the same time:
x1prior = zeros(ntrials, 1);
x2prior = zeros(ntrials, 1);
x3prior = zeros(ntrials, 1);
x4prior = zeros(ntrials, 1);

f1 = filters{1};
f2 = filters{2};
f3 = filters{3};
f4 = filters{4};

[nr, nc] = size(f1); % # frequencies, # time bins

for i = nc:ntrials

   x1prior(i) =  sum( sum ( stimulus( index_freq, i-nc+1:i ) .* f1 ) ); % inner product
   x2prior(i) =  sum( sum ( stimulus( index_freq, i-nc+1:i ) .* f2 ) ); % inner product
   x3prior(i) =  sum( sum ( stimulus( index_freq, i-nc+1:i ) .* f3 ) ); % inner product
   x4prior(i) =  sum( sum ( stimulus( index_freq, i-nc+1:i ) .* f4 ) ); % inner product

end % (for i)


% For the training set:
x1train = x1prior(itrain1); % include prior and posterior
x1train_locator = locator(itrain1);
x1spktrain = x1train( x1train_locator > 0 ); % includes only posterior

x2train = x2prior(itrain2); % include prior and posterior
x2train_locator = locator(itrain2);
x2spktrain = x2train( x2train_locator > 0 ); % includes only posterior

x3train = x3prior(itrain3); % include prior and posterior
x3train_locator = locator(itrain3);
x3spktrain = x3train( x3train_locator > 0 ); % includes only posterior

x4train = x4prior(itrain4); % include prior and posterior
x4train_locator = locator(itrain4);
x4spktrain = x4train( x4train_locator > 0 ); % includes only posterior


% For the test set:
x1test = x1prior(itest1); % includes prior and posterior
x1test_locator = locator(itest1);
x1spktest = x1test( x1test_locator > 0 ); % includes only posterior

x2test = x2prior(itest2); % includes prior and posterior
x2test_locator = locator(itest2);
x2spktest = x2test( x2test_locator > 0 ); % includes only posterior

x3test = x3prior(itest3); % includes prior and posterior
x3test_locator = locator(itest3);
x3spktest = x3test( x3test_locator > 0 ); % includes only posterior

x4test = x4prior(itest4); % includes prior and posterior
x4test_locator = locator(itest4);
x4spktest = x4test( x4test_locator > 0 ); % includes only posterior



% Save training data to output cell arrays
xtrain{1} = single(x1train);
xtrain{2} = single(x2train);
xtrain{3} = single(x3train);
xtrain{4} = single(x4train);

xtrain_locator{1} = single(x1train_locator);
xtrain_locator{2} = single(x2train_locator);
xtrain_locator{3} = single(x3train_locator);
xtrain_locator{4} = single(x4train_locator);

xspktrain{1} = single(x1spktrain);
xspktrain{2} = single(x2spktrain);
xspktrain{3} = single(x3spktrain);
xspktrain{4} = single(x4spktrain);



% Save test data to output cell arrays
xtest{1} = single(x1test);
xtest{2} = single(x2test);
xtest{3} = single(x3test);
xtest{4} = single(x4test);

xtest_locator{1} = single(x1test_locator);
xtest_locator{2} = single(x2test_locator);
xtest_locator{3} = single(x3test_locator);
xtest_locator{4} = single(x4test_locator);

xspktest{1} = single(x1spktest);
xspktest{2} = single(x2spktest);
xspktest{3} = single(x3spktest);
xspktest{4} = single(x4spktest);


% [length(xtrain) length(xtest) length(xtrain_locator) length(xtest_locator)]


return;




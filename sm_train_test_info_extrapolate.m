function [info_extrap_train, info_extrap_test] = ...
   sm_train_test_info_extrapolate(fraction, ifrac_mtx_train, ifrac_mn_train, ...
                                         ifrac_mtx_test, ifrac_mn_test)
%train_test_info_extrapolate - extrapolated information values from data
%fractions.
%
% [info_extrap_train, info_extrap_test] = ...
%    train_test_info_extrapolate(fraction, ifrac_mtx_train, ifrac_mn_train, ...
%    ifrac_mtx_test, ifrac_mn_test)
% -----------------------------------------------------------------------
%
% Information values were calculated for different fractions of the data.
% We fit a line to the information values versus the inverse of the data
% fraction. The y-intercept of the line represents the information value
% that would be present for infinite data set size. This y-intercept value
% is the extrapolated information value. Extrapolated values are calculated
% for 8 different data sets. 4 training sets and 4 test sets.
%
% Input arguments:
%
% fraction : the fractions of the data that were used. Usually something
% like [80 85 90 92.5 95 97.5 100]
%
% ifrac_mtx_train : matrix of information values for each training set and
% all the data fractions. A 4xlength(fraction) matrix. Each row represents
% a training set, and each column is a data fraction.
%
% ifrac_mn_train : a vector of mean information values over the 4 training
% sets for each data fraction.
%
% ifrac_mtx_test : matrix of information values for each test set and
% all the data fractions. A 4xlength(fraction) matrix. Each row represents
% a test set, and each column is a data fraction.
%
% ifrac_mn_test : a vector of mean information values over the 4 test
% sets for each data fraction.
%
% Output arguments:
%
% info_extrap_train : 1x5 vector of extrapolated training set information
% values. The first 4 training sets are held in the first four elements.
% The fifth element holds the extrapolated information value for the mean
% training set information values.
%
% info_extrap_test : 1x5 vector of extrapolated test set information
% values. The first 4 test sets are held in the first four elements.
% The fifth element holds the extrapolated information value for the mean
% test set information values.
%
% caa 3/15/09


fprintf('\nRunning train_test_info_extrapolate ...\n');

info_extrap_train = zeros(1,5);
info_extrap_test = zeros(1,5);

x = 1./fraction;

% Get, save, extrapolated training set information values
y = ifrac_mtx_train(1,:);
p1train = polyfit(x,y,1);

y = ifrac_mtx_train(2,:);
p2train = polyfit(x,y,1);

y = ifrac_mtx_train(3,:);
p3train = polyfit(x,y,1);

y = ifrac_mtx_train(4,:);
p4train = polyfit(x,y,1);

y = ifrac_mn_train;
ptrain = polyfit(x,y,1);

info_extrap_train(1) = p1train(2);
info_extrap_train(2) = p2train(2);
info_extrap_train(3) = p3train(2);
info_extrap_train(4) = p4train(2);
info_extrap_train(5) = ptrain(2);


% Get, save, extrapolated test set information values
y = ifrac_mtx_test(1,:);
p1test = polyfit(x,y,1);

y = ifrac_mtx_test(2,:);
p2test = polyfit(x,y,1);

y = ifrac_mtx_test(3,:);
p3test = polyfit(x,y,1);

y = ifrac_mtx_test(4,:);
p4test = polyfit(x,y,1);

y = ifrac_mn_test;
ptest = polyfit(x,y,1);

info_extrap_test(1) = p1test(2);
info_extrap_test(2) = p2test(2);
info_extrap_test(3) = p3test(2);
info_extrap_test(4) = p4test(2);
info_extrap_test(5) = ptest(2);


return;











function sm_mid_plot_projinfo_train_test_information(fraction, ifrac_train_mtx, ifrac_train_mn, ...
    ifrac_train_std, ifrac_test_mtx, ifrac_test_mn, ifrac_test_std, titlestr)
% sm_mid_plot_projinfo_train_test_information - Show MID information results
%
% Information values were calculated for different fractions of the data.
% We fit a line to the information values versus the inverse of the data
% fraction. Information values were calculated for 8 different data set. 
% 4 training sets and 4 test sets.
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
% Output arguments: none.
%


if ( nargin < 7 )
   error('You need 7 or 8 input args.');
end

if ( nargin ~= 8 )
   titlestr = [];
end


xmin = min(1./fraction);
xmax = max(1./fraction);
xrange = xmax - xmin;
xlim_vec = [xmin-0.1*xrange xmax+0.1*xrange];

x = 1./fraction;
xfit = linspace(0, max(x), 1000);

y = ifrac_train_mtx(1,:);
p1train = polyfit(x,y,1);
y1train = polyval(p1train, xfit);

y = ifrac_train_mtx(2,:);
p2train = polyfit(x,y,1);
y2train = polyval(p2train, xfit);

y = ifrac_train_mtx(3,:);
p3train = polyfit(x,y,1);
y3train = polyval(p3train, xfit);

y = ifrac_train_mtx(4,:);
p4train = polyfit(x,y,1);
y4train = polyval(p4train, xfit);


y = ifrac_test_mtx(1,:);
p1test = polyfit(x,y,1);
y1test = polyval(p1test, xfit);

y = ifrac_test_mtx(2,:);
p2test = polyfit(x,y,1);
y2test = polyval(p2test, xfit);

y = ifrac_test_mtx(3,:);
p3test = polyfit(x,y,1);
y3test = polyval(p3test, xfit);

y = ifrac_test_mtx(4,:);
p4test = polyfit(x,y,1);
y4test = polyval(p4test, xfit);




figure; 

% Plot the train data set information
subplot(2,5,1);
hold on;
plot( 1./fraction, ifrac_train_mtx(1,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y1train, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_train_mtx(1,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Train Set 1');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);
ylabel('Info [bits/spike]');



subplot(2,5,2);
hold on;
plot( 1./fraction, ifrac_train_mtx(2,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y2train, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_train_mtx(2,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Train Set 2');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);

subplot(2,5,3);
hold on;
plot( 1./fraction, ifrac_train_mtx(3,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y3train, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_train_mtx(3,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Train Set 3');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);

subplot(2,5,4);
hold on;
plot( 1./fraction, ifrac_train_mtx(4,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y4train, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_train_mtx(4,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Train Set 4');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);



% Plot the test data set information
subplot(2,5,6);
hold on;
plot( 1./fraction, ifrac_test_mtx(1,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y1test, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_test_mtx(1,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Test Set 1');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);
ylabel('Info [bits/spike]');


subplot(2,5,7);
hold on;
plot( 1./fraction, ifrac_test_mtx(2,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y2test, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_test_mtx(2,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Test Set 2');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);


subplot(2,5,8);
hold on;
plot( 1./fraction, ifrac_test_mtx(3,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y3test, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_test_mtx(3,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Test Set 3');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);
xlabel('Data Percentage');


subplot(2,5,9);
hold on;
plot( 1./fraction, ifrac_test_mtx(4,:), 'ko', 'markerfacecolor', 'k');
plot(xfit, y4test, 'k-');
xlim(xlim_vec);
ylim([0 1.1*max( ifrac_test_mtx(4,:) )]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Test Set 4');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);


y = ifrac_train_mn;
ptrain = polyfit(x,y,1);
ytrain = polyval(ptrain, xfit);

y = ifrac_test_mn;
ptest = polyfit(x,y,1);
ytest = polyval(ptest, xfit);


subplot(2,5,5);
hold on;
%errorbar( 1./fraction, ifrac_train_mn, ifrac_train_std/2, 'ko', 'markerfacecolor', 'k');
plot( 1./fraction, ifrac_train_mn, 'ko', 'markerfacecolor', 'k');
plot(xfit, ytrain, 'k-');
xlim(xlim_vec);
ylim( [0 1.1*max(ifrac_train_mn)+ max(ifrac_train_std)] );
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Train Set Mean');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);


subplot(2,5,10);
hold on;
%errorbar( 1./fraction, ifrac_test_mn, ifrac_test_std/2, 'ko', 'markerfacecolor', 'k');
plot( 1./fraction, ifrac_test_mn, 'ko', 'markerfacecolor', 'k');
plot(xfit, ytest, 'k-');
xlim(xlim_vec);
ylim( [0 1.1*max(ifrac_test_mn)+ max(ifrac_test_std)] );
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
title('Test Set Mean');
xticklabel = roundsd(1./get(gca,'xtick'), 2);
set(gca,'xticklabel', xticklabel);

if (  ~isempty(titlestr) )
   suptitle(titlestr);
end

set(gcf, 'position', [133   295   760   420]);

return;



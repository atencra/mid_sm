function sm_plot_filters_nonlinearities(sta, xbins, pspk, pspkx, titlestr)
%plot_filters_nonlinearities - display filters and nonlinearities.
%
% plot_filters_nonlinearities(sta, xbins, pspk, pspkx)
% -------------------------------------------------------------------
%
% sta : 1x4 cell array. Each element represents a different filter for
% a training data set.
%
% xbins : values at which projection values were binned. This is the
% abscissa for the nonlinearity.
%
% pspk : 1x4 cell array. Probability of a spike for each of the 4 training
% data sets.
%
% pspkx : 1x4 cell array. Each element represents the nonlinearity for one
% of the training sets.
%
% caa 3/13/09

fprintf('\nRunning plot_filters_nonlinearities ...\n');


if ( nargin < 4 )
   error('You need 4 or 5 input args.');
end

if ( nargin ~= 5 )
   titlestr = [];
end



% Plot the filters
% ----------------------------------------------------------


figure;

subplot(2,4,1);
imagesc( sta{1} );
minmin = min(min(sta{1}));
maxmax = max(max(sta{1}));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
cmap = brewmaps('rdbu',21);
colormap(cmap);
title('Train Set 1');

subplot(2,4,2);
imagesc( sta{2} );
minmin = min(min(sta{2}));
maxmax = max(max(sta{2}));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
cmap = brewmaps('rdbu',21);
colormap(cmap);
title('Train Set 2');


subplot(2,4,3);
imagesc( sta{3} );
minmin = min(min(sta{3}));
maxmax = max(max(sta{3}));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
cmap = brewmaps('rdbu',21);
colormap(cmap);
title('Train Set 3');


subplot(2,4,4);
imagesc( sta{4} );
minmin = min(min(sta{4}));
maxmax = max(max(sta{4}));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
cmap = brewmaps('rdbu',21);
colormap(cmap);
title('Train Set 4');


% Plot the nonlinearities
% ----------------------------------------------------------

maxmax = max([max(pspkx{1}) max(pspkx{2}) max(pspkx{3}) max(pspkx{4}) ]);

subplot(2,4,5);
hold on;
plot(xbins{1}, pspkx{1}, 'ko-', 'markerfacecolor', 'k');
plot([min(xbins{1}) max(xbins{1})], [pspk{1} pspk{1}], 'k--');
xlim(1.1*[min(xbins{1}) max(xbins{1})]);
ylim([0 maxmax]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
xlabel('Projection (SD)');
ylabel('P(spk|x)');

subplot(2,4,6);
hold on;
plot(xbins{2}, pspkx{2}, 'ko-', 'markerfacecolor', 'k');
plot([min(xbins{2}) max(xbins{2})], [pspk{2} pspk{2}], 'k--');
xlim(1.1*[min(xbins{2}) max(xbins{2})]);
ylim([0 maxmax]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

subplot(2,4,7);
hold on;
plot(xbins{3}, pspkx{3}, 'ko-', 'markerfacecolor', 'k');
plot([min(xbins{3}) max(xbins{3})], [pspk{3} pspk{3}], 'k--');
xlim(1.1*[min(xbins{3}) max(xbins{3})]);
ylim([0 maxmax]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

subplot(2,4,8);
hold on;
plot(xbins{4}, pspkx{4}, 'ko-', 'markerfacecolor', 'k');
plot([min(xbins{4}) max(xbins{4})], [pspk{4} pspk{4}], 'k--');
xlim(1.1*[min(xbins{4}) max(xbins{4})]);
ylim([0 maxmax]);
set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

if (  ~isempty(titlestr) )
   suptitle(titlestr);
end

set(gcf, 'position', [293 267 1095 571]);


return;

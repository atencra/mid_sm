function sm_mid_plot_cat_sm_nonlinearity_params(smfioparams, catfioparams)
% mid_sm_plot_cat_sm_nonlinearity_params Compare nonlinearity params for cat and squirrel monkey MIDs
%
% mid_sm_plot_cat_sm_nonlinearity_params(smfioparams, catfioparams) 
% ---------------------------------------------------------------------------------
%
% smfioparams : struct holding cell arrays of information calculations for squirrel monkey.
%
% catfioparams : struct holding cell arrays of info for the cat.


% First compare STA and MID1 information


sta_asi_sm = cell2mat(smfioparams.sta_asi);
mid1_asi_sm = cell2mat(smfioparams.mid1_asi);
mid2_asi_sm = cell2mat(smfioparams.mid2_asi);
mid12_si_sm = cell2mat(smfioparams.mid12_si);

sta_asi_cat = cell2mat(catfioparams.sta_asi);
mid1_asi_cat = cell2mat(catfioparams.mid1_asi);
mid2_asi_cat = cell2mat(catfioparams.mid2_asi);
mid12_si_cat = cell2mat(catfioparams.mid12_si);



lw = 4;
fs = 12;
fstick = 10;

figure;


index_sm = sta_asi_sm>-2;
sta_asi_sm_good = sta_asi_sm(index_sm); 

index_cat = sta_asi_cat>-2;
sta_asi_cat_good = sta_asi_cat(index_cat);

[xsm,ysm] = empcdf(sta_asi_sm_good);
[xcat,ycat] = empcdf(sta_asi_cat_good);

subplot(2,2,1);
cmap = brewmaps('blues', 5);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
xlim([-1 1]);
legend('SM', 'Cat', 'location', 'west');
tick = -1:0.5:1;
set(gca,'ytick', tick, 'yticklabel', tick);
set(gca, 'fontsize', fs);
tickpref;
xlabel('STA NL Asymmetry', 'fontsize', fs);
ylabel('Proportion');
subplot_label(gca, 'A');
[hyp, pval] = kstest2(sta_asi_sm_good, sta_asi_cat_good);
text(-0.75, 0.8, sprintf('p=%.6f\nKS-test', pval));






index_sm = mid1_asi_sm>-2;
mid1_asi_sm_good = mid1_asi_sm(index_sm); 

index_cat = mid1_asi_cat>-2;
mid1_asi_cat_good = mid1_asi_cat(index_cat);

[xsm,ysm] = empcdf(mid1_asi_sm_good);
[xcat,ycat] = empcdf(mid1_asi_cat_good);

subplot(2,2,2);
cmap = brewmaps('blues', 5);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
xlim([-1 1]);
tick = -1:0.5:1;
set(gca,'ytick', tick, 'yticklabel', tick);
set(gca, 'fontsize', fs);
tickpref;
xlabel('MID1 NL Asymmetry', 'fontsize', fs);
ylabel('Proportion');
subplot_label(gca, 'B');
[hyp, pval] = kstest2(mid1_asi_sm_good, mid1_asi_cat_good);
text(-0.75, 0.8, sprintf('p=%.6f\nKS-test', pval));




index_sm = mid2_asi_sm>-2;
mid2_asi_sm_good = mid2_asi_sm(index_sm); 

index_cat = mid2_asi_cat>-2;
mid2_asi_cat_good = mid2_asi_cat(index_cat);

[xsm,ysm] = empcdf(mid2_asi_sm_good);
[xcat,ycat] = empcdf(mid2_asi_cat_good);

subplot(2,2,3);
cmap = brewmaps('blues', 5);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
xlim([-1 1]);
tick = -1:0.5:1;
set(gca,'ytick', tick, 'yticklabel', tick);
set(gca, 'fontsize', fs);
tickpref;
xlabel('MID2 NL Asymmetry', 'fontsize', fs);
ylabel('Proportion');
subplot_label(gca, 'C');
[hyp, pval] = kstest2(mid2_asi_sm_good, mid2_asi_cat_good);
text(-0.75, 0.8, sprintf('p=%.6f\nKS-test', pval));





index_sm = mid12_si_sm>-2;
mid12_si_sm_good = mid12_si_sm(index_sm); 

index_cat = mid12_si_cat>-2;
mid12_si_cat_good = mid12_si_cat(index_cat);

[xsm,ysm] = empcdf(mid12_si_sm_good);
[xcat,ycat] = empcdf(mid12_si_cat_good);

subplot(2,2,4);
cmap = brewmaps('blues', 5);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
xlim([0 1]);
ytick = -1:0.5:1;
set(gca,'ytick', ytick, 'yticklabel', ytick);

xtick = 0:0.25:1;
set(gca,'xtick', xtick, 'xticklabel', xtick);

set(gca, 'fontsize', fs);
tickpref;
xlabel('MID12 NL Separability Index', 'fontsize', fs);
ylabel('Proportion');
subplot_label(gca, 'D');
[hyp, pval] = kstest2(mid12_si_sm_good, mid12_si_cat_good);
text(0.125, 0.8, sprintf('p=%.6f\nKS-test', pval));














return;









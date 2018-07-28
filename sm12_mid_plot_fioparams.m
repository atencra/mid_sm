function sm_mid_plot_fioparams(fioparams)
% sm_mid_plot_fioparams  SM nonlinearity asymmetry / separability
%
% sm_mid_plot_fioparams(fioparams)
%
%       fioparams : struct array holding 1D nonlinearity asymmetry and 
%               2D nonlinearity separability for the STA and MIDs.
%
% Shows the CDFs of the asymmetries for each type of filter, and also
% shows histograms of the values.
%


sta_asi = [fioparams.sta_asi];
mid1_asi = [fioparams.mid1_asi];
mid2_asi = [fioparams.mid2_asi];
mid12_si = [fioparams.mid12_si];



hf = figure;
set(hf,'position', [680 300 650 475]);
orient landscape;


subplot(3,3,1);
edges = -1:0.1:1;
count = histc(sta_asi, edges);
count = count / sum(count);
hb = bar(edges, count, 'histc');
set(hb, 'facecolor', 0.6 * ones(1,3));
tickpref;
xlim([-1 1]);
xlabel('STA NL ASI');
ylabel('Proportion');
subplot_label(gca, 'A');



subplot(3,3,2);
edges = -1:0.1:1;
count = histc(mid1_asi, edges);
count = count / sum(count);
hb = bar(edges, count, 'histc');
set(hb, 'facecolor', 0.6 * ones(1,3));
tickpref;
xlim([-1 1]);
xlabel('MID1 NL ASI');
subplot_label(gca, 'B');


subplot(3,3,3);
edges = -1:0.1:1;
count = histc(mid2_asi, edges);
count = count / sum(count);
hb = bar(edges, count, 'histc');
set(hb, 'facecolor', 0.6 * ones(1,3));
tickpref;
xlim([-1 1]);
xlabel('MID2 NL ASI');
subplot_label(gca, 'C');



subplot(3,3,4);
[xsta,ysta] = empcdf(sta_asi(sta_asi>-2));
[xmid1,ymid1] = empcdf(mid1_asi(mid1_asi>-2));
[xmid2,ymid2] = empcdf(mid2_asi(mid2_asi>-2));
hold on;

cmap = brewmaps('blues', 5);
plot(xsta, ysta, '-', 'color', cmap(1,:), 'linewidth', 2);
plot(xmid1, ymid1, '-', 'color', cmap(2,:), 'linewidth', 2);
plot(xmid2, ymid2, '-', 'color', cmap(3,:), 'linewidth', 2);
legend('STA', 'MID1', 'MID2', 'location', 'northwest');
xlabel('NL ASI');
tick = 0:0.25:1;
set(gca,'ytick', tick, 'yticklabel', tick);
tickpref;
ylabel('Proportion');
subplot_label(gca, 'D');




subplot(3,3,5);
hold on;
index = (sta_asi>-2) & (mid1_asi>-2);
x = sta_asi(index);
y = mid1_asi(index);
plot([-1 1], [-1 1], 'k-');
plot(x, y, 'ko', 'markersize', 3); %, 'markeredgecolor', 'k', 'markerfacecolor', 0.6*ones(1,3));
tick = -1:0.25:1;
set(gca,'xtick', tick, 'xticklabel', tick);
set(gca,'ytick', tick, 'yticklabel', tick);
xlim([min(x) max(x)]);
ylim([min(y) max(y)]);
xlabel('STA NL ASI');
ylabel('MID1 NL ASI');
tickpref;
subplot_label(gca, 'E');



subplot(3,3,6);
hold on;
index = (mid2_asi>-2) & (mid1_asi>-2);
x = mid1_asi(index);
y = mid2_asi(index);
plot([-1 1], [-1 1], 'k-');
plot(x, y, 'ko', 'markersize', 3); %, 'markeredgecolor', 'k', 'markerfacecolor', 0.6*ones(1,3));
tick = -1:0.25:1;
set(gca,'xtick', tick, 'xticklabel', tick);
set(gca,'ytick', tick, 'yticklabel', tick);
xlim([min(x) max(x)]);
ylim([min(y) max(y)]);
xlabel('MID1 NL ASI');
ylabel('MID2 NL ASI');
tickpref;
subplot_label(gca, 'F');



subplot(3,3,8);
edges = 0:0.05:1;
count = histc(mid12_si, edges);
count = count / sum(count);
hb = bar(edges, count, 'histc');
set(hb, 'facecolor', 0.6 * ones(1,3));
tickpref;
tick = -1:0.25:1;
set(gca,'xtick', tick, 'xticklabel', tick);
xlim([0 1]);
xlabel('MID 2D NL SI');
ylabel('Proportion');
subplot_label(gca, 'G');

print_mfilename(mfilename);

return;














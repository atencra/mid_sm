function sm_mid_plot_cat_sm_info(sminfo, catinfo)
% mid_sm_plot_cat_sm_info Compare information for cat and squirrel monkey MIDs
%
% mid_sm_plot_cat_sm_info(sminfo, catinfo) 
% ---------------------------------------------------------------------------------
%
% sminfo : struct holding cell arrays of information calculations for squirrel monkey.
%
% catinfo : struct holding cell arrays of info for the cat.


% First compare STA and MID1 information


infosta_sm = cell2mat(sminfo.infosta);
infomid1_sm = cell2mat(sminfo.infomid1);
infomid2_sm = cell2mat(sminfo.infomid2);
infomid12_sm = cell2mat(sminfo.infomid12);

infosta_cat = cell2mat(catinfo.infosta);
infomid1_cat = cell2mat(catinfo.infomid1);
infomid2_cat = cell2mat(catinfo.infomid2);
infomid12_cat = cell2mat(catinfo.infomid12);

lw = 4;
fs = 12;
fstick = 10;

figure;


index_sm = infosta_sm>-2 & infomid1_sm>-2;
sta_contribution_sm = 100* infosta_sm(index_sm) ./ infomid1_sm(index_sm);

index_cat = infosta_cat>-2 & infomid1_cat>-2;
sta_contribution_cat = 100* infosta_cat(index_cat) ./ infomid1_cat(index_cat);

[xsm,ysm] = empcdf(sta_contribution_sm);
[xcat,ycat] = empcdf(sta_contribution_cat);

subplot(2,2,1);
cmap = brewmaps('blues', 5);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
xlim([0 200]);
legend('SM', 'Cat', 'location', 'southeast');
tick = 0:0.25:1;
set(gca,'ytick', tick, 'yticklabel', tick);
set(gca, 'fontsize', fs);
tickpref;
xlabel('100 STA / MID1 Info', 'fontsize', fs);
ylabel('Proportion');
subplot_label(gca, 'A');
[hyp, pval] = kstest2(sta_contribution_sm, sta_contribution_cat);
text(100, 0.5, sprintf('p=%.8f', pval));



index_sm = infomid1_sm>-2 & infomid12_sm>-2;
mid1_contribution_sm = 100* infomid1_sm(index_sm) ./ infomid12_sm(index_sm);

index_cat = infosta_cat>-2 & infomid12_cat>-2;
mid1_contribution_cat = 100* infomid1_cat(index_cat) ./ infomid12_cat(index_cat);

[xsm,ysm] = empcdf(mid1_contribution_sm);
[xcat,ycat] = empcdf(mid1_contribution_cat);

subplot(2,2,2);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
xlim([0 200]);
tick = 0:0.25:1;
set(gca,'ytick', tick, 'yticklabel', tick);
set(gca, 'fontsize', fs);
tickpref;
xlabel('100 MID1 / MID12 Info', 'fontsize', fs);
ylabel('Proportion', 'fontsize', fs);
subplot_label(gca, 'B');

[hyp, pval] = kstest2(mid1_contribution_sm, mid1_contribution_cat);
text(100, 0.25, sprintf('p=%.4f', pval));



index_sm = infomid1_sm>-2 & infomid2_sm>-2;
mid2_contribution_sm = 100* infomid2_sm(index_sm) ./ infomid1_sm(index_sm);

index_cat = infomid1_cat>-2 & infomid2_cat>-2;
mid2_contribution_cat = 100* infomid2_cat(index_cat) ./ infomid1_cat(index_cat);

[xsm,ysm] = empcdf(mid2_contribution_sm);
[xcat,ycat] = empcdf(mid2_contribution_cat);

subplot(2,2,3);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
xlim([0 200]);
tick = 0:0.25:1;
set(gca,'ytick', tick, 'yticklabel', tick);
set(gca, 'fontsize', fs);
tickpref;
xlabel('100 MID2 / MID1 Info', 'fontsize', fs);
ylabel('Proportion', 'fontsize', fs);
subplot_label(gca, 'C');

[hyp, pval] = kstest2(mid2_contribution_sm, mid2_contribution_cat);
text(100, 0.25, sprintf('p=%.4f', pval));


index_sm = infomid1_sm>-2 & infomid2_sm>-2 & infomid12_sm>-2;
synergy_sm = 100* infomid12_sm(index_sm) ./ (infomid1_sm(index_sm) + infomid2_sm(index_sm));
synergy_sm = synergy_sm(synergy_sm<350 & synergy_sm>0);

index_cat = infomid1_cat>-2 & infomid2_cat>-2 & infomid12_cat;
synergy_cat = 100* infomid12_cat(index_cat) ./ (infomid1_cat(index_cat) + infomid2_cat(index_cat));
synergy_cat = synergy_cat(synergy_cat<350 & synergy_cat>0);


[xsm,ysm] = empcdf(synergy_sm);
[xcat,ycat] = empcdf(synergy_cat);



subplot(2,2,4);
hold on;
plot(xsm, ysm, '-', 'color', cmap(1,:), 'linewidth', lw);
plot(xcat, ycat, '-', 'color', cmap(2,:), 'linewidth', lw);
%xlim([0 200]);
tick = 0:0.25:1;
set(gca,'ytick', tick, 'yticklabel', tick);
set(gca, 'fontsize', fs);
tickpref;
xlabel('100 MID12 / (MID1+MID2) Info', 'fontsize', fs);
ylabel('Proportion', 'fontsize', fs);
subplot_label(gca, 'D');

[hyp, pval] = kstest2(synergy_cat, synergy_sm)
text(200, 0.25, sprintf('p=%.4f', pval));


return;





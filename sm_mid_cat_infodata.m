function catinfo = sm_mid_cat_infodata(extrap_info, nsets)
% sm_mid_cat_infodata  Cat MID extrapolated information values
%
%    catinfo = sm_mid_cat_infodata(extrap_info, nsets)
% 
%       extrap_info : data base of extrapolated information values from cat MIDs.
%       nsets : # of test sets that must have good information values. If fewer
%           sets don't have enough good estimates, then a sentinel, -9999, 
%           is returned.
%
%       catinfo : struct holding information values.
%    

graphics_toolkit('qt');

narginchk(1,2);


if nargin == 1
    nsets = 1; % must have more than 1 good test set information calculation, i.e. 2, 3, or 4
else
    nsets = nsets - 1;
end


experiment = {};
site = {};
chan = {};
model = {};
depth = {};
position = {};
stim = {};
atten = {};
spl = {};
sm = {};
tm = {};
mdb = {};

numbins_cell = {};
nsets_cell = {};
infosta = {};
infomid1 = {};
infomid2 = {};
infomid12 = {};

for i = 1:length(extrap_info)

    experiment{i} = extrap_info(i).exp;
    site{i} = extrap_info(i).site;
    chan{i} = extrap_info(i).chan;
    model{i} = extrap_info(i).model;
    depth{i} = extrap_info(i).depth;
    position{i} = extrap_info(i).position;
    stim{i} = extrap_info(i).stim;
    atten{i} = extrap_info(i).atten;
    spl{i} = extrap_info(i).spl;
    sm{i} = 4;
    tm{i} = 40;
    mdb{i} = 40; 

    numbins = extrap_info(i).numbins;
    numbins_cell{i} = 15;
    index1d = find(numbins == 15);
    index2d = find(numbins == 15);

    % Part 1 data:
    sta_info_part1 = extrap_info(i).sta.part1_test_extrap(index1d);
    mid1_info_part1 = extrap_info(i).mid1.part1_test_extrap(index1d);
    mid2_info_part1 = extrap_info(i).mid2.part1_test_extrap(index1d);
    mid12_info_part1 = mean( extrap_info(i).mid12.part1_test_extrap(index2d) );

    % Part 2 data:
    sta_info_part2 = extrap_info(i).sta.part2_test_extrap(index1d);
    mid1_info_part2 = extrap_info(i).mid1.part2_test_extrap(index1d);
    mid2_info_part2 = extrap_info(i).mid2.part2_test_extrap(index1d);
    mid12_info_part2 = mean( extrap_info(i).mid12.part2_test_extrap(index2d) );


    % Part 3 data:
    sta_info_part3 = extrap_info(i).sta.part3_test_extrap(index1d);
    mid1_info_part3 = extrap_info(i).mid1.part3_test_extrap(index1d);
    mid2_info_part3 = extrap_info(i).mid2.part3_test_extrap(index1d);
    mid12_info_part3 = mean( extrap_info(i).mid12.part3_test_extrap(index2d) );

    % Part 4 data:
    sta_info_part4 = extrap_info(i).sta.part4_test_extrap(index1d);
    mid1_info_part4 = extrap_info(i).mid1.part4_test_extrap(index1d);
    mid2_info_part4 = extrap_info(i).mid2.part4_test_extrap(index1d);
    mid12_info_part4 = mean( extrap_info(i).mid12.part4_test_extrap(index2d) );

    ista = [sta_info_part1 sta_info_part2 sta_info_part3 sta_info_part4];
    imid1 = [mid1_info_part1 mid1_info_part2 mid1_info_part3 mid1_info_part4];
    imid2 = [mid2_info_part1 mid2_info_part2 mid2_info_part3 mid2_info_part4];
    imid12 = [mid12_info_part1 mid12_info_part2 mid12_info_part3 mid12_info_part4];

    index_sta = find(ista > 0);
    index_mid1 = find(imid1 > 0);
    index_mid2 = find(imid2 > 0);
    index_mid12 = find(imid12 > 0);

    % Get values when all 4 estimates were good
    if ( length(index_sta)>nsets )
        infosta{i} = mean(ista(index_sta));
    else
        infosta{i} = -9999;
    end

    if ( length(index_mid1)>nsets )
        infomid1{i} = mean(imid1(index_mid1));
    else
        infomid1{i} = -9999;
    end

    if ( length(index_mid2)>nsets )
        infomid2{i} = mean(imid2(index_mid2));
    else
        infomid2{i} = -9999;
    end

    if ( length(index_mid12)>nsets )
        infomid12{i} = mean(imid12(index_mid12));
    else
        infomid12{i} = -9999;
    end

    nsets_cell{i} = nsets+1;

    clear('ista', 'imid1', 'imid2', 'imid12');
    clear('index_sta', 'index_mid1', 'index_mid2', 'index_mid12');

end % (for i)


catinfo.experiment = experiment;
catinfo.site = site;
catinfo.chan = chan;
catinfo.model = model;
catinfo.depth = depth;
catinfo.position = position;
catinfo.stim = stim;
catinfo.atten = atten;
catinfo.spl = spl;
catinfo.sm = sm;
catinfo.tm = tm;
catinfo.mdb = mdb;
catinfo.numbins = numbins_cell;
catinfo.nsets = nsets_cell;
catinfo.infosta = infosta;
catinfo.infomid1 = infomid1;
catinfo.infomid2 = infomid2;
catinfo.infomid12 = infomid12;


return;



% ==================================================================================
% =========================== Function Declarations ================================
% ==================================================================================

function plot_extrapolated_information(infosta, infomid1, infomid2, infomid12)

% Plot the Extrapolated Information Values
% =======================================================
% =======================================================

figure;

% Plot the first mid against the sta
% -----------------------------------------
% [infomid1' infomid1_real' max([infomid1(:)'; infomid1_real(:)'])']
subplot(2,2,1);
plot(infosta, infomid1, 'ko');
mxmx = 1.05 * max([ max(infosta) max(infomid1) ]);
hold on;
plot([0.01 mxmx], [0.01 mxmx], 'k-');
xlim([0.01 mxmx])
ylim([0.01 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out');
axis('square');
xlabel('I_{STA}');
ylabel('I_{MID1}');
title('MID_{1} versus STA');



% Plot the first mid against the second mid
% -----------------------------------------
subplot(2,2,2);
plot(infomid1, infomid2, 'ko');
mxmx = max([ get(gca,'xlim') get(gca,'ylim') ]);
hold on;
plot([0.01 mxmx], [0.01 mxmx], 'k-');
xlabel('I_{MID1}');
ylabel('I_{MID2}');
xlim([0.01 mxmx])
ylim([0.01 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out');
axis('square');
xlabel('I_{MID1}');
ylabel('I_{MID2}');
title('MID_{2} versus MID_{1}');



% Plot the first mid against the first and second mid
% ---------------------------------------------------
subplot(2,2,3);
plot(infomid1, infomid12, 'ko');
mxmx = max([ get(gca,'xlim') get(gca,'ylim') ]);
hold on;
plot([0.02 mxmx], [0.02 mxmx], 'k-');
xlim([0.02 mxmx])
ylim([0.02 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out');
axis('square');
xlabel('I_{MID1}');
ylabel('I_{MID12}');
title('MID_{12} versus MID_{1}');




% Plot the synergy
% -----------------------------------------
subplot(2,2,4);
plot(infomid1+infomid2, infomid12, 'ko');
mxmx = max([ get(gca,'xlim') get(gca,'ylim') ]);
hold on;
plot([0.02 mxmx], [0.02 mxmx], 'k-');
xlim([0.02 mxmx])
ylim([0.02 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out');
axis('square');
xlabel('I_{MID1} + I_{MID2}');
ylabel('I_{MID12}');
title('MID_{1} + MID_{2} versus MID_{12}');

suptitle('Extrapolation to Infinite Data Set Size');
print_mfilename(mfilename);
orient('landscape');

return; % end of function plot_extrapolated_information




function plot_extrap_info_scatter(infosta, infomid1, infomid2, infomid12)


% Plot scatter and histograms of the information comparisons
% ==========================================================
% ==========================================================


figure;
markersize = 2;
% Plot the first mid against the sta
% -----------------------------------------
subplot(2,2,1);
plot(infosta, infomid1, 'ko', 'markersize', markersize);
mxmx = 3.5; %1.05 * max([ max(infosta) max(infomid1) ]);
hold on;
plot([0.01 mxmx], [0.01 mxmx], 'k-');
xlim([0.01 mxmx])
ylim([0.01 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
tick = [0.01 0.1 1 3.5];
set(gca,'xtick', tick, 'xticklabel', tick);
set(gca,'ytick', tick, 'yticklabel', tick);
axis('square');
xlabel('I_{STA}');
ylabel('I_{MID1}');
title('MID_{1} versus STA');


% Plot the first mid against the second mid
% -----------------------------------------
subplot(2,2,2);
plot(infomid1, infomid2, 'ko', 'markersize', markersize);
mxmx = max([ get(gca,'xlim') get(gca,'ylim') ]);
hold on;
plot([0.01 mxmx], [0.01 mxmx], 'k-');
xlabel('I_{MID1}');
ylabel('I_{MID2}');
xlim([0.01 mxmx])
ylim([0.01 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
tick = [0.01 0.1 1 4];
set(gca,'xtick', tick, 'xticklabel', tick);
set(gca,'ytick', tick, 'yticklabel', tick);
axis('square');
xlabel('I_{MID1}');
ylabel('I_{MID2}');
title('MID_{2} versus MID_{1}');


% Plot the first mid against the first and second mid
% ---------------------------------------------------
subplot(2,2,3);
plot(infomid1, infomid12, 'ko', 'markersize', markersize);
mxmx = max([ get(gca,'xlim') get(gca,'ylim') ]);
hold on;
plot([0.02 mxmx], [0.02 mxmx], 'k-');
xlim([0.02 mxmx])
ylim([0.02 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
tick = [0.02 0.1 1 6];
set(gca,'xtick', tick, 'xticklabel', tick);
set(gca,'ytick', tick, 'yticklabel', tick);
axis('square');
xlabel('I_{MID1}');
ylabel('I_{MID12}');
title('MID_{12} versus MID_{1}');


% Plot the synergy
% -----------------------------------------
subplot(2,2,4);
plot(infomid1+infomid2, infomid12, 'ko', 'markersize', markersize);
mxmx = max([ get(gca,'xlim') get(gca,'ylim') ]);
hold on;
plot([0.02 mxmx], [0.02 mxmx], 'k-');
xlim([0.02 mxmx])
ylim([0.02 mxmx])
set(gca,'xscale', 'log');
set(gca,'yscale', 'log');
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
tick = [0.02 0.1 1 6];
set(gca,'xtick', tick, 'xticklabel', tick);
set(gca,'ytick', tick, 'yticklabel', tick);
axis('square');
xlabel('I_{MID1} + I_{MID2}');
ylabel('I_{MID12}');
title('MID_{1} + MID_{2} versus MID_{12}');

suptitle('Extrapolated Data Set');
print_mfilename(mfilename);
orient('tall');

return; % end of function plot_extrap_info_scatter_hist






function plot_extrap_info_hist(infosta, infomid1, infomid2, infomid12)

% Plot scatter and histograms of the information comparisons
% ==========================================================
% ==========================================================

info1_info12 = 100 * infomid1 ./ infomid12;
info2_info12 = 100 * infomid2 ./ infomid12;
info1_info1_info2 = 100 * infomid1 ./ (infomid1 + infomid2);
info12_info1_info2 = 100 * infomid12 ./ (infomid1 + infomid2);
info2_info1 = 100 * infomid2 ./ infomid1;
infosta_info1 = 100 * infosta ./ infomid1;
infosta_info12 = 100 * infosta ./ infomid12;


[infosta(:) infomid1(:)];

[min(infosta_info1) max(infosta_info1)];


figure;
markersize = 2;

% Plot the first mid against the sta
% -----------------------------------------
subplot(2,2,1);
bins = linspace(0,100,11);
count = histc(infosta_info1, bins);
total_count = sum(count);
count = 100 * count ./ total_count;
hb = bar(bins, count, 'histc');
set(hb, 'facecolor', [0.75 0.75 0.75])
axis([-10 110 0 1.05*max(count)]);
set(gca,'xtick', [0:20:100], 'xticklabel', [0:20:100]);
set(gca,'ytick', [0:5:25], 'yticklabel', [0:5:25]);
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
xlabel('100 * STA / MID_1 Information');
ylabel('Percent of neurons (%)');
title(sprintf('mn=%.2f, sd=%.2f', mean(infosta_info1), std(infosta_info1) ));


% Plot the first mid against the second mid
% -----------------------------------------
subplot(2,2,2);
bins = linspace(0,100,11);
count = histc(info2_info1, bins);
total_count = sum(count);
count = 100 * count ./ total_count;
hb = bar(bins, count, 'histc');
set(hb, 'facecolor', [0.75 0.75 0.75])
axis([-10 110 0 1.05*max(count)]);
set(gca,'xtick', [0:20:100], 'xticklabel', [0:20:100]);
set(gca,'ytick', [0:5:35], 'yticklabel', [0:5:35]);
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
xlabel('100 * MID_2 / MID_1 Information');
ylabel('Percent of neurons (%)');
title(sprintf('mn=%.2f, sd=%.2f', mean(info2_info1), std(info2_info1) ));


% Plot the first mid against the first and second mid
% ---------------------------------------------------
subplot(2,2,3);
bins = linspace(0,100,11);
count = histc(info1_info12, bins);
total_count = sum(count);
count = 100 * count ./ total_count;
hb = bar(bins, count, 'histc');
set(hb, 'facecolor', [0.75 0.75 0.75])
axis([-10 110 0 1.05*max(count)]);
set(gca,'xtick', 0:20:100, 'xticklabel', 0:20:100);
set(gca,'ytick', [0:5:35], 'yticklabel', [0:5:35]);
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
xlabel('100 * MID_1 / MID_{12} Information');
ylabel('Percent of neurons (%)');
title(sprintf('mn=%.2f, sd=%.2f', mean(info1_info12), std(info1_info12) ));


% Plot the synergy
% -----------------------------------------
subplot(2,2,4);

% bins = linspace(75,300,10);

bins = linspace(75,200,11);

info12_info1_info2( info12_info1_info2 >= 200 ) = 199;

count = histc(info12_info1_info2, bins);
total_count = sum(count);
count = 100 * count ./ total_count;
hb = bar(bins, count, 'histc');
set(hb, 'facecolor', [0.75 0.75 0.75])
axis([65 210 0 1.05*max(count)]);
set(gca,'xtick', [75:25:200], 'xticklabel', [75:25:200]);
set(gca,'ytick', [0:5:50], 'yticklabel', [0:5:50]);
set(gca,'tickdir', 'out', 'ticklength', [0.025 0.025]);
xlabel('100 * MID_{12} / ( MID_1 + MID_2 ) Information');
ylabel('Percent of neurons(%)');
title(sprintf('mn=%.2f, sd=%.2f', mean(info12_info1_info2), std(info12_info1_info2) ));

[h,p,ci,stat] = ttest(info12_info1_info2, 100, 0.05, 1);

suptitle('Extrapolated Data Set');
print_mfilename(mfilename);
orient('tall');

length(find(info12_info1_info2>=125))/length(info12_info1_info2);

return; % end of function plot_extrap_info_scatter_hist





function [data, err] = error_check_info_values(sta_info, mid1_info, mid2_info, mid12_info, sta_info_normr, mid1_info_normr, mid2_info_normr, mid12_info_normr)

data = [sta_info mid1_info mid2_info mid12_info];

% normr = [sta_info_normr mid1_info_normr mid2_info_normr mid12_info_normr];

if ( sta_info>mid12_info | sta_info>mid1_info | mid1_info>mid12_info | mid2_info>mid1_info | min(data)<0 | mid12_info<0.01 )
%      mid12_info<0.01 | sum( normr>0.05 ) )
   data = [];
   err = 1;
else
   err = 0;
end


if ( min(data) <= 0 ) % can't have negative or zero extrapolated information values
   data = [];
   err = 1;
else
   err = 0;
end



return;

























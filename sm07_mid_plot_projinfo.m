function sminfo = sm_mid_plot_projinfo(projinfo, nsets)
% mid_sm_plot_projinfo Plot information results for awake squirrel monkey MID analysis
%
% mid_sm_plot_projinfo(projinfo, nsets) 
% ---------------------------------------------------------------------------------
%
% Plots STA, MID1, MID2, MID12 information values contained in the struct
% array projinfo. 
%
% projinfo : struct array holding information estimates. These were estimates 
%   made after the MID analysis and will include training and test set information
%   calculations.
%
% projinfo is obtained from mid_dir_sm_filter_to_fio_info.m, which in turn is
%   a fancy wrapper for mid_filter_to_fio_info.m
% 

if nargin == 1
    nsets = 3;
else
    nsets = nsets - 1;
end


% First compare STA and MID1 information

infosta = [];
infomid1 = [];
sta_mid1 = [];

for i = 1:length(projinfo)

    ista = projinfo(i).info0_extrap_test(1:4);
    imid1 = projinfo(i).info1_extrap_test(1:4);

    temp = projinfo(i).info0_extrap_test;

    index_sta = find(ista > 0);
    index_mid1 = find(imid1 > 0);

    % Get values when all 4 estimates were good
    if ( length(index_sta)>nsets && length(index_mid1)>nsets )
        infosta = [infosta mean(ista(index_sta))];
        infomid1 = [infomid1 mean(imid1(index_mid1))];
        sta_mid1 = [sta_mid1 projinfo(i)];
    end

end % (for i)


figure;
subplot(2,1,1);
mnmn = min([infosta(:); infomid1(:)]);
mxmx = max([infosta(:); infomid1(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(infosta, infomid1, 'ko', 'markersize', 2);
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('STA Info [bits/spike]');
ylabel('MID1 Info [bits/spike]');
title(sprintf('MID1 vs. STA; N = %.0f', length(infosta)));

subplot(2,1,2);
edges = 0:10:200;
contribution = 100*infosta ./ infomid1;
plot_info_sta_mid1_ratio_hist(edges, contribution);


%suptitle(strrep(mfilename,'_', '-'));

set(gcf,'position', [840 109 600 850]);
orient tall;


fprintf('STA vs. MID1\n');
p = ranksum(infosta(:), infomid1(:))

fprintf('STA / MID1 stats\n');
simple_stats(contribution)



% First compare MID1 and MID12 information

infomid1 = [];
infomid12 = [];
mid1_mid12 = [];

for i = 1:length(projinfo)

    imid1 = projinfo(i).info1_extrap_test(1:4);
    imid12 = projinfo(i).info12_extrap_test(1:4);

    index_mid1 = find(imid1 > 0);
    index_mid12 = find(imid12 > 0);

    if ( length(index_mid1)>nsets && length(index_mid12)>nsets )
        infomid1 = [infomid1 mean(imid1(index_mid1))];
        infomid12 = [infomid12 mean(imid12(index_mid12))];
        mid1_mid12 = [mid1_mid12 projinfo(i)];
    end

end % (for i)


figure;
subplot(2,1,1);
mnmn = min([infomid1(:); infomid12(:)]);
mxmx = max([infomid1(:); infomid12(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(infomid1, infomid12, 'ko', 'markersize', 2);
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('MID1 Info [bits/spike]');
ylabel('MID12 Info [bits/spike]');
title(sprintf('MID12 vs. MID1; N = %.0f', length(infomid1)));


subplot(2,1,2);
edges = 0:10:200;
contribution = 100*infomid1 ./ infomid12;
plot_info_mid1_contribution_hist(edges, contribution);

set(gcf,'position', [840 109 600 850]);
orient tall;

fprintf('MID1 vs. MID12\n');
p = ranksum(infomid12(:), infomid1(:))

fprintf('MID1 / MID12 stats\n');
simple_stats(contribution)





% First compare MID1 and MID2 information

infomid1 = [];
infomid2 = [];
mid1_mid2 = [];

for i = 1:length(projinfo)

    imid1 = projinfo(i).info1_extrap_test(1:4);
    imid2 = projinfo(i).info2_extrap_test(1:4);

    index_mid1 = find(imid1 > 0);
    index_mid2 = find(imid2 > 0);

    if ( length(index_mid1)>nsets && length(index_mid2)>nsets )
        infomid1 = [infomid1 mean(imid1(index_mid1))];
        infomid2 = [infomid2 mean(imid2(index_mid2))];
        mid1_mid2 = [mid1_mid2 projinfo(i)];
    end

end % (for i)


figure;
subplot(2,1,1);
mnmn = min([infomid1(:); infomid2(:)]);
mxmx = max([infomid1(:); infomid2(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(infomid1, infomid2, 'ko', 'markersize', 2);
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('MID1 Info [bits/spike]');
ylabel('MID2 Info [bits/spike]');
title(sprintf('MID2 vs. MID1; N = %.0f', length(infomid1)));

subplot(2,1,2);
edges = 0:10:200;
contribution = 100 * infomid2 ./ infomid1;
plot_info_mid2_mid1_ratio_hist(edges, contribution);

set(gcf,'position', [840 109 600 850]);
orient tall;


fprintf('MID2 vs. MID1\n');
p = ranksum(infomid2(:), infomid1(:))

fprintf('MID2 / MID1 stats\n');
simple_stats(contribution)







% Compare MID12 and (MID1+MID2) information

infomid1 = [];
infomid2 = [];
infomid12 = [];

for i = 1:length(projinfo)

    imid1 = projinfo(i).info1_extrap_test(1:4);
    imid2 = projinfo(i).info2_extrap_test(1:4);
    imid12 = projinfo(i).info12_extrap_test(1:4);

    index_mid1 = find(imid1 > 0 );
    index_mid2 = find(imid2 > 0 );
    index_mid12 = find(imid12 > 0 );

    if ( length(index_mid1)>nsets && length(index_mid2)>nsets && length(index_mid12)>nsets )
        infomid1 = [infomid1 mean(imid1(index_mid1))];
        infomid2 = [infomid2 mean(imid2(index_mid2))];
        infomid12 = [infomid12 mean(imid12(index_mid12))];
    end

end % (for i)

joint_info = infomid12;
sep_info = infomid1 + infomid2;
synergy = 100 * infomid12 ./ sep_info;


figure;
subplot(2,1,1);
mnmn = min([joint_info(:); sep_info(:)]);
mxmx = max([joint_info(:); sep_info(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(sep_info, joint_info, 'ko', 'markersize', 2);
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('MID1+MID2 Info [bits/spike]');
ylabel('MID12 Info [bits/spike]');
title(sprintf('MID12 vs. MID1+MID2; N = %.0f', length(joint_info)));

subplot(2,1,2);
edges = 50:25:400;
plot_info_synergy_hist(edges, synergy);

set(gcf,'position', [840 109 600 850]);
orient tall;


fprintf('MID21 vs. MID1+MID2\n');
p = ranksum(joint_info(:), sep_info(:))

fprintf('MID12 / (MID1+MID2) stats\n');
simple_stats(synergy)




sprfile = {};
iskfile = {};
experiment = {};
time = {};
site = {};
stim = {};
unit = {};
nsets_cell = {};
infosta = {};
infomid1 = {};
infomid2 = {};
infomid12 = {};


for i = 1:length(projinfo)

    sprfile{i} = projinfo(i).sprfile;
    iskfile{i} = projinfo(i).iskfile;
    experiment{i} = projinfo(i).exp;
    time{i} = projinfo(i).time;
    site{i} = projinfo(i).site;
    stim{i} = projinfo(i).stim;
    unit{i} = projinfo(i).unit;
    nsets_cell{i} = nsets+1;

    ista = projinfo(i).info0_extrap_test(1:4);
    imid1 = projinfo(i).info1_extrap_test(1:4);
    imid2 = projinfo(i).info2_extrap_test(1:4);
    imid12 = projinfo(i).info12_extrap_test(1:4);

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

    clear('ista', 'imid1', 'imid2', 'imid12');
    clear('index_sta', 'index_mid1', 'index_mid2', 'index_mid12');


end % (for i)


sminfo.sprfile = sprfile;
sminfo.iskfile = iskfile;
sminfo.experiment = experiment;
sminfo.time = time;
sminfo.site = site;
sminfo.stim = stim;
sminfo.unit = unit;
sminfo.nsets = nsets_cell;
sminfo.infosta = infosta;
sminfo.infomid1 = infomid1;
sminfo.infomid2 = infomid2;
sminfo.infomid12 = infomid12;


return;




% Information histograms

infosta = [];
infomid1 = [];
infomid2 = [];
infomid12 = [];

for i = 1:length(projinfo)

    ista = projinfo(i).info0_extrap_test;
    imid1 = projinfo(i).info1_extrap_test;
    imid2 = projinfo(i).info2_extrap_test;
    imid12 = projinfo(i).info12_extrap_test;


    index_sta = find(ista > 0);
    index_mid1 = find(imid1 > 0);
    index_mid2 = find(imid2 > 0 );
    index_mid12 = find(imid12 > 0 );


    if ( length(index_sta)>nsets )
        infosta = [infosta mean(ista(index_sta))];
    end


    if ( length(index_mid1)>nsets )
        infomid1 = [infomid1 mean(imid1(index_mid1))];
    end


    if ( length(index_mid2)>nsets )
        infomid2 = [infomid2 mean(imid2(index_mid2))];
    end


    if ( length(index_mid12)>nsets )
        infomid12 = [infomid12 mean(imid12(index_mid12))];
    end

end % (for i)




figure;

subplot(2,2,1);
edges = linspace(0,2.5,26);
plot_info_hist(edges, infosta, 'STA');


subplot(2,2,2);
plot_info_hist(edges, infomid1, 'MID1');


subplot(2,2,3);
plot_info_hist(edges, infomid2, 'MID2');


subplot(2,2,4);
plot_info_hist(edges, infomid12, 'MID12');




% Get all well behaved information calculations for a neuron.

info0 = [];
info1 = [];
info2 = [];
info12 = [];

for i = 1:length(projinfo)

    info0_unit = projinfo(i).info0_extrap_test;
    info1_unit = projinfo(i).info1_extrap_test;
    info2_unit = projinfo(i).info2_extrap_test;
    info12_unit = projinfo(i).info12_extrap_test;

    index0 = find(info0_unit > 0 );
    index1 = find(info1_unit > 0 );
    index2 = find(info2_unit > 0 );
    index12 = find(info12_unit > 0 );

    if ( length(index0)>nsets &&  ...
         length(index1)>nsets && ...
         length(index2)>nsets && ...
         length(index12)>nsets )
        info0 = [info0 mean(info0_unit(index0))];
        info1 = [info1 mean(info1_unit(index1))];
        info2 = [info2 mean(info2_unit(index2))];
        info12 = [info12 mean(info12_unit(index12))];
    end

end % (for i)



% Make 3D scatter plots:

figure;

scatter3(info0, info1, info2);
xlabel('STA');
ylabel('MID1');
zlabel('MID2');
set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');
set(gca, 'zscale', 'log');


return;





function plot_info_hist(edges, info, xstr, titstr);
    count = histc(info, edges);
    prop = 100 * count / sum(count);
    h = bar(edges, prop, 'histc');
    set(h, 'facecolor', 0.5*ones(1,3));
    xlim([min(edges) max(edges)]);
    ylim([0 100]);
    tickpref;
    xlabel(sprintf('%s Info [bits/spike]',xstr));
    ylabel('Percent (%)');
    title(sprintf('%s Info; N = %.0f', xstr, length(info)));
return;




function plot_info_synergy_hist(edges, synergy);
    count = histc(synergy, edges);
    prop = 100 * count / sum(count);
    h = bar(edges, prop, 'histc');
    set(h, 'facecolor', 0.5*ones(1,3));
    xlim([min(edges) max(edges)]);
    ylim([0 1.05*max(prop)]);
    xtick = [50 100 200 300 400];
    set(gca,'xtick', xtick, 'xticklabel', xtick);
    tickpref;
    xlabel(sprintf('100 MID12 / (MID1 + MID2)'));
    ylabel('Percent (%)');
    title(sprintf('MID Synergy; N = %.0f', length(synergy)));
return;




function plot_info_mid1_contribution_hist(edges, contribution);
    count = histc(contribution, edges);
    prop = 100 * count / sum(count);
    h = bar(edges, prop, 'histc');
    set(h, 'facecolor', 0.5*ones(1,3));
    xlim([min(edges) max(edges)]);
    ylim([0 1.05*max(prop)]);
    tickpref;
    xlabel(sprintf('100 MID1 / MID12'));
    ylabel('Percent (%)');
    title(sprintf('100 * MID1 / MID1,2; N = %.0f', length(contribution)));
return;


function plot_info_sta_mid1_ratio_hist(edges, contribution);
    count = histc(contribution, edges);
    prop = 100 * count / sum(count);
    h = bar(edges, prop, 'histc');
    set(h, 'facecolor', 0.5*ones(1,3));
    xlim([min(edges) max(edges)]);
    ylim([0 1.05*max(prop)]);
    tickpref;
    xlabel(sprintf('100 STA / MID1'));
    ylabel('Percent (%)');
    title(sprintf('STA Sufficiency; N = %.0f', length(contribution)));
return;


function plot_info_mid2_mid1_ratio_hist(edges, contribution);
    count = histc(contribution, edges);
    prop = 100 * count / sum(count);
    h = bar(edges, prop, 'histc');
    set(h, 'facecolor', 0.5*ones(1,3));
    xlim([min(edges) max(edges)]);
    ylim([0 1.05*max(prop)]);
    tickpref;
    xlabel(sprintf('100 MID2 / MID1'));
    ylabel('Percent (%)');
    title(sprintf('100 * MID2 / MID1; N = %.0f', length(contribution)));
return;
















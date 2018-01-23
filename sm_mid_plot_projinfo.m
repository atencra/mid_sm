function sm_mid_plot_projinfo(projinfo)
% mid_sm_plot_projinfo Plot information results for awake squirrel monkey MID analysis
%
% mid_sm_plot_projinfo(projinfo) 
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



% First compare STA and MID1 information

infosta = [];
infomid1 = [];

for i = 1:length(projinfo)

    ista = projinfo(i).info0_extrap_test;
    imid1 = projinfo(i).info1_extrap_test;

    index_sta = find(ista > 0);
    index_mid1 = find(imid1 > 0);

    if ( ~isempty(index_sta) & ~isempty(index_mid1) )
        infosta = [infosta mean(ista(index_sta))];
        infomid1 = [infomid1 mean(imid1(index_mid1))];
    end

end % (for i)


figure;
mnmn = min([infosta(:); infomid1(:)]);
mxmx = max([infosta(:); infomid1(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(infosta, infomid1, 'ko');
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('STA Info [bits/spike]');
ylabel('MID1 Info [bits/spike]');
title(sprintf('MID1 vs. STA; N = %.0f', length(infosta)));




% First compare MID1 and MID12 information

infomid1 = [];
infomid12 = [];

for i = 1:length(projinfo)

    imid1 = projinfo(i).info1_extrap_test;
    imid12 = projinfo(i).info12_extrap_test;

    index_mid1 = find(imid1 > 0);
    index_mid12 = find(imid12 > 0);

    if ( ~isempty(index_mid1) & ~isempty(index_mid12) )
        infomid1 = [infomid1 mean(imid1(index_mid1))];
        infomid12 = [infomid12 mean(imid12(index_mid12))];
    end

end % (for i)


figure;
mnmn = min([infomid1(:); infomid12(:)]);
mxmx = max([infomid1(:); infomid12(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(infomid1, infomid12, 'ko');
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('MID1 Info [bits/spike]');
ylabel('MID12 Info [bits/spike]');
title(sprintf('MID12 vs. MID1; N = %.0f', length(infomid1)));



% First compare MID1 and MID2 information

infomid1 = [];
infomid2 = [];

for i = 1:length(projinfo)

    imid1 = projinfo(i).info1_extrap_test;
    imid2 = projinfo(i).info2_extrap_test;

    index_mid1 = find(imid1 > 0);
    index_mid2 = find(imid2 > 0);

    if ( ~isempty(index_mid1) & ~isempty(index_mid2) )
        infomid1 = [infomid1 mean(imid1(index_mid1))];
        infomid2 = [infomid2 mean(imid2(index_mid2))];
    end

end % (for i)


figure;
mnmn = min([infomid1(:); infomid2(:)]);
mxmx = max([infomid1(:); infomid2(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(infomid1, infomid2, 'ko');
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('MID1 Info [bits/spike]');
ylabel('MID2 Info [bits/spike]');
title(sprintf('MID2 vs. MID1; N = %.0f', length(infomid1)));




% First compare MID12 and (MID1+MID2) information

infomid1 = [];
infomid2 = [];
infomid12 = [];

for i = 1:length(projinfo)

    imid1 = projinfo(i).info1_extrap_test;
    imid2 = projinfo(i).info2_extrap_test;
    imid12 = projinfo(i).info12_extrap_test;

    index_mid1 = find(imid1 > 0 );
    index_mid2 = find(imid2 > 0 );
    index_mid12 = find(imid12 > 0 );

    if ( ~isempty(index_mid1) &  ~isempty(index_mid2) & ~isempty(index_mid12) )
        infomid1 = [infomid1 mean(imid1)];
        infomid2 = [infomid2 mean(imid2)];
        infomid12 = [infomid12 mean(imid12)];
    end

end % (for i)

joint_info = infomid12;
sep_info = infomid1 + infomid2;

figure;
mnmn = min([joint_info(:); sep_info(:)]);
mxmx = max([joint_info(:); sep_info(:)]);
plot([mnmn mxmx], [mnmn mxmx], 'k-');
hold on;
plot(sep_info, joint_info, 'ko');
set(gca,'xscale', 'log');
set(gca, 'yscale', 'log');
tickpref;
xlabel('MID1+MID2 Info [bits/spike]');
ylabel('MID12 Info [bits/spike]');
title(sprintf('MID12 vs. MID1+MID2; N = %.0f', length(joint_info)));




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

    if ( all(ista>0) )
        infosta = [infosta mean(ista)];
    end

    if ( all(imid1>0) )
        infomid1 = [infomid1 mean(imid1)];
    end

    if ( all(imid2>0) )
        infomid2 = [infomid2 mean(imid2)];
    end

    if ( all(imid12>0) )
        infomid12 = [infomid12 mean(imid12)];
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










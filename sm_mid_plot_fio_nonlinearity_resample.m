function sm_mid_plot_fio_nonlinearity_resample(fio)
% sm_mid_fio_nonlinearity_resample  MID analysis filters
%
% sm_mid_plot_fio_filters(fio) plots the filters derived from the
% mid analysis.
%
% STA, MID1, and MID2 filters are plotted in rows. Each column shows 
% the filter from a training set (columns 1-4), or the mean filter
% column (5).
%
% The color scale is relative to each filter.
%
% fio is a struct holding the results of the mid calculations.
%
% 


plot_filters(fio)

plot_fio_nonlinearities_resample(fio);


return;



function plot_filters(fio)

iskfile = fio.iskfile;

numfbins = fio.nf_filter;
numtbins = fio.nt_filter;

sta{1} = reshape( fio.filter_matrix_sta(:,1), numfbins, numtbins );
sta{2} = reshape( fio.filter_matrix_sta(:,2), numfbins, numtbins );
sta{3} = reshape( fio.filter_matrix_sta(:,3), numfbins, numtbins );
sta{4} = reshape( fio.filter_matrix_sta(:,4), numfbins, numtbins );
sta{5} = reshape( fio.filter_mean_sta, numfbins, numtbins );

mid1{1} = reshape( fio.filter_matrix_test2_v1(:,1), numfbins, numtbins );
mid1{2} = reshape( fio.filter_matrix_test2_v1(:,2), numfbins, numtbins );
mid1{3} = reshape( fio.filter_matrix_test2_v1(:,3), numfbins, numtbins );
mid1{4} = reshape( fio.filter_matrix_test2_v1(:,4), numfbins, numtbins );
mid1{5} = reshape( fio.filter_mean_test2_v1, numfbins, numtbins );

mid2{1} = reshape( fio.filter_matrix_test2_v2(:,1), numfbins, numtbins );
mid2{2} = reshape( fio.filter_matrix_test2_v2(:,2), numfbins, numtbins );
mid2{3} = reshape( fio.filter_matrix_test2_v2(:,3), numfbins, numtbins );
mid2{4} = reshape( fio.filter_matrix_test2_v2(:,4), numfbins, numtbins );
mid2{5} = reshape( fio.filter_mean_test2_v2, numfbins, numtbins );


% Plot the filters
% ----------------------------------------------------------

figure;

for i = 1:5
    subplot(3,5,i);
    imagesc( sta{i} );
    minmin = min(min(sta{i}));
    maxmax = max(max(sta{i}));
    boundary = max([abs(minmin) abs(maxmax)]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    cmap = brewmaps('rdbu',21);
    colormap(cmap);
    if i == 1
        ylabel('STA');
    end

    if i < 5
        title(sprintf('Training Set %.0f',i));
    else
        title('Mean');
    end
end % (for i)




for i = 1:5
    subplot(3,5,i+5);
    imagesc( mid1{i} );
    minmin = min(min(mid1{i}));
    maxmax = max(max(mid1{i}));
    boundary = max([abs(minmin) abs(maxmax)]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    cmap = brewmaps('rdbu',21);
    colormap(cmap);
    if i == 1
        ylabel('MID1');
    end
end % (for i)


for i = 1:5
    subplot(3,5,i+10);
    imagesc( mid2{i} );
    minmin = min(min(mid2{i}));
    maxmax = max(max(mid2{i}));
    boundary = max([abs(minmin) abs(maxmax)]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    cmap = brewmaps('rdbu',21);
    colormap(cmap);
    if i == 1
        ylabel('MID2');
    end
end % (for i)


iskfile = strrep(iskfile, '_', '-');
suptitle(sprintf('%ss', iskfile));

set(gcf,'position', [495 341 899 422]);

print_mfilename(mfilename);

return;



function plot_fio_resample(fio_resample, iskfile, datatype)

fprintf('Running plot_fio_resample.\n');


ms = 3;

%figure;

assert(length(fio_resample)==4, 'fio_resample should have length 4.');

% Plot the STA nonlinearities
% ----------------------------------------------------------

nreps = fio_resample(1).nreps;
percent = fio_resample(1).percent;

color_style = {'k', 'b', 'r', 'g'};
marker_style = {'o', 'o', 's', '^'};
line_style = {'-', '--', '-', '--'};

cmap = brewmaps('gnbu', 6);

%figure;

xtotal = [];
ytotal = [];

for ii = 1:length(fio_resample)

    xbins = fio_resample(ii).xbins;
    pspk = fio_resample(ii).pspk;
    pspkx = fio_resample(ii).pspkx;

    subplot(1,5,ii);
    hold on;

    xtotal_rep = [];
    ytotal_rep = [];

    for i = 1:10 %length(pspkx)

        plot(xbins{i}, pspkx{i}, ...
            sprintf('%s%s', marker_style{ii}, line_style{ii}), ...
            'color', cmap(ii,:), ...
            'markerfacecolor', cmap(ii,:), 'markersize', ms);

        plot([min(xbins{i}) max(xbins{i})], [pspk{i} pspk{i}], ...
            sprintf('%s', line_style{ii}), 'color', cmap(ii,:));

        xlim(1.1*[min(xbins{i}) max(xbins{i})]);
        set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

        xtotal_rep = [xtotal_rep xbins{i}(:)'];
        ytotal_rep = [ytotal_rep pspkx{i}(:)'];

    end % (for i)

    clear('xbins', 'pspk', 'pspkx');

    [xsort, index] = sort(xtotal_rep);
    ysort = ytotal_rep(index);

    xlow = prctile(xsort, [1]);
    xhigh = prctile(xsort, [99]);
    newx = linspace(xlow, xhigh, 15);
    newy = interp1(xsort, ysort, newx, 'linear');
    plot(newx, newy, 'r-', 'linewidth', 4);

    xtotal = [xtotal xtotal_rep(:)'];
    ytotal = [ytotal ytotal_rep(:)'];

    clear('xtotal_rep', 'ytotal_rep');

end % (for ii)

xlabel('x (SD)');
ylabel('p(spk|x)');


subplot(1,5,5);
hold on;

[xsort, index] = sort(xtotal);
ysort = ytotal(index);

xlow = prctile(xsort, [1]);
xhigh = prctile(xsort, [99]);

newx = linspace(xlow, xhigh, 15);
newy = interp1(xsort, ysort, newx, 'linear');
plot(newx, newy, 'r-', 'linewidth', 4);

plot(xsort, ysort, 'ko');
plot(newx, newy, 'r-', 'linewidth', 4);

clear('xtotal', 'ytotal');
clear('xsort', 'ysort');

iskfile = strrep(iskfile, '_', '-');

%suptitle(sprintf('%s - %s', datatype, iskfile));

fprintf('Finished plot_fio_resample.\n');

return;








function plot_fio_nonlinearities_resample(fio)

fprintf('Running plot_fio_nonlinearities_resample.\n');

iskfile = fio.iskfile;

ms = 3;


nreps = fio.sta_fio_resample(1).nreps;
percent = fio.sta_fio_resample(1).percent;

color_style = {'k', 'b', 'r', 'g'};
marker_style = {'o', 'o', 's', '^'};
line_style = {'-', '--', '-', '--'};

cmap = brewmaps('gnbu', 6);


figure;

% Plot the STA nonlinearities
% ----------------------------------------------------------

xtotal = [];
ytotal = [];

for ii = 1:length(fio.sta_fio_resample)

    xbins = fio.sta_fio_resample(ii).xbins;
    pspk = fio.sta_fio_resample(ii).pspk;
    pspkx = fio.sta_fio_resample(ii).pspkx;

    subplot(3,5,ii);
    hold on;

    xtotal_rep = [];
    ytotal_rep = [];

    for i = 1:10 %length(pspkx)

        plot(xbins{i}, pspkx{i}, ...
            sprintf('%s%s', marker_style{ii}, line_style{ii}), ...
            'color', cmap(ii,:), ...
            'markerfacecolor', cmap(ii,:), 'markersize', ms);

        plot([min(xbins{i}) max(xbins{i})], [pspk{i} pspk{i}], ...
            sprintf('%s', line_style{ii}), 'color', cmap(ii,:));

        xlim(1.1*[min(xbins{i}) max(xbins{i})]);
        set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

        xtotal_rep = [xtotal_rep xbins{i}(:)'];
        ytotal_rep = [ytotal_rep pspkx{i}(:)'];

    end % (for i)

    clear('xbins', 'pspk', 'pspkx');

    [xsort, index] = sort(xtotal_rep);
    ysort = ytotal_rep(index);

    xlow = prctile(xsort, [1]);
    xhigh = prctile(xsort, [99]);
    newx = linspace(xlow, xhigh, 15);
    newy = interp1(xsort, ysort, newx, 'linear');
    plot(newx, newy, 'r-', 'linewidth', 4);

    if ii == 1
        ylabel('STA');
    end
    xlabel('x (SD)');

    title(sprintf('Training Set %.0f',ii));

    xtotal = [xtotal xtotal_rep(:)'];
    ytotal = [ytotal ytotal_rep(:)'];

    clear('xtotal_rep', 'ytotal_rep');

end % (for ii)



subplot(3,5,5);
hold on;

[xsort, index] = sort(xtotal);
ysort = ytotal(index);

xlow = prctile(xsort, [1]);
xhigh = prctile(xsort, [99]);

newx = linspace(xlow, xhigh, 15);
newy = interp1(xsort, ysort, newx, 'linear');
plot(newx, newy, 'r-', 'linewidth', 4);

plot(xsort, ysort, 'ko');
plot(newx, newy, 'r-', 'linewidth', 4);
xlabel('x (SD)');
title('Mean');

clear('xtotal', 'ytotal');
clear('xsort', 'ysort');



% MID1

xtotal = [];
ytotal = [];

for ii = 1:length(fio.mid1_fio_resample)

    xbins = fio.mid1_fio_resample(ii).xbins;
    pspk = fio.mid1_fio_resample(ii).pspk;
    pspkx = fio.mid1_fio_resample(ii).pspkx;

    subplot(3,5,ii+5);
    hold on;

    xtotal_rep = [];
    ytotal_rep = [];

    for i = 1:10 %length(pspkx)

        plot(xbins{i}, pspkx{i}, ...
            sprintf('%s%s', marker_style{ii}, line_style{ii}), ...
            'color', cmap(ii,:), ...
            'markerfacecolor', cmap(ii,:), 'markersize', ms);

        plot([min(xbins{i}) max(xbins{i})], [pspk{i} pspk{i}], ...
            sprintf('%s', line_style{ii}), 'color', cmap(ii,:));

        xlim(1.1*[min(xbins{i}) max(xbins{i})]);
        set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

        xtotal_rep = [xtotal_rep xbins{i}(:)'];
        ytotal_rep = [ytotal_rep pspkx{i}(:)'];

    end % (for i)

    clear('xbins', 'pspk', 'pspkx');

    [xsort, index] = sort(xtotal_rep);
    ysort = ytotal_rep(index);

    if ii == 1
        ylabel('MID1');
    end

    xlow = prctile(xsort, [1]);
    xhigh = prctile(xsort, [99]);
    newx = linspace(xlow, xhigh, 15);
    newy = interp1(xsort, ysort, newx, 'linear');
    plot(newx, newy, 'r-', 'linewidth', 4);

    xtotal = [xtotal xtotal_rep(:)'];
    ytotal = [ytotal ytotal_rep(:)'];

    clear('xtotal_rep', 'ytotal_rep');

end % (for ii)



subplot(3,5,5+5);
hold on;

[xsort, index] = sort(xtotal);
ysort = ytotal(index);

xlow = prctile(xsort, [1]);
xhigh = prctile(xsort, [99]);

newx = linspace(xlow, xhigh, 15);
newy = interp1(xsort, ysort, newx, 'linear');
plot(newx, newy, 'r-', 'linewidth', 4);

plot(xsort, ysort, 'ko');
plot(newx, newy, 'r-', 'linewidth', 4);

clear('xtotal', 'ytotal');
clear('xsort', 'ysort');





% MID2

xtotal = [];
ytotal = [];

for ii = 1:length(fio.mid2_fio_resample)

    xbins = fio.mid2_fio_resample(ii).xbins;
    pspk = fio.mid2_fio_resample(ii).pspk;
    pspkx = fio.mid2_fio_resample(ii).pspkx;


    subplot(3,5,ii+10);
    hold on;

    xtotal_rep = [];
    ytotal_rep = [];

    for i = 1:10 %length(pspkx)

        plot(xbins{i}, pspkx{i}, ...
            sprintf('%s%s', marker_style{ii}, line_style{ii}), ...
            'color', cmap(ii,:), ...
            'markerfacecolor', cmap(ii,:), 'markersize', ms);

        plot([min(xbins{i}) max(xbins{i})], [pspk{i} pspk{i}], ...
            sprintf('%s', line_style{ii}), 'color', cmap(ii,:));

        xlim(1.1*[min(xbins{i}) max(xbins{i})]);
        set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

        xtotal_rep = [xtotal_rep xbins{i}(:)'];
        ytotal_rep = [ytotal_rep pspkx{i}(:)'];

    end % (for i)

    clear('xbins', 'pspk', 'pspkx');

    [xsort, index] = sort(xtotal_rep);
    ysort = ytotal_rep(index);

    xlow = prctile(xsort, [1]);
    xhigh = prctile(xsort, [99]);
    newx = linspace(xlow, xhigh, 15);
    newy = interp1(xsort, ysort, newx, 'linear');
    plot(newx, newy, 'r-', 'linewidth', 4);

    if ii == 1
        ylabel('MID2');
    end
    xlabel('x (SD)');

    xtotal = [xtotal xtotal_rep(:)'];
    ytotal = [ytotal ytotal_rep(:)'];

    clear('xtotal_rep', 'ytotal_rep');

end % (for ii)



subplot(3,5,10+5);
hold on;

[xsort, index] = sort(xtotal);
ysort = ytotal(index);

xlow = prctile(xsort, [1]);
xhigh = prctile(xsort, [99]);

newx = linspace(xlow, xhigh, 15);
newy = interp1(xsort, ysort, newx, 'linear');
plot(newx, newy, 'r-', 'linewidth', 4);
xlabel('x (SD)');

plot(xsort, ysort, 'ko');
plot(newx, newy, 'r-', 'linewidth', 4);

clear('xtotal', 'ytotal');
clear('xsort', 'ysort');


iskfile = strrep(iskfile, '_', '-');

suptitle(sprintf('%ss', iskfile));

set(gcf,'position', [495 341 899 422]);

fprintf('Finished plot_fio_resample.\n');

return;








function plot_nonlinearities(fio)
% sm_mid_plot_fio_nonlinearities(fio)
% sm_mid_plot_fio_nonlinearities(fio) MID analysis nonlinearities
%
% sm_mid_plot_fio_nonlinearities(fio) plots the filters derived from the
% mid analysis.
%
% STA, MID1, MID2, and MID12 nonlinearities are plotted in rows. Each column 
% shows the filter from a training set (columns 1-4), or the mean filter column (5).
%
% The color scale for the 2D nonlinearity is relative to each nonlinearity.
%
% fio is a struct holding the results of the mid calculations.
%
% 


iskfile = fio.iskfile;
ms = 3;

figure;


% Plot the STA nonlinearities
% ----------------------------------------------------------


pspk{1} = fio.fio_sta.pspk_mtx(1);
pspk{2} = fio.fio_sta.pspk_mtx(2);
pspk{3} = fio.fio_sta.pspk_mtx(3);
pspk{4} = fio.fio_sta.pspk_mtx(4);
pspk{5} = fio.fio_sta.pspk_mean;

x0{1} = fio.fio_sta.x_mtx(:,1);
x0{2} = fio.fio_sta.x_mtx(:,2);
x0{3} = fio.fio_sta.x_mtx(:,3);
x0{4} = fio.fio_sta.x_mtx(:,4);
x0{5} = fio.fio_sta.x_mean;

pspkx0{1} = fio.fio_sta.ior_mtx(:,1);
pspkx0{2} = fio.fio_sta.ior_mtx(:,2);
pspkx0{3} = fio.fio_sta.ior_mtx(:,3);
pspkx0{4} = fio.fio_sta.ior_mtx(:,4);
pspkx0{5} = fio.fio_sta.ior_mean;


maxmax = max([max(pspkx0{1}) max(pspkx0{2}) max(pspkx0{3}) max(pspkx0{4}) max(pspkx0{5})]);

for i = 1:5

    subplot(4,5,i);
    hold on;
    plot(x0{i}, pspkx0{i}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
    plot([min(x0{i}) max(x0{i})], [pspk{i} pspk{i}], 'k--');
    xlim(1.1*[min(x0{i}) max(x0{i})]);
    ylim([0 maxmax]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

    if i == 1
        ylabel('STA');
    end

    if i < 5
        title(sprintf('Training Set %.0f',i));
    else
        title('Mean');
    end

end % (for i)



% Plot the MID1 nonlinearities
% ----------------------------------------------------------

pspk{1} = fio.fio_mid1.pspk_mtx(1);
pspk{2} = fio.fio_mid1.pspk_mtx(2);
pspk{3} = fio.fio_mid1.pspk_mtx(3);
pspk{4} = fio.fio_mid1.pspk_mtx(4);
pspk{5} = fio.fio_mid1.pspk_mean;

x1{1} = fio.fio_mid1.x1_mtx(:,1);
x1{2} = fio.fio_mid1.x1_mtx(:,2);
x1{3} = fio.fio_mid1.x1_mtx(:,3);
x1{4} = fio.fio_mid1.x1_mtx(:,4);
x1{5} = fio.fio_mid1.x1_mean;

pspkx1{1} = fio.fio_mid1.pspkx1_mtx(:,1);
pspkx1{2} = fio.fio_mid1.pspkx1_mtx(:,2);
pspkx1{3} = fio.fio_mid1.pspkx1_mtx(:,3);
pspkx1{4} = fio.fio_mid1.pspkx1_mtx(:,4);
pspkx1{5} = fio.fio_mid1.pspkx1_mean;



maxmax = max([max(pspkx1{1}) max(pspkx1{2}) max(pspkx1{3}) max(pspkx1{4}) max(pspkx1{5})]);


for i = 1:5

    subplot(4,5,i+5);
    hold on;
    plot(x1{i}, pspkx1{i}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
    plot([min(x1{i}) max(x1{i})], [pspk{i} pspk{i}], 'k--');
    xlim(1.1*[min(x1{i}) max(x1{i})]);
    ylim([0 maxmax]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

    if i == 1
        ylabel('MID1');
    end

end % (for i)




% Plot the MID2 nonlinearities
% ----------------------------------------------------------

pspk{1} = fio.fio_mid2.pspk_mtx(1);
pspk{2} = fio.fio_mid2.pspk_mtx(2);
pspk{3} = fio.fio_mid2.pspk_mtx(3);
pspk{4} = fio.fio_mid2.pspk_mtx(4);
pspk{5} = fio.fio_mid2.pspk_mean;

x2{1} = fio.fio_mid2.x2_mtx(:,1);
x2{2} = fio.fio_mid2.x2_mtx(:,2);
x2{3} = fio.fio_mid2.x2_mtx(:,3);
x2{4} = fio.fio_mid2.x2_mtx(:,4);
x2{5} = fio.fio_mid2.x2_mean;

pspkx2{1} = fio.fio_mid2.pspkx2_mtx(:,1);
pspkx2{2} = fio.fio_mid2.pspkx2_mtx(:,2);
pspkx2{3} = fio.fio_mid2.pspkx2_mtx(:,3);
pspkx2{4} = fio.fio_mid2.pspkx2_mtx(:,4);
pspkx2{5} = fio.fio_mid2.pspkx2_mean;

maxmax = max([max(pspkx2{1}) max(pspkx2{2}) max(pspkx2{3}) max(pspkx2{4}) max(pspkx2{5})]);

for i = 1:5

    subplot(4,5,i+10);
    hold on;
    plot(x2{i}, pspkx2{i}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
    plot([min(x2{i}) max(x2{i})], [pspk{i} pspk{i}], 'k--');
    xlim(1.1*[min(x2{i}) max(x2{i})]);
    ylim([0 maxmax]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

    if i == 1
        ylabel('MID2');
    end

end % (for i)




% Plot the MID12 2D nonlinearities
% ----------------------------------------------------------

nbins = fio.fio_mid12.nbins;

pspk{1} = fio.fio_mid12.pspk_mtx(1);
pspk{2} = fio.fio_mid12.pspk_mtx(2);
pspk{3} = fio.fio_mid12.pspk_mtx(3);
pspk{4} = fio.fio_mid12.pspk_mtx(4);
pspk{5} = fio.fio_mid12.pspk_mean;


x1{1} = fio.fio_mid12.x1_mtx(:,1);
x1{2} = fio.fio_mid12.x1_mtx(:,2);
x1{3} = fio.fio_mid12.x1_mtx(:,3);
x1{4} = fio.fio_mid12.x1_mtx(:,4);
x1{5} = fio.fio_mid12.x1_mean;

x2{1} = fio.fio_mid12.x2_mtx(:,1);
x2{2} = fio.fio_mid12.x2_mtx(:,2);
x2{3} = fio.fio_mid12.x2_mtx(:,3);
x2{4} = fio.fio_mid12.x2_mtx(:,4);
x2{5} = fio.fio_mid12.x2_mean;

pspkx1x2{1} = reshape(fio.fio_mid12.pspkx1x2_mtx(:,1), nbins, nbins) + eps;
pspkx1x2{2} = reshape(fio.fio_mid12.pspkx1x2_mtx(:,2), nbins, nbins) + eps;
pspkx1x2{3} = reshape(fio.fio_mid12.pspkx1x2_mtx(:,3), nbins, nbins) + eps;
pspkx1x2{4} = reshape(fio.fio_mid12.pspkx1x2_mtx(:,4), nbins, nbins) + eps;
pspkx1x2{5} = reshape(fio.fio_mid12.pspkx1x2_mean, nbins, nbins) + eps;


for i = 1:5

    subplot(4,5,i+15);
    mxmx = max(pspkx1x2{i}(:));
    imagesc(x1{i}, x2{i},  log10(pspkx1x2{i}));
    set(gca,'clim', [-3 log10(mxmx)]);
    tickpref;
    axis('xy');
    xlabel('MID1 Proj');
    if i == 1
        ylabel('MID2 Proj');
    end

end % (for i)


suptitle(strrep(iskfile, '_', '-'));

print_mfilename(mfilename);

set(gcf,'position', [450 50 1200 800]);

return;



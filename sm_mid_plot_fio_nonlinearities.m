function sm_mid_plot_fio_nonlinearities(fio)
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



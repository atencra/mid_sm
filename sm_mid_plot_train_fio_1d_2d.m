function sm_mid_plot_train_fio_1d_2d(fio)

iskfile = fio.iskfile;
%nspk = sum(fio.locator);
nspk = 0;
ms = 3;

figure;


% Plot the STA nonlinearities
% ----------------------------------------------------------

xbins = fio.x0bins;
pspk = fio.pspk;
pspkx = fio.pspkx0;
        
maxmax = max([max(pspkx{1}) max(pspkx{2}) max(pspkx{3}) max(pspkx{4}) ]);

for i = 1:4

    subplot(4,4,i);
    hold on;
    plot(xbins{i}, pspkx{i}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
    plot([min(xbins{i}) max(xbins{i})], [pspk{i} pspk{i}], 'k--');
    xlim(1.1*[min(xbins{i}) max(xbins{i})]);
    ylim([0 maxmax]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

    if i == 1
        ylabel('STA');
    end

end % (for i)

clear('xbins', 'pspkx');



% Plot the MID1 nonlinearities
% ----------------------------------------------------------

xbins = fio.x1bins;
pspkx = fio.pspkx1;
        
maxmax = max([max(pspkx{1}) max(pspkx{2}) max(pspkx{3}) max(pspkx{4}) ]);

for i = 1:4
    subplot(4,4,i+4);
    hold on;
    plot(xbins{i}, pspkx{i}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
    plot([min(xbins{i}) max(xbins{i})], [pspk{1} pspk{1}], 'k--');
    xlim(1.1*[min(xbins{i}) max(xbins{i})]);
    ylim([0 maxmax]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    if i == 1
        ylabel('MID1');
    end
end % (for i)

clear('xbins', 'pspkx');




% Plot the nonlinearities
% ----------------------------------------------------------

xbins = fio.x2bins;
pspkx = fio.pspkx2;
        
maxmax = max([max(pspkx{1}) max(pspkx{2}) max(pspkx{3}) max(pspkx{4}) ]);
for i = 1:4
    subplot(4,4,i+8);
    hold on;
    plot(xbins{i}, pspkx{i}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
    plot([min(xbins{i}) max(xbins{i})], [pspk{1} pspk{1}], 'k--');
    xlim(1.1*[min(xbins{i}) max(xbins{i})]);
    ylim([0 maxmax]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    if i == 1
        ylabel('MID2');
    end
end % (for i)

clear('xbins', 'pspkx');



% 2D nonlinearity
%------------------------------


x1binedges = fio.x1binedges;
x2binedges = fio.x2binedges;
pspkx1x2 = fio.pspkx1x2;

for i = 1:4
    subplot(4,4,i+12);
    mxmx = max(pspkx1x2{i}(:));
    imagesc(edge2center(x1binedges{i}), edge2center(x2binedges{i}),  log10(pspkx1x2{i}));
    set(gca,'clim', [-3 log10(mxmx)]);
    set(gca,'tickdir', 'out');
    axis('xy');
    xlabel('MID1 Proj');
    if i == 1
        ylabel('MID2 Proj');
    end
end % (for i)



suptitle(strrep(iskfile, '_', '-'));

print_mfilename(mfilename);


return;


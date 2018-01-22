function mid_plot_train_fio_1d_2d(fio)

iskfile = fio.iskfile;
nspk = sum(fio.locator);
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


%subplot(4,4,2);
%hold on;
%plot(xbins{2}, pspkx{2}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{2}) max(xbins{2})], [pspk{2} pspk{2}], 'k--');
%xlim(1.1*[min(xbins{2}) max(xbins{2})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
%
%
%subplot(4,4,3);
%hold on;
%plot(xbins{3}, pspkx{3}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{3}) max(xbins{3})], [pspk{3} pspk{3}], 'k--');
%xlim(1.1*[min(xbins{3}) max(xbins{3})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
%
%
%subplot(4,4,4);
%hold on;
%plot(xbins{4}, pspkx{4}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{4}) max(xbins{4})], [pspk{4} pspk{4}], 'k--');
%xlim(1.1*[min(xbins{4}) max(xbins{4})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);




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

%subplot(4,4,6);
%hold on;
%plot(xbins{2}, pspkx{2}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{2}) max(xbins{2})], [pspk{2} pspk{2}], 'k--');
%xlim(1.1*[min(xbins{2}) max(xbins{2})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
%
%subplot(4,4,7);
%hold on;
%plot(xbins{3}, pspkx{3}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{3}) max(xbins{3})], [pspk{3} pspk{3}], 'k--');
%xlim(1.1*[min(xbins{3}) max(xbins{3})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
%
%subplot(4,4,8);
%hold on;
%plot(xbins{4}, pspkx{4}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{4}) max(xbins{4})], [pspk{4} pspk{4}], 'k--');
%xlim(1.1*[min(xbins{4}) max(xbins{4})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);

%if (  ~isempty(titlestr) )
%   suptitle(titlestr);
%end
%
%set(gcf, 'position', [293 267 1095 571]);




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


%subplot(4,4,10);
%hold on;
%plot(xbins{2}, pspkx{2}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{2}) max(xbins{2})], [pspk{2} pspk{2}], 'k--');
%xlim(1.1*[min(xbins{2}) max(xbins{2})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
%
%subplot(4,4,11);
%hold on;
%plot(xbins{3}, pspkx{3}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{3}) max(xbins{3})], [pspk{3} pspk{3}], 'k--');
%xlim(1.1*[min(xbins{3}) max(xbins{3})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
%
%subplot(4,4,12);
%hold on;
%plot(xbins{4}, pspkx{4}, 'ko-', 'markerfacecolor', 'k', 'markersize', ms);
%plot([min(xbins{4}) max(xbins{4})], [pspk{4} pspk{4}], 'k--');
%xlim(1.1*[min(xbins{4}) max(xbins{4})]);
%ylim([0 maxmax]);
%set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);



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


%subplot(4,4,14);
%mxmx = max(pspkx1x2{2}(:));
%imagesc(edge2center(x1binedges{2}), edge2center(x2binedges{2}),  log10(pspkx1x2{2}));
%set(gca,'clim', [-3 log10(mxmx)]);
%set(gca,'tickdir', 'out');
%axis('xy');
%xlabel('MID1 Proj');
%
%
%subplot(4,4,15);
%mxmx = max(pspkx1x2{3}(:));
%imagesc(edge2center(x1binedges{3}), edge2center(x2binedges{3}),  log10(pspkx1x2{3}));
%set(gca,'clim', [-3 log10(mxmx)]);
%set(gca,'tickdir', 'out');
%axis('xy');
%xlabel('MID1 Proj');
%
%
%
%subplot(4,4,16);
%mxmx = max(pspkx1x2{4}(:));
%imagesc(edge2center(x1binedges{4}), edge2center(x2binedges{4}),  log10(pspkx1x2{3}));
%set(gca,'clim', [-3 log10(mxmx)]);
%set(gca,'tickdir', 'out');
%axis('xy');
%xlabel('MID1 Proj');



%
%hc = colorbar('EastOutside');
%
%set(hc,'ytick', [log10(0.001) log10(mxmx)], ...
%       'yticklabel', [0.001 roundsd(mxmx,3)], ...
%       'Position', [0.5 0.11 0.02 0.15], 'tickdir', 'out');
%
%

suptitle(strrep(iskfile, '_', '-'));

print_mfilename(mfilename);


return;


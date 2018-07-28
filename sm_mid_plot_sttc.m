function sm_mid_plot_sttc(data)
%
% sm_mid_plot_sttc(sttc_info) Plot STA/MIDs from STTC_Info data struct
%

repfile = data.repfile;
longfile = data.longfile;
sprfile = data.sprfile;

nf_filter = data.nf_filter;
nt_filter = data.nt_filter;


sta_filt = data.filter_mean_sta;
sta_fio_x = data.sta_xbins;
sta_fio_ior = data.sta_fio;

pspk = data.pspk;

mid1_filt = data.filter_mean_test2_v1;
mid1_fio_x = data.mid1_xbins;
mid1_fio_ior = data.mid1_fio;

mid2_filt = data.filter_mean_test2_v2;
mid2_fio_x = data.mid2_xbins;
mid2_fio_ior = data.mid2_fio;


hf = figure;
set(hf,'position', [680 300 500 400]);
orient portrait;
orient tall;


subplot(2,3,1);
imagesc(sta_filt);
tickpref;
%title(sprintf('STA; nspk=%.0f, ndim=%.0f, nspk/ndim=%.2f', ...
%    nspk, nf_filter*nt_filter, nspk / (nf_filter*nt_filter)));
title(sprintf('STA'));
ylabel('Frequency (kHz)');
minmin = min(min(sta_filt));
maxmax = max(max(sta_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
xtick = [1 size(sta_filt,2)];
set(gca,'xtick', xtick, 'xticklabel', xtick);
ytick = [1 size(sta_filt,1)];
set(gca,'ytick', ytick, 'yticklabel', ytick);


ms = 3;
lw = 1;

subplot(2,3,4);
hold on;
x = sta_fio_x;
fx = sta_fio_ior; 

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
    plot(x,fx,'ko-','markerfacecolor','k','markersize',ms,'linewidth',lw);
    xlim([1.1*min(x) 1.1*max(x)]);
    if ~isempty(pspk)
        plot(xlim, [pspk pspk], 'k--');
    end
    ymax = max(fx);
    ymax = ceil(ymax*10) / 10;
    ytick = [0 ymax/2 ymax];
    set(gca,'ytick', ytick, 'yticklabel', ytick);
    ylim([0 1.1*max(ytick)]);
    tickpref;
    ylabel('Spike Probability');
    xtick = [round(min(x)) 0 round(max(x))];
    set(gca,'xtick', xtick, 'xticklabel', xtick);
end


   

subplot(2,3,2);
imagesc(mid1_filt);
tickpref;
title('MID1');
minmin = min(min(mid1_filt));
maxmax = max(max(mid1_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
xtick = [1 size(mid1_filt,2)];
set(gca,'xtick', xtick, 'xticklabel', xtick);
ytick = [1 size(mid1_filt,1)];
set(gca,'ytick', ytick, 'yticklabel', ytick);
xlabel('Time (ms)');


subplot(2,3,5);
hold on;
x = mid1_fio_x;
fx = mid1_fio_ior;

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
    plot(x,fx,'ko-','markerfacecolor','k','markersize',ms,'linewidth',lw);
    xlim([1.1*min(x) 1.1*max(x)]);
    if ~isempty(pspk)
        plot(xlim, [pspk pspk], 'k--');
    end
    ymax = max(fx);
    ymax = ceil(ymax*10) / 10;
    ytick = [0 ymax/2 ymax];
    set(gca,'ytick', ytick, 'yticklabel', ytick);
    ylim([0 1.1*max(ytick)]);
    tickpref;
    xtick = [round(min(x)) 0 round(max(x))];
    set(gca,'xtick', xtick, 'xticklabel', xtick);
    xlabel('Projection (ms)');
end



subplot(2,3,3);
imagesc(mid2_filt);
tickpref;
title('MID2');
minmin = min(min(mid2_filt));
maxmax = max(max(mid2_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
xtick = [1 size(mid2_filt,2)];
set(gca,'xtick', xtick, 'xticklabel', xtick);
ytick = [1 size(mid2_filt,1)];
set(gca,'ytick', ytick, 'yticklabel', ytick);


subplot(2,3,6);
hold on;
x = mid2_fio_x;
fx = mid2_fio_ior; 

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
    plot(x,fx,'ko-','markerfacecolor','k','markersize',ms,'linewidth',lw);
    xlim([1.1*min(x) 1.1*max(x)]);
    if ~isempty(pspk)
        plot(xlim, [pspk pspk], 'k--');
    end
    ymax = max(fx);
    ymax = ceil(ymax*10) / 10;
    ytick = [0 ymax/2 ymax];
    set(gca,'ytick', ytick, 'yticklabel', ytick);
    ylim([0 1.1*max(ytick)]);
    tickpref;
    xtick = [round(min(x)) 0 round(max(x))];
    set(gca,'xtick', xtick, 'xticklabel', xtick);
end



return;


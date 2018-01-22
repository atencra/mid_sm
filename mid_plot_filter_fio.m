function mid_plot_filter_fio(data)
%mid_plot_filter_fio Disply MID Filters/Nonlinearities
%    
%    mid_plot_filter_fio(data) plots the filters and nonlinearities stored
%    in the struct 'data'. data is stored in files having the form *-filter-fio.mat
%    and is obtained with mid_dir_file_struct_to_filters.m
%




iskfile = data.iskfile;
nspk = sum(data.locator);
nf_filter = data.nf_filter;
nt_filter = data.nt_filter;


sta_filt = data.filter_mean_sta;
sta_fio_x = data.fio_sta.x_mean;
sta_fio_ior = data.fio_sta.ior_mean;
sta_fio_ior_std = data.fio_sta.ior_std;

pspk = data.fio_sta.pspk_mean;
if isempty(pspk)
    pspk = 0;
end

mid1_filt = data.filter_mean_test2_v1;
mid1_fio_x = data.fio_mid1.x1_mean;
mid1_fio_ior = data.fio_mid1.pspkx1_mean;
mid1_fio_ior_std = data.fio_mid1.pspkx1_std;


mid2_filt = data.filter_mean_test2_v2;
mid2_fio_x = data.fio_mid2.x2_mean;
mid2_fio_ior = data.fio_mid2.pspkx2_mean;
mid2_fio_ior_std = data.fio_mid2.pspkx2_std;


xfio0 = sta_fio_x(2:end-1);
fio0 = sta_fio_ior(2:end-1);
xfio1 = mid1_fio_x(2:end-1);
fio1 = mid1_fio_ior(2:end-1);
xfio2 = mid2_fio_x(2:end-1);
fio2 = mid2_fio_ior(2:end-1);

mxmx = max([abs(xfio0(:)); abs(xfio1(:)); abs(xfio2(:))]);

mxmx_prob = max([abs(fio0(:)); abs(fio1(:)); abs(fio2(:))]);


subplot(3,2,1);
imagesc(sta_filt);
cmap = brewmaps('rdbu', 21);
cmap = cmap([1:9 11 13:end],:); % get more contrast in STRF
colormap(cmap);
boundary = max(abs(sta_filt(:)));
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
tickpref;
title(sprintf('STA; nspk=%.0f, ndim=%.0f, nspk/ndim=%.2f', ...
    nspk, nf_filter*nt_filter, nspk / (nf_filter*nt_filter)));

subplot(3,2,2);
hold on;
plot(sta_fio_x(2:end-1), 200*sta_fio_ior(2:end-1), 'ko-', 'markerfacecolor', 'k');
%xlim([1.1*min(sta_fio_x) 1.1*max(sta_fio_x)]);
xlim([-mxmx mxmx]);
%ylim([0 1.1*max(sta_fio_ior)]);
ylim([0 200*mxmx_prob]);
plot(xlim, 200*[pspk pspk], 'k--');
tickpref;
title('STA Nonlinearity');
    

subplot(3,2,3);
imagesc(mid1_filt);
cmap = brewmaps('rdbu', 21);
cmap = cmap([1:9 11 13:end],:); % get more contrast in STRF
colormap(cmap);
boundary = max(abs(mid1_filt(:)));
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
tickpref;
title('MID1');

subplot(3,2,4);
hold on;
plot(mid1_fio_x(2:end-1), 200*mid1_fio_ior(2:end-1), 'ko-', 'markerfacecolor', 'k');
%xlim([1.1*min(mid1_fio_x) 1.1*max(mid1_fio_x)]);
xlim([-mxmx mxmx]);
%ylim([0 1.1*max(mid1_fio_ior)]);
ylim([0 200*mxmx_prob]);
plot(xlim, 200*[pspk pspk], 'k--');
tickpref;
title('MID1 Nonlinearity');


subplot(3,2,5);
imagesc(mid2_filt);
cmap = brewmaps('rdbu', 21);
cmap = cmap([1:9 11 13:end],:); % get more contrast in STRF
colormap(cmap);
boundary = max(abs(mid2_filt(:)));
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
tickpref;
title('MID2');

subplot(3,2,6);
hold on;
plot(mid2_fio_x(2:end-1), 200*mid2_fio_ior(2:end-1), 'ko-', 'markerfacecolor', 'k');
%xlim([1.1*min(mid2_fio_x) 1.1*max(mid2_fio_x)]);
%ylim([0 1.1*max(mid2_fio_ior)]);
xlim([-mxmx mxmx]);
ylim([0 200*mxmx_prob]);
plot(xlim, 200*[pspk pspk], 'k--');
tickpref;
title('MID2 Nonlinearity');

suptitle(strrep(iskfile, '_', '-'));

ss = get(0,'screensize');
set(gcf,'position', [ss(3)-1.05*560 ss(4)-1.2*720 460 720]);

print_mfilename(mfilename);

orient tall;

return;






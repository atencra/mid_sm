function sm_mid_dir_plot_filter_fio2d(varargin)
% sm_mid_dir_plot_filter_fio2d Plot MID filters and 1D/2D nonlinearities
%
%    sm_mid_dir_plot_filter_fio2d(keyword, value, ...)
% 
%    sm_mid_dir_pdf_plot_filter_fio2d goes through the current directory 
%    and searches for *-filter-fio.mat files.
%       
%    It then plots the filters and nonlineaities within the folder.
%
%    sm_mid_dir_plot_filter_fio2d accepts keyword/value arguments.
%
%       keyword         value
%       ==============================================================
%       'savepdf'       Default = 0. If 1, then the figures are saved.
%
%       'batch'         Default = 0. If 1, then the function is assumed
%                       to be run outside of data folders.
%
%       'process'       Overwrite existing files? Default = 0 = NO. 
%                       Set to 1 to overwrite files with the same name.
%
%       Note: ghostscript is required and thus must be installed.
%
%    Default assumed location is 
%       gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%    

library('export_fig');

graphics_toolkit('qt');


narginchk(0,4);

options = struct('savepdf', 0, 'batch', 0, 'process', 0);

options = input_options(options, varargin);


figpath = '.';
gsdir = 'C:\Program Files\gs\gs9.20\bin';
gsfile = 'gswin64c.exe';
gspath = fullfile(gsdir, gsfile);


if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    dfilters = dir(fullfile('.', '*-filter-fio.mat'));

    if ~isempty(dfilters)

        matfiles = {dfilters.name};

        pdf_file_total = {};

        for i = 1:length(matfiles)
           
            fprintf('\nPlotting %s\n', matfiles{i});

            [pathstr, name, ext] = fileparts(matfiles{i});
            
            eps_file = fullfile(figpath, sprintf('%s2d.eps',name));
            pdf_file = fullfile(figpath, sprintf('%s2d.pdf',name));

            if ( exist(eps_file) && exist(pdf_file) && ~options.process ) 
                continue;
            end 
           
            load(matfiles{i}, 'data');
            
            mid_plot_filter_fio(data);
            colormap jet;
            orient tall;
            
            clear('data');
           
            if ( options.savepdf )
                fig2eps(eps_file);
                pause(0.5);
                crop = 0;
                append = 0;
                gray = 0;
                quality = 1000;
                eps2pdf(eps_file, pdf_file, crop, append, gray, quality);
                pause(0.5);
                pause(0.5)
                close all;
                fprintf('Figure saved in: %s\n\n', pdf_file);
            else
                pause;
            end

        end % (for i)
    else

        fprintf('No *-filter-fio.mat files in %s\n', folders{ii});

    end % ( ~isempty )

    cd(startdir)

end % (for ii)

return;




%     if ( savepdf )
%         pdf_file_combined = sprintf('mid_filter_fio12.pdf');
%         pdf_file_combined = fullfile(figpath, pdf_file_combined);
%         for n = 1:length(pdf_file_total)
%             append_pdfs(pdf_file_combined, pdf_file_total{n}); 
%         end
%     end



function mid_plot_filter_fio(data)

iskfile = data.iskfile;
nspk = sum(data.locator);
nf_filter = data.nf_filter;
nt_filter = data.nt_filter;


sta_filt = data.filter_mean_sta;
sta_fio_x = data.fio_sta.x_mean;
sta_fio_ior = data.fio_sta.ior_mean;
sta_fio_ior_std = data.fio_sta.ior_std;

pspk = data.fio_sta.pspk_mean;

mid1_filt = data.filter_mean_test2_v1;
mid1_fio_x = data.fio_mid1.x1_mean;
mid1_fio_ior = data.fio_mid1.pspkx1_mean;
mid1_fio_ior_std = data.fio_mid1.pspkx1_std;


mid2_filt = data.filter_mean_test2_v2;
mid2_fio_x = data.fio_mid2.x2_mean;
mid2_fio_ior = data.fio_mid2.pspkx2_mean;
mid2_fio_ior_std = data.fio_mid2.pspkx2_std;

mid12_fio_x1 = data.fio_mid12.x1_mean;
mid12_fio_x2 = data.fio_mid12.x2_mean;
mid12_fio_ior = data.fio_mid12.pspkx1x2_mean;
mid12_fio_ior_std = data.fio_mid12.pspkx1x2_std;



hf = figure;
set(hf,'position', [680 300 500 400]);
orient portrait;
orient tall;


subplot(3,3,1);
imagesc(sta_filt);
tickpref;
%title(sprintf('STA; nspk=%.0f, ndim=%.0f, nspk/ndim=%.2f', ...
%    nspk, nf_filter*nt_filter, nspk / (nf_filter*nt_filter)));
title(sprintf('STA; nspk=%.0f', nspk));
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

subplot(3,3,4);
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


   

subplot(3,3,2);
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


subplot(3,3,5);
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



subplot(3,3,3);
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


subplot(3,3,6);
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



% 2D nonlinearity
%------------------------------

mid12_fio_x1 = data.fio_mid12.x1_mean;
mid12_fio_x2 = data.fio_mid12.x2_mean;
mid12_fio_ior = data.fio_mid12.pspkx1x2_mean;
mid12_fio_ior_std = data.fio_mid12.pspkx1x2_std;

subplot(3,3,8);
pspkx1x2 =  mid12_fio_ior + 0.001;
mxmx = max(pspkx1x2(:));
imagesc(mid12_fio_x1, mid12_fio_x2,  log10(pspkx1x2));
set(gca,'clim', [-3 log10(mxmx)]);
tickpref;

xlabel('MID1 Projection (SD)');
ylabel('MID2 Projection (SD)');

axis('xy');
hc = colorbar('EastOutside');

%set(hc,'ytick', [-3 -2 -1 0], 'yticklabel', [0.001 0.01 0.1 1], ...
%       'Position', [0.5 0.11 0.02 0.15], 'tickdir', 'out');


set(hc,'ytick', [log10(0.001) log10(mxmx)], ...
       'yticklabel', [0.001 roundsd(mxmx,3)], ...
       'Position', [0.5 0.11 0.02 0.15], 'tickdir', 'out');



suptitle(strrep(iskfile, '_', '-'));

%ss = get(0,'screensize');
%set(gcf,'position', [ss(3)-1.05*560 ss(4)-1.2*720 560 720]);

print_mfilename(mfilename);

return;




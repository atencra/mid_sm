function mid_dir_plot_filter_fio2d(datapath, savepdf, batch)
%mid_dir_plot_filter_fio2d
%
%    mid_dir_plot_filter_fio2d(datapath, savepdf, batch)
% 
%    mid_dir_pdf_plot_filter_fio2d(datapath, savepdf, batch) goes through 
%    the folder datapath and searches for *-filter-fio.mat files.
%    It then plots the filters and nonlineaities within the folder,
%    converts the figures to pdf files, and saves the pdfs in the
%    folder figpath.
%
%    datapath : folder holding *-filter-fio.mat files. The files
%    hold filters and nonlinearities for single neurons.
%    Default = '.'
% 
%    savepdf : Save figures to pdf files? savepdf = 1 = yes. Default = no.
%
%    gspath : complete path to Ghostscript executable. Default is
%        gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%    This input is generally not needed, since the default has been 
%    set during ghostscript installation.
%    

library('export_fig');

narginchk(0,3);


if nargin == 0
    datapath = '.';
    savepdf = 0;
    batch = 0;
end

if nargin == 1
    savepdf = 0;
    batch = 0;
end

if nargin == 2
    batch = 0;
end


if isempty(datapath)
    datapath = '.';
end

if isempty(savepdf)
    savepdf = 0;
end

if isempty(batch)
    batch = 0;
end



figpath = '.';
gsdir = 'C:\Program Files\gs\gs9.20\bin';
gsfile = 'gswin64c.exe';
gspath = fullfile(gsdir, gsfile);


if ( batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    dfilters = dir(fullfile(datapath, '*-filter-fio.mat'));
    if isempty(dfilters)
        %fprintf('\nNo *-filter-fio.mat files in %s.\n\n', folders{ii});
    end

    matfiles = {dfilters.name};

    pdf_file_total = {};

    for i = 1:length(matfiles)
       
        fprintf('\nPlotting %s\n', matfiles{i});

        [pathstr, name, ext] = fileparts(matfiles{i});
        
        eps_file = fullfile(figpath, sprintf('%s.eps',name));
        pdf_file = fullfile(figpath, sprintf('%s12.pdf',name));
       
        pdf_file_total{length(pdf_file_total)+1} = pdf_file;

        load(matfiles{i}, 'data');
        
        if ( 1 ) %~exist(pdf_file,'file') )
            
            mid_plot_filter_fio(data);
            colormap jet;
            orient tall;
            
            clear('data');
           
            if ( savepdf ) 
                fig2eps(eps_file);
                pause(0.5);
                %eps2pdf1(eps_file, gspath);
                crop = 1;
                append = 0;
                gray = 0;
                quality = 1000;
                eps2pdf(eps_file, pdf_file, crop, append, gray, quality);
                pause(0.5);
                %delete(eps_file);
                pause(0.5)
                close all;
                fprintf('Figure saved in: %s\n\n', pdf_file);
            end

        else
            %fprintf('Figure already saved in: %s\n\n', pdf_file);
            mid_plot_filter_fio(data);
            orient portrait;
            orient tall;
        end
        
    end % (for i)

    if ( savepdf )
        pdf_file_combined = sprintf('mid_filter_fio12.pdf');
        pdf_file_combined = fullfile(figpath, pdf_file_combined);
        for n = 1:length(pdf_file_total)
            append_pdfs(pdf_file_combined, pdf_file_total{n}); 
        end
    end

    cd(startdir)

end % (for ii)

return;





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
set(hf,'position', [680 100 560 800]);
orient portrait;
orient tall;


subplot(4,2,1);
imagesc(sta_filt);
tickpref;
title(sprintf('STA; nspk=%.0f, ndim=%.0f, nspk/ndim=%.2f', ...
    nspk, nf_filter*nt_filter, nspk / (nf_filter*nt_filter)));
minmin = min(min(sta_filt));
maxmax = max(max(sta_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);



subplot(4,2,2);
hold on;
plot(sta_fio_x, sta_fio_ior, 'ko-', 'markerfacecolor', 'k');
xlim([1.1*min(sta_fio_x) 1.1*max(sta_fio_x)]);
ylim([0 1.1*max(sta_fio_ior)]);
plot(xlim, [pspk pspk], 'k--');
tickpref;
title('STA Nonlinearity');


   

subplot(4,2,3);
imagesc(mid1_filt);
tickpref;
title('MID1');
minmin = min(min(mid1_filt));
maxmax = max(max(mid1_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);


subplot(4,2,4);
hold on;
plot(mid1_fio_x, mid1_fio_ior, 'ko-', 'markerfacecolor', 'k');
xlim([1.1*min(mid1_fio_x) 1.1*max(mid1_fio_x)]);
ylim([0 1.1*max(mid1_fio_ior)]);
plot(xlim, [pspk pspk], 'k--');
tickpref;
title('MID1 Nonlinearity');


subplot(4,2,5);
imagesc(mid2_filt);
tickpref;
title('MID2');
minmin = min(min(mid2_filt));
maxmax = max(max(mid2_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);


subplot(4,2,6);
hold on;
plot(mid2_fio_x, mid2_fio_ior, 'ko-', 'markerfacecolor', 'k');
xlim([1.1*min(mid2_fio_x) 1.1*max(mid2_fio_x)]);
ylim([0 1.1*max(mid2_fio_ior)]);
plot(xlim, [pspk pspk], 'k--');
tickpref;
title('MID2 Nonlinearity');



% 2D nonlinearity
%------------------------------

mid12_fio_x1 = data.fio_mid12.x1_mean;
mid12_fio_x2 = data.fio_mid12.x2_mean;
mid12_fio_ior = data.fio_mid12.pspkx1x2_mean;
mid12_fio_ior_std = data.fio_mid12.pspkx1x2_std;

subplot(4,2,7);
pspkx1x2 =  mid12_fio_ior + 0.001;
mxmx = max(pspkx1x2(:));
imagesc(mid12_fio_x2, mid12_fio_x2,  log10(pspkx1x2));
set(gca,'clim', [-3 log10(mxmx)]);
set(gca,'tickdir', 'out');

xlabel('MID1 Proj');
ylabel('MID2 Proj');

axis('xy');
hc = colorbar('EastOutside');

%set(hc,'ytick', [-3 -2 -1 0], 'yticklabel', [0.001 0.01 0.1 1], ...
%       'Position', [0.5 0.11 0.02 0.15], 'tickdir', 'out');


set(hc,'ytick', [log10(0.001) log10(mxmx)], ...
       'yticklabel', [0.001 roundsd(mxmx,3)], ...
       'Position', [0.5 0.11 0.02 0.15], 'tickdir', 'out');

title('P(spike|x1,x2)');



suptitle(strrep(iskfile, '_', '-'));

%ss = get(0,'screensize');
%set(gcf,'position', [ss(3)-1.05*560 ss(4)-1.2*720 560 720]);

print_mfilename(mfilename);

return;




function mid_dir_plot_filter_fio1d(datapath)
% mid_dir_plot_filter_fio1d Plot MID filters and 1D nonlinearities
%
%    mid_dir_plot_filter_fio1d(keyword, value, ...)
% 
%    mid_dir_pdf_plot_filter_fio1d goes through the current directory 
%    and searches for *-filter-fio.mat files.
%       
%    It then plots the filters and nonlineaities within the folder.
%
%    mid_dir_plot_filter_fio1d accepts keyword/value arguments.
%
%       keyword         value
%       'savepdf'       Default = 0. If 1, then the figures are saved.
%
%       'batch'         Default = 0. If 1, then the function is assumed
%                       to be run outside of data folders.
%
%       Note: ghostscript is required and thus must be installed.
%
%    Default assumed location is 
%       gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%    


library('export_fig');


narginchk(0,4);

options = struct('savepdf', 0, 'batch', 0);

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

        for i = 1:length(matfiles)
           
            fprintf('\nPlotting %s\n', matfiles{i});

            [pathstr, name, ext] = fileparts(matfiles{i});
            
            eps_file = fullfile(figpath, sprintf('%s1d.eps',name));
            pdf_file = fullfile(figpath, sprintf('%s1d.pdf',name));
           
            load(matfiles{i}, 'data');
            
            mid_plot_filter_fio(data);
            colormap jet;
            orient tall;
            
            clear('data');


            if ( options.savepdf ) 
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

        end % (for i)

    else

        fprintf('No *-filter-fio.mat files in %s\n', folders{ii});

    end % ( ~isempty )

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



subplot(3,2,1);
imagesc(sta_filt);
tickpref;
title(sprintf('STA; nspk=%.0f, ndim=%.0f, nspk/ndim=%.2f', ...
    nspk, nf_filter*nt_filter, nspk / (nf_filter*nt_filter)));

subplot(3,2,2);
hold on;
plot(sta_fio_x, sta_fio_ior, 'ko-', 'markerfacecolor', 'k');
xlim([1.1*min(sta_fio_x) 1.1*max(sta_fio_x)]);
ylim([0 1.1*max(sta_fio_ior)]);
plot(xlim, [pspk pspk], 'k--');
tickpref;
title('STA Nonlinearity');
    

subplot(3,2,3);
imagesc(mid1_filt);
tickpref;
title('MID1');

subplot(3,2,4);
hold on;
plot(mid1_fio_x, mid1_fio_ior, 'ko-', 'markerfacecolor', 'k');
xlim([1.1*min(mid1_fio_x) 1.1*max(mid1_fio_x)]);
ylim([0 1.1*max(mid1_fio_ior)]);
plot(xlim, [pspk pspk], 'k--');
tickpref;
title('MID1 Nonlinearity');


subplot(3,2,5);
imagesc(mid2_filt);
tickpref;
title('MID2');

subplot(3,2,6);
hold on;
plot(mid2_fio_x, mid2_fio_ior, 'ko-', 'markerfacecolor', 'k');
xlim([1.1*min(mid2_fio_x) 1.1*max(mid2_fio_x)]);
ylim([0 1.1*max(mid2_fio_ior)]);
plot(xlim, [pspk pspk], 'k--');
tickpref;
title('MID2 Nonlinearity');

suptitle(iskfile);

ss = get(0,'screensize');
set(gcf,'position', [ss(3)-1.05*560 ss(4)-1.2*720 560 720]);

print_mfilename(mfilename);

return;






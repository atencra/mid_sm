function mid_dir_plot_filter_fio(datapath)
%mid_dir_plot_filter_fio
%
%    mid_dir_plot_filter_fio(datapath, figpath, gspath)
% 
%    mid_dir_pdf_plot_filter_fio(datapath, figpath) goes through 
%    the folder datapath and searches for *-filter-fio.mat files.
%    It then plots the filters and nonlineaities within the folder,
%    converts the figures to pdf files, and saves the pdfs in the
%    folder figpath.
%
%    datapath : folder holding *-filter-fio.mat files. The files
%    hold filters and nonlinearities for single neurons.
%    Default = '.'
% 
%    figpath : where you want the figures saved. Default is '."
%
%    gspath : complete path to Ghostscript executable. Default is
%        gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%    This input is generally not needed, since the default has been 
%    set during ghostscript installation.
%    


library('export_fig');



narginchk(0,3);

if ( nargin == 0 ) 
    datapath = '.';
    figpath = '.';
    %gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe'%;
    gsdir = 'C:\Program Files\gs\gs9.20\bin';
    gsfile = 'gswin64c.exe';
    gspath = fullfile(gsdir, gsfile);
end

if ( nargin == 1 ) 
    if ( isempty(datapath) )
        datapath = '.';
    end
    figpath = '.';
    %gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
    gsdir = 'C:\Program Files\gs\gs9.20\bin';
    gsfile = 'gswin64c.exe';
    gspath = fullfile(gsdir, gsfile);
end

if ( nargin == 2 ) 
    if ( isempty(datapath) )
        datapath = '.';
    end
    if ( isempty(figpath) )
        figpath = '.';
    end
    %gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
    gsdir = 'C:\Program Files\gs\gs9.20\bin';
    gsfile = 'gswin64c.exe';
    gspath = fullfile(gsdir, gsfile);
end

if ( nargin == 3 ) 
    if ( isempty(datapath) )
        datapath = '.';
    end
    if ( isempty(figpath) )
        figpath = '.';
    end
    if ( isempty(gspath) )
        %gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
        gsdir = 'C:\Program Files\gs\gs9.20\bin';
        gsfile = 'gswin64c.exe';
        gspath = fullfile(gsdir, gsfile);
    end
end


startdir = pwd;

dfilters = dir(fullfile(datapath, '*-filter-fio.mat'));
if isempty(dfilters)
    error('No *-filter-fio.mat files in datapath.');
end

matfiles = {dfilters.name};


% Get experiment and site files so we can save data by
% electrode penetrations.
exp_site = {};

for i = 1:length(matfiles)

    file = matfiles{i};
    index = findstr(file, '_');
    exp_site{length(exp_site)+1} = file(1:(index(2)-1));
end % (for i) 

exp_site = unique(exp_site);



pdf_file_units = {};

for i = 1:length(matfiles)
   
    fprintf('\nPlotting %s\n', matfiles{i});

    [pathstr, name, ext] = fileparts(matfiles{i});
    
    eps_file = fullfile(figpath, sprintf('%s.eps',name));
    pdf_file = fullfile(figpath, sprintf('%s.pdf',name));
   
    pdf_file_units{length(pdf_file_units)+1} = pdf_file;
    
%    if ( ~exist(pdf_file,'file') )
        
        load(matfiles{i}, 'data');
        
        mid_plot_filter_fio(data);
        
        clear('data');
        
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
%    else
%        fprintf('Figure already saved in: %s\n\n', pdf_file);
%    end
    
end % (for i)


pdf_file_site = sprintf('mid_filter_fio.pdf');
pdf_file_site = fullfile(figpath, pdf_file_site);
if exist(pdf_file_site, 'file')
    delete(pdf_file_site);
end

for j = 1:length(pdf_file_units)
    file = pdf_file_units{j};
    fprintf('Appending %s\n', file);
    append_pdfs(pdf_file_site, file);
end % (for j)

%
%d = dir(pdf_file_dir);
%if isempty(d)
%    append_pdfs(pdf_file_dir, pdf_file_total); 
%end
%
%
%for i = 1:length(exp_site)
%    exp_site_files = sprintf('%s_*-filter-fio.pdf', exp_site{i});
%    d = dir(fullfile(figpath, exp_site_files));
%    exp_site_files = {d.name};
%
%    for j = 1:length(exp_site_files)
%        exp_site_files{j} = fullfile(figpath, exp_site_files{j});
%        fprintf('Appending %s\n', exp_site_files{j});
%    end % (for j)
%
%    exp_site_group_pdf_file = fullfile(figpath, sprintf('%s-filter-fio.pdf', exp_site{i}));
%    append_pdfs(exp_site_group_pdf_file, exp_site_files);
%
%end % (for i)


return;



%function mid_plot_filter_fio(data)
%
%iskfile = data.iskfile;
%nspk = sum(data.locator);
%nf_filter = data.nf_filter;
%nt_filter = data.nt_filter;
%
%
%sta_filt = data.filter_mean_sta;
%sta_fio_x = data.fio_sta.x_mean;
%sta_fio_ior = data.fio_sta.ior_mean;
%sta_fio_ior_std = data.fio_sta.ior_std;
%
%pspk = data.fio_sta.pspk_mean;
%
%mid1_filt = data.filter_mean_test2_v1;
%mid1_fio_x = data.fio_mid1.x1_mean;
%mid1_fio_ior = data.fio_mid1.pspkx1_mean;
%mid1_fio_ior_std = data.fio_mid1.pspkx1_std;
%
%
%mid2_filt = data.filter_mean_test2_v2;
%mid2_fio_x = data.fio_mid2.x2_mean;
%mid2_fio_ior = data.fio_mid2.pspkx2_mean;
%mid2_fio_ior_std = data.fio_mid2.pspkx2_std;
%
%
%
%subplot(3,2,1);
%imagesc(sta_filt);
%tickpref;
%title(sprintf('STA; nspk=%.0f, ndim=%.0f, nspk/ndim=%.2f', ...
%    nspk, nf_filter*nt_filter, nspk / (nf_filter*nt_filter)));
%
%subplot(3,2,2);
%hold on;
%plot(sta_fio_x, sta_fio_ior, 'ko-', 'markerfacecolor', 'k');
%xlim([1.1*min(sta_fio_x) 1.1*max(sta_fio_x)]);
%ylim([0 1.1*max(sta_fio_ior)]);
%plot(xlim, [pspk pspk], 'k--');
%tickpref;
%title('STA Nonlinearity');
%    
%
%subplot(3,2,3);
%imagesc(mid1_filt);
%tickpref;
%title('MID1');
%
%subplot(3,2,4);
%hold on;
%plot(mid1_fio_x, mid1_fio_ior, 'ko-', 'markerfacecolor', 'k');
%xlim([1.1*min(mid1_fio_x) 1.1*max(mid1_fio_x)]);
%ylim([0 1.1*max(mid1_fio_ior)]);
%plot(xlim, [pspk pspk], 'k--');
%tickpref;
%title('MID1 Nonlinearity');
%
%
%subplot(3,2,5);
%imagesc(mid2_filt);
%tickpref;
%title('MID2');
%
%subplot(3,2,6);
%hold on;
%plot(mid2_fio_x, mid2_fio_ior, 'ko-', 'markerfacecolor', 'k');
%xlim([1.1*min(mid2_fio_x) 1.1*max(mid2_fio_x)]);
%ylim([0 1.1*max(mid2_fio_ior)]);
%plot(xlim, [pspk pspk], 'k--');
%tickpref;
%title('MID2 Nonlinearity');
%
%suptitle(iskfile);
%
%ss = get(0,'screensize');
%set(gcf,'position', [ss(3)-1.05*560 ss(4)-1.2*720 560 720]);
%
%print_mfilename(mfilename);
%
%return;






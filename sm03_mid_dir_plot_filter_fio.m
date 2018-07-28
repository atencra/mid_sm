function mid_dir_plot_filter_fio(datapath)
% mid_dir_plot_filter_fio Plot and save MID filters and nonlinearities
%
%    mid_dir_plot_filter_fio(...
%       'gsdir', folder, 'gsfile', file, 'batch', value, 'process', value, 'savetofile', value)
% 
%    Goes through a folder and searches for *-filter-fio.mat files.
%    It then plots the filters and nonlineaities within the folder.
%
%    Keyword / value input arguments are allowed:
%    
% Keyword       Value
% ------------------------------------------
% process       write data to file. Default = 0. -> do not overwrite already
%               existing files. Set process = 1 if you want to overwrite any 
%               existing file names that have the same names.
%
% batch         batch = 0 if you run this inside a data folder. Set batch = 1
%               to run the program outside the data folders, which will then
%               be entered and processed. Default: batch = 0. 
%
% savetofile    Save plots to eps and pdf files? Default is 0, which is no.
%               To save the figures, set savetofile to 1. To save the figures,
%               Ghostscript is required.
%
% gspath        complete path to folder the Ghostscript executable. 
%               Default: C:\Program Files\gs\gs9.20\bin
%               Only needed/used if savetofile = 1.
%
% gsfile        Ghostscript executable. Default: gswin64c.exe
%               Only needed/used if savetofile = 1.
%
% gspath and gsfile are generally not needed, since the default has been 
%    set during ghostscript installation.

%
% Example:
%   mid_dir_plot_filter_fio('batch', 1, 'process', 1, 'savetofile', 1);


library('export_fig');

narginchk(0,10);

options = struct(...
'gsdir', 'C:\Program Files\gs\gs9.20\bin', ...
'gsfile', 'gswin64c.exe', ...
'savetofile', 0, ...
'batch', 0, ...
'process', 0);

options = input_options(options, varargin);


figpath = '.';
datapath = '.';

if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});


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

        load(matfiles{i}, 'data');
        
        mid_plot_filter_fio(data);

        clear('data');
       
                        
        if ( options.savetofile )

            if ( ~exist(pdf_file,'file') )
                fig2eps(eps_file);
                pause(0.5);
                %eps2pdf1(eps_file, gspath);
                crop = 1;
                append = 0;
                gray = 0;
                quality = 1000;
                eps2pdf(eps_file, pdf_file, crop, append, gray, quality);
                pause(0.5);
                pause(0.5)
                close all;
                fprintf('Figure saved in: %s\n\n', pdf_file);
            else
                fprintf('Figure already saved in: %s\n\n', pdf_file);
            end
        end
        
    end % (for i)

    if ( options.savetofile )
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
    end % (if savetofile)

    cd(outerfolder);

end % (for ii)

return;



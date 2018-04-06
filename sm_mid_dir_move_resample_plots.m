function sm_mid_dir_move_resample_plots(varargin)
% sm_mid_dir_plot_fio_nonlinearity_resample
%
%    sm_mid_dir_plot_fio_nonlinearity_resample(batch)
%
%    sm_mid_dir_plot_fio_nonlinearity_resample (batch) goes through 
%    the folder datapath and searches for *-filter-fio-resample.mat files.
%    These files hold filter and resampled nonlinearity data.
%
%    batch : if 1, then the function assumes it is outside the folders
%       holding the data. It then goes in to each folder, makes plots, and 
%       comes back out. Default = 0. 
% 
%    This function requires that the Ghostscript executable be installed.
%    It is assumed to have the name and path:
%       gsfile = 'gswin64c.exe';
%       gsdir = 'C:\Program Files\gs\gs9.20\bin';
%    



options = struct('batch', 1, 'figdir', 'K:\SM_MIDs\results\figdir');

options = input_options(options, varargin);

batch = options.batch;
figdir = options.figdir;

library('export_fig');


narginchk(0,4);

figpath = '.';
datapath = '.';


if ( batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    dfigs = dir(fullfile(datapath, '*-filter-fio-resample.pdf'));
    if isempty(dfigs)
        fprintf('\nNo *-filter-fio-resample.pdf files in %s.\n\n', folders{ii});
    end

    figfiles = {dfigs.name};


    for i = 1:length(figfiles)
       
        outfile = fullfile(figdir, figfiles{i});

        fprintf('\nCopying %s\n', figfiles{i});

        copyfile(figfiles{i}, outfile, 'f');

    end % (for i)

    cd(startdir)

end % (for ii)


return;

















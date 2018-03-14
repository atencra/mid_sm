function sm_mid_dir_proj_to_fio_resample(varargin)
% sm_mid_dir_proj_to_fio_resample Resample nonlinearities
%
% sm_mid_dir_proj_to_fio_resample(keyword1, value1, ...) 
% ---------------------------------------------------------------------------------
%
% Goes through a directory, load saved projection values, and perform a
% resampling of nonlinearity values.
%
% The nonlinearities are estimated 100 times from the projection values using
% 95% of the data.
%
% These data will later be used to find an overall global nonlinearity that is
% robust to undersampling.
%
%
% Projection values are expected in *-filter-fio-proj.mat files.
% file.
%
% Data are saved in *-filter-fio-resample.mat files.
% 
% Inputs take the form of keyword/value inputs.
%
% Keyword/Value inputs:
%
% batch : if you run the function outside a set of folders that you wish to
%       analyze, set batch = 1 and all folders will be entered and processed.
%       Default: batch = 0 -> look only in the current directory.
%
% process : If *-filter-fio-resample.mat files already exist, then the data is not processed.
%       To overwrite the files and recalculate, set the keyword for process to 1.
%
% Example: sm_mid_dir_proj_to_fio_resample('batch', value1, 'process', value);
%
% Any pair of values may be used or omitted.
% 


narginchk(0,6);

options = struct('batch', 0, 'process', 0);

options = input_options(options, varargin);

infolder = '.';
outfolder = '.';


if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    matfiles = dir(fullfile(infolder, '*-filter-fio-proj.mat'));
    matfiles = {matfiles.name};

    for i = 1:length(matfiles)

        fprintf('\nProcessing %s\n', matfiles{i});

        outfile = fullfile(outfolder, strrep(matfiles{i}, '-proj.mat', '-resample.mat'));
        fprintf('Outfile = %s\n', outfile);

        d = dir(outfile);

        if ( isempty(d) || options.process )

            load(matfiles{i}, 'proj');
            
            [fio] = sm_mid_proj_to_fio_resample(proj);

            save(outfile, 'fio');
            fprintf('Data saved in  %s\n\n', outfile);

            close all;

        else

            fprintf('Data already saved in %s\n\n', outfile);

        end

    end % (for i)

    cd(startdir)

end % (for ii)

return;









function sm_mid_dir_filter_stimulus_locator_to_fio_resample(varargin)
% sm_mid_dir_filter_stimulus_locator_to_fio_resample Resample nonlinearities
%
% sm_mid_dir_filter_stimulus_locator_to_fio_resample(keyword1, value1, ...) 
% ---------------------------------------------------------------------------------
%
% Goes through the current directory specified by 'infolder' and obtains *.mat 
% files holding previously calculated filters from MID analysis. For each file
%
% MID filters/nonlinearities are stored in files of the form: *-filter_fio.mat
%
% Filters are extracted from data files, and the nonlinearity is estimated
% many times to obtain a distribution of nonlinearities. This allows a better
% estimate of the nonlinearity over the range of projection values while
% minimizing the influence of the largest projection values, which are
% subject to large variances due to low sample numbers.
%
% The stimulus that was used is listed as field in the data structure in the
% *-filter-fio.mat file. The stimulus is listed there as a *.spr file. This
% envelope file must be read in as a large matrix, and saved in a *-matrix.mat
% file.
%
% Resulting calculations are saved in a *-proj-info.mat file.
% 
%
% Keyword/Value inputs:
%
% infolder : string indicating location of *-files.mat files.
%
%      Example: C:\Users\craig\OneDrive\Projects\TMP_MID\Data\20140306\Site10
%
% outfolder : string indicating location where filter and nonlinearities
%       should be saved. Data are saved in *-fio-proj-info.mat files.
%       Default = '.'
%
% stimfolder : location of the stimulus .spr and -matrix.mat files.
%       Default = current directory.
%
% batch : if you run the function outside a set of folders that you wish to
%       analyze, set batch = 1 and all folders will be entered and processed.
%       Default: batch = 0 -> look only in the current directory.
%
% process : % If *-fio-proj-info.mat files already exist, then the data is not processed.
%       To overwrite the files and recalculate, set the keyword for process to 1.
%
% 


narginchk(0,6);

options = struct('stimfolder', '.', 'batch', 0, 'process', 0);

options = input_options(options, varargin);

infolder = '.';
outfolder = '.';
stimfolder = options.stimfolder;



if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    matfiles = dir(fullfile(infolder, '*-filter-fio.mat'));
    matfiles = {matfiles.name};

    for i = 1:length(matfiles)

        fprintf('\nProcessing %s\n', matfiles{i});

        outfile = fullfile(outfolder, strrep(matfiles{i}, '.mat', '-resample.mat'));
        fprintf('Outfile = %s\n', outfile);
        fprintf('Paused ...\n');
        pause

        d = dir(outfile);

        if ( isempty(d) || options.process )

            load(matfiles{i}, 'data');
            
            fields = {...
                'filter_mean_best1_v1',...
                'coeff_best1_v1',...
                'projection_best1_v1',...
                'filter_matrix_best1_v1',...
                'filter_mean_best1_v2',...
                'coeff_best1_v2',...
                'projection_best1_v2',...
                'filter_matrix_best1_v2',...
                'filter_mean_test1_v1',...
                'coeff_test1_v1',...
                'projection_test1_v1',...
                'filter_matrix_test1_v1',...
                'filter_mean_test1_v2',...
                'coeff_test1_v2',...
                'projection_test1_v2',...
                'filter_matrix_test1_v2',...
                'filter_mean_best2_v1',...
                'coeff_best2_v1',...
                'projection_best2_v1',...
                'filter_matrix_best2_v1',...
                'filter_mean_best2_v2',...
                'coeff_best2_v2',...
                'projection_best2_v2',...
                'filter_matrix_best2_v2'};

            data = rmfield(data, fields); 

            locator = data.locator;

            sprfile = data.sprfile;

            matrix_file = strrep(sprfile, '.spr', '-matrix.mat');
            matrix_file_path = fullfile(stimfolder, matrix_file);
            load(matrix_file_path, 'stimulus');
        
            [fio] = sm_mid_filter_stimulus_locator_to_fio_resample(data, stimulus, locator);

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









function mid_dir_filter_to_fio_info(varargin)
% mid_dir_filter_to_fio_info Filters/nonlinearities from file names
%
% mid_dir_filter_to_fio_info('infolder', dir1, 'outfolder', dir2, 'stimfolder', dir3)
% -------------------------------------------------------------------------------------------
%
% Goes throught the directory specified by 'infolder' and obtains *.mat 
% files holding previously calculated filters from MID analysis. For each file
%
% MID filters are stored in files of the form: *-filter_fio.mat
%
% The function mid_filter_to_fio_info.m is called, which estimates the 
% nonlinearities and information from the original spike train and
% the ripple stimulus *.spr file.
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
%       should be saved.
%
%      Example: C:\Users\craig\OneDrive\Projects\TMP_MID\Data\20140306\Site10
%
% stimfolder : location of the stimulus .spr and -matrix.mat files.
%
% Defaults for infolder, outfolder, and stimfolder are the current directory.


narginchk(0,6);

options = struct('infolder', '.', 'outfolder', '.', 'stimfolder', '.');

options = input_options(options, varargin);

infolder = options.infolder;
outfolder = options.outfolder;
stimfolder = options.stimfolder;


matfiles = dir(fullfile(infolder, '*-filter-fio.mat'));
matfiles = {matfiles.name};

for i = 1:length(matfiles)

    fprintf('Processing %s\n', matfiles{i});

    outfile = fullfile(outfolder, strrep(matfiles{i}, '.mat', '-proj-info.mat'));

    d = dir(outfile);

    if isempty(d)

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
    
        [fio, projinfo] = mid_filter_to_fio_info(data, stimulus, locator);

        save(outfile, 'fio', 'projinfo');
        fprintf('Data saved in  %s\n\n', outfile);

    else

        fprintf('Data already saved in %s\n\n', outfile);

    end

end % (for i)


return;









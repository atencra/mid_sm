function sm_mid_sm_analysis_procedure
%
% List of steps and functions used to analyze the squirrel monkey MID data
%
% This assumes that the MIDs have been estimated, and that the data is
% saved in folders, with one folder per electrode penetration.
%
% 1. sm01_mid_dir_file_names_to_file_struct;
%   Already run - does not need to be run again.
%
% 2. sm02_mid_dir_file_struct_to_filters;
%   Already run - does not need to be run again.
%
% 3. sm03_mid_dir_file_struct_to_filters;
%   Already run - does not need to be run again.
%
% 4. sm04_mid_dir_plot_filter_fio1d;
%
% 5. sm05_mid_dir_plot_filter_fio2d;
%
% 6. sm06_mid_dir_filter_to_fio_info
%   Already run - does not need to be run again.
%



sm_mid_plot_projinfo(projinfo);

sm_mid_plot_fio_filters_nonlinearities(fio);

sm_mid_plot_projinfo_mid_types(projinfo, fio);



% To resample nonlinearities:


sm_mid_dir_filter_stimulus_locator_to_fio_resample(varargin)

which calls:

    [fio] = mid_filter_stimulus_locator_fio_resample(data, stimulus, locator)


% To plot filters and nonlinearities

sm_mid_dir_plot_filter_fio2d.m


% To estimate nonlinearity parameters:

fioparams = sm_mid_dir_nonlinearity_params.m

    % run in batch mode outside data folders



% To plot nonlinearity parameters:

sm_mid_plot_fioparams.m



% Plot the FRA, filters, nonlinearities, and the raster

sm_dir_plot_fra_sta_mid_raster(varargin)



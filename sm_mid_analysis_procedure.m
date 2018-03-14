function sm_mid_sm_analysis_procedure(varargin)

library('mid_sm');

options = struct('batch', 0);

options = input_options(options, varargin);

stimfolder = 'I:\SM_MIDs\Stimuli';
sprfile = 'dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8.spr';

if ( options.batch )

    d = dir('.');
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];

    outerfolder = pwd;

    for i = 1:length(nameFolds)

        cd(nameFolds{i});

        sm_mid_dir_file_names_to_file_struct('savepath', '.');

        sm_mid_dir_file_struct_to_filters;

        sm_mid_dir_plot_filter_fio;

        sm_mid_dir_plot_filter_fio2d;

        sm_mid_dir_filter_to_fio_info('stimfolder', stimfolder, 'batch', 1);

        cd(outerfolder);

    end

else

    sm_mid_dir_file_names_to_file_struct('savepath', '.');

    sm_mid_dir_file_struct_to_filters;

    sm_mid_dir_plot_filter_fio;

    sm_mid_dir_plot_filter_fio2d;

    sm_mid_dir_filter_to_fio_info('stimfolder', stimfolder);

end


sm_mid_plot_projinfo(projinfo);

sm_mid_plot_fio_filters_nonlinearities(fio);

sm_mid_plot_projinfo_mid_types(projinfo, fio);

return;





% To resample nonlinearities:


sm_mid_dir_filter_stimulus_locator_to_fio_resample(varargin)

which calls:

    [fio] = mid_filter_stimulus_locator_fio_resample(data, stimulus, locator)







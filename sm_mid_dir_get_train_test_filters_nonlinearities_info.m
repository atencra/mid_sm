function [fio, projinfo] = sm_mid_dir_get_train_test_filters_nonlinearities_info(batch)
%mid_dir_get_train_test_filters_nonlinearities_info
%
%    [fio, projinfo] = mid_dir_get_train_test_filters_nonlinearities_info(batch)
% 
%    mid_dir_get_train_test_filters_nonlinearities_info(batch) goes through 
%    the current folder and searches for *-filter-fio-proj-info.mat files.
%    These files hold filter, nonlinearity, and information results for
%    the MID analysis.
%
%    It then saves the data to large struct array that contain data for the
%    neuron. 
%
%    batch : if 1, then the function assumes it is outside the folders
%       holding the data. It then goes in to each folder, makes plots, and 
%       comes back out. Default = 0. 
% 
%    



narginchk(0,1);

if nargin == 0
    batch = 0;
end

if isempty(batch)
    batch = 0;
end


figpath = '.';
datapath = '.';


if ( batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

fio = [];
projinfo = [];

for ii = 1:length(folders)

    cd(folders{ii});

    dfilters = dir(fullfile(datapath, '*-filter-fio-proj-info.mat'));
    if isempty(dfilters)
        fprintf('\nNo *-filter-fio-proj-info.mat files in %s.\n\n', folders{ii});
    end

    matfiles = {dfilters.name};


    for i = 1:length(matfiles)
       
        fprintf('\nGetting data from: %s\n', matfiles{i});
        data = load(matfiles{i}, 'fio', 'projinfo');

        data.fio = rmfield(data.fio, 'locator');
        data.projinfo = rmfield(data.projinfo, 'locator');

        fio = [fio data.fio];
        projinfo = [projinfo data.projinfo];

    end % (for i)

    cd(startdir)

end % (for ii)


return;




function params_total = sm_dir_get_fra_params(varargin)
% sm_dir_get_fra_params Go through directory files and get FRA params
%
% params_total = sm_dir_get_fra_params(kwargs) gets the FRA parameter data from
% saved files.
%
% Arguments are keyword/values:
%
%   Keyword        Value
%   ===============================
%    options = struct(...
%                     'batch', 0, ...
%                     'process', 0, ...
%                     'repfolder', 'K:\SM_MIDs\SM_data_dmrrepeat', ...
%                     'longfolder', 'K:\SM_MIDs\SM_data_dmrlong', ...
%                     'frafolder', 'K:\SM_FRA', ...
%                     'filestr', []);
%
%       filestr : struct holding file names for tuning curve, long dmr, and
%           repeated dmr response data.
%
% 

graphics_toolkit('qt');

library('export_fig');

close all;

narginchk(2,12);

options = struct(...
                 'batch', 0, ...
                 'process', 0, ...
                 'repfolder', 'K:\SM_MIDs\SM_data_dmrrepeat', ...
                 'longfolder', 'K:\SM_MIDs\SM_data_dmrlong', ...
                 'frafolder', 'K:\SM_FRA', ...
                 'filestr', []);

options = input_options(options, varargin);

repfolder = options.repfolder;
longfolder = options.longfolder;
frafolder = options.frafolder;

if ( isempty(options.filestr) )
    error('Please provide filestr');
else
    filestr = options.filestr;
end



if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;
params_total = [];

for ii = 1:length(folders)

    cd(folders{ii});

    iskfiles_folder = dir('*.isk');
    iskfiles_folder = {iskfiles_folder.name};

    for i = 1:length(iskfiles_folder)

        iskfile = iskfiles_folder{i};

        fprintf('Folder %.0f of %.0f, File %.0f of %.0f: Processing %s\n', ...
            ii, length(folders), i, length(iskfiles_folder), iskfile);

        for j = 1:length(filestr)
            if ( strcmp(filestr(j).iskfile, iskfile) )
                nev_rep_file = filestr(j).nevfile_rep;
                nev_long_file = filestr(j).nevfile_long;
                nev_fra_file = filestr(j).frafile;
            end
        end % (for j)

        if ( strcmp(lower(nev_fra_file), 'none') )
            continue;
        end

        outfile = strrep(nev_fra_file, '.mat', '-params.mat');

        d = dir(outfile);

        if ( exist(outfile, 'file') && options.process==0 )
            load(outfile, 'params');
            params.iskfile = iskfile;
            params.nev_fra_file = nev_fra_file;
            params.nev_long_file = nev_long_file;
            params.nev_rep_file = nev_rep_file;
            params.params_file = outfile;
            params_total = [params_total params];
            clear('outfile');
        end
       
    end % (for i)

    cd(startdir)

end % (for ii)

return;






















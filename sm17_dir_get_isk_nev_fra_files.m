function filestr = sm_dir_get_isk_nev_fra_files(varargin)
% sm_dir_get_isk_nev_fra_files Link data files for a neuron
%
% filestr = sm_dir_get_isk_nev_fra_files.m creates a struct array filestr, with one
% element per neuron. Each element holds 4 file names: the isk file, the
% dmr long file, the dmr repeats file, and the fra file.
%
% The files hold data for binned spike trains, responses to the long dmr
% stimulus, responses to the repeated dmr stimulus, and the frequency 
% response area stimuli.
%
% This structure makes later analyses easier since it is collates the data
% types in one data structure.
%
% The function must be run inside:
%
%       K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_MID_Results
%
%
% The location of the different data types needs to be specified through
% keyword/value arguments.
%
%
% spike train in the current folder.
%
% The sta is estimated from a matrix of the spr envelope.
%
% The MTFs are estimated using temporal and spectral modulation frequency values 
% for each stimulus trial frame of the spr stimulus matrix. The 2D MTF is 
% estimated by making a histogram of the modulation values that corresponded 
% to a spike.
%
%   Arguments are keyword/values:
%
%   Keyword        Value
%   ===============================
%
%   'repfolder'     folder holding dmr repeat data.
%                   Default: 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrrepeat', ...
%   
%   'longfolder'    folder holding dmr long stimulus data.
%                   Default: 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrlong', ...
%   
%   'frafolder'     folder holding fra data.
%                   Default: 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_FRA');
%   
%   'batch'         specify whether to process multiple folders (which is the normal usage).
%                   Default: 1 = yes. 0 = no.
%   
%  Note: currently, the filestr results of this function are stored in:
%     K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_MID_Results\sm-dmr-long-rep-isk-fra-files.mat

narginchk(0,8);

options = struct('batch', 1, ...
                 'repfolder', 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrrepeat', ...
                 'longfolder', 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrlong', ...
                 'frafolder', 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_FRA');

options = input_options(options, varargin);
repfolder = options.repfolder;
longfolder = options.longfolder;
frafolder = options.frafolder;

if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

filestr = [];

for ii = 1:length(folders)

    cd(folders{ii});

    iskfiles = dir('*.isk');
    iskfiles = {iskfiles.name};

    for i = 1:length(iskfiles)

        fprintf('Processing %s\n', iskfiles{i});

        %nevfile_rep = sm_iskfile_to_dmrrep_nevfile(iskfiles{i}, repfolder);
        nevfile_rep = sm_iskfile_to_nevfile(iskfiles{i}, repfolder);

        %nevfile_long = sm_iskfile_to_dmrrep_nevfile(iskfiles{i}, longfolder);
        nevfile_long = sm_iskfile_to_nevfile(iskfiles{i}, longfolder);

        %frafile = sm_nevfile_to_frafile(nevfile, frafolder);
        frafile = sm_iskfile_to_nevfile(iskfiles{i}, frafolder);

        s.iskfile = iskfiles{i};
        s.nevfile_rep = nevfile_rep;
        s.nevfile_long = nevfile_long;
        s.frafile = frafile;
        filestr = [filestr s];
        clear('s');
    end % (for i)

    cd(startdir)

end % (for ii)


return;

























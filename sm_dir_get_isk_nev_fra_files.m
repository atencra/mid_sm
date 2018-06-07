function filestr = sm_dir_get_isk_nev_fra_files(varargin)
% sm_mid_dir_plot_sta_sprtmf_smf 2D Spike-triggered modulation frequencies
%
% sm_mid_dir_plot_sta_sprtmf_smf(kwargs) plots the sta and 2D MTFs for each
% spike train in the current folder.
%
% The sta is estimated from a matrix of the spr envelope.
%
% The MTFs are estimated using temporal and spectral modulation frequency values 
% for each stimulus trial frame of the spr stimulus matrix. The 2D MTF is 
% estimated by making a histogram of the modulation values that corresponded 
% to a spike.
%
% Arguments are keyword/values:
%   Keyword        Value
%   ===============================
%   'batch'        process multiple folders? Default: 0, no we are inside a single folder. 
%   'repfolder'    directory holding responses to dmr repeated stimulus.
%                  Default: K:\SM_MIDs\SM_data_dmrrepeat
%
% 
%   Complete example call:
%       sm_mid_dir_plot_sta_tmf_smf('batch', 0, 'repfolder', 'K:\SM_MIDs\SM_data_dmrrepeat');
%


%longfilefolder = 'I:\SM_data\nhp_su_sta_dmr\PSTH_sig';
%repfilefolder = 'I:\SM_data\nhp_su_repeated_dmr';


narginchk(0,8);

options = struct('batch', 0, ...
                 'repfolder', 'K:\SM_MIDs\SM_data_dmrrepeat', ...
                 'longfolder', 'K:\SM_MIDs\SM_data_dmrlong', ...
                 'frafolder', 'K:\SM_FRA');

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

























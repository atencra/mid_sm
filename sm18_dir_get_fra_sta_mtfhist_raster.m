function sm18_dir_get_fra_sta_mtfhist_raster(varargin)
% sm18_mid_dir_get_sta_sprtmf_smf Save 2D Spike-triggered modulation frequencies analysis
%
% sm18_mid_dir_get_sta_sprtmf_smf(kwargs) estimates the fra, the sta, raster for
% responses to a repeated dmr stimulus, and 2D MTFs for each spike train in the 
% current folder and saves them. If the fra data is not available, then
% no data will be saved.
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
%   'stimulus'     matrix of spr envelope. Required. Default: []. 
%       File normally used: dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8-matrix.mat
%
%   'sprtmf'       vector of stimulus frame tmf values. Required. 
%       Should be saved in: dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8-mtf-hires.mat
%
%   'sprsmf'       vector of stimulus frame smf values. Required. 
%       Should be saved in: dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8-mtf-hires.mat
%
%   'batch'        process multiple folders? Default: 0, no we are inside a single folder. 
%
%   'process'      process data and overwrite any saved files? Default: 0, no.
%
%   'repfolder'    directory holding responses to dmr repeated stimulus.
%                  Default: 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrrepeat'
%
%   'longfolder'   directory holding responses to long dmr stimulus.
%                  Default: 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrlong'
%
%   'frafolder'    directory holding fra data.
%                  Default: 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_FRA'
%
%   'filestr'      Required. file struct array holding filenames. This structure links the
%                  isk file, fra file, dmr long file, and dmr repeats file for each neuron.
%                  Stored in: sm-dmr-long-rep-isk-fra-files.mat inside
%                  'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_MID_Results'
%
%
%   Complete example call:
%
%   sm18_dir_get_fra_sta_mtfhist_raster('stimulus', stimulus, 'sprtmf', sprtmf, 'sprsmf', sprsmf, 'batch', 1, 'filestr', filestr);
%

fprintf('%s\n', mfilename);

narginchk(4,20);

options = struct('stimulus', [], ...
                 'sprtmf', [], ...
                 'sprsmf', [], ...
                 'figdir', '.', ...
                 'batch', 0, ...
                 'process', 0, ...
                 'repfolder', 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrrepeat', ...
                 'longfolder', 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_Data_dmrlong', ...
                 'frafolder', 'K:\Squirrel_Monkey\Squirrel_Monkey_MID_Project\SM_FRA', ...
                 'filestr', []);

options = input_options(options, varargin);

assert(~isempty(options.sprtmf), 'Please input sprtmf.');
assert(~isempty(options.sprsmf), 'Please input sprsmf.');
assert(~isempty(options.stimulus), 'Please input stimulus.');

sprtmf = options.sprtmf;
sprsmf = options.sprsmf;
figdir = options.figdir;
stimulus = options.stimulus;
repfolder = options.repfolder;
longfolder = options.longfolder;
frafolder = options.frafolder;

if ( isempty(options.filestr) )
    error('Please provide filestr');
else
    filestr = options.filestr;
end

assert(length(sprtmf) == length(sprsmf), 'sprtmf and sprsmf lengths dont match.');
assert(length(sprtmf) == size(stimulus,2), 'sprtmf, sprsmf, and stimulus lengths dont match.');


if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    iskfiles_folder = dir('*.isk');
    iskfiles_folder = {iskfiles_folder.name};

    for i = 1:length(iskfiles_folder)

        iskfile = iskfiles_folder{i};

        fprintf('Processing %s\n', iskfile);

        for j = 1:length(filestr)
            if ( strcmp(filestr(j).iskfile, iskfile) )
                nev_rep_file = filestr(j).nevfile_rep;
                nev_long_file = filestr(j).nevfile_long;
                nev_fra_file = filestr(j).frafile;
            end
        end % (for j)


        outfile = strrep(iskfile, '.isk', '-fra-sta-mtf-raster.mat');

        if ( exist(outfile, 'file') && options.process==0 )
            fprintf('Data already saved in: %s\n\n', outfile);
            continue;
        end


        if ( strcmp(lower(nev_fra_file), 'none') )
            fra = [];
        else
            load(fullfile(frafolder, nev_fra_file), 'nevstruct', 'trigstruct');
            load(fullfile(frafolder, 'tcparams.mat'), 'params');
            spiketimes = nevstruct.tspk_ms;
            triggers = trigstruct.trig_ms;
            start = 0;
            stop = 50;
            fra = sm_fra_nev(spiketimes, triggers, start, stop, params);
        end


        locator = sm_isk_file_to_locator(iskfile);
        locator = locator(:)';
        assert(length(locator) == size(stimulus,2), 'locator and stimulus dont match.');
        nlags = 20;
        sta = get_sta_from_locator(locator, stimulus, nlags);

        ntrials = length(locator);
        shiftsize = round(ntrials/2);
        locator_rand = circshift(locator, shiftsize, 2);
        %starand = get_sta_from_locator(locator_rand, stimulus, nlags);

        assert(length(locator) == length(sprtmf), 'locator and sprtmf have different lengths.');
        assert(length(sprtmf) == length(sprsmf), 'sprtmf and sprsmf have different lengths.');

        nevfile = sm_iskfile_to_dmrrep_nevfile(iskfile, repfolder);

        load(fullfile(repfolder, nevfile), 'nevstruct', 'trigstruct')
        raster = sm_calc_rep_raster(nevstruct,trigstruct,5);

        mtfdata = sm_get_fra_sta_mtfhist_raster('locator', locator, 'sprtmf', sprtmf, 'sprsmf', sprsmf, ...
            'sta', sta, 'nevfra', fra, 'iskfile', iskfile, 'raster', raster, ...
            'repfile', nev_rep_file, 'longfile', nev_long_file, 'frafile', nev_fra_file);

        save(outfile, 'mtfdata');
        fprintf('MTF data saved to: %s\n\n', outfile);

    end % (for i)

    cd(startdir)

end % (for ii)

return;


function mtfdata = sm_get_fra_sta_mtfhist_raster(varargin)
% sm_plot_fra_sta_mtfhist_raster FRA, STA, MTF Hist plot
%
%   Usually called from: sm_dir_plot_fra_sta_mtfhist_raster.m
%
%   Keyword / value arguments are required:
%
%    options = struct('locator', [], ...
%                     'sprtmf', [], 'sprsmf', [], ...
%                     'nlags', 20, 'sta', [], ...
%                     'iskfile', [], ...
%                     'raster', [], ...
%                     'nevfra', [], ...
%                     'repfile', [], ...
%                     'longfile', [], ...
%                     'frafile', []);
%
%   Example call from sm_dir_plot_fra_sta_mtfhist_raster.m : 
%
%        sm_plot_fra_sta_mtfhist_raster('locator', locator, 'sprtmf', sprtmf, 'sprsmf', sprsmf, ...
%            'sta', sta, 'nevfra', fra, 'iskfile', iskfile, 'raster', raster, ...
%            'repfile', nev_rep_file, 'longfile', nev_long_file, 'frafile', nev_fra_file);
%
%

fprintf('%s\n', mfilename);

options = struct('locator', [], ...
                 'sprtmf', [], 'sprsmf', [], ...
                 'nlags', 20, 'sta', [], ...
                 'iskfile', [], ...
                 'raster', [], ...
                 'nevfra', [], ...
                 'repfile', [], ...
                 'longfile', [], ...
                 'frafile', []);

options = input_options(options, varargin);
assert(~isempty(options.locator), 'Please input locator.');
assert(~isempty(options.sprtmf), 'Please input sprtmf.');
assert(~isempty(options.sprsmf), 'Please input sprsmf.');
assert(~isempty(options.sta), 'Please input sta.');
assert(~isempty(options.raster), 'Please input raster.');
assert(~isempty(options.longfile), 'Please input nev file.');
assert(~isempty(options.iskfile), 'Please input isk file.');
assert(~isempty(options.repfile), 'Please input rep file.');
assert(~isempty(options.frafile), 'Please input fra file.');

locator = options.locator;
sprtmf = options.sprtmf;
sprsmf = options.sprsmf;
nlags = options.nlags;
sta = options.sta;
raster = options.raster;
fra = options.nevfra;
longfile = options.longfile;
frafile = options.frafile;
repfile = options.repfile;
iskfile = options.iskfile;


index = find(locator > 0);
index = index(index>nlags);


% MTF data for negative and positive tmf values
xspk = sprtmf(index);
dx = 5;
xedges = (-dx/2-50):dx:(dx/2+50);
xcenter = edge2center(xedges);

yspk = sprsmf(index);
dy = 0.1;
yedges = 0:dy:(1.2);
ycenter = edge2center(yedges);

xyspkhist = sm_hist2d (xspk, yspk, xedges, yedges);



% mtf data for positive tmf data only
xspkpos = abs(sprtmf(index));
dx = 5;
xedges_pos = 0:dx:50;
xcenter = edge2center(xedges_pos);

yspkpos = sprsmf(index);
yedges_pos = yedges;

xyspkposhist = sm_hist2d (xspkpos, yspkpos, xedges_pos, yedges_pos);


mtfdata.locator = options.locator;
mtfdata.sprtmf = options.sprtmf;
mtfdata.sprsmf = options.sprsmf;
mtfdata.nlags = options.nlags;
mtfdata.sta = options.sta;
mtfdata.raster = options.raster;
mtfdata.fra = options.nevfra;
mtfdata.longfile = options.longfile;
mtfdata.frafile = options.frafile;
mtfdata.repfile = options.repfile;
mtfdata.iskfile = options.iskfile;

mtfdata.tmfedges = xedges;
mtfdata.smfedges = yedges;
mtfdata.mtfhist = xyspkhist;

mtfdata.tmfedges_pos = xedges;
mtfdata.smfedges_pos = yedges;
mtfdata.mtfhist_pos = xyspkposhist;

return;
















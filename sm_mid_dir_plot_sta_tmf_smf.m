function sm_mid_dir_plot_sta_tmf_smf(varargin)
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
%   'stimulus'     matrix of spr envelope. Required. Default: []. dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8-mtf-hires.mat
%   'sprtmf'       vector of stimulus frame tmf values. Required. Default: []. dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8-mtf-hires.mat
%   'sprsmf'       vector of stimulus frame smf values. Required. Default: []. dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8-mtf-hires.mat
%   'figdir'       where to save figures. Default: '.', the current directory. 
%   'batch'        process multiple folders? Default: 0, no we are inside a single folder. 
%   'process'      process data and overwrite any saved files? Default: 0, no.
%
% 
%   Note: ghostscript must be on the computer and is assumed to be in:
%       'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%   
%   Complete example call:
%       sm_mid_dir_plot_sta_tmf_smf('stimulus', [], 'sprtmf', [], 'sprsmf', [], 'figdir', '.', 'batch', 0, 'process', 0);

library('export_fig');

close all;

narginchk(4,10);

options = struct('stimulus', [], 'sprtmf', [], 'sprsmf', [], 'figdir', '.', 'batch', 0, 'process', 0);
options = input_options(options, varargin);

assert(~isempty(options.sprtmf), 'Please input sprtmf.');
assert(~isempty(options.sprsmf), 'Please input sprsmf.');
assert(~isempty(options.stimulus), 'Please input stimulus.');

sprtmf = options.sprtmf;
sprsmf = options.sprsmf;
figdir = options.figdir;
stimulus = options.stimulus;

assert(length(sprtmf) == length(sprsmf), 'sprtmf and sprsmf lengths dont match.');
assert(length(sprtmf) == size(stimulus,2), 'sprtmf, sprsmf, and stimulus lengths dont match.');


gsdir = 'C:\Program Files\gs\gs9.20\bin';
gsfile = 'gswin64c.exe';
gspath = fullfile(gsdir, gsfile);

if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    iskfiles = dir('*.isk');
    iskfiles = {iskfiles.name};

    for i = 1:length(iskfiles)

        fprintf('Processing %s\n', iskfiles{i});

        basefile = strrep(iskfiles{i}, '.isk', '-mtf-highres')
        eps_file = fullfile(figdir, sprintf('%s.eps', basefile))
        pdf_file = fullfile(figdir, sprintf('%s.pdf', basefile))

        d = dir(pdf_file);

        if ( isempty(d) || options.process )

            locator = sm_isk_file_to_locator(iskfiles{i});
            locator = locator(:)';
            assert(length(locator) == size(stimulus,2), 'locator and stimulus dont match.');
            nlags = 20;
            sta = get_sta_from_locator(locator, stimulus, nlags);

            ntrials = length(locator);
            shiftsize = round(ntrials/2);
            locator_rand = circshift(locator, shiftsize, 2);
            starand = get_sta_from_locator(locator_rand, stimulus, nlags);

            assert(length(locator) == length(sprtmf), 'locator and sprtmf have different lengths.');
            assert(length(sprtmf) == length(sprsmf), 'sprtmf and sprsmf have different lengths.');
            titlestring = strrep(iskfiles{i},'_', '-');

            sm_plot_sta_tmf_smf_hist('locator', locator, 'sprtmf', sprtmf, 'sprsmf', sprsmf, 'sta', sta, 'starand', starand, 'titlestring', titlestring);
            set(gcf,'position', [300 200 360 620]);

            fig2eps(eps_file);
            pause(1);
            crop = 1;
            append = 0;
            gray = 0;
            quality = 1000;
            eps2pdf(eps_file, pdf_file, crop, append, gray, quality);
            pause(1);
            close all;
            fprintf('Figure saved in: %s\n\n', pdf_file);
        else
            fprintf('Figure already saved in: %s\n\n', pdf_file);
        end

    end % (for i)

    cd(startdir)

end % (for ii)

return;



%pdf_file_dir = sprintf('mid_filter_fio.pdf');
%pdf_file_dir = fullfile(figpath, pdf_file_dir);
%
%d = dir(pdf_file_dir);
%if isempty(d)
%    append_pdfs(pdf_file_dir, pdf_file_total); 
%end
%
%for i = 1:length(exp_site)
%    exp_site_files = sprintf('%s_*-filter-fio.pdf', exp_site{i});
%    d = dir(fullfile(figpath, exp_site_files));
%    exp_site_files = {d.name};
%
%    for j = 1:length(exp_site_files)
%        exp_site_files{j} = fullfile(figpath, exp_site_files{j});
%        fprintf('Appending %s\n', exp_site_files{j});
%    end % (for j)
%
%    exp_site_group_pdf_file = fullfile(figpath, sprintf('%s-filter-fio.pdf', exp_site{i}));
%    append_pdfs(exp_site_group_pdf_file, exp_site_files);
%
%end % (for i)














function sm_mid_dir_plot_rtfhist(varargin)
%mid_dir_plot_filter_fio
%
% options = struct('stimulus', [], 'tmf', [], 'smf', [], 'figdir', '.', 'batch', 0, 'process', 0);
% options = input_options(options, varargin);
%
% 
%    figpath : where you want the figures saved. Default is '."
%
%    gspath : complete path to Ghostscript executable. Default is
%        gspath = 'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%    This input is generally not needed, since the default has been 
%    set during ghostscript installation.
%    

library('export_fig');

close all;

narginchk(4,10);

options = struct('stimulus', [], 'tmf', [], 'smf', [], 'figdir', '.', 'batch', 0, 'process', 0);
options = input_options(options, varargin);

assert(~isempty(options.tmf), 'Please input tmf.');
assert(~isempty(options.smf), 'Please input smf.');
assert(~isempty(options.stimulus), 'Please input stimulus.');

tmf = options.tmf;
smf = options.smf;
figdir = options.figdir;
stimulus = options.stimulus;


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

        basefile = strrep(iskfiles{i}, '.isk', '-mtf')
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

            resp = sm_locator_to_trimmed_resp(locator, nlags);
            assert(length(resp) == length(tmf), 'resp and tmf have different lengths.');
            assert(length(tmf) == length(smf), 'tmf and smf have different lengths.');
            titlestring = strrep(iskfiles{i},'_', '-');
            sm_plotrtfhist('resp', resp, 'tm', tmf, 'sm', smf, 'sta', sta, 'starand', starand, 'titlestring', titlestring);
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














function sm_dir_plot_mtfhist_raster(varargin)
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
%   'repfolder'    directory holding responses to dmr repeated stimulus.
%                  Default: K:\SM_MIDs\SM_data_dmrrepeat
%
% 
%   Note: ghostscript must be on the computer and is assumed to be in:
%       'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%   
%   Complete example call:
%       sm_mid_dir_plot_sta_tmf_smf('stimulus', [], 'sprtmf', [], 'sprsmf', [], 'figdir', '.', 'batch', 0, 'process', 0);



longfilefolder = 'I:\SM_data\nhp_su_sta_dmr\PSTH_sig';
repfilefolder = 'I:\SM_data\nhp_su_repeated_dmr';

graphics_toolkit('gnuplot');

library('export_fig');

close all;

narginchk(4,10);

options = struct('stimulus', [], ...
                 'sprtmf', [], ...
                 'sprsmf', [], ...
                 'figdir', '.', ...
                 'batch', 0, ...
                 'process', 0, ...
                 'repfolder', 'K:\SM_MIDs\SM_data_dmrrepeat');
options = input_options(options, varargin);

assert(~isempty(options.sprtmf), 'Please input sprtmf.');
assert(~isempty(options.sprsmf), 'Please input sprsmf.');
assert(~isempty(options.stimulus), 'Please input stimulus.');

sprtmf = options.sprtmf;
sprsmf = options.sprsmf;
figdir = options.figdir;
stimulus = options.stimulus;
repfolder = options.repfolder;

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

        basefile = strrep(iskfiles{i}, '.isk', '-mtf-highres-raster');
        eps_file = fullfile(figdir, sprintf('%s.eps', basefile));
        pdf_file = fullfile(figdir, sprintf('%s.pdf', basefile));
        d = dir(pdf_file);

        if ( exist(pdf_file, 'file') && options.process==0 )
            fprintf('Figure already saved in: %s\n\n', pdf_file);
            continue;
        end

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


        nevfile = sm_iskfile_to_dmrrep_nevfile(iskfiles{i}, repfolder);

        load(fullfile(repfolder, nevfile), 'nevstruct', 'trigstruct')
        raster = sm_calc_rep_raster(nevstruct,trigstruct,5);

        sm_plot_sta_tmf_smf_raster('locator', locator, 'sprtmf', sprtmf, 'sprsmf', sprsmf, ...
            'sta', sta, 'starand', starand, 'titlestring', titlestring, 'raster', raster, 'nevfile', nevfile);

        fig2eps(eps_file);
        pause(1);
        crop = 1;
        append = 0;
        gray = 0;
        quality = 1000;
        eps2pdf(eps_file, pdf_file, crop, append, gray, quality);
        pause(1);
        fprintf('Figure saved in: %s\n\n', pdf_file);
        close all;

    end % (for i)

    cd(startdir)

end % (for ii)

return;


























for i = 1:length(STTC_info)
    
    curfolder = cd;
    pdffile = sprintf('temp%d.pdf',i);
    
    if exist(fullfile(curfolder,pdffile),'file')
        fprintf('\n%s already exists! Skipping...', pdffile)
        continue
    end       
    
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    
    % plot MID12 vs STTC
    subplot(3,4,1)
    hold on
    scatter(PSTHcorrmn, MID12info, 10);
    scatter(PSTHcorrmn(i), MID12info(i), 30, 'r', 'filled')
    xlabel('PSTH correlation');
    ylabel('MID 12 info (bits/spike)');
    tickpref;
    
    % plot MID2 vs MID1
    subplot(3,4,5)
    hold on
    scatter(MID1info, MID2info, 10);
    scatter(MID1info(i), MID2info(i), 30, 'r', 'filled')
    xlabel('MID 1 info (bits/spike)');
    ylabel('MID 2 info (bits/spike)');
    tickpref;
    
    % plot MID1 vs STA
    subplot(3,4,9)
    hold on
    scatter(STAinfo, MID1info, 10);
    scatter(STAinfo(i), MID1info(i), 30, 'r', 'filled')
    xlabel('STA info (bits/spike)');
    ylabel('MID 1 info (bits/spike)');
    tickpref;
    
    % plot raster plot, label with STTC value
    subplot(3,4,[2 4])
    hold on
    load(fullfile(repfilefolder, STTC_info(i).repfile), 'nevstruct', 'trigstruct')
    raster = sm_calc_rep_raster(nevstruct,trigstruct,5);
    plotSpikeRaster(logical(raster), 'PlotType','vertline');
    xtick = get(gca, 'xtick');
    xticklabel = xtick/(size(raster,2)/30);
    set(gca, 'XTickLabel', xticklabel);
    xlabel('Time (s)')
    ylabel('Trial number')
    title(sprintf('PSTH correlation = %.2f', PSTHcorrmn(i)))
    
    % load longdmr data
    load(fullfile(longfilefolder, STTC_info(i).longfile), 'nevstruct', 'trigstruct')
    locator = sm_get_spktrain_from_stim_mat(nevstruct, trigstruct, stim_mat); 
    
    % plot STA and nonlinearity
    subplot(3,4,6)
    hold on
    sta = STTC_info(i).filter_mean_sta;
    imagesc(sta);
    minmin = min(min(sta));
    maxmax = max(max(sta));
    boundary = max([abs(minmin) abs(maxmax)]);
    axis xy
    xlim([.5 nt+.5])
    ylim([.5 nf+.5])
    ytick = get(gca, 'ytick');
    xtick = length(taxis) - get(gca, 'xtick') + 1;
    set(gca, 'yticklabel', faxis(ytick));
    set(gca, 'xticklabel', taxis(xtick));
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    colormap(cmap);
    title(sprintf('STA, MI: %.2f bits/spk', STAinfo(i)));
    ylabel('Freq (kHz)')
    box on
   
    subplot(3,4,10)
    [xprior, xposterior] = ne_sta_stimulus_projection(sta, locator, stim_mat);
    [px,pspk,pxspk,xbinedges] = calc_px_pspk_pxspk(xprior,xposterior, 15);
    nl = pspk .* pxspk ./ px;
    if ~all(isnan(nl))
        xbins = edge2center(xbinedges);
        maxmax = max(nl);
        hold on;
        plot(xbins, nl, 'ko-', 'markerfacecolor', 'k');
        minx = min(xbins);
        maxx = max(xbins);
        plot([minx-1 maxx+1], [pspk pspk], 'k--');
        xlim([minx-2 maxx+2]);
        ylim([0 maxmax]);
        set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
        ylabel('P(spk|x)');
    end
    
    % plot MID1 and nonlinearity
    subplot(3,4,7)
    hold on
    mid1 = STTC_info(i).filter_mean_test2_v1;
    imagesc(mid1);
    minmin = min(min(mid1));
    maxmax = max(max(mid1));
    boundary = max([abs(minmin) abs(maxmax)]);
    axis xy
    xlim([.5 nt+.5])
    ylim([.5 nf+.5])
    ytick = get(gca, 'ytick');
    xtick = length(taxis) - get(gca, 'xtick') + 1;
    set(gca, 'yticklabel', faxis(ytick));
    set(gca, 'xticklabel', taxis(xtick));
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    colormap(cmap);
    title(sprintf('MID 1, MI: %.2f bits/spk', MID1info(i)));
    xlabel('Time before spike (ms)')
    box on
   
    subplot(3,4,11)
    [xprior, xposterior] = ne_sta_stimulus_projection(mid1, locator, stim_mat);
    [px,pspk,pxspk,xbinedges] = calc_px_pspk_pxspk(xprior,xposterior, 15);
    nl = pspk .* pxspk ./ px;
    if ~all(isnan(nl))
        xbins = edge2center(xbinedges);
        maxmax = max(nl);
        hold on;
        plot(xbins, nl, 'ko-', 'markerfacecolor', 'k');
        minx = min(xbins);
        maxx = max(xbins);
        plot([minx-1 maxx+1], [pspk pspk], 'k--');
        xlim([minx-2 maxx+2]);
        ylim([0 maxmax]);
        set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
        xlabel('Projection (SD)');
    end
    
    % plot MID2 and nonlinearity
    subplot(3,4,8)
    hold on
    mid2 = STTC_info(i).filter_mean_test2_v2;
    imagesc(mid2);
    minmin = min(min(mid2));
    maxmax = max(max(mid2));
    boundary = max([abs(minmin) abs(maxmax)]);
    axis xy
    xlim([.5 nt+.5])
    ylim([.5 nf+.5])
    ytick = get(gca, 'ytick');
    xtick = length(taxis) - get(gca, 'xtick') + 1;
    set(gca, 'yticklabel', faxis(ytick));
    set(gca, 'xticklabel', taxis(xtick));
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    colormap(cmap);
    title(sprintf('MID 2, MI: %.2f bits/spk', MID2info(i)));
    box on
   
    subplot(3,4,12)
    [xprior, xposterior] = ne_sta_stimulus_projection(mid2, locator, stim_mat);
    [px,pspk,pxspk,xbinedges] = calc_px_pspk_pxspk(xprior,xposterior, 15);
    nl = pspk .* pxspk ./ px;
    if ~all(isnan(nl))
        xbins = edge2center(xbinedges);
        maxmax = max(nl);
        hold on;
        plot(xbins, nl, 'ko-', 'markerfacecolor', 'k');
        minx = min(xbins);
        maxx = max(xbins);
        plot([minx-1 maxx+1], [pspk pspk], 'k--');
        xlim([minx-2 maxx+2]);
        ylim([0 maxmax]);
        set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    end
    
    filename = STTC_info(i).longfile;
    date = regexp(filename, '(?<=(nev_))\d{4}-\d{2}-\d{2}(?=(_\d{2}))', 'match', 'once');
    chan = regexprep(regexp(filename, 'do\d{2}_ch\d{2}','match','once'), '_', '\\_');
    su = regexp(filename, 'su\d{1}(?=(.mat))', 'match', 'once');
    
    suptitle(sprintf('%s\\_%s\\_%s, MID12 MI: %.2f bits/spk ',date, chan, su, MID12info(i)));
    
    print_mfilename(mfilename);
    
    export_fig(h, pdffile, '-nocrop');
    close(h);

end


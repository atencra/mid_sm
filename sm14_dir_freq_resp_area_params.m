function sm_dir_freq_resp_area_params(varargin)
% sm_dir_freq_resp_area_params Go through directory files and get FRA params
%
% sm_dir_freq_resp_area_params(kwargs) plots the FRA for each file and allows
% the user to select FRA parameters such CF, BW10, etc.
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
            fprintf('FRA params already already saved in: %s\n\n', outfile);
            continue;
        end

        load(fullfile(frafolder, nev_fra_file), 'nevstruct', 'trigstruct'); 
        load(fullfile(frafolder, 'tcparams.mat'), 'params');
        spiketimes = nevstruct.tspk_ms;
        triggers = trigstruct.trig_ms;
        start = 0;
        stop = 50;
        fra = sm_fra_nev(spiketimes, triggers, start, stop, params);

        params = sm_freq_resp_area_params(fra);
        save(outfile, 'spiketimes', 'triggers', 'start', 'stop', 'fra', 'params');
        clear('spiketimes', 'triggers', 'fra', 'params');
        fprintf('FRA params saved to: %s\n', outfile);
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


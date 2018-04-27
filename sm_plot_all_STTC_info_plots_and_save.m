function sm_plot_all_STTC_info_plots_and_save(STTC_info)


PSTHcorrmn = [STTC_info.mean_PSTHcorr];
STAinfo = cellfun(@mean, {STTC_info.info0_extrap_test});
MID1info = cellfun(@mean, {STTC_info.info1_extrap_test});
MID2info = cellfun(@mean, {STTC_info.info2_extrap_test});
MID12info = cellfun(@mean, {STTC_info.info12_extrap_test});

sprfile = STTC_info(1).sprfile;
basename = regexp(sprfile, '^\S+(?=(.spr))','match','once');
paramfile = [basename '_param.mat'];
matrixfile = [basename '_matrix.mat'];
stimfolder = 'I:\Ripple_Noise\downsampled_for_MID';
load(fullfile(stimfolder, paramfile), 'faxis', 'taxis')
load(fullfile(stimfolder, matrixfile));

nt = STTC_info(1).nt_filter;
nf = STTC_info(1).nf_filter;
taxis = round(taxis(1:nt) * 1000);
faxis = round(faxis)/1000;
cmap = cschemes('rdbu',21);

longfilefolder = 'I:\SM_data\nhp_su_sta_dmr\PSTH_sig';
repfilefolder = 'I:\SM_data\nhp_su_repeated_dmr';

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


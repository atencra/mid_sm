function sm_dir_plot_fra_sta_mid_raster(varargin)
% sm_dir_plot_fra_sta_mid_raster Plot filters, fra, and raster in folder
%
% sm_dir_plot_fra_sta_mid_raster (kwargs) plots the fra, the sta 
% and mid filters, and the raster for the repeated response to 
% the short ripple segment.
%
% Filters and nonlinearities are from MID calculations. 
%
% FRAs are from separately estimated pure tone responses.
%
% Rasters are from separate responses to repeated presentations of a
% DMR 30 second stimulus.
%
% Arguments are keyword/values:
%   Keyword        Value
%   ===============================
%   'filestr'      Required. Struct holding file names for FRA and DMR responses.
%
%   'figdir'       where to save figures. Default: '.', the current directory. 
%
%   'batch'        Go into data folders? Default: 0 = we are inside a single folder. 
%                  Set to 1 if to run outside of data folders, and then enter each
%                  folder sequentially and process the data.
%
%   'process'      Overwrite previously saved files with the same name?
%                  Default: 0, no.
%
%   'repfolder'    Directory holding responses to dmr repeated stimulus.
%                  Default: K:\SM_MIDs\SM_data_dmrrepeat
%
%   'longfolder'   Directory holding responses to long dmr stimulus.
%                  Default: K:\SM_MIDs\SM_data_dmrlong
%
%   'frafolder'   Directory holding FRA responses.
%                  Default: K:\SM_FRA
%
%   Note: ghostscript must be on the computer and is assumed to be in:
%       'C:\Program Files (x86)\gs\gs9.19\bin\gswin32c.exe';
%   
%   Example calls:
%       sm_dir_plot_fra_sta_mid_raster('filestr', filestr);
%       sm_dir_plot_fra_sta_mid_raster('filestr', filestr, 'batch', 1);
%       sm_dir_plot_fra_sta_mid_raster('filestr', filestr, 'process', 1);
%       sm_dir_plot_fra_sta_mid_raster('filestr', filestr, 'batch', 1, 'process', 1);
%


graphics_toolkit('qt');
library('export_fig');

close all;

narginchk(2,14);

options = struct(...
        'figdir', '.', ...
        'batch', 0, ...
        'process', 0, ...
        'repfolder', 'K:\SM_MIDs\SM_data_dmrrepeat', ...
        'longfolder', 'K:\SM_MIDs\SM_data_dmrlong', ...
        'frafolder', 'K:\SM_FRA', ...
        'filestr', []);

options = input_options(options, varargin);


figdir = options.figdir;
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

    for i = 1:1 %length(iskfiles_folder)

        iskfile = iskfiles_folder{i};

        fprintf('Processing %s\n', iskfile);

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

        s1 = strrep(iskfile,'site','');
        s2 = strrep(s1,'dmr-fs30303-spk-neuron','');
        s3 = strrep(s2,'.isk','');
        s4 = strrep(s3,'-','_');
        midfile = sprintf('%s-filter-fio.mat', s4);

        load(midfile, 'data');
        middata = data;

        assert(strcmp(iskfile, data.iskfile), 'folder and mid isk files do not match.');

        basefile = strrep(iskfile, '.isk', '-fra-sta-mid-fio-raster');
        eps_file = fullfile(figdir, sprintf('%s.eps', basefile));
        pdf_file = fullfile(figdir, sprintf('%s.pdf', basefile));
        d = dir(pdf_file);

        if ( exist(pdf_file, 'file') && exist(eps_file, 'file') && options.process==0 )
            fprintf('Figure already saved in: %s\n\n', pdf_file);
            continue;
        end

        load(fullfile(frafolder, nev_fra_file), 'nevstruct', 'trigstruct'); 
        load(fullfile(frafolder, 'tcparams.mat'), 'params');
        spiketimes = nevstruct.tspk_ms;
        triggers = trigstruct.trig_ms;
        start = 0;
        stop = 50;
        fra = sm_fra_nev(spiketimes, triggers, start, stop, params);

        nevfile = sm_iskfile_to_dmrrep_nevfile(iskfile, repfolder);

        load(fullfile(repfolder, nevfile), 'nevstruct', 'trigstruct')
        raster = sm_calc_rep_raster(nevstruct,trigstruct,5);

        sm_plot_fra_sta_mid_fio_raster(...
            'middata', middata, 'nevfra', fra, 'iskfile', iskfile, 'raster', raster);

        fig2eps(eps_file);
        pause(1);
        crop = 0;
        append = 0;
        gray = 0;
        quality = 1000;
        eps2pdf(eps_file, pdf_file, crop, append, gray, quality);
        pause(1);
        fprintf('Figure saved as: %s\n\n', pdf_file);
        close all;

    end % (for i)

    cd(startdir)

end % (for ii)

return;




function sm_plot_fra_sta_mid_fio_raster(varargin)

options = struct('middata', [], ...
                 'iskfile', [], ...
                 'raster', [], ...
                 'nevfra', []);

options = input_options(options, varargin);

middata = options.middata;
iskfile = options.iskfile;
raster = options.raster;
fra = options.nevfra;


sta_filt = middata.filter_mean_sta;
sta_fio_x = middata.fio_sta.x_mean;
sta_fio_ior = middata.fio_sta.ior_mean;
sta_fio_ior_std = middata.fio_sta.ior_std;

pspk = middata.fio_sta.pspk_mean;

mid1_filt = middata.filter_mean_test2_v1;
mid1_fio_x = middata.fio_mid1.x1_mean;
mid1_fio_ior = middata.fio_mid1.pspkx1_mean;
mid1_fio_ior_std = middata.fio_mid1.pspkx1_std;


mid2_filt = middata.filter_mean_test2_v2;
mid2_fio_x = middata.fio_mid2.x2_mean;
mid2_fio_ior = middata.fio_mid2.pspkx2_mean;
mid2_fio_ior_std = middata.fio_mid2.pspkx2_std;

mid12_fio_x1 = middata.fio_mid12.x1_mean;
mid12_fio_x2 = middata.fio_mid12.x2_mean;
mid12_fio_ior = middata.fio_mid12.pspkx1x2_mean;
mid12_fio_ior_std = middata.fio_mid12.pspkx1x2_std;



hf = figure;
set(hf,'position', [300 100 300 800]);
orient tall;
colormap('jet');

ms = 3;
lw = 1;


subplot(5,3,1);
plot_tms_nev_fra(fra, 'ydf', 3, 'xdf', 12);
xlabel('Freq (kHz)');
ylabel('Atten (dB)');
title('FRA');


subplot(5,3,4);
imagesc(sta_filt);
tickpref;
xlabel('Time (ms)');
ylabel('Freq (kHz)');
title('STA');
minmin = min(min(sta_filt));
maxmax = max(max(sta_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
xtick = [1 size(sta_filt,2)];
set(gca,'xtick', xtick, 'xticklabel', xtick);
ytick = [1 size(sta_filt,1)];
set(gca,'ytick', ytick, 'yticklabel', ytick);


subplot(5,3,5);
hold on;
x = sta_fio_x;
fx = sta_fio_ior; 

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
    plot(x,fx,'ko-','markerfacecolor','k','markersize',ms,'linewidth',lw);
    xlim([1.1*min(x) 1.1*max(x)]);
    if ~isempty(pspk)
        plot(xlim, [pspk pspk], 'k--');
    end
    ymax = max(fx);
    ymax = ceil(ymax*10) / 10;
    ytick = [0 ymax/2 ymax];
    set(gca,'ytick', ytick, 'yticklabel', ytick);
    ylim([0 1.1*max(ytick)]);
    tickpref;
    ylabel('Spike Probability');
    xtick = [round(min(x)) 0 round(max(x))];
    set(gca,'xtick', xtick, 'xticklabel', xtick);
end


   

subplot(5,3,7);
imagesc(mid1_filt);
tickpref;
ylabel('Freq (kHz)');
title('MID1');
minmin = min(min(mid1_filt));
maxmax = max(max(mid1_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
xtick = [1 size(mid1_filt,2)];
set(gca,'xtick', xtick, 'xticklabel', xtick);
ytick = [1 size(mid1_filt,1)];
set(gca,'ytick', ytick, 'yticklabel', ytick);
xlabel('Time (ms)');


subplot(5,3,8);
hold on;
x = mid1_fio_x;
fx = mid1_fio_ior;

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
    plot(x,fx,'ko-','markerfacecolor','k','markersize',ms,'linewidth',lw);
    xlim([1.1*min(x) 1.1*max(x)]);
    if ~isempty(pspk)
        plot(xlim, [pspk pspk], 'k--');
    end
    ymax = max(fx);
    ymax = ceil(ymax*10) / 10;
    ytick = [0 ymax/2 ymax];
    set(gca,'ytick', ytick, 'yticklabel', ytick);
    ylim([0 1.1*max(ytick)]);
    tickpref;
    xtick = [round(min(x)) 0 round(max(x))];
    set(gca,'xtick', xtick, 'xticklabel', xtick);
    ylabel('Spike Probability');
end



subplot(5,3,10);
imagesc(mid2_filt);
tickpref;
xlabel('Time (ms)');
ylabel('Freq (kHz)');
title('MID2');
minmin = min(min(mid2_filt));
maxmax = max(max(mid2_filt));
boundary = max([abs(minmin) abs(maxmax)]);
set(gca,'ydir', 'normal');
set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
xtick = [1 size(mid2_filt,2)];
set(gca,'xtick', xtick, 'xticklabel', xtick);
ytick = [1 size(mid2_filt,1)];
set(gca,'ytick', ytick, 'yticklabel', ytick);


subplot(5,3,11);
hold on;
x = mid2_fio_x;
fx = mid2_fio_ior; 

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
    plot(x,fx,'ko-','markerfacecolor','k','markersize',ms,'linewidth',lw);
    xlim([1.1*min(x) 1.1*max(x)]);
    if ~isempty(pspk)
        plot(xlim, [pspk pspk], 'k--');
    end
    ymax = max(fx);
    ymax = ceil(ymax*10) / 10;
    ytick = [0 ymax/2 ymax];
    set(gca,'ytick', ytick, 'yticklabel', ytick);
    ylim([0 1.1*max(ytick)]);
    tickpref;
    xtick = [round(min(x)) 0 round(max(x))];
    set(gca,'xtick', xtick, 'xticklabel', xtick);
    xlabel('Projection (ms)');
    ylabel('Spike Probability');
end


subplot(5,3,13);
plotSpikeRaster(logical(raster), 'PlotType','vertline');
xtick = get(gca, 'xtick');
xticklabel = roundsd(xtick/(size(raster,2)/30),2);
set(gca, 'XTickLabel', xticklabel);
xlabel('Time (s)')
ylabel('Trial number')



% 2D nonlinearity
%------------------------------

subplot(5,3,14);
pspkx1x2 =  mid12_fio_ior + 0.001;
mxmx = max(pspkx1x2(:));
imagesc(mid12_fio_x1, mid12_fio_x2,  log10(pspkx1x2));
set(gca,'clim', [-3 log10(mxmx)]);
tickpref;

xlabel('MID1 Projection (SD)');
ylabel('MID2 Projection (SD)');

axis('xy');

% hc = colorbar('EastOutside');
% 
% %set(hc,'ytick', [-3 -2 -1 0], 'yticklabel', [0.001 0.01 0.1 1], ...
% %       'Position', [0.5 0.11 0.02 0.15], 'tickdir', 'out');
% 
% 
% set(hc,'ytick', [log10(0.001) log10(mxmx)], ...
%        'yticklabel', [0.001 roundsd(mxmx,3)], ...
%        'Position', [0.5 0.11 0.02 0.15], 'tickdir', 'out');

suptitle(sprintf('%s\n%s', ...
    strrep(iskfile, '_', '-'), ...
    strrep(mfilename, '_', '-')));


return;











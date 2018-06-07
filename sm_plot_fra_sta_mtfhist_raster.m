function sm_plot_fra_sta_mtfhist_raster(varargin)
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
assert(~isempty(options.nevfra), 'Please input fra.');
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

hf = figure;

subplot(3,2,1);
imagesc(sta);
set(gca, 'xtick', [], 'xticklabel', []);
set(gca, 'ytick', [], 'yticklabel', []);
ht = title(sprintf('%s\n ', strrep(longfile, '_', '-')));
set(ht, 'fontname', 'Arial', 'fontsize', 8);


subplot(3,2,2);
plot_tms_nev_fra(fra);
ht = title(sprintf(' \n%s', strrep(frafile, '_', '-')));
set(ht, 'fontname', 'Arial', 'fontsize', 8);



subplot(3,2,3);
xspk = sprtmf(index);
dx = 5;
xedges = (-dx/2-50):dx:(dx/2+50);
xcenter = edge2center(xedges);

yspk = sprsmf(index);
dy = 0.1;
yedges = 0:dy:(1.2);
ycenter = edge2center(yedges);

xyspkhist = sm_hist2d (xspk, yspk, xedges, yedges);
imagesc(xyspkhist);

indx1 = find(xcenter==min(xcenter));
indx2 = find(xcenter==max(xcenter));
indx3 = find(xcenter==0);
set(gca, 'xtick', [indx1 indx2 indx3], 'xticklabel', xcenter([indx1 indx2 indx3]));

indy1 = find(ycenter==min(ycenter));
indy2 = find(ycenter==max(ycenter));
set(gca, 'ytick', [indy1 indy2], 'yticklabel', ycenter([indy1 indy2]));
axis xy;
set(gca, 'tickdir', 'out');
ht = title(strrep(iskfile, '_', '-'));
set(ht, 'fontname', 'Arial', 'fontsize', 8);



subplot(3,2,4);
xspkpos = abs(sprtmf(index));
dx = 5;
xedges = 0:dx:50;
xcenter = edge2center(xedges);

yspkpos = sprsmf(index);

xyspkposhist = sm_hist2d (xspkpos, yspkpos, xedges, yedges);
imagesc(xyspkposhist);

indx1 = find(xcenter==2.5);
indx2 = find(xcenter==47.5);
set(gca, 'xtick', [indx1 indx2], 'xticklabel', xcenter([indx1 indx2]));

indy1 = find(ycenter==min(ycenter));
indy2 = find(ycenter==max(ycenter));
set(gca, 'ytick', [indy1 indy2], 'yticklabel', ycenter([indy1 indy2]));
axis xy;
set(gca, 'tickdir', 'out');



subplot(3,2,[5 6]);
plotSpikeRaster(logical(raster), 'PlotType','vertline');
xtick = get(gca, 'xtick');
xticklabel = roundsd(xtick/(size(raster,2)/30),2);
set(gca, 'XTickLabel', xticklabel);
xlabel('Time (s)')
ylabel('Trial number')
ht = title(strrep(repfile, '_', '-'));
set(ht, 'fontname', 'Arial', 'fontsize', 8);

set(hf,'position', [300 200 600 800]);

return;






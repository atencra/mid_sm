function sm_plot_sta_tmf_smf_hist(varargin)
%%
% sprtmf and sprsmf are saved in 
%       dmr-50flo-40000fhi-4SM-150TM-40db-96kHz-96DF-30min_DFt5_DFf8-mtf-hires.mat
%
%function [fighandle]=plotrtfhist(filename,RDMax,FMMax,invert)
%
%       FILE NAME       : PLOT RTF HIST
%       DESCRIPTION     : Plots the data from an RTF Hist file
%
%	filename	: Input RTFHist file name
%	RDMax		: Maximum Ripple Density
%			  Default = 4 Cycles / Octave
%	FMMax		: Maximum Modulation Rate 
%			  Default = 350 Hz
%	invert		: Inverts the Spike Waveform
%			  'y' or 'n', Default='n'
%

fprintf('%s\n', mfilename);

options = struct('locator', [], 'sprtmf', [], 'sprsmf', [], 'nlags', 20, 'sta', [], 'starand', [], 'titlestring', []);
options = input_options(options, varargin);
assert(~isempty(options.locator), 'Please input locator.');
assert(~isempty(options.sprtmf), 'Please input sprtmf.');
assert(~isempty(options.sprsmf), 'Please input sprsmf.');
assert(~isempty(options.sta), 'Please input sta.');
assert(~isempty(options.starand), 'Please input starand.');

locator = options.locator;
sprtmf = options.sprtmf;
sprsmf = options.sprsmf;
nlags = options.nlags;
sta = options.sta;
starand = options.starand;
titlestring = options.titlestring;

index = find(locator > 0);
index = index(index>nlags);


subplot(3,2,1);
imagesc(sta);
set(gca, 'xtick', [], 'xticklabel', []);
set(gca, 'ytick', [], 'yticklabel', []);
if ( isempty(titlestring) )
    title('Spikes');
else
    title(sprintf('\t\t\t\t\t%s\nSpikes', titlestring));
end

subplot(3,2,2);
imagesc(starand);
set(gca, 'xtick', [], 'xticklabel', []);
set(gca, 'ytick', [], 'yticklabel', []);
title('Random Spikes');


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
title('Spikes');



subplot(3,2,4);
x = sprtmf;
y = sprsmf;
xyhist = sm_hist2d (x, y, xedges, yedges);
imagesc(xyhist);

set(gca, 'xtick', [indx1 indx2 indx3], 'xticklabel', xcenter([indx1 indx2 indx3]));
set(gca, 'ytick', [indy1 indy2], 'yticklabel', ycenter([indy1 indy2]));
axis xy;
set(gca, 'tickdir', 'out');
title('Prior');


subplot(3,2,5);
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


subplot(3,2,6);
xpos = abs(sprtmf);
ypos = sprsmf;
xyposhist = sm_hist2d (xpos, ypos, xedges, yedges);
imagesc(xyposhist);
set(gca, 'xtick', [indx1 indx2], 'xticklabel', xcenter([indx1 indx2]));
set(gca, 'ytick', [indy1 indy2], 'yticklabel', ycenter([indy1 indy2]));
axis xy;
set(gca, 'tickdir', 'out');

return;



function xyhist = sm_hist2d(xdata, ydata, xedge, yedge)
% sm_hist2d 2D histogram
%
% xyhist = hist2d (xdata, ydata, xedge, yedge)
%
% Counts number of points in the bins defined by xedge, yedge.
% length(xdata) == length(ydata)
% size(xyhist) == [length(yedge)-1, length(xedge)-1]
%
% EXAMPLE:
%   xdata = rand(100,1);
%   ydata = rand(100,1);
%   xedge = linspace(0,1,10);
%   yedge = linspace(0,1,20);
%   xyhist = sm_hist2d(xdata, ydata, xedge, yedge);
%
%   nxbins = length(xedge);
%   nybins = length(yedge);
%   xlab = 0.5*(xedge(1:(nxbins-1))+xedge(2:nxbins));
%   ylab = 0.5*(yedge(1:(nybins-1))+yedge(2:nybins));
%
%   imagesc(xedge, yedge, xyhist2d);
%   axis xy;
%   set(gca, 'tickdir', 'out');
%   colorbar;


mX = [ydata(:) xdata(:)];

nCol = size(mX, 2);
if nCol < 2
    error ('mX has less than two columns')
end

nRow = length(yedge)-1;
nCol = length(xedge)-1;

vRow = mX(:,1);
vCol = mX(:,2);

xyhist = zeros(nRow,nCol);

for iRow = 1:nRow

    rRowLB = yedge(iRow);
    rRowUB = yedge(iRow+1);

    vColFound = vCol( (vRow > rRowLB) & (vRow <= rRowUB) );

    if (~isempty(vColFound))
        
        
        vFound = histc(vColFound, xedge);
        
        nFound = (length(vFound)-1);
        
        if (nFound ~= nCol)
            disp([nFound nCol])
            error ('sm_hist2d error: Size Error')
        end
        
        [nRowFound, nColFound] = size(vFound);
        
        nRowFound = nRowFound - 1;
        nColFound = nColFound - 1;
        
        if nRowFound == nCol
            xyhist(iRow, :)= vFound(1:nFound)';
        elseif nColFound == nCol
            xyhist(iRow, :)= vFound(1:nFound);
        else
            error ('sm_hist2d error: Size Error')
        end
    end
    
end

return;



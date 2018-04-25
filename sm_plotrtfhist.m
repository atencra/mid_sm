function sm_plotrtfhist(varargin)
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

options = struct('resp', [], 'tm', [], 'sm', [], 'sta', [], 'starand', [], 'titlestring', []);
options = input_options(options, varargin);
assert(~isempty(options.resp), 'Please input resp.');
assert(~isempty(options.tm), 'Please input tm.');
assert(~isempty(options.sm), 'Please input sm.');
assert(~isempty(options.sta), 'Please input sta.');
assert(~isempty(options.starand), 'Please input starand.');

resp = options.resp;
tm = options.tm;
sm = options.sm;
sta = options.sta;
starand = options.starand;
titlestring = options.titlestring;



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
index = find(resp > 0);
x = tm(index);
dx = 10;
xedges = (-dx/2-100):dx:(dx/2+100);
xcenter = edge2center(xedges); 

y = sm(index);
dy = 0.1;
yedges = (-dy/2):dy:(dy/2+1.2);
ycenter = edge2center(yedges); 

xyhist = sm_hist2d (x, y, xedges, yedges);
imagesc(xyhist);

ind1 = find(xcenter==-100);
ind2 = find(xcenter==0);
ind3 = find(xcenter==100);
set(gca, 'xtick', [ind1 ind2 ind3], 'xticklabel', xcenter([ind1 ind2 ind3]));
%set(gca, 'xtick', 1:length(xcenter), 'xticklabel', roundsd(xcenter,1));

ind1 = find(ycenter==0);
ind2 = find(ycenter==0.5);
ind3 = find(ycenter==1);
set(gca, 'ytick', [ind1 ind2 ind3], 'yticklabel', ycenter([ind1 ind2 ind3]));
%set(gca, 'ytick', 1:length(ycenter), 'yticklabel', roundsd(ycenter,2));
axis xy;
set(gca, 'tickdir', 'out');
%colorbar;
title('Spikes');


subplot(3,2,4);
x = tm;
dx = 10;
xedges = (-dx/2-100):dx:(dx/2+100);
xcenter = edge2center(xedges); 

y = sm;
dy = 0.1;
yedges = (-dy/2):dy:(dy/2+1.2);
ycenter = edge2center(yedges); 

xyhist = sm_hist2d (x, y, xedges, yedges);
imagesc(xyhist);
ind1 = find(xcenter==-100);
ind2 = find(xcenter==0);
ind3 = find(xcenter==100);
set(gca, 'xtick', [ind1 ind2 ind3], 'xticklabel', xcenter([ind1 ind2 ind3]));
%set(gca, 'xtick', 1:length(xcenter), 'xticklabel', roundsd(xcenter,1));

ind1 = find(ycenter==0);
ind2 = find(ycenter==0.5);
ind3 = find(ycenter==1);
set(gca, 'ytick', [ind1 ind2 ind3], 'yticklabel', ycenter([ind1 ind2 ind3]));
%set(gca, 'ytick', 1:length(ycenter), 'yticklabel', roundsd(ycenter,2));
axis xy;
set(gca, 'tickdir', 'out');
%colorbar;
title('Prior');



subplot(3,2,5);
x = abs(tm(index));
dx = 10;
xedges = (-dx/2):dx:(dx/2+100);
xcenter = edge2center(xedges); 

y = sm(index);
dy = 0.1;
yedges = (-dy/2):dy:(dy/2+1.2);
ycenter = edge2center(yedges); 

xyhist = sm_hist2d (x, y, xedges, yedges);
imagesc(xyhist);
ind1 = find(xcenter==0);
ind2 = find(xcenter==50);
ind3 = find(xcenter==100);
set(gca, 'xtick', [ind1 ind2 ind3], 'xticklabel', xcenter([ind1 ind2 ind3]));
%set(gca, 'xtick', 1:length(xcenter), 'xticklabel', roundsd(xcenter,1));

ind1 = find(ycenter==0);
ind2 = find(ycenter==0.5);
ind3 = find(ycenter==1);
set(gca, 'ytick', [ind1 ind2 ind3], 'yticklabel', ycenter([ind1 ind2 ind3]));
%set(gca, 'ytick', 1:length(ycenter), 'yticklabel', roundsd(ycenter,2));
axis xy;
set(gca, 'tickdir', 'out');
%colorbar;


subplot(3,2,6);
x = abs(tm);
dx = 10;
xedges = (-dx/2):dx:(dx/2+100);
xcenter = edge2center(xedges); 

y = sm;
dy = 0.1;
yedges = (-dy/2):dy:(dy/2+1.2);
ycenter = edge2center(yedges); 

xyhist = sm_hist2d (x, y, xedges, yedges);
imagesc(xyhist);
ind1 = find(xcenter==0);
ind2 = find(xcenter==50);
ind3 = find(xcenter==100);
set(gca, 'xtick', [ind1 ind2 ind3], 'xticklabel', xcenter([ind1 ind2 ind3]));
%set(gca, 'xtick', 1:length(xcenter), 'xticklabel', roundsd(xcenter,1));

ind1 = find(ycenter==0);
ind2 = find(ycenter==0.5);
ind3 = find(ycenter==1);
set(gca, 'ytick', [ind1 ind2 ind3], 'yticklabel', ycenter([ind1 ind2 ind3]));
%set(gca, 'ytick', 1:length(ycenter), 'yticklabel', roundsd(ycenter,2));
axis xy;
set(gca, 'tickdir', 'out');
%colorbar;


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



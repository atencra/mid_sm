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
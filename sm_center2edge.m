function edges = center2edge(centers)
% center2edge  Convert histogram bin centers to bin edges 
% edges = center2edge(centers) returns the bin edges for bin centers. This 
% is useful when you want to use histc() and it is more natural to first 
% list the bin centers.
%
% The vector edges will have length(edges) = length(centers)+1
%
% caa 12/18/06
%
% edges = center2edge(centers)

delta = centers(2)-centers(1);

a = centers(1)-delta/2;

b = centers+delta/2;

edges = [a(:); b(:)];
edges = edges(:)';

return;
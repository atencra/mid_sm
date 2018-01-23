function centers = edge2center(edges)
% edge2center  Convert histogram bin edges to bin centers 
% centers = edge2center(edges) returns the bin centers for the supplied
% bin edges. This is useful when you have the bin edges though you want
% to use bar() or hist().
%
% The vector centers will have length(centers) = length(edges) - 1
%
% caa 12/18/06
%
% centers = edge2center(edges)

centers = ( edges(1:end-1) + edges(2:end) ) / 2;


return;
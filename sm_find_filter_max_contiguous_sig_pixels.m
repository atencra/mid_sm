function [maxcount, indices] = sm_find_filter_max_contiguous_sig_pixels(filter, sigthresh)
% sm_find_filter_max_contiguous_sig_pixels Get number of neighboring pixels in filter matrix
%
%   [maxcount, indices] = sm_find_filter_max_contiguous_sig_pixels(filter, sigthresh)
%
%   Inputs:
%       filter: STA or MID, in matrix form (i.e. nf x nt)
%       sigthresh: percentile threshold to consider
%
%   Outputs:
%       maxcount : 

pkg load image;


if ~exist('sigthresh','var')
    sigthresh = 0;
end



% get absolute threshold
if sigthresh ~= 0
    thresh = prctile(abs(filter(:)), sigthresh); 
    logifilter = abs(filter) >= thresh;
else
    logifilter = abs(filter) > 0;
end

% get labels of contiguous areas
labelmat = bwlabel(logifilter);

% get rid of zeros, vectorize
labelvec = labelmat;
labelvec(labelvec == 0) = [];

% run-length encoding and get max count
[count, idx] = rude(sort(labelvec));
maxcount = max(count);

if maxcount == 0
    indices = [];
else

    % find instances of labels with max contiguous size
    maxidx = idx(count == maxcount);
    indices = cell(length(maxidx),1);

    for i = 1:length(maxidx)
        [tempx, tempy] = find(labelmat == maxidx(i));
        indices{i} = [tempx tempy];
    end
end

end


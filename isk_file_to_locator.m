function locator = isk_file_to_locator(iskfile)
% isk_file_to_locator  Takes an iskfile, returns a spike train vector.
%
% locator = isk_file_to_locator(iskfile)
% ------------------------------------------------------
%
%
% iskfile : created using the function get_locator_for_mid_analysis.m
%       An integer file holding binned spike train data for a single 
%       spike train.
%
% locator : binned spike train vector. 
%
% The isk files are used in the MID analysis.
%
% caa 3/11/09

fid = fopen(iskfile, 'r');

locator = fscanf(fid, '%d');

fclose(fid);

[nr,nc] = size(locator);

if ( nr > nc )
   locator = locator';
end

return

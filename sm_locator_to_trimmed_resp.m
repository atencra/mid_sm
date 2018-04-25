function resp = sm_locator_to_trimmed_resp(locator, nlags)
% sm_locator_to_trimmed_resp Response vector for observation stimulus
% 
%    resp = sm_locator_to_trimmed_resp(locator, nlags)
%    ----------------------------------------------------------------------
%
%    locator is a binned spike train vector.
% 
%    nf : number of frequencies that are desired in the final stimulus matrix.
%    This is usually 25. Thus, if the original stimulus matrix had 33 frequencies,
%    the MNE stimulus has have 25 frequencies.
% 
%    resp : spike train column vector. The number of rows in resp is equal to the
%    number of rows in stim. 
% 



% Process input arguments
narginchk(1,2);

if nargin == 1
    nlags = 20;
end


% Open responses and cut according to # of time lags
resp = locator(nlags:length(locator));
resp = resp(:); % make it a column vector; one response/spike per row

return;
















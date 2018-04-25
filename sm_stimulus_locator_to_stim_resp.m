function [stim, resp] = sm_stimulus_locator_to_stim_resp(stimulus, locator, nf, nlags, x0)
% sm_stimulus_locator_to_stim_resp Stimulus observation matrix and response
% 
%    [stim, resp] = get_mne_stim_resp(stimulus, locator, nf, nlags, x0)
%    ----------------------------------------------------------------------
%
%    stimulus is a matrix that was contained in a *.mat file. Usually stimulus is stored
%    in a file like 'dmr-500flo-20000fhi-4SM-40TM-40db-44khz-10DF-15min_DFt22_DFf7-matrix.mat'
% 
%    locator is a binned spike train vector.
% 
%    nf : number of frequencies that are desired in the final stimulus matrix.
%    This is usually 25. Thus, if the original stimulus matrix had 33 frequencies,
%    the MNE stimulus has have 25 frequencies.
% 
%    nlags : number of time bins of memory for the MNE stimulus. Default is 20.
% 
%    x0 : starting point where frequencies from original stimulus matrix are
%    obtained. Thus, if x0 = 9, and nf = 25, and the original stimulus matrix
%    had 33 frequencies, then rows 9:33 are used to create the MNE stimulus.
%    The default for x0 = nstimfreqs - nf + 1; thus, if the original stimulus
%    had 33 frequencies, and 25 frequencies were requested, then x0 = 9.
% 
%    stim : stimulus matrix where each row corresponds to one trial. One trial
%    is nf x nlags. stim will have dimensions (nf*nlags) X (Nsamples - (nlags-1))
%    where Nsamples is the number of time bins in the original stimulus matrix
% 
%    resp : spike train column vector. The number of rows in resp is equal to the
%    number of rows in stim. 
% 



% Process input arguments

error(nargchk(2,5,nargin));


% Assign missing input args. We assign x0 later, since we need to
% know the number of frequencies in the stimulus if we want to give
% it a default value.
if ( nargin == 2 || nargin == 3 )
   nf = 25; % use 25 frequencies of the stimulus
   nlags   = 20; % use 20 time bins for memory of receptive field
end

if ( nargin == 4 )
   nlags   = 20; % use 20 time bins for memory of receptive field
end


[nstimfreqs, ntimes] = size(stimulus); % dimension of stimulus matrix


% Assign x0 if it wasn't an input argument
if ( nargin == 2 )
   x0 = nstimfreqs - nf + 1;
end


% Get index vector that will be used to cut down stimulus matrix
index_freq = (x0):(nf-1+x0);
stimulus = stimulus(index_freq,:);

Nsamples = length(locator);


% Spike train length must equal stimulus length
if ( ntimes ~= Nsamples )
   error('Number of trials in locator and stimulus do not match.');
end


Ndim    = length(index_freq); % # dimensions per time lag
nf = Ndim; % New # of frequencies


% Make new stimulus matrix, with each row of the matrix equal to 
% the total number of stimulus dimensions. Thus, if there are 
% 25 frequencies and 20 time lags, each row of the new stim matrix
% will have 500 columns.
if ( nlags > 1 )

   Nsamples = Nsamples - (nlags-1);
   Ndimtotal = nf*nlags; % total stimulus dimensions = #freq's by #time lags

   stim = zeros(Nsamples,Ndimtotal);

   for i = 1:Nsamples
      chunk = stimulus(:,i:i+nlags-1);
      stim(i,:) = chunk(:)'; % make a row vector and assign to stim
   end

else % only happens for visual stimuli
    stim = stimulus;
end


% Open responses and cut according to # of time lags
resp = locator(nlags:length(locator));
resp = resp(:); % make it a column vector; one response/spike per row




return;
















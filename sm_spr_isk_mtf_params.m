function [resp, tmfreq, smfreq] = sm_spr_isk_mtf_params(varargin)
%mid_stim_projection_params Projection and Mod values for MID filters and stimulus
%
%    [stim_data, response_data] = mid_stim_projection_params(sprfolder, iskfolder, index)
%    ------------------------------------------------------------------------------------
%    Inputs:
%    Keyword / Value
%    'sprpath' : absolute path spr matrix data.
%    'iskpath' : absolute path to isk file holding binned spike train.
%       
%    Outputs:
%    resp : spike train from iskfile
%    tmfreq : tmf for each stimulus trial
%    smfreq : smf for each stimulus trial
%


narginchk(4,4);

options = struct('sprpath', [], 'iskpath', [], 'tmfreq', [], 'smfreq', []);
options = input_options(options, varargin);

if ( isempty(options.sprpath) )
    error('You must provide the absolute path to the spr file.');
end

if ( isempty(options.iskpath) )
    error('You must provide the absolute path to the isk file.');
end


load(options.sprpath, 'stimulus');

locator = sm_isk_file_to_locator(options.iskpath);

x0 = 1;
[nf, nt] = size(stimulus);
nlags = 20;
[stim, resp] = sm_stimulus_locator_to_stim_resp(stimulus, locator, nf, nlags, x0);


if ( isempty(options.tmfreq) || isempty(options.smfreq) )
    paramfile = strrep(options.sprpath, '-matrix.mat', '_param.mat');
    data = load(paramfile, 'taxis', 'faxis');
    taxis = data.taxis;
    faxis = data.faxis;
    [tmfreq, smfreq] = sm_stim_modulation_params(stim, nf, nlags, taxis, faxis);
else
    tmfreq = options.tmfreq;
    smfreq = options.smfreq;
    assert(length(tmfreq) == length(smfreq), 'tmfreq and smfreq have different lengths.');
    assert(length(tmfreq) == length(resp), 'resp and tmfreq have different lengths.');
end

return;



if exist('stim_data', 'var');

    mid_plot_filters(response_data.sta, ...
        response_data.mid1, ...
        response_data.mid2, ...
        response_data.nt_filter, ...
        response_data.nf_filter, ...
        response_data.synergy);

    mid_plot_resp_projection_modulation(response_data.resp, ...
        response_data.proj_all_sta, ...
        response_data.proj_all_mid1, ...
        response_data.proj_all_mid2, ...
        stim_data.tmfreq, ...
        stim_data.smfreq); 

    return;
end



% 8. Estimate projections of stimulus onto each filter.
[proj_all_sta, proj_spike_sta] = filter_projection_centered_scaled(stim, sta, resp);
[proj_all_mid1, proj_spike_mid1] = filter_projection_centered_scaled(stim, mid1, resp);
[proj_all_mid2, proj_spike_mid2] = filter_projection_centered_scaled(stim, mid2, resp);



% 9. Plot spike train, projection values, and modulation values
mid_plot_resp_projection_modulation(resp, proj_all_sta, proj_all_mid1, proj_all_mid2, tmfreq, smfreq) 



% Assign data to output variable if requested by user.

if ( (nargout == 1) | (nargout == 2) )
    stim_data.sprfile = sprfile;
    stim_data.nt_filter = nlags;
    stim_data.nf_filter = nf_filter;
    stim_data.stim = stim;
    stim_data.tmfreq = tmfreq;
    stim_data.smfreq = smfreq;
end



if nargout == 2
    response_data.index = index;
    response_data.sprfile = sprfile;
    response_data.iskfile = iskfile;
    response_data.resp = resp;
    response_data.nt_filter = nlags;
    response_data.nf_filter = nf_filter;
    response_data.taxis = taxis;
    response_data.faxis = faxis;
    response_data.sta = sta;
    response_data.mid1 = mid1;
    response_data.mid2 = mid2;
    response_data.info1 = info1;
    response_data.info2 = info2;
    response_data.info12 = info12;
    response_data.synergy = synergy;
    response_data.proj_all_sta = proj_all_sta;
    response_data.proj_all_mid1 = proj_all_mid1;
    response_data.proj_all_mid2 = proj_all_mid2;
end



% If you want to see the nonlinearity for a filter, issue
% the following commands. (Here 'v' is sta, mid1, or mid2).
%
%nbins = 15; % number of bins in the nonlinearity
%[x, px, pxspk, pspk, pspkx] = stim_resp_sta_fio(v, stim, resp, nbins);
%

return;



% ------------------------------------------------------------
% Function definitions
% ------------------------------------------------------------


function iskfile = mid_data_to_iskfile(midpos, midts, iskfolder)
% mid_data_to_iskfile Construct isk file name from mid data struct

iskfile = sprintf('%s-site%0.f-%.0fum-%.0fdb-%s-fs*-%.0f.isk', ...
midpos(1).exp, midpos(1).site, midpos(1).depth, midpos(1).atten, ...
midpos(1).stim, midts(1).unit);
datafile = fullfile(iskfolder, iskfile);


disk = dir(datafile);

if ~isempty(disk)
    iskfile = disk.name;
else
    error('That isk file does not exist in the iskfolder.');
end

return;



function [proj_prior, proj_posterior] = filter_projection_centered_scaled(stim, v, resp)
%filter_projection_centered_scaled Projection values from stimulus, filter and spike train
%    
%    [proj_prior, proj_posterior] = filter_projection_centered_scaled(stim, v, resp)
%    
%    stim : stimulus, with dimension Ntrials X Ndims. where Ndims = size(v,1)*size(v,2)
%    
%    resp : binned spike train. length(resp) = Ntrials.
%    
%    proj_prior : all projection values. length(proj_prior) = length(resp) = Ntrials.
%
%    proj_posterior : projection values corresponding to a spike.
%       length(proj_posterior) = sum(resp) = number of spikes


projection = stim * v;

sd_proj = std(projection(:));
mn_proj = mean(projection(:));
proj_prior = (projection - mn_proj) ./ sd_proj;
proj_posterior = proj_prior(resp>0);

return;





function  mid_plot_filters(sta, mid1, mid2, nt_filter, nf_filter, synergy)
%mid_plot_filters Display sta, mid1, and mid2 filter
%
%    mid_plot_filters(sta, mid1, mid2, nt_filter, nf_filter) 
%    ---------------------------------------------------------------------
%    
%    sta, mid1, mid2 : Estimated filters from MID analysis. Column vectors.
%
%    nt_filter : number of time bins in filter.
%
%    nf_filter : number of frequency bins in filter.
%    


% Check input arguments
narginchk(5,6);


% Plot the data
hf2 = figure;

subplot(3,1,1);
imagesc(reshape(sta, nf_filter, nt_filter));
title('STA');

subplot(3,1,2);
imagesc(reshape(mid1, nf_filter, nt_filter));
if nargin == 5
    title('MID1');
else
    title(sprintf('MID1 - Synergy = %.2f', synergy));
end


subplot(3,1,3);
imagesc(reshape(mid2, nf_filter, nt_filter));
title('MID2');

ss = get(0, 'screensize');
set(hf2,'position', [0.8*ss(3) 0.1*ss(4) 0.1*ss(3) 0.6*ss(4)]);

return;




function mid_plot_resp_projection_modulation(resp, proj_all_sta, proj_all_mid1, proj_all_mid2, tmfreq, smfreq) 
%mid_plot_resp_projection_modulation Plot spike train, projections, and stimulus modulation parameters
%    
%    mid_plot_resp_projection_modulation(resp, proj_all_sta, proj_all_mid1, proj_all_mid2, tmfreq, smfreq) 
%    ------------------------------------------------------------------------------------------------
%    
%    resp : binned spike containing 0s and 1s
%    
%    proj_all_* : projection values for sta, mid1, or mid2
%    
%    tmfreq : temporal modulation values for stimulus
%    
%    smfreq : spectral modulation values for stimulus
%    


% Check input arguments
narginchk(6,6);

if ( isempty(resp) )
    error('resp input argument is empty.');
elseif isempty(proj_all_sta) 
    error('proj_all_sta input argument is empty.');
elseif isempty(proj_all_mid1)
    error('proj_all_mid1 input argument is empty.');
elseif isempty(proj_all_mid2) 
    error('proj_all_mid2 input argument is empty.');
elseif isempty(tmfreq) 
    error('tmfreq input argument is empty.');
elseif isempty(smfreq) 
    error('smfreq input argument is empty.');
end

% Check and see if each input has the same length.
if ( (length(resp) + length(proj_all_sta) + length(proj_all_mid1) + ...
      length(proj_all_mid2) + length(tmfreq) + length(smfreq)) ~= 6*length(resp) )
    warning('Number of time bins in input arguments do not match.');
end

index = 20000:21000;

% Plot the data
hf = figure;

max_proj = max([proj_all_sta(:)' proj_all_mid1(:)' proj_all_mid2(:)']);
min_proj = min([proj_all_sta(:)' proj_all_mid1(:)' proj_all_mid2(:)']);

subplot(6,1,1);
stem(resp(index), 'filled', 'color', 'r', 'markersize', 0, 'linewidth', 2);
ylim([0 1.1]);
ylabel('Spike');


subplot(6,1,2);
plot(proj_all_sta(index))
ylim([min_proj max_proj]);
ylabel('STA Proj')


subplot(6,1,3);
plot(proj_all_mid1(index))
ylim([min_proj max_proj]);
ylabel('MID1 Proj')


subplot(6,1,4);
plot(proj_all_mid2(index))
ylim([min_proj max_proj]);
ylabel('MID2 Proj')


subplot(6,1,5);
plot(tmfreq(index))
ylabel('TMF (cyc/s)');


subplot(6,1,6);
plot(smfreq(index))
ylabel('SMF (cyc/oct)');

ss = get(0, 'screensize');
set(hf,'position', [ss(3)*0.1 ss(4)*0.1 0.8*ss(3) 0.8*ss(4)]);

return;











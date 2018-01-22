function [x0, locator] = mid_get_x0_locator_for_mid_submission(sprfile, spk, trigger, x0)
% sm_dir_get_x0_for_mid_submission Select frequency for MID analysis
%
% sm_dir_get_x0_for_mid_submission(stimfolder)
%
% For MID analysis, a subset of the frequency of the envelope is used.
% This function allows you to manually select the portion that will be used
% in the MID analysis.
%
% The function expects the current directory to hold *-spk-strfcmb.mat files.
%
% stimfolder holds stimulus files that will be used to calculate MIDs.
% The folder holds downsampled versions of ripple stimuli. The stimuli
% were downsampled to allow the MID to calculate filters with a reasonable 
% number of parameters. 
%
% For rat plasticity experiments, stimuli were downsampled to by a factor
% of 10 along the time axis and a factor of 8 along the frequency axis. This
% gives 5 ms resolution in time, and 6 frequencies per octave spectrally.
% 
%       stimfolder = 'D:\TM_Plasticity_Project_Physiology\Stimuli_Downsampled';
%
%
% When you run the function, the STA is estimated and shown. You then select
% the lowest index that provides a bound on the STA. The upper bound is 
% automatically selected because only 25 frequency values are allowed.
%
% Upon completion, for every spike train in *-spk-strfcmb.mat, there will
% be a corresponding file with 'x0' in it. These values are used by 
% tmp_dir_make_mid_submission.m to create the MID analysis submission
% files that will be used on the QB3 computer cluster.

library('stimbox');
library('midbox');

dsfile = strrep(sprfile, '.spr', '-matrix.mat');

load(dsfile,'stimulus');

fsad = spk.fs;
spiketimes = spk.spiketimes;
spet = round(spiketimes / 1000 * fsad);
spet = spet(:)';

t1 = 0.1;
t2 = 0.1;

% Get binned spike train
[taxis, faxis, locator, numspikes, averate, locator_ipsi] = ...
    get_locator_for_mid_analysis(sprfile, t1, t2, spet, trigger, fsad);

% Check to make sure that the locator and the stimulus have ...
% the same number of trials
if ( length(locator) ~= length(stimulus(1,:)) )
    error('spike train and stimulus must have same number of trials.');
end


% Plot the STA to select x0
sta = get_sta_from_locator(locator, stimulus, 20);
fig = figure;
subplot(1,1,1);
hold on;
imagesc(sta);
axis xy;
xlim([0 size(sta,2)+1]);
ylim([0 size(sta,1)+1]);


if ( nargin == 3 )
    [xindex, yindex] = ginput(1);
    yindex = ceil(yindex);

    [nf,nt] = size(sta);
    if ( yindex+25-1 > nf )
        yindex = nf - 25 + 1;
    end 
    x0 = yindex;

    %subplot(1,2,2);
    %imagesc(sta(yindex:yindex+25-1,:));
end


index = x0:x0+25-1;
fprintf('x0 = %.0f\n\n', x0); 
fprintf('index min = %.0f\n\n', min(index)); 
fprintf('index max = %.0f\n\n', max(index)); 

plot([1 size(sta,2)], [min(index) min(index)], 'k-');
plot([1 size(sta,2)], [max(index) max(index)], 'k-');


return;







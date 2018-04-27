function ITtrigger = sm_parse_repeat_trigger(trigstruct)

nreps = 50;
fs = trigstruct.fs;
trigger = trigstruct.trig_smpl;
stimlen_ms = 30 * 1000;

% triple trigger: inter-trigger interval < 60ms
tripletrigthresh = round(60/1000*fs);
tripletrigidx = logical([0 diff(trigger) < tripletrigthresh]);

% remove 2nd and 3rd triggers of triple trigger
trigger(tripletrigidx) = [];

% inter trial trigger: inter-trigger interval > 1s
ITthresh = fs; 
ITidx = find(diff(trigger) > ITthresh) + 1;

% find start of each trial
ITtrigger = zeros(nreps, 2);
ITtrigger(:,1) = trigger([1; ITidx']);

% convert to ms
ITtrigger(:,1) = ITtrigger(:,1)/fs*1000;

% mark end of trial as 30s from first trigger of each trial (note that this
% includes ~333 ms of dead time at the end of each trial since actual
% stimulus length is 29.67s)
ITtrigger(:,2) = ITtrigger(:,1) + stimlen_ms;
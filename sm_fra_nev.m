function fra = sm_fra_nev(spiketimes, triggers, start, stop, params)

% generate a tuning matrix and plot it if required. tuning curves are based on
% 3 repeats of 60 frequencies at 15 attenuation values.

% START and STOP define the analysis window borders in ms (e.g., 0, 100)
% PLOTFLAG should be set to 1 to plot the results.

% load the parameter file
%load tcparams

% params =
%       dur: [2700x1 double]
%       isi: [2700x1 double]
%      freq: [2700x1 double]
%     atten: [2700x1 double]
% dur is uniformly 50 ms. isi is uniformly 300 ms.

fprintf('%s\n', mfilename);

plotflag = 0;


tuning_matrix = [];

% check that the filetype is appropriate

if length(triggers) ~= 2700
    error('Unexpected trigger count');
end

sweeplen   = diff(triggers);
stimdur    = sweeplen(2);
nreps      = 3;

% get spiketimes relative to the beginning of each sweep
sweep = [];
for tt = 1:length(triggers),
    spkind = find(spiketimes >= triggers(tt) & spiketimes < triggers(tt)+stimdur);
    sweep(tt).spikes = spiketimes(spkind) - triggers(tt);
end %tt
nevstruct.sweep = sweep;

% simplify the variable names...
for ii=1:length(nevstruct.sweep)
    rasters{ii} = nevstruct.sweep(ii).spikes;
end

% generate lists of stimulus parameters
freqlist    = unique(params.freq);
attenlist   = unique(params.atten);

% find the indices for each unique stimulus.
for qq=1:length(freqlist)
    for ww=1:length(attenlist)
        fmindx{qq,ww} = intersect(find(params.freq==freqlist(qq)), ...
            find(params.atten==attenlist(ww)));
        psth = horzcat(rasters{fmindx{qq,ww}});
        psth = psth(intersect(find(psth > start), find(psth < stop)));
        spkcount(qq,ww) = length(psth); % db by rows, freq by columns
        % store stimulus values
        freqdx(qq,ww) = freqlist(qq);
        dbdx(qq,ww)   = attenlist(ww);
    end
end

% convert to spikes per second (divide by trials and duration (s))
spkrate = spkcount./(nreps*(stop-start)./1000);

% return a 3 column matrix with the counts and stimulus values...
dbvec    = reshape(dbdx,900,1);
freqvec  = reshape(freqdx,900,1);
countvec = reshape(spkcount,900,1);
ratevec  = reshape(spkrate,900,1);
tuning_matrix = [freqvec,dbvec,ratevec];

fra.atten = dbvec;
fra.freq = freqvec;
fra.spkcount = countvec;
fra.spkrate = ratevec;


if plotflag
    
    imagesc(flipud(spkrate')); axis square;
    colormap(flipud(gray)); colorbar;
    xlabel('Frequency (kHz)')
    ylabel('Level (dB)')
    set(gca,'ydir', 'normal')
    set(gca,'ytick',1:2:15,'yticklabel',attenlist(1:2:15))
    set(gca,'xtick',6:10:60,'xticklabel',round(freqlist(6:10:60)/1000,0))
    
end


return;



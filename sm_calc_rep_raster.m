function raster = sm_calc_rep_raster(nevstruct,trigstruct,binsize_ms)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

nreps = 50;
spktimes = nevstruct.tspk_ms;
stimlen_ms = 30000;

ITtrigger = sm_parse_repeat_trigger(trigstruct);

spktimes_trial = cell(nreps,1);

% get spike times for each trial, and then subtract the start trigger to
% get spike times relative to the start of each trial
for i = 1:length(spktimes_trial)
    spktimes_trial{i} = spktimes(spktimes >= ITtrigger(i,1) & spktimes <= ITtrigger(i,2)) - ITtrigger(i,1);
end


edges = 0:binsize_ms:stimlen_ms;

raster = zeros(length(spktimes_trial),length(edges));

for i = 1:length(spktimes_trial)
    if ( length(spktimes_trial{i})>1 )
        raster(i,:) = histc(spktimes_trial{i},edges);
    end
end


%%raster = cell2mat(cellfun(@(x) histcounts(x, edges), spktimes_trial, 'UniformOutput', 0));
%raster = cell2mat(cellfun(@(x) histc(x, edges), spktimes_trial, 'UniformOutput', 0));

end


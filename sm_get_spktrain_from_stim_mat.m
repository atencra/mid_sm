function spktrain = sm_get_spktrain_from_stim_mat(nevstruct, trigstruct, stim_mat)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

spktimes = nevstruct.tspk_ms;
trig_ms = trigstruct.trig_ms;

N = size(stim_mat,2)/length(trig_ms);    
    
if mod(N,1) ~= 0
    warning('Something''s wrong, skipping...')
    spktrain = [];
    return
end

max_trig_diff = max(diff(trig_ms));
trig_ms = [trig_ms trig_ms(end) + max_trig_diff];
trig_diff = diff(trig_ms);
trig_step = trig_diff/N;

edges = unique(cell2mat(arrayfun(@(x,y,z) x:z:y, trig_ms(1:end-1),...
    trig_ms(2:end),trig_step,'UniformOutput',0)));

spktrain = histcounts(spktimes, edges);


end


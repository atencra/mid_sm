function [tmf_trial, smf_trial] = sm_stim_modulation_params(stim, nf, nlags, taxis, faxis)
% sm_stim_modulation_params Peak temporal/spectral modulation value in stimulus
%
%    [tmf_trial, smf_trial] = sm_stim_modulation_params(stim, nf, nlags, taxis, faxis)
%    
%    stim : Ntrials x Ndim stimulus matrix. Each row is one stimulus trial.
%    
%    nf : number of frequencies in stimulus trial.
%    
%    nlags : number of time bins in each strial.
%    
%    taxis : temporal axis of stimulus or filter.
%    
%    faxis : spectral axis of stimulus or filter.
%
%    tmf_trial : peak temporal modulation value during the stimulus trial.
%    smf_trial : peak spectral modulation value.
%    



tmf_trial = zeros(size(stim,1),1);
smf_trial = zeros(size(stim,1),1);

maxtm = 150;
maxsm = 4;

dt = taxis(2) - taxis(1);
doct = log2(faxis(2)/faxis(1));

maxtm = 1 / dt / 2;
maxsm = 1 / doct / 2;

for i = 1:size(stim,1)

    trialmat = reshape(stim(i,:)', nf, nlags);
    [tmf, xmf, rtf] = sm_mtf_sta2rtf(trialmat, taxis, faxis, maxtm, maxsm);
    [rtf_fold, tmf_mtf, tmtf, smf_mtf, smtf] = sm_mtf_rtf2mtf(rtf, tmf, xmf);

    [indfmax, indtmax] = find(rtf == max(rtf(:)));
    xmf_max = max(xmf(indfmax));
    tmf_max = max(tmf(indtmax));


    % Uncomment the following to see the stimulus, the rtf, and
    % the estimated peak tmf and smf
%    clf(hf);
%    subplot(2,1,1);
%    imagesc(trialmat);
%
%    subplot(2,1,2);
%    imagesc(tmf, xmf, rtf);
%    title(sprintf('TBMF = %.2f, SBMF = %.2f', tmf_max, xmf_max));
%    pause(0.05); 

    tmf_trial(i) = tmf_max;
    smf_trial(i) = xmf_max;

end

return;



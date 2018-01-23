% [taxis, faxis, locator, numspikes, averate] = ...
%     get_locator_for_mid_analysis(specfile, t1, t2, spet, trigger, fss)
%
% Obtain spike train locator for Maximally Informative Dimensions Analysis.
%
%  specfile       :  Spectral Profile File ( *.spr file )
%  t1, t2         :  Evaluation delay interval for STRF(T,F), in seconds
%                    T E [- T1 , T2 ], Note that T1 and T2 > 0
%  spet           :  Array of spike event times in sample number
%  trigger        :  Array of Trigger Times
%  fss            :  Sampling Rate for TRIGGER and SPET
%
%  RETURNED VALUES 
%
%  taxis      : Time Axis (is sec)
%  faxis      : Frequency Axis (in Hz)
%  locator    : spike train binned at the resolution of specfile
%  numspikes  : Number of spikes used in strf
%  averate    : average firing rate (spikes / sec)
%
%
% To obtain the output variables two files need to be placed in the same
% folder. One is the specfile, which is named as *.spr. The other file
% is a parameter file that is named as *_param.mat file. 
%
%
% Here specfile is the spr envelope file, 0.05 specifies the noncausal
% extent of the strf, in seconds, and 0.2 specifies the causal portion 
% of the strf, in seconds. For a faster estimate with fewer dimensions the
% values may be changed to 0.0 and 0.080.
%
% spet is the spike times in sample number, created via the
% following command: spet = spk(i).spiketimes / 1000 * fss, where spk is
% a data structure holding spike time information, with spike times in
% msec's.
%
% trigger is a vector of trigger times, in sample number.
% The triggers are included because the sampling rate of the sound and the 
% spike times are different, and also because the envelope file has been
% downsampled. The triggers help us line up the spike times with the
% appropriate bins of the envelope, from which we estimate get the 
% binned spike train.
% 
function [taxis, faxis, locator, numspikes, averate, locator_ipsi] = ...
   get_locator_for_mid_analysis(specfile, t1, t2, spet, trigger, fss)


numtrig = length(trigger);

% Loading Parameter Data
index = findstr(specfile,'.spr');
paramfile = [specfile(1:index(1)-1) '_param.mat'];
f = ['load ' paramfile];
eval(f);

% Clear possible useless variables in the param file
clear App MaxFM XMax Axis MaxRD RD f phase Block Mn RP f1 
clear f2 Mnfft FM N fFM fRD NB NS LL filename M X fphase Fsn


% Flipping Trig and Spet for channel 1 STRF
mintime = min([trigger spet]);
maxtime = max([trigger spet]);
spet = spet - mintime + 1;
trigger = trigger - mintime + 1;

% Converting Temporal Delays to Sample Numbers
n1 = round( t1 * Fs / DF);
n2 = round( t2 * Fs / DF);

% % Initializing Some Variables
% numspikes = 0;  % Number of Spikes

Ntrials = NT*numtrig; % newnt=320;

locator = zeros(Ntrials,1);
locator_ipsi = zeros(Ntrials,1);

for trigcount = 2:length(trigger)-1 

% 		index1 = find(spet>=Trig(TrigCount) & spet<Trig(TrigCount+1));
% 		spettrig1 = ceil( (spet(index1)-Trig(TrigCount)+1) * Fs / Fss /DF );
% 		
% 		index2 = find(spet>Trig(NTrig-TrigCount+1) & spet<=Trig(NTrig-TrigCount+2));
% 		spettrig2 = ceil( (Trig(NTrig-TrigCount+2)+1-spet(index2)) * Fs / Fss /DF );
% 
% 		index2 = find(spet>trigger(numtrig-trigcount+1) & spet<=trigger(numtrig-trigcount+2));
% 		spettrig2 = ceil( (Trig(numtrig-trigcount+2)+1-spet(index2)) * Fs / Fss /DF );


    % Finding SPET in between triggers and resampling spet relative to the 
    %    Spectral Profile samples
    index = find( spet>=trigger(trigcount) & spet<trigger(trigcount+1) );
    spettrig = ceil( (spet(index)-trigger(trigcount)+1) * Fs / fss / DF );
   

	index2 = find(spet>trigger(numtrig-trigcount+1) & spet<=trigger(numtrig-trigcount+2));
	spettrig2 = ceil( (trigger(numtrig-trigcount+2)+1-spet(index2)) * Fs / fss /DF );


    for k = 1:length(spettrig)
        spike = spettrig(k);
% [trigcount NT (trigcount-1)*NT spike spike+(trigcount-1)*NT]
% pause
        locator(spike+(trigcount-1)*NT) = locator(spike+(trigcount-1)*NT)+1;
    end


%     for k = 1:length(spettrig2)
%         spike2 = spettrig2(k);
% [trigcount NT (trigcount-1)*NT spike2 spike2+(trigcount-1)*NT]
% pause
%         locator_ipsi(spike2+(trigcount-1)*NT) = locator_ipsi(spike+(trigcount-1)*NT)+1;
%     end
%
%
% 		for k=1:length(spettrig1)
% 			L=spettrig1(k);
% 			%Averaging Pre-Event Spectral Profiles
% 			if L < N2
% 				STRF1=STRF1+ MdB*[S1(:,M-(N2-L-1):M) S2(:,1:L+N1)] - RMSP;
% 			elseif L+N1 > M
% 				STRF1=STRF1+ MdB*[S2(:,L-N2+1:M) S3(:,1:N1-M+L)] - RMSP;
% 			else
% 				STRF1=STRF1+ MdB*[S2(:,L-N2+1:L+N1)] - RMSP;
% 			end
% 		end
% 
% 		%Finding Receptive Field for Channel 2
% 		for k=1:length(spettrig2)
% 			L=spettrig2(k);
% 			%Averaging Pre-Event Spectral Profiles
% 			if L < N1
% 				STRF2=STRF2+ MdB*[S1(:,M-(N1-L-1):M) S2(:,1:L+N2)] - RMSP;
% 			elseif L+N2 > M
% 				STRF2=STRF2+ MdB*[S2(:,L-N1+1:M) S3(:,1:N2-M+L)] -RMSP;
% 			else
% 				STRF2=STRF2+ MdB*[S2(:,L-N1+1:L+N2)] - RMSP;
% 			end
% 		end

    
end % (while ~feof(fid) & trigcount<length(trigger)-1 )

% Closing all opened files
fclose('all');

[n, nt, nf] = ripple_stim_length(specfile);

index_min = min( [length(locator) n/nf] );
locator = locator( 1:index_min );
locator_ipsi = locator_ipsi( 1:index_min );


numspikes = sum(locator);
stim_duration = ( max(trigger) - min(trigger) ) / fss;
averate = numspikes / stim_duration;

% get time and frequency axes for the receptive field
faxis = faxis;
taxis = (-n1:n2-1) / (Fs/DF);








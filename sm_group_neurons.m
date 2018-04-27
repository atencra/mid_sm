function smgroup = sm_group_neurons(STTC_info)

smgroup.group1 = []; %normal cells with MID1 (and STA) only
smgroup.group2 = []; %normal cells with MID1 and MID2
smgroup.group3 = []; %'complex cells' with no MID2
smgroup.group4 = []; %'complex cells' with MID2
smgroup.group5 = []; %strange cells: reliable repeats but no filters whatsoever
smgroup.group6 = []; %no auditory preferences
% smgroup.ungrouped = []; %temp placeholder for debugging

% sttcthresh = 70;
% staprcthresh = 60;
mid1prcthresh = 50;
mid2prcthresh = 80;

% STTCthresh = prctile(cellfun(@mean, {STTC_info.STTC}), sttcthresh);
% STTCthresh = 0.05;
% staPTDthresh = prctile([STTC_info.sta_ptd], staprcthresh);
PSTHcorrthresh = 0.3;
mid1PTDthresh = prctile([STTC_info.mid1_ptd], mid1prcthresh);
mid2PTDthresh = prctile([STTC_info.mid2_ptd], mid2prcthresh);
% stainfothresh = prctile(cellfun(@mean, {STTC_info.info0_extrap_test}), staprcthresh);
mid1infothresh = prctile(cellfun(@mean, {STTC_info.info1_extrap_test}), mid1prcthresh);
mid2infothresh = prctile(cellfun(@mean, {STTC_info.info2_extrap_test}), mid2prcthresh);

mid1contigfiltthresh = 4;
mid2contigfiltthresh = 5;
contigprctile = 95;
mid1nlthresh = 4; % specifically for non-symmetric mid1/sta
mid2nlthresh = 7; % out of 13 since we remove the 2 extreme points

% Symmetry threshold
symthresh = prctile(abs(cellfun(@(x) (sum(x(9:14)) - sum(x(2:7)))/...
    (sum(x(9:14)) + sum(x(2:7))), {STTC_info.mid1_fio})), 40); 
MID1symmethod = @(x)(sum(x(9:14)) - sum(x(2:7)))/(sum(x(9:14)) + sum(x(2:7))); 

% STA, MID1 correlation
stamidcorrthresh = prctile(abs(cellfun(@(x,y) corr(x(:),y(:)),...
    {STTC_info.filter_mean_sta}, {STTC_info.filter_mean_test2_v1})), 80);


% find group 5 cells first:
for i = 1:length(STTC_info)
%     
%     if i == 2
%         keyboard
%     end
        
    %basic tests on sta and mid1
%     STAinfo = mean(STTC_info(i).info0_extrap_test);
    MID1info = mean(STTC_info(i).info1_extrap_test);
    
%     STAptd = STTC_info(i).sta_ptd;
    MID1ptd = STTC_info(i).mid1_ptd;
    
%     STAcontig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_sta, contigprctile);
    MID1contig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_test2_v1, contigprctile);
    
%     STAnl = sum(STTC_info(i).sta_fio(2:end-1) > STTC_info(i).pspk);
    MID1nl = sum(STTC_info(i).mid1_fio(2:end-1) > STTC_info(i).pspk);
    
%     STAcond = sum([STAinfo>=stainfothresh, STAptd>=staPTDthresh,...
%         STAcontig>=contigfiltthresh, STAnl>=nlthresh]) >= 3;
    MID1cond = MID1contig>=mid1contigfiltthresh & MID1nl>=mid1nlthresh; %& (MID1info>=mid1infothresh || MID1ptd>=mid1PTDthresh);
    PSTHcorr = mean(STTC_info(i).mean_PSTHcorr);
    
%     if i == 4
%         keyboard
%     end      
    
    % look for groups 5 and 6 first
    if ~MID1cond
        % if STTC is 'high enough', assign to group 5
        if PSTHcorr >= PSTHcorrthresh
            smgroup.group5 = [smgroup.group5 i];
        % otherwise, neuron has no auditory preferences
        else
            smgroup.group6 = [smgroup.group6 i];
        end
    % everything else in groups 1 to 4
    else
        % MID1 symmetry and STA-MID1 correlation checks
        MID1sym = abs(MID1symmethod(STTC_info(i).mid1_fio)) < symthresh;
        stamidcorr = abs(corr(STTC_info(i).filter_mean_sta(:),...
            STTC_info(i).filter_mean_test2_v1(:))) < stamidcorrthresh;
        
        % MID2 checks
        MID2info = mean(STTC_info(i).info2_extrap_test);
        MID2ptd = STTC_info(i).mid2_ptd;
        MID2contig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_test2_v2, contigprctile);
        MID2nl = sum(STTC_info(i).mid2_fio(2:end-1) > STTC_info(i).pspk);
        MID2cond = (MID2info>=mid2infothresh | MID2ptd>=mid2PTDthresh) &...
            MID2contig>=mid2contigfiltthresh & MID2nl>=mid2nlthresh;       
        
        
        % groups 3 and 4
        if MID1sym && MID1nl>=mid2nlthresh && (MID1info>=mid1infothresh*2 || MID1ptd>=mid1PTDthresh*2) && MID1contig>=6
            if MID2cond
                smgroup.group4 = [smgroup.group4 i];
            else
                smgroup.group3 = [smgroup.group3 i];
            end     

        % groups 1 and 2
        elseif ~MID1sym 
            if MID2cond
                smgroup.group2 = [smgroup.group2 i];
            else
                smgroup.group1 = [smgroup.group1 i];
            end
        % for troubleshooting
        elseif PSTHcorr >= PSTHcorrthresh
            % final catch before depositing into group 5
            if MID1contig>= mid1contigfiltthresh && (MID1info>=mid1infothresh || MID1ptd>=mid1PTDthresh)
                smgroup.group1 = [smgroup.group1 i];
            else
                smgroup.group5 = [smgroup.group5 i];
            end
        else
            smgroup.group6 = [smgroup.group6 i];
        end
        
    end
end
function [smgroups, groupcounts] = sm_group_neurons(STTC_info, fioparams, sminfo, filestr)
% sm_group_neurons Squirrel neuron groups based on psth responses and filters
% 
%     [smgroups, groupcounts] = sm_group_neurons(STTC_info)
% 
%     STTC_info : struct array holding mid calculations and psth for repeated
%         ripple stimulus responses
% 
%     smgroups : same as STTC_info, but with the group of each neuron added as a field
% 
%     groupcounts : struct, with fields for each of the 6 counts. Each field holds
%         a vector, where elements are the index into STTC_info
% 
%     The 6 groups are:
% 
%     group1 : normal cells with MID1 (and STA) only
%     group2 : normal cells with MID1 and MID2
%     group3 : 'complex cells' with no MID2
%     group4 : 'complex cells' with MID2
%     group5 : strange cells: reliable repeats but no filters whatsoever
%     group6 : no auditory preferences

narginchk(1,4);

if ( nargin==2 | nargin==3 )
    error('Need 1 or 4 inputs args.');
end


if ( nargin == 1 )

    groupcounts.group1 = []; %normal cells with MID1 (and STA) only
    groupcounts.group2 = []; %normal cells with MID1 and MID2
    groupcounts.group3 = []; %'complex cells' with no MID2
    groupcounts.group4 = []; %'complex cells' with MID2
    groupcounts.group5 = []; %strange cells: reliable repeats but no filters whatsoever
    groupcounts.group6 = []; %no auditory preferences
    % groupcounts.ungrouped = []; %temp placeholder for debugging


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
    contigthresh = 6;
    mid1nlthresh = 4; % specifically for non-symmetric mid1/sta     C   
    mid2nlthresh = 7; % out of 13 since we remove the 2 extreme points

    % Symmetry threshold
    mid1nl_percentile = 40;
    symthresh = prctile(abs(cellfun(@(x) (sum(x(9:14)) - sum(x(2:7)))/...
        (sum(x(9:14)) + sum(x(2:7))), {STTC_info.mid1_fio})), mid1nl_percentile); 

    MID1symmethod = @(x)(sum(x(9:14)) - sum(x(2:7)))/(sum(x(9:14)) + sum(x(2:7))); 

    % STA, MID1 correlation
    stamidcorr_percentile = 80;
    stamidcorrthresh = prctile(abs(cellfun(@(x,y) corr(x(:),y(:)),...
        {STTC_info.filter_mean_sta}, {STTC_info.filter_mean_test2_v1})), stamidcorr_percentile);


    % find group 5 cells first:
    smgroups = STTC_info;

    fields_keep = {'longfile', 'repfile', 'sprfile'};

    fields_all = fieldnames(smgroups);

    fields_remove = setdiff(fields_all, fields_keep);

    smgroups = rmfield(smgroups, fields_remove);



    for i = 1:length(STTC_info)

        group = [];
    %     
    %     if i == 2
    %         keyboard
    %     end
            
        %basic tests on sta and mid1
        STAinfo = mean(STTC_info(i).info0_extrap_test);
        MID1info = mean(STTC_info(i).info1_extrap_test);
        
        STAptd = STTC_info(i).sta_ptd;
        MID1ptd = STTC_info(i).mid1_ptd;
        
        STAcontig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_sta, contigprctile);

        MID1contig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_test2_v1, contigprctile);
        
        STAnl = sum(STTC_info(i).sta_fio(2:end-1) > STTC_info(i).pspk);
        MID1nl = sum(STTC_info(i).mid1_fio(2:end-1) > STTC_info(i).pspk);
        
        STAcond = sum([STAinfo>=stainfothresh, STAptd>=staPTDthresh,...
            STAcontig>=contigfiltthresh, STAnl>=nlthresh]) >= 3;

        MID1cond = MID1contig>=mid1contigfiltthresh & MID1nl>=mid1nlthresh; %& (MID1info>=mid1infothresh || MID1ptd>=mid1PTDthresh);

        PSTHcorr = mean(STTC_info(i).mean_PSTHcorr);
        

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


        % look for groups 5 and 6 first
        if ~MID1cond
            % if STTC is 'high enough', assign to group 5
            if PSTHcorr >= PSTHcorrthresh
                groupcounts.group5 = [groupcounts.group5 i];
                group = 5;
            % otherwise, neuron has no auditory preferences
            else
                groupcounts.group6 = [groupcounts.group6 i];
                group = 6;
            end
        % everything else in groups 1 to 4
        else

            % MID1 symmetry and STA-MID1 correlation checks
            % MID1sym = abs(MID1symmethod(STTC_info(i).mid1_fio)) < symthresh;
            % stamidcorr = abs(corr(STTC_info(i).filter_mean_sta(:),...
            %   STTC_info(i).filter_mean_test2_v1(:))) < stamidcorrthresh;
            
            % MID2 checks
            % MID2info = mean(STTC_info(i).info2_extrap_test);
            % MID2ptd = STTC_info(i).mid2_ptd;
            % MID2contig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_test2_v2, contigprctile);
            % MID2nl = sum(STTC_info(i).mid2_fio(2:end-1) > STTC_info(i).pspk);
            % MID2cond = (MID2info>=mid2infothresh | MID2ptd>=mid2PTDthresh) & MID2contig>=mid2contigfiltthresh & MID2nl>=mid2nlthresh;       
            
            
            % groups 3 and 4
            if ( MID1sym && MID1nl>=mid2nlthresh && (MID1info>=mid1infothresh*2 || MID1ptd>=mid1PTDthresh*2) && MID1contig>=MID1contigfiltthresh )
                if MID2cond
                    groupcounts.group4 = [groupcounts.group4 i];
                    group = 4;
                else
                    groupcounts.group3 = [groupcounts.group3 i];
                    group = 3;
                end     

            % groups 1 and 2
            elseif ~MID1sym 
                if MID2cond
                    groupcounts.group2 = [groupcounts.group2 i];
                    group = 2;
                else
                    groupcounts.group1 = [groupcounts.group1 i];
                    group = 1;
                end
            % for troubleshooting
            elseif PSTHcorr >= PSTHcorrthresh
                % final catch before depositing into group 5
                if MID1contig>= mid1contigfiltthresh && (MID1info>=mid1infothresh || MID1ptd>=mid1PTDthresh)
                    groupcounts.group1 = [groupcounts.group1 i];
                    group = 1;
                else
                    groupcounts.group5 = [groupcounts.group5 i];
                    group = 5;
                end
            else
                groupcounts.group6 = [groupcounts.group6 i];
                group = 6;
            end
            
        end

        if isempty(group)
            error(sprintf('No group assigned for neuron #%.0f', i));
        else

            if group == 1
                grouplabel = 'STA, MID1, no MID2'; % normal cells with MID1 (and STA) only
            elseif group == 2
                grouplabel = 'STA, MID1, MID2'; % normal cells with MID1 and MID2
            elseif group == 3
                grouplabel = 'no STA, MID1, no MID2'; % 'complex cells' with no MID2
            elseif group == 4
                grouplabel = 'no STA, MID1, MID2'; % 'complex cells' with MID2
            elseif group == 5
                grouplabel = 'no STA, no MIDs, Repeats'; % strange cells: reliable repeats but no filters whatsoever
            elseif group == 6
                grouplabel = 'No Responses'; % no auditory preferences
            else
                error('Unknown group.');
            end

            smgroups(i).STTC_info_index = i;
            
            smgroups(i).mid1prcthresh = mid1prcthresh;
            smgroups(i).mid2prcthresh = mid2prcthresh;

            smgroups(i).PSTHcorrthresh = PSTHcorrthresh;

            smgroups(i).mid1PTDthresh = mid1PTDthresh;
            smgroups(i).mid2PTDthresh = mid2PTDthresh;

            smgroups(i).mid1infothresh = mid1infothresh;
            smgroups(i).mid2infothresh = mid2infothresh;

            smgroups(i).mid1contigfiltthresh = mid1contigfiltthresh;
            smgroups(i).mid2contigfiltthresh = mid2contigfiltthresh;

            smgroups(i).contigprctile = contigprctile;

            smgroups(i).mid1nlthresh = mid1nlthresh;
            smgroups(i).mid2nlthresh = mid2nlthresh;

            smgroups(i).mid1nl_percentile = mid1nl_percentile;
            smgroups(i).symthresh = symthresh;

            smgroups(i).stamidcorr_percentile = stamidcorr_percentile;
            smgroups(i).stamidcorrthresh = stamidcorrthresh;

            smgroups(i).MID1info = MID1info;
            smgroups(i).MID1ptd = MID1ptd;
            smgroups(i).MID1contig = MID1contig;
            smgroups(i).MID1contig = MID1contig;
            smgroups(i).MID1nl = MID1nl;
            smgroups(i).MID1cond = double(MID1cond);
            smgroups(i).PSTHcorr = PSTHcorr;
            smgroups(i).MIDsym = MID1sym;
            smgroups(i).stamidcorr = stamidcorr;

            smgroups(i).MID2info = MID2info;
            smgroups(i).MID2ptd = MID2ptd;
            smgroups(i).MID2contig = MID2contig;
            smgroups(i).MID2nl = MID2nl;
            smgroups(i).MID2cond = double(MID2cond);

            smgroups(i).group = group;
            smgroups(i).grouplabel = grouplabel;
            
        end

    end


    fnames = fieldnames(smgroups);

    for i = 1:length(fnames)
        for j = 1:length(smgroups)
            eval(sprintf('data.%s{j} = smgroups(j).%s;', fnames{i}, fnames{i}));
        end
    end

    clear('smgroups');
    smgroups = data;

elseif ( nargin == 4)

    sta_info_total = [];
    mid1_info_total = [];
    mid2_info_total = [];
    mid12_info_total = [];

    sta_asi_total = [];
    mid1_asi_total = [];
    mid2_asi_total = [];

    for i = 1:length(STTC_info)

        longfile = STTC_info(i).longfile;

        [sta_asi, mid1_asi, mid2_asi, index_fio] = ...
            sm_longfile_to_fio_asi(longfile, fioparams, filestr);
        sta_asi_total = [sta_asi_total sta_asi];
        mid1_asi_total = [mid1_asi_total mid1_asi];
        mid2_asi_total = [mid2_asi_total mid2_asi];

        [sta_info, mid1_info, mid2_info, mid12_info, index_sminfo] = ...
            sm_longfile_to_sminfo(longfile, sminfo, filestr);
        sta_info_total = [sta_info_total sta_info];
        mid1_info_total = [mid1_info_total mid1_info];
        mid2_info_total = [mid2_info_total mid2_info];
        mid12_info_total = [mid12_info_total mid12_info];
    end

    PSTHcorrthresh = 0.3


    sta_ptd_percentile = 50;
    mid1_ptd_percentile = 50;
    mid2_ptd_percentile = 80;

    sta_ptd = [STTC_info.sta_ptd];
    mid1_ptd = [STTC_info.mid1_ptd];
    mid2_ptd = [STTC_info.mid2_ptd];

    staPTDthresh = prctile(mid1_ptd, sta_ptd_percentile);
    mid1PTDthresh = prctile(mid1_ptd, mid1_ptd_percentile);
    mid2PTDthresh = prctile(mid2_ptd, mid2_ptd_percentile);


    sta_info_percentile = 50;
    mid1_info_percentile = 50;
    mid2_info_percentile = 80;

    stainfothresh =  prctile(sta_info_total(sta_info_total>0), sta_info_percentile);
    mid1infothresh = prctile(mid1_info_total(mid1_info_total>0), mid1_info_percentile);
    mid2infothresh = prctile(mid2_info_total(mid2_info_total>0), mid2_info_percentile);


    mid1_asi_percentile = 40;
    symthresh = prctile(abs(mid1_asi_total), mid1_asi_percentile);



    % STA, MID1 correlation
    stamidcorr_percentile = 80;
    stamidcorr = zeros(1,length(STTC_info));

    for j = 1:length(STTC_info)
        x = STTC_info.filter_mean_sta;
        y = STTC_info.filter_mean_test2_v1;
        stamidcorr(j) = corr(x(:), y(:));
    end

    stamidcorrthresh = prctile(abs(stamidcorr), stamidcorr_percentile);

    mid1contigfiltthresh = 4;
    mid2contigfiltthresh = 5;
    contigprctile = 95;
    contigthresh = 6;

    sta_contig_pixels = zeros(1,length(STTC_info));
    mid1_contig_pixels = zeros(1,length(STTC_info));
    mid2_contig_pixels = zeros(1,length(STTC_info));

    for j = 1:length(STTC_info)
        sta_contig_pixels(j) = sm_find_filter_max_contiguous_sig_pixels(STTC_info(j).filter_mean_sta, contigprctile);
        mid1_contig_pixels(j) = sm_find_filter_max_contiguous_sig_pixels(STTC_info(j).filter_mean_test2_v1, contigprctile);
        mid2_contig_pixels(j) = sm_find_filter_max_contiguous_sig_pixels(STTC_info(j).filter_mean_test2_v2, contigprctile);
    end


    groupcounts.group1 = []; %normal cells with MID1 (and STA) only
    groupcounts.group2 = []; %normal cells with MID1 and MID2
    groupcounts.group3 = []; %'complex cells' with no MID2
    groupcounts.group4 = []; %'complex cells' with MID2
    groupcounts.group5 = []; %strange cells: reliable repeats but no filters whatsoever
    groupcounts.group6 = []; %no auditory preferences
    % groupcounts.ungrouped = []; %temp placeholder for debugging


    sta_nl_crossings_thresh = 4; % specifically for non-symmetric mid1/sta
    mid1_nl_crossings_thresh = 4; % specifically for non-symmetric mid1/sta
    mid2_nl_crossings_thresh = 7; % out of 13 since we remove the 2 extreme points

    sta_nl_crossings_total = zeros(1,length(STTC_info));
    mid1_nl_crossings_total = zeros(1,length(STTC_info));
    mid2_nl_crossings_total = zeros(1,length(STTC_info));

    for i = 1:length(STTC_info)

        longfile = STTC_info(i).longfile;

        [sta_nl_crossings, mid1_nl_crossings, mid2_nl_crossings, index_fio] = ...
            sm_longfile_to_fio_pspk_crossings(longfile, fioparams, filestr);

        sta_nl_crossings_total(i) = sta_nl_crossings;
        mid1_nl_crossings_total(i) = mid1_nl_crossings;
        mid2_nl_crossings_total(i) = mid2_nl_crossings;

    end


    % MID1symmethod = @(x)(sum(x(9:14)) - sum(x(2:7)))/(sum(x(9:14)) + sum(x(2:7))); 

    % find group 5 cells first:
    smgroups = STTC_info;

    fields_keep = {'longfile', 'repfile', 'sprfile'};

    fields_all = fieldnames(smgroups);

    fields_remove = setdiff(fields_all, fields_keep);

    smgroups = rmfield(smgroups, fields_remove);




%%%%%%%%%%%%%%% 
% We stop here because we can't do the grouping without knowing the
% signficance of the filters
%%%%%%%%%%%%%%%%%


% Variables so far:
%    sta_info_total = [];
%    mid1_info_total = [];
%    mid2_info_total = [];
%    mid12_info_total = [];
%
%    sta_asi_total = [];
%    mid1_asi_total = [];
%    mid2_asi_total = [];
%
%    sta_nl_crossings_total = [];
%    mid1_nl_crossings_total = [];
%    mid2_nl_crossings_total = [];
%
%    sta_contig_pixels = zeros(1,length(STTC_info));
%    mid1_contig_pixels = zeros(1,length(STTC_info));
%    mid2_contig_pixels = zeros(1,length(STTC_info));
%
%    stamidcorr = zeros(1,length(STTC_info));
%
%    sta_ptd = [STTC_info.sta_ptd];
%    mid1_ptd = [STTC_info.mid1_ptd];
%    mid2_ptd = [STTC_info.mid2_ptd];

[length(sta_info_total) length(mid1_info_total) length(mid2_info_total) length(mid12_info_total)]

[length(sta_asi_total) length(mid1_asi_total) length(mid2_asi_total)]

[length(sta_nl_crossings_total) length(mid1_nl_crossings_total) length(mid2_nl_crossings_total)]

[length(sta_contig_pixels) length(mid1_contig_pixels) length(mid2_contig_pixels)]

length(stamidcorr)

[length(sta_ptd) length(mid1_ptd) length(mid2_ptd)]

disp('pause');

pause

    for i = 1:length(STTC_info)

        group = [];
    %     
    %     if i == 2
    %         keyboard
    %     end
            
        %basic tests on sta and mid1
        STAinfo = mean(STTC_info(i).info0_extrap_test);
        MID1info = mean(STTC_info(i).info1_extrap_test);
        
        STAptd = STTC_info(i).sta_ptd;
        MID1ptd = STTC_info(i).mid1_ptd;
        
        STAcontig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_sta, contigprctile);
        MID1contig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_test2_v1, contigprctile);
        
        STAnl = sum(STTC_info(i).sta_fio(2:end-1) > STTC_info(i).pspk);
        MID1nl = sum(STTC_info(i).mid1_fio(2:end-1) > STTC_info(i).pspk);
        
        STAcond = sum([STAinfo>=stainfothresh, STAptd>=staPTDthresh,...
            STAcontig>=contigfiltthresh, STAnl>=nlthresh]) >= 3;

        MID1cond = MID1contig>=mid1contigfiltthresh & MID1nl>=mid1nlthresh; %& (MID1info>=mid1infothresh || MID1ptd>=mid1PTDthresh);

        PSTHcorr = mean(STTC_info(i).mean_PSTHcorr);
        

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


        % look for groups 5 and 6 first
        if ~MID1cond
            % if STTC is 'high enough', assign to group 5
            if PSTHcorr >= PSTHcorrthresh
                groupcounts.group5 = [groupcounts.group5 i];
                group = 5;
            % otherwise, neuron has no auditory preferences
            else
                groupcounts.group6 = [groupcounts.group6 i];
                group = 6;
            end
        % everything else in groups 1 to 4
        else

            % MID1 symmetry and STA-MID1 correlation checks
            % MID1sym = abs(MID1symmethod(STTC_info(i).mid1_fio)) < symthresh;
            % stamidcorr = abs(corr(STTC_info(i).filter_mean_sta(:),...
            %   STTC_info(i).filter_mean_test2_v1(:))) < stamidcorrthresh;
            
            % MID2 checks
            % MID2info = mean(STTC_info(i).info2_extrap_test);
            % MID2ptd = STTC_info(i).mid2_ptd;
            % MID2contig = sm_find_filter_max_contiguous_sig_pixels(STTC_info(i).filter_mean_test2_v2, contigprctile);
            % MID2nl = sum(STTC_info(i).mid2_fio(2:end-1) > STTC_info(i).pspk);
            % MID2cond = (MID2info>=mid2infothresh | MID2ptd>=mid2PTDthresh) & MID2contig>=mid2contigfiltthresh & MID2nl>=mid2nlthresh;       
            
            
            % groups 3 and 4
            if ( MID1sym && MID1nl>=mid2nlthresh && (MID1info>=mid1infothresh*2 || MID1ptd>=mid1PTDthresh*2) && MID1contig>=MID1contigfiltthresh )
                if MID2cond
                    groupcounts.group4 = [groupcounts.group4 i];
                    group = 4;
                else
                    groupcounts.group3 = [groupcounts.group3 i];
                    group = 3;
                end     

            % groups 1 and 2
            elseif ~MID1sym 
                if MID2cond
                    groupcounts.group2 = [groupcounts.group2 i];
                    group = 2;
                else
                    groupcounts.group1 = [groupcounts.group1 i];
                    group = 1;
                end
            % for troubleshooting
            elseif PSTHcorr >= PSTHcorrthresh
                % final catch before depositing into group 5
                if MID1contig>= mid1contigfiltthresh && (MID1info>=mid1infothresh || MID1ptd>=mid1PTDthresh)
                    groupcounts.group1 = [groupcounts.group1 i];
                    group = 1;
                else
                    groupcounts.group5 = [groupcounts.group5 i];
                    group = 5;
                end
            else
                groupcounts.group6 = [groupcounts.group6 i];
                group = 6;
            end
            
        end

        if isempty(group)
            error(sprintf('No group assigned for neuron #%.0f', i));
        else

            if group == 1
                grouplabel = 'STA, MID1, no MID2'; % normal cells with MID1 (and STA) only
            elseif group == 2
                grouplabel = 'STA, MID1, MID2'; % normal cells with MID1 and MID2
            elseif group == 3
                grouplabel = 'no STA, MID1, no MID2'; % 'complex cells' with no MID2
            elseif group == 4
                grouplabel = 'no STA, MID1, MID2'; % 'complex cells' with MID2
            elseif group == 5
                grouplabel = 'no STA, no MIDs, Repeats'; % strange cells: reliable repeats but no filters whatsoever
            elseif group == 6
                grouplabel = 'No Responses'; % no auditory preferences
            else
                error('Unknown group.');
            end

            smgroups(i).STTC_info_index = i;
            
            smgroups(i).mid1prcthresh = mid1prcthresh;
            smgroups(i).mid2prcthresh = mid2prcthresh;

            smgroups(i).PSTHcorrthresh = PSTHcorrthresh;

            smgroups(i).mid1PTDthresh = mid1PTDthresh;
            smgroups(i).mid2PTDthresh = mid2PTDthresh;

            smgroups(i).mid1infothresh = mid1infothresh;
            smgroups(i).mid2infothresh = mid2infothresh;

            smgroups(i).mid1contigfiltthresh = mid1contigfiltthresh;
            smgroups(i).mid2contigfiltthresh = mid2contigfiltthresh;

            smgroups(i).contigprctile = contigprctile;

            smgroups(i).mid1nlthresh = mid1nlthresh;
            smgroups(i).mid2nlthresh = mid2nlthresh;

            smgroups(i).mid1nl_percentile = mid1nl_percentile;
            smgroups(i).symthresh = symthresh;

            smgroups(i).stamidcorr_percentile = stamidcorr_percentile;
            smgroups(i).stamidcorrthresh = stamidcorrthresh;

            smgroups(i).MID1info = MID1info;
            smgroups(i).MID1ptd = MID1ptd;
            smgroups(i).MID1contig = MID1contig;
            smgroups(i).MID1contig = MID1contig;
            smgroups(i).MID1nl = MID1nl;
            smgroups(i).MID1cond = double(MID1cond);
            smgroups(i).PSTHcorr = PSTHcorr;
            smgroups(i).MIDsym = MID1sym;
            smgroups(i).stamidcorr = stamidcorr;

            smgroups(i).MID2info = MID2info;
            smgroups(i).MID2ptd = MID2ptd;
            smgroups(i).MID2contig = MID2contig;
            smgroups(i).MID2nl = MID2nl;
            smgroups(i).MID2cond = double(MID2cond);

            smgroups(i).group = group;
            smgroups(i).grouplabel = grouplabel;
            
        end

    end


    fnames = fieldnames(smgroups);

    for i = 1:length(fnames)
        for j = 1:length(smgroups)
            eval(sprintf('data.%s{j} = smgroups(j).%s;', fnames{i}, fnames{i}));
        end
    end

    clear('smgroups');
    smgroups = data;


end

return;



function [sta_asi, mid1_asi, mid2_asi, index] = sm_longfile_to_fio_asi(longfile, fioparams, filestr)
%
% [sta_asi, mid1_asi, mid2_asi, index] = sm_longfile_to_fio_unit(longfile, fioparams, filestr);
%
% longfile : .mat file name holding response to long dmr
% fioparams : struct array holding nonlinearity data
% filestr : struct array holding file names for each unit
%
% sta_asi, mid1_asi, mid2_asi : asymmetry index of 1D STA/MID nonlinearities
% index : index into fioparams corresponding to fio_unit
%
%


index = 0;

iskfile = [];
for i = 1:length(filestr)
    if ( strcmp(longfile, filestr(i).nevfile_long) )
        iskfile = filestr(i).iskfile;
    end
end

if ( isempty(iskfile) )
    error('Did not find matching isk file.');
end


fio_unit = [];

for i = 1:length(fioparams)
    if ( strcmp(iskfile, fioparams(i).iskfile) )
        fio_unit = fioparams(i);
        index = i;
    end
end

if ( isempty(fio_unit) )
    error('Did not find matching fio_unit.');
end


x = fio_unit.fio_sta.x_mean;
f = fio_unit.fio_sta.ior_mean;
x = x(2:end-1);
f = f(2:end-1);
right = sum(f(x>0));
left = sum(f(x<0));

if ( (right+left) == 0 )
    sta_asi = -9999;
else
    sta_asi = (right - left) / (right+left);
end


x = fio_unit.fio_mid1.x1_mean;
f = fio_unit.fio_mid1.pspkx1_mean;
x = x(2:end-1);
f = f(2:end-1);
right = sum(f(x>0));
left = sum(f(x<0));

if ( (right+left) == 0 )
    mid1_asi = -9999;
else
    mid1_asi = (right - left) / (right+left);
end




x = fio_unit.fio_mid2.x2_mean;
f = fio_unit.fio_mid2.pspkx2_mean;
x = x(2:end-1);
f = f(2:end-1);
right = sum(f(x>0));
left = sum(f(x<0));

if ( (right+left) == 0 )
    mid2_asi = -9999;
else
    mid2_asi = (right - left) / (right+left);
end


return



function [sta_info, mid1_info, mid2_info, mid12_info, index] = ...
    sm_longfile_to_sminfo(longfile, sminfo, filestr)
%
% fio_unit = sm_longfile_to_fio_unit(longfile, fioparams, filestr);
%
% longfile : .mat file name holding response to long dmr
% fioparams : struct array holding nonlinearity data
% filestr : struct array holding file names for each unit
%
% sta_info, mid1_info, mid2_info, mid12_info : information values where at least 
%   two of the four test reps had positive, well-behaved information estimates.
%   The returned values are the mean in each case.
% index : index into the sminfo values.
%
%


index = 0;

iskfile = [];
for i = 1:length(filestr)
    if ( strcmp(longfile, filestr(i).nevfile_long) )
        iskfile = filestr(i).iskfile;
    end
end

if ( isempty(iskfile) )
    error('Did not find matching isk file.');
end


sta_info = [];
mid1_info = [];
mid2_info = [];
mid12_info = [];

for i = 1:length(sminfo.iskfile)
    if ( strcmp(iskfile, sminfo.iskfile(i)) )
        sta_info = sminfo.infosta{i};
        mid1_info = sminfo.infomid1{i};
        mid2_info = sminfo.infomid2{i};
        mid12_info = sminfo.infomid12{i};
        index = i;
    end
end

if ( isempty(sta_info) )
    error('Did not find matching unit info.');
end


return








function [sta_crossings, mid1_crossings, mid2_crossings, index] = sm_longfile_to_fio_pspk_crossings(longfile, fioparams, filestr)
%
% [sta_asi, mid1_asi, mid2_asi, index] = sm_longfile_to_fio_unit(longfile, fioparams, filestr);
%
% longfile : .mat file name holding response to long dmr
% fioparams : struct array holding nonlinearity data
% filestr : struct array holding file names for each unit
%
% sta_asi, mid1_asi, mid2_asi : asymmetry index of 1D STA/MID nonlinearities
% index : index into fioparams corresponding to fio_unit
%
%


index = 0;

iskfile = [];
for i = 1:length(filestr)
    if ( strcmp(longfile, filestr(i).nevfile_long) )
        iskfile = filestr(i).iskfile;
    end
end

if ( isempty(iskfile) )
    error('Did not find matching isk file.');
end


fio_unit = [];

for i = 1:length(fioparams)
    if ( strcmp(iskfile, fioparams(i).iskfile) )
        fio_unit = fioparams(i);
        index = i;
    end
end

if ( isempty(fio_unit) )
    error('Did not find matching fio_unit.');
end


pspk0 = fio_unit.fio_sta.pspk_mean;
if isempty(pspk0)
    pspk0 = -9999;
end

pspk1 = fio_unit.fio_mid1.pspk_mean;
if isempty(pspk1)
    pspk1 = 0;
end


pspk2 = fio_unit.fio_mid2.pspk_mean;
if isempty(pspk2)
    pspk2 = 0;
end

pspk = [pspk0 pspk1 pspk2];

if sum(pspk) == 0
    error('pspk undefined.');
end

pspk = mean(pspk(pspk>0));


x = fio_unit.fio_sta.x_mean;
f = fio_unit.fio_sta.ior_mean;
x = x(2:end-1);
f = f(2:end-1);

sta_crossings = sum(f>pspk);


x = fio_unit.fio_mid1.x1_mean;
f = fio_unit.fio_mid1.pspkx1_mean;
x = x(2:end-1);
f = f(2:end-1);

mid1_crossings = sum(f>pspk);


x = fio_unit.fio_mid2.x2_mean;
f = fio_unit.fio_mid2.pspkx2_mean;
x = x(2:end-1);
f = f(2:end-1);

mid2_crossings = sum(f>pspk);


return












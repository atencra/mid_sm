function nevfiles = sm_match_nevfile_to_iskfile(iskfiles, nevfileloc)
% sm_match_nevfile_to_iskfile
%
% nevfiles = sm_match_nevfile_to_iskfile(iskfiles, nevfileloc)


if ~exist('nevfileloc','var')
    nevfileloc = 'I:\nhp_su_sta_dmr\PSTH_sig';
end

%cd(nevfileloc)
if ~iscell(iskfiles)
    iskfiles = {iskfiles};
end

datetime = regexp(regexp(iskfiles, '^\d{6}_\d{6}','match','once'), '_', 'split');
datetime

date = cellfun(@(x) x{1}, datetime, 'UniformOutput', 0);

date = cellfun(@(x) ['20' x(1:2) '-' x(3:4) '-' x(5:6)], date, 'UniformOutput', 0);
time = cellfun(@(x) x{2}, datetime, 'UniformOutput', 0);
time = cellfun(@(x) [x(1:2) '-' x(3:4) '-' x(5:6)], time, 'UniformOutput', 0);

site = regexp(iskfiles, '(?<=(site))\d{2}','match','once');
neuron = regexp(iskfiles, '(?<=(neuron))\d{1}','match','once');
    
nevfiles = cellfun(@(a,b,c,d) gfn(['nev_' a '_' b '_do' c '_*_su' d '.mat'],...
    1), date, time, site, neuron); 


return;



function frafile = sm_nevfile_to_frafile(nevfile, folder)
% sm_iskfile_to_nevfile NEV file name from ISK long dmr file name
%
% nevfiles = sm_iskfile_to_nevfile(iskfiles) converts the file(s) in iskfiles
% to equivalent nevfiles.
%
% iskfiles may be a string or a cell array of strings. If iskfiles is a string,
% then nevfiles will be a string. For cell array of sting inputs, the output
% will be a cell array of strings.
%
%


if nargin == 1
    folder = '.';
end


%nevfile = nev_2009-06-10_17-43-39_do04_ch07_curly_repeats_su1.mat

idash = strfind(nevfile, '_');
prefix = nevfile(1:idash(2)-1);
id = nevfile(idash(3)+1 : idash(4)-1);
unit = nevfile(idash(end)+1:end);
unit = strrep(unit, '.mat', '');
basefile = sprintf('%s_*_%s_*_%s.mat', prefix, id, unit);
dfra = dir(fullfile(folder, basefile));

if length(dfra)==0
    frafile = 'none';
elseif ( length(dfra)>1 )
    {dfra.name}
    nevfile
    error('More than one nev file matches the iskfile.');
else
    frafile = dfra.name;
    {dfra.name}
    nevfile
end

return;



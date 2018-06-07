function nevfile = sm_iskfile_to_nevfile(iskfile, folder)
% sm_iskfile_to_nevfile NEV file name from ISK file name
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


infile = iskfile;
datetime = regexp(infile, '^\d{6}_\d{6}','match','once');
parts = strsplit(datetime,'_'); 

date = parts{1};
date = sprintf('20%s-%s-%s', date(1:2), date(3:4), date(5:6)); 

time = parts{2};
time = sprintf('%s-%s-%s', time(1:2), time(3:4), time(5:6)); 

site = regexp(infile, '(?<=(site))\d{2}','match','once');
neuron = regexp(infile, '(?<=(neuron))\d{1}','match','once');

basefile = sprintf('nev_%s_*_do%s_*_su%s.mat', date, site, neuron); 

dnev = dir(fullfile(folder, basefile));

if length(dnev)==0
    nevfile = 'none';
elseif ( length(dnev)>1 )
    nevfile = {dnev.name};
    warning(sprintf('More than one nev file matches %s',infile));
else
    nevfile = dnev.name;
end


return;



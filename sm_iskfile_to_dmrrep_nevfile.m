function nevfiles = sm_iskfile_to_dmrrep_nevfile(iskfiles, folder)
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

if ischar(iskfiles)
    iskfiles = {iskfiles};
end

if nargin == 1
    folder = '.';
end

for i = 1:length(iskfiles)

    infile = iskfiles{i};
    datetime = regexp(infile, '^\d{6}_\d{6}','match','once');
    parts = strsplit(datetime,'_'); 

    date = parts{1};
    date = sprintf('20%s-%s-%s', date(1:2), date(3:4), date(5:6)); 

    time = parts{2};
    time = sprintf('%s-%s-%s', time(1:2), time(3:4), time(5:6)); 
    time = sprintf('*-*-*');

    site = regexp(infile, '(?<=(site))\d{2}','match','once');
    neuron = regexp(infile, '(?<=(neuron))\d{1}','match','once');

    basefile = sprintf('nev_%s_%s_do%s_*_su%s.mat', date, time, site, neuron);

    dnev = dir(fullfile(folder, basefile));

    if length(dnev)==0
        error('No nev files in folder.');
    elseif ( length(dnev)>1 )
        error('More than one nev file matches the iskfile.');
    else
        outfile = dnev.name;
    end

    nevfiles{i} = outfile;

end

if length(nevfiles) == 1
    nevfiles = nevfiles{1};
end

return;



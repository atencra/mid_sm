function csvfile = sm_filestr_to_csvfile(filestr, outfolder, filename)
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
    outfolder = '.';
    filename = 'sm-mid-files.csv';
end

if nargin == 2
    filename = 'sm-mid-files.csv';
end


fid = fopen(filename, 'w');

fprintf(fid, 'Day,id,ch,animal,unit,dmrlong,dmrrep,isk,fra\n');

for i = 1:length(filestr)

    longfile = filestr(i).nevfile_long;

    iunder = strfind(longfile, '_');

    day = longfile(iunder(1)+1 : iunder(2)-1);

    id = longfile(iunder(3)+3 : iunder(4)-1);

    ch = longfile(iunder(4)+3 : iunder(5)-1);

    animal = longfile(iunder(5)+1 : iunder(6)-1);

    unit = longfile(iunder(end)+3);

    if ( i < length(filestr) )
        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n', ...
            day, id, ch, animal, unit, ...
            filestr(i).nevfile_long, ...
            filestr(i).nevfile_rep, ...
            filestr(i).iskfile, ...
            filestr(i).frafile);
    else
        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s', ...
            day, id, ch, animal, unit, ...
            filestr(i).nevfile_long, ...
            filestr(i).nevfile_rep, ...
            filestr(i).iskfile, ...
            filestr(i).frafile);
    end

end

fclose('all');

return;



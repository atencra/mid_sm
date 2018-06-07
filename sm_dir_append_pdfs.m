function sm_dir_append_pdfs(varargin)
%
%
% =============================================================================
% sm_dir_append_pdfs Combine pdfs in folder(s) into a single pdf
%
% Goes through the current directory, or through multiple directories, looks
% for pdfs satisfying a specified file naming pattern, and combines the pdfs into
% file.
%
% Keyword/Value options are:
%
% 'filepattern' :   the form of the file that will be searched for, and combined.
%   Example: 'mtf-highres'. All files that have this in the file name will be
%   combined. Required.
%
% 'outfolder' : where the combined will be saved. Default: '.'
%
% 'batch' : 1 : run the function outside a group of folders. Each folder will be
%               entered and scanned.
%           0 : run the function inside a folder, and only that folder will be 
%               scanned. 
%           Default: 0.
%
% 'outfile' : name of the combined pdf. Default is {filepattern}-combined.pdf.
% 
% Example calls:
%
% sm_dir_append_pdfs('filepattern', 'mtf-highres', 'batch', 1, 'process', 1);
% sm_dir_append_pdfs('filepattern', 'mtf-highres', 'batch', 1, 'outfolder', outf);
%
%   For this call the output file name will be: mtf-highres-combined.pdf
%
% Note: 1. ghostscript must be installed on the computer. 
%       2. Requires the matlab toolbox 'export_fig'.
%       3. Any previously created combined pdf with the same name will be 
%          overwritten.
%    
% =============================================================================
%
%

library('export_fig');

narginchk(2,6);

options = struct('filepattern', [], 'outfolder', [], 'batch', 0, 'outfile', []);
options = input_options(options, varargin);
assert(~isempty(options.filepattern), 'Please input a filepattern.');

filepattern = options.filepattern;
outfolder = options.outfolder;
batch = options.batch;
outfile = options.outfile;

gsdir = 'C:\Program Files\gs\gs9.20\bin';
gsfile = 'gswin64c.exe';
gspath = fullfile(gsdir, gsfile);

if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

if ( isempty(outfolder) )
    outfolder = pwd;
end

if ( isempty(outfile) )
    basefile = sprintf('combined-%s.pdf', filepattern);
else
    basefile = outfile;
end

initialized = 0;

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});
    pdfs = dir(sprintf('*%s*.pdf', filepattern));
    pdfs = {pdfs.name};

    for i = 1:length(pdfs)

        infile = pdfs{i};

        fprintf('Processing %s\n', infile);

        if ( ~initialized )
            [status, msg, msgid] = copyfile(infile, fullfile(outfolder, basefile));
            initialized = 1;
            continue;
        end

        append_pdfs(fullfile(outfolder, basefile), infile);

    end % (for i)

    cd(startdir)

end % (for ii)

return;

















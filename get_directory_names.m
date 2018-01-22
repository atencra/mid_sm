function [ dirList ] = get_directory_names( dir_name )
% get_directory_names Names of directories within specified directory
%
% dn = get_directory_names(dir_name)
%
% dir_name : directory name - path of directory. 
%
% dn : cell array of directory names
%
% dn = get_directory_names uses the current directory.
%
%
%
% from: http://stackoverflow.com/questions/8748976/list-the-subfolders-
% in-a-folder-matlab-only-subfolders-not-files
%

if nargin == 0
    dir_name = '.';
end

dd = dir(dir_name);
isub = [dd(:).isdir]; %# returns logical vector
dirList = {dd(isub).name}';
dirList(ismember(dirList,{'.','..'})) = [];

return

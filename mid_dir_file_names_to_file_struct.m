function datafiles = mid_dir_file_names_to_file_struct(varargin)
%  mid_dir_file_names_to_file_struct - MID files for each single unit
%
%  datafiles = mid_dir_file_names_to_file_struct()
%  ===============================================================
%  Searches through the current directory and finds the file names
%  for each single unit that was analyzed.
%
%  The rip_params_*.txt, the *.isk, the *info1.txt, and 
%  the *.info12.txt files, as well as all MID files, need to
%  be in the current directory.
%
%  Parameter files, information progress files, and spike train files 
%  are also found. The text of each parameter file and each information
%  progress file is extracted from the file and saved in a struct array.
%
%  Note that for MID analysis 4 jacknife estimates are made. Therefore,
%  this program will return an error if 4 files for each MID estimation
%  are not present.
%
%  datafiles = mid_dir_file_names_to_file_struct('savepath', folder) saves
%  the data files to a *-files.mat file in folder. 
%
%  Example datafiles struct:
%
%                         sprfile: [1x65 char]
%                         iskfile: [1x56 char]
%                             exp: '2014-3-6'
%                            site: 'site1'
%                            stim: 'rn1'
%                            unit: '1'
%                rip_params_files: {1x4 cell}
%           rip_params_files_text: {{11x1 cell} {11x1 cell} {11x1 cell} {11x1 cell}}
%                     rpsta_files: {1x4 cell}
%             rpx1pxpxt_sta_files: {1x4 cell}
%               rpdbest1_v1_files: {1x4 cell}
%               rpdbest1_v2_files: {1x4 cell}
%               rpdtest1_v1_files: {1x4 cell}
%               rpdtest1_v2_files: {1x4 cell}
%               rpdbest2_v1_files: {1x4 cell}
%               rpdbest2_v2_files: {1x4 cell}
%               rpdtest2_v1_files: {1x4 cell}
%               rpdtest2_v2_files: {1x4 cell}
%           rpdx1x2px_pxt_1_files: {1x4 cell}
%          rpd_x1x2px_pxt_2_files: {1x4 cell}
%         rpdtest1_v1_info1_files: {1x4 cell}
%    rpdtest1_v1_info1_files_text: {1x4 cell}
%       rpdtest2_v12_info12_files: {1x4 cell}
%  rpdtest2_v12_info12_files_text: {1x4 cell}
%                         locator: [1x120265 double]
%
%

options = struct('savepath', []);

options = input_options(options, varargin);





d = dir('rip_params_*.txt');

if ( isempty(d) )
    error('No parameter files in current directory.');
end

file_base = {};
for i = 1:length(d)
    filename = d(i).name;
    index = findstr(filename, '.txt');
    file_base{i} = filename(1:index-2);
end

unit_file_base = unique(file_base);




for i = 1:length(unit_file_base)

    clear('datafiles');

    index = findstr(unit_file_base{i}, '_');
    outfile = sprintf('%s-files', unit_file_base{i}(index(2)+1:index(end)-1));

    % Read parameter files
    dparams = dir(sprintf('%s*.txt', unit_file_base{i}));
    rip_params_files = {dparams.name};

    if length(dparams) ~= 4
        error('Do not have parameter files for 4 jacknifes.');
    end

    % Get the experiment, site, stim, and unit as listed
    % in the MID analysis output dat files
    index = findstr(rip_params_files{1}, '_');

    exp_dat = rip_params_files{1}(index(2)+1:index(3)-1);
    site_dat = rip_params_files{1}(index(3)+1:index(4)-1);
    stim_unit_dat = rip_params_files{1}(index(4)+1:index(5)-1);


    % Read the text within parameter files
    rip_params_files_text = {};
    for j = 1:length(rip_params_files)
        [data, result] = readtext(rip_params_files{j}, '\n');
        rip_params_files_text{j} = data;
    end



    % Stimulus type, experiment, site, and unit as originally listed. 
    datafiles.sprfile = rip_params_files_text{1}{1};
    datafiles.iskfile = rip_params_files_text{1}{2};

    index = findstr(datafiles.sprfile, '-');
    stim = datafiles.sprfile(1:index(1)-1);

    datafiles.iskfile

    index = findstr(datafiles.iskfile, '-');
    index_site = findstr(datafiles.iskfile, 'site');

    exp = datafiles.iskfile(1:index_site-2);

    site_part = datafiles.iskfile(index_site:end);
    index_dash = findstr(site_part, '-');
    site = site_part(5:index_dash(1)-1);


    index_dot = findstr(datafiles.iskfile, '.isk');
    unit = datafiles.iskfile(index(end)+1:index_dot-1);

    datafiles.exp = exp;
    datafiles.site = site;
    datafiles.stim = stim;
    datafiles.unit = unit;
    datafiles.rip_params_files = rip_params_files;
    datafiles.rip_params_files_text = rip_params_files_text;


    % STA filter file names
    %============================================================
    rpsta_files = dir(sprintf('rpsta_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpsta_files) ~= 4 )
        error(sprintf('length(rpsta_files) = %.0f', ...
            length(rpsta_files)));
    else
        rpsta_files = {rpsta_files.name};
        datafiles.rpsta_files = rpsta_files;
    end


    % STA nonlinearity file names
    %============================================================
    rpx1pxpxt_sta_files = dir(sprintf('rpx1pxpxt_sta_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpx1pxpxt_sta_files) ~= 4 )
        error(sprintf('length(rpx1pxpxt_sta_files) = %.0f', ...
            length(rpx1pxpxt_sta_files)));
    else
        rpx1pxpxt_sta_files = {rpx1pxpxt_sta_files.name};
        datafiles.rpx1pxpxt_sta_files = rpx1pxpxt_sta_files;
    end


    % Best1 MID files
    %============================================================
    rpdbest1_v1_files = dir(sprintf('rpdbest1_v1_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdbest1_v1_files) ~= 4 )
        error(sprintf('length(rpdbest1_v1_files) = %.0f', ...
            length(rpdbest1_v1_files)));
    else
        rpdbest1_v1_files = {rpdbest1_v1_files.name};
        datafiles.rpdbest1_v1_files = rpdbest1_v1_files;
    end


    rpdbest1_v2_files = dir(sprintf('rpdbest1_v2_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdbest1_v2_files) ~= 4 )
        error(sprintf('length(rpdbest1_v2_files) = %.0f', ...
            length(rpdbest1_v2_files)));
    else
        rpdbest1_v2_files = {rpdbest1_v2_files.name};
        datafiles.rpdbest1_v2_files = rpdbest1_v2_files;
    end


    % Test1 MID files
    %============================================================
    rpdtest1_v1_files = dir(sprintf('rpdtest1_v1_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdtest1_v1_files) ~= 4 )
        error(sprintf('length(rpdtest1_v1_files) = %.0f', ...
            length(rpdtest1_v1_files)));
    else
        rpdtest1_v1_files = {rpdtest1_v1_files.name};
        datafiles.rpdtest1_v1_files = rpdtest1_v1_files;
    end


    rpdtest1_v2_files = dir(sprintf('rpdtest1_v2_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdtest1_v2_files) ~= 4 )
        error(sprintf('length(rpdtest1_v2_files) = %.0f', ...
            length(rpdtest1_v2_files)));
    else
        rpdtest1_v2_files = {rpdtest1_v2_files.name};
        datafiles.rpdtest1_v2_files = rpdtest1_v2_files;
    end


    % Best2 MID files
    %============================================================
    rpdbest2_v1_files = dir(sprintf('rpdbest2_v1_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdbest2_v1_files) ~= 4 )
        error(sprintf('length(rpdbest2_v1_files) = %.0f', ...
            length(rpdbest2_v1_files)));
    else
        rpdbest2_v1_files = {rpdbest2_v1_files.name};
        datafiles.rpdbest2_v1_files = rpdbest2_v1_files;
    end


    rpdbest2_v2_files = dir(sprintf('rpdbest2_v2_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdbest2_v2_files) ~= 4 )
        error(sprintf('length(rpdbest2_v2_files) = %.0f', ...
            length(rpdbest2_v2_files)));
    else
        rpdbest2_v2_files = {rpdbest2_v2_files.name};
        datafiles.rpdbest2_v2_files = rpdbest2_v2_files;
    end


    % Test2 MID files
    %============================================================
    rpdtest2_v1_files = dir(sprintf('rpdtest2_v1_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdtest2_v1_files) ~= 4 )
        error(sprintf('length(rpdtest2_v1_files) = %.0f', ...
            length(rpdtest2_v1_files)));
    else
        rpdtest2_v1_files = {rpdtest2_v1_files.name};
        datafiles.rpdtest2_v1_files = rpdtest2_v1_files;
    end


    rpdtest2_v2_files = dir(sprintf('rpdtest2_v2_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdtest2_v2_files) ~= 4 )
        error(sprintf('length(rpdtest2_v2_files) = %.0f', ...
            length(rpdtest2_v2_files)));
    else
        rpdtest2_v2_files = {rpdtest2_v2_files.name};
        datafiles.rpdtest2_v2_files = rpdtest2_v2_files;
    end



    % MID optimization #1 nonlinearity files
    %============================================================
    rpdx1x2px_pxt_1_files = dir(sprintf('rpdx1x2px_pxt_1_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdx1x2px_pxt_1_files) ~= 4 )
        error(sprintf('length(rpdx1x2px_pxt_1_files) = %.0f', ...
            length(rpdx1x2px_pxt_1_files)));
    else
        rpdx1x2px_pxt_1_files  = {rpdx1x2px_pxt_1_files.name};
        datafiles.rpdx1x2px_pxt_1_files = rpdx1x2px_pxt_1_files;
    end


    % MID optimization #2 nonlinearity files
    %============================================================
    rpd_x1x2px_pxt_2_files = dir(sprintf('rpd_x1x2px_pxt_2_%s_%s_%s_*.dat', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpd_x1x2px_pxt_2_files) ~= 4 )
        warning(sprintf('length(rpd_x1x2px_pxt_2_files) = %.0f', ...
            length(rpd_x1x2px_pxt_2_files)));
    end

    rpd_x1x2px_pxt_2_files = {rpd_x1x2px_pxt_2_files.name};
    datafiles.rpd_x1x2px_pxt_2_files = rpd_x1x2px_pxt_2_files;



    % MID optimization #1 information progress
    %============================================================
    rpdtest1_v1_info1_files = dir(sprintf('rpdtest1_v1_%s_%s_%s_*_info1.txt', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdtest1_v1_info1_files) ~= 4 )
        error(sprintf('length(rpdtest1_v1_info1_files) = %.0f', ...
            length(rpdtest1_v1_info1_files)));
    else
        rpdtest1_v1_info1_files = {rpdtest1_v1_info1_files.name};
        datafiles.rpdtest1_v1_info1_files = rpdtest1_v1_info1_files;

        % Read the text within parameter files
        rpdtest1_v1_info1_files_text = {};
        for j = 1:length(rpdtest1_v1_info1_files)
            [data, result] = readtext(rpdtest1_v1_info1_files{j});
            rpdtest1_v1_info1_files_text{j} = data;
        end
        datafiles.rpdtest1_v1_info1_files_text = rpdtest1_v1_info1_files_text;
    end



    % MID optimization #2 information progress
    %============================================================
    rpdtest2_v12_info12_files = dir(sprintf('rpdtest2_v12_%s_%s_%s_*_info12.txt', ...
                            exp_dat, site_dat, stim_unit_dat));

    if ( length(rpdtest2_v12_info12_files) ~= 4 )
        error(sprintf('length(rpdtest2_v12_info12_files) = %.0f', ...
            length(rpdtest2_v12_info12_files)));
    else
        rpdtest2_v12_info12_files = {rpdtest2_v12_info12_files.name};
        datafiles.rpdtest2_v12_info12_files = rpdtest2_v12_info12_files;

        % Read the text within parameter files
        rpdtest2_v12_info12_files_text = {};
        for j = 1:length(rpdtest2_v12_info12_files)
            [data, result] = readtext(rpdtest2_v12_info12_files{j});
            rpdtest2_v12_info12_files_text{j} = data;
        end
        datafiles.rpdtest2_v12_info12_files_text = rpdtest2_v12_info12_files_text;
    end


    % Get binned spike train from isk file
    %============================================================
    locator = isk_file_to_locator(datafiles.iskfile);
    datafiles.locator = locator;


    % If requested, save struct to output folder
    if ( ~isempty(options.savepath) )
        save(fullfile(options.savepath, outfile), 'datafiles');
        fprintf('datafiles struct saved to: %s\n', ...
            fullfile(options.savepath, outfile) );
    end

end


return;





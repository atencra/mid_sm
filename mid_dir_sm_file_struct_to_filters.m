function [data] = mid_dir_sm_file_struct_to_filters(varargin)
% mid_dir_sm_file_struct_to_filters Filters/nonlinearities from file names
%
% [data] = mid_dir_sm_file_struct_to_filters ('filepath', dir1, 'outfolder', dir2, 'process', value)
% --------------------------------------------------------------------------------
%
% Goes throught the directory specified by 'filepath' and obtains *.mat 
% files holding the file names of MID analysis results. For each file
% name, the data is read in and stored in a data structure.
%
% The data are then saved in the folder indicated by outfolder. 
%
% filepath : string indicating location of *-files.mat files.
%
% outfolder : string indicating location where filter and nonlinearies
%       should be saved.
%
% process : write data to file. process = 0 if you do not wish to 
%       overwrite previously existing data. process = 1 if you wish to
%       allow overwrites.
%
% Defaults for filepath and outfolder are the current directory.


narginchk(0,6);

options = struct('filepath', '.', 'outfolder', '.', 'process', 0);

options = input_options(options, varargin);

filepath = options.filepath;
outfolder = options.outfolder;
process = options.process;



matfiles = dir(fullfile(filepath, '*-files.mat'));
matfiles = {matfiles.name};

for i = 1:length(matfiles)

    fprintf('Processing %s\n', matfiles{i});

    index = findstr(matfiles{i}, '-files');
    outfile = sprintf('%s-filter-fio.mat', matfiles{i}(1:index-1));
    outfile = fullfile(outfolder, outfile);

    d = dir(outfile);

    if ( isempty(d) || process )
    
        load(matfiles{i}, 'datafiles');
        fields = {...
            'rip_params_files', ...
            'rip_params_files_text', ...
            'rpsta_files', ...
            'rpx1pxpxt_sta_files', ...
            'rpdbest1_v1_files', ...
            'rpdbest1_v2_files', ...
            'rpdtest1_v1_files', ...
            'rpdtest1_v2_files', ...
            'rpdbest2_v1_files', ...
            'rpdbest2_v2_files', ...
            'rpdtest2_v1_files', ...
            'rpdtest2_v2_files', ...
            'rpdx1x2px_pxt_1_files', ...
            'rpd_x1x2px_pxt_2_files', ...
            'rpdtest1_v1_info1_files', ...
            'rpdtest1_v1_info1_files_text', ...
            'rpdtest2_v12_info12_files', ...
            'rpdtest2_v12_info12_files_text'};

        if ( isfield(datafiles, 'rpx1pxpxt_sta_files') && ...
            isfield(datafiles, 'rpdbest1_v1_files') && ...
            isfield(datafiles, 'rpdbest1_v2_files') && ...
            isfield(datafiles, 'rpdtest1_v1_files') && ...
            isfield(datafiles, 'rpdtest1_v2_files') && ...
            isfield(datafiles, 'rpdbest2_v1_files') && ...
            isfield(datafiles, 'rpdbest2_v2_files') && ...
            isfield(datafiles, 'rpdtest2_v1_files') && ...
            isfield(datafiles, 'rpdtest2_v2_files') && ...
            isfield(datafiles, 'rpdx1x2px_pxt_1_files') && ...
            isfield(datafiles, 'rpd_x1x2px_pxt_2_files') && ...
            isfield(datafiles, 'rpdtest1_v1_info1_files') && ...
            isfield(datafiles, 'rpdtest1_v1_info1_files_text') && ...
            isfield(datafiles, 'rpdtest2_v12_info12_files') && ...
            isfield(datafiles, 'rpdtest2_v12_info12_files_text') )

                
            data = datafiles;
            data = rmfield(data, fields); 
        
            sprfile = datafiles.rip_params_files_text{1}{1};
            iskfile = datafiles.rip_params_files_text{1}{2};
            exp_dat = datafiles.rip_params_files_text{1}{3};
            site_dat = datafiles.rip_params_files_text{1}{4};
            stim_unit_dat = datafiles.rip_params_files_text{1}{5};
            nf_spr = datafiles.rip_params_files_text{1}{6};
            x0 = datafiles.rip_params_files_text{1}{7};
            ntrials = datafiles.rip_params_files_text{1}{8};
            niter_mid1 = datafiles.rip_params_files_text{1}{9};
            niter_mid12 = datafiles.rip_params_files_text{1}{10};
            testrep = datafiles.rip_params_files_text{1}{11};
        
            example_file = datafiles.rpsta_files{1};
            index = findstr(example_file, '_');
            filter_specs = example_file(index(4)+1:index(5)-1);
            index = findstr(filter_specs, 'x');
            nf_filter = str2double(filter_specs(index(1)+1:index(2)-1));
            nt_filter = str2double(filter_specs(index(2)+1:end));
        
        
            % Assign intial parameters from MID analysis
            %--------------------------------------------------------------------
            data.nf_spr = nf_spr;
            data.x0 = x0;
            data.ntrials = ntrials;
            data.niter_mid1 = niter_mid1;
            data.niter_mid12 = niter_mid12;
            data.testrep = testrep;
            data.nf_filter = nf_filter;
            data.nt_filter = nt_filter;
            
            %   STA Filter from MID Code
            %--------------------------------------------------------------------
            sta_files = fullfile(filepath, datafiles.rpsta_files);

            [sta_filter, coeff_sta, projection_sta, filter_matrix_sta] = ...
                get_auditory_filter(sta_files, nf_filter, nt_filter);
            data.filter_mean_sta = sta_filter;
            data.coeff_sta = coeff_sta;
            data.projection_sta = projection_sta;
            data.filter_matrix_sta = filter_matrix_sta;

            
        
            %--------------------------------------------------------------------
            %   STA Nonlinearity from MID Code
            %--------------------------------------------------------------------
            sta_files = fullfile(filepath, datafiles.rpx1pxpxt_sta_files);
            fio_sta = mid_get_dat_sta_fio(sta_files, coeff_sta);
            data.fio_sta = fio_sta;
           
        
        
            % Get MID filters
            %--------------------------------------------------------------------
            filter_file_types = {...
                'rpdbest1_v1_files', ...
                'rpdbest1_v2_files', ...
                'rpdtest1_v1_files', ...
                'rpdtest1_v2_files', ...
                'rpdbest2_v1_files', ...
                'rpdbest2_v2_files', ...
                'rpdtest2_v1_files', ...
                'rpdtest2_v2_files'};
        
            filter_data_names = {...
                'best1_v1', ...
                'best1_v2', ...
                'test1_v1', ...
                'test1_v2', ...
                'best2_v1', ...
                'best2_v2', ...
                'test2_v1', ...
                'test2_v2'};
                
        
            for j = 1:length(filter_file_types)
                total_files = {};
                for k = 1:4
                    s1 = sprintf('datafiles.%s{%.0f}', filter_file_types{j},k);
                    s2 = sprintf('fullfile(filepath,%s);', s1);
                    total_files{k} = eval(s2);
                end
        
                [filter_mean, coeff, projection, filter_matrix] = ...
                    get_auditory_filter(total_files, nf_filter, nt_filter);
        
                string_data = sprintf('data.filter_mean_%s', filter_data_names{j});
                eval(sprintf('%s = filter_mean;', string_data));
        
                string_data = sprintf('data.coeff_%s', filter_data_names{j});
                eval(sprintf('%s = coeff;', string_data));
        
                string_data = sprintf('data.projection_%s', filter_data_names{j});
                eval(sprintf('%s = projection;', string_data));
        
                string_data = sprintf('data.filter_matrix_%s', filter_data_names{j});
                eval(sprintf('%s = filter_matrix;', string_data));
            end
        
        
            % Get MID nonlinearities
            %--------------------------------------------------------------------
            [fio_mid1] = get_dat_mid1_fio(datafiles.rpd_x1x2px_pxt_2_files, ...
                data.coeff_test2_v1, data.coeff_test2_v2);

        
            [fio_mid2] = get_dat_mid2_fio(datafiles.rpd_x1x2px_pxt_2_files, ...
                data.coeff_test2_v1, data.coeff_test2_v2);

            [fio_mid12] = get_dat_mid12_fio(datafiles.rpd_x1x2px_pxt_2_files, ...
                data.coeff_test2_v1, data.coeff_test2_v2);
        
            data.fio_mid1 = fio_mid1;
            data.fio_mid2 = fio_mid2;
            data.fio_mid12 = fio_mid12;

            save(outfile, 'data');
            fprintf('Data saved in  %s\n\n', outfile);

        else

            fprintf('Missing files.\n\n');

        end

    else

        fprintf('Data not saved because %s already exists\n\n', outfile);

    end


end % (for i)


return;







nh = filestruct(1).nh;
nv = filestruct(1).nv;
nlags = filestruct(1).nlags;
numtbins = filestruct(1).tbins; %20;
numfbins = filestruct(1).fbins; %25;
x0 = filestruct(1).x0; %20;
index_freq = (x0):(numfbins-1+x0);

s = load(paramfile,'taxis', 'faxis');
taxis = s.taxis;
time = taxis(1:numtbins); % time axis for filters
faxis = s.faxis;
freq = faxis(index_freq); % frequency axis for filters



% if ( length(locator) ~= size(stimulus,2) )
%    error('Spike train and envelope file have different number of trials.');
% end


for i = 1:length(filestruct)

	if ( isfield(filestruct, 'exp') )
	   filtstr(i).exp = filestruct(i).exp;
		filtstr(i).site = filestruct(i).site;
		filtstr(i).chan = filestruct(i).chan;
		filtstr(i).model = filestruct(i).model;
		filtstr(i).depth = filestruct(i).depth;
		filtstr(i).position = filestruct(i).position;
		filtstr(i).stim = filestruct(i).stim;
		filtstr(i).atten = filestruct(i).atten;
		filtstr(i).spl = filestruct(i).spl;
		filtstr(i).sm = filestruct(i).sm;
		filtstr(i).tm = filestruct(i).tm;
		filtstr(i).mdb = filestruct(i).mdb;
	else
	   filtstr(i).exp = [];
		filtstr(i).site = [];
		filtstr(i).chan = [];
		filtstr(i).model = [];
		filtstr(i).depth = [];
		filtstr(i).position = [];
		filtstr(i).stim = [];
		filtstr(i).atten = [];
		filtstr(i).spl = [];
		filtstr(i).sm = [];
		filtstr(i).tm = [];
		filtstr(i).mdb = [];
	end

   filtstr(i).location = filestruct(i).location;
   filtstr(i).unit = filestruct(i).unit;
   filtstr(i).x0 = filestruct(i).x0;
   filtstr(i).nh = filestruct(i).nh;
   filtstr(i).nv = filestruct(i).nv;
   filtstr(i).nlags = filestruct(i).nlags;
   filtstr(i).numtbins = numtbins;
   filtstr(i).numfbins = numfbins;
   filtstr(i).time = time;
   filtstr(i).freq = freq;


   %--------------------------------------------------------------------
   %   STA Filter from MID Code
   %--------------------------------------------------------------------

   if ( ~isempty(filestruct(i).rpsta) && length(filestruct(i).rpsta)==4 )

      if ( isempty(prefix) )
         file_sta = filestruct(i).rpsta;
      else
         for j = 1:length( filestruct(i).rpdtest2_v1 )
            file_sta{j} = sprintf('%s%s', prefix, filestruct(i).rpsta{j});
         end
      end

      [v_sta, coeff_sta, projection_sta, mtx_sta] = get_auditory_filter(file_sta, nh, nv, nlags);
   
      filtstr(i).v_sta = v_sta;
      filtstr(i).mtx_sta = mtx_sta;

   elseif ( ~isempty(filestruct(i).rpsta) && length(filestruct(i).rpsta)~=4 )
      filtstr(i).v_sta = [];
      filtstr(i).mtx_sta = [];
   else
      error('Code not ready to compute STAs just yet.');
   end





   %--------------------------------------------------------------------
   %   MID1 Filter from MID Code
   %--------------------------------------------------------------------

   if ( ~isempty(filestruct(i).rpdtest2_v1) && length(filestruct(i).rpdtest2_v1)==4 )

      if ( isempty(prefix) )
         file_v1 = filestruct(i).rpdtest2_v1;
      else
         for j = 1:length( filestruct(i).rpdtest2_v1 )
            file_v1{j} = sprintf('%s%s', prefix, filestruct(i).rpdtest2_v1{j});
         end
      end

      [v1, coeff_v1, projection_v1, mtx_v1] = get_auditory_filter(file_v1, nh, nv, nlags);
   
      filtstr(i).v1 = v1;
      filtstr(i).mtx_v1 = mtx_v1;

   elseif ( ~isempty(filestruct(i).rpdtest2_v1) && length(filestruct(i).rpdtest2_v1)~=4 )
      filtstr(i).v1 = [];
      filtstr(i).mtx_v1 = [];
   else
      fprintf('You need to run the mid code to compute the second filter.\n');
      %error('You need to run the mid code to compute the second filter.');
   end



   %--------------------------------------------------------------------
   %   MID2 Filter from MID Code
   %--------------------------------------------------------------------

   if ( ~isempty(filestruct(i).rpdtest2_v2) && length(filestruct(i).rpdtest2_v2)==4 )

      if ( isempty(prefix) )
         file_v2 = filestruct(i).rpdtest2_v2;
      else
         for j = 1:length( filestruct(i).rpdtest2_v2 )
            file_v2{j} = sprintf('%s%s', prefix, filestruct(i).rpdtest2_v2{j});
         end
      end

      [v2, coeff_v2, projection_v2, mtx_v2] = get_auditory_filter(file_v2, nh, nv, nlags);
   
      filtstr(i).v2 = v2;
      filtstr(i).mtx_v2 = mtx_v2;

   elseif ( ~isempty(filestruct(i).rpdtest2_v2) && length(filestruct(i).rpdtest2_v2)~=4 )
      filtstr(i).v2 = [];
      filtstr(i).mtx_v2 = [];
   else
      fprintf('You need to run the mid code to compute the second filter.\n');
      %error('You need to run the mid code to compute the second filter.');
   end

end

return;








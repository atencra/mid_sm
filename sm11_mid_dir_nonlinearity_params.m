function varargout = sm_mid_dir_nonlinearity_params(varargin)
% sm_mid_dir_nonlinearity_params  Asymmetry and separability of MID nonlinearities
%
%    sm_mid_dir_nonlinearity_params(keyword, value, ...)
% 
%    sm_mid_dir_nonlinearity_params goes through the current directory 
%    and searches for *-filter-fio.mat files.
%
%    It then extracts the nonlinearities and estimates the asymmetry of the
%    1D nonlinearities and the separability index of the 2D nonlinearity.
%
%    Data are saved in *-filter-fio-params.mat files.
%
%    sm_mid_dir_nonlinearity_params accepts keyword/value arguments.
%
%       keyword         value
%       ==============================================================
%       'batch'         Default = 0. If 1, then the function is assumed
%                       to be run outside of data folders.
%
%       'process'       Overwrite existing files? Default = 0 = NO. 
%                       Set to 1 to overwrite files with the same name.
%    
%    All processed data and the results can be returned by specifying
%    a single output argument:
%
%       fioparams = sm_mid_dir_nonlinearity_params();

graphics_toolkit('qt');


narginchk(0,4);

options = struct('batch', 0, 'process', 0);

options = input_options(options, varargin);


if ( options.batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

fioparams_total = [];

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    dfilters = dir(fullfile('.', '*-filter-fio.mat'));

    if ~isempty(dfilters)

        matfiles = {dfilters.name};

        for i = 1:length(matfiles)

            outfile = matfiles{i};
            outfile = strrep(outfile, '.mat', '-params.mat');
           
            fprintf('\nProcessing %s\n', matfiles{i});

            if ( exist(outfile,'file') && ~options.process ) 
                fprintf('\nData already saved in %s\n', outfile);
                continue;
            end 
           
            load(matfiles{i}, 'data');
            
            [sta_asi, mid1_asi, mid2_asi, mid12_si] = ...
                mid_nonlinearity_1d_2d_params(data);

            fioparams = data;
            data_fieldnames = fieldnames(data);
            params_fieldnames = {'sprfile', 'iskfile', 'exp', 'time', ...
                                'site', 'stim', 'unit', 'fio_sta', 'fio_mid1', ...
                                'fio_mid2', 'fio_mid12'};
            remove_fieldnames = setdiff(data_fieldnames, params_fieldnames);
            fioparams = rmfield(fioparams, remove_fieldnames);

            fioparams.sta_asi = sta_asi;
            fioparams.mid1_asi = mid1_asi;
            fioparams.mid2_asi = mid2_asi;
            fioparams.mid12_si = mid12_si;

            save(outfile, 'fioparams');
            fprintf('Data saved to %s\n', outfile);

            if nargout == 1
                fioparams_total = [fioparams_total fioparams];
            end

        end % (for i)
    else

        fprintf('No *-filter-fio.mat files in %s\n', folders{ii});

    end % ( ~isempty )

    cd(startdir)

end % (for ii)

if nargout == 1
    varargout{1} = fioparams_total;
end

return;


function [sta_asi, mid1_asi, mid2_asi, mid12_si] = ...
    mid_nonlinearity_1d_2d_params(data)

iskfile = data.iskfile;
nspk = sum(data.locator);
nf_filter = data.nf_filter;
nt_filter = data.nt_filter;


sta_filt = data.filter_mean_sta;
sta_fio_x = data.fio_sta.x_mean;
sta_fio_ior = data.fio_sta.ior_mean;
sta_fio_ior_std = data.fio_sta.ior_std;

pspk = data.fio_sta.pspk_mean;

mid1_filt = data.filter_mean_test2_v1;
mid1_fio_x = data.fio_mid1.x1_mean;
mid1_fio_ior = data.fio_mid1.pspkx1_mean;
mid1_fio_ior_std = data.fio_mid1.pspkx1_std;


mid2_filt = data.filter_mean_test2_v2;
mid2_fio_x = data.fio_mid2.x2_mean;
mid2_fio_ior = data.fio_mid2.pspkx2_mean;
mid2_fio_ior_std = data.fio_mid2.pspkx2_std;

mid12_fio_x1 = data.fio_mid12.x1_mean;
mid12_fio_x2 = data.fio_mid12.x2_mean;
mid12_fio_ior = data.fio_mid12.pspkx1x2_mean;
mid12_fio_ior_std = data.fio_mid12.pspkx1x2_std;



x = sta_fio_x;
fx = sta_fio_ior; 

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )

    index = find(x < 0);
    neg = fx(index);

    index = find(x > 0);
    pos = fx(index);

    sta_asi = (sum(pos) - sum(neg)) / (sum(pos) + sum(neg));

else

    sta_asi = -9999;

end



x = mid1_fio_x;
fx = mid1_fio_ior; 

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )

    index = find(x < 0);
    neg = fx(index);

    index = find(x > 0);
    pos = fx(index);

    mid1_asi = (sum(pos) - sum(neg)) / (sum(pos) + sum(neg));

else

    mid1_asi = -9999;

end

   


x = mid2_fio_x;
fx = mid2_fio_ior; 

if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )

    index = find(x < 0);
    neg = fx(index);

    index = find(x > 0);
    pos = fx(index);

    mid2_asi = (sum(pos) - sum(neg)) / (sum(pos) + sum(neg));

else

    mid2_asi = -9999;

end













% 2D nonlinearity
%------------------------------

mid12_fio_x1 = data.fio_mid12.x1_mean;
mid12_fio_x2 = data.fio_mid12.x2_mean;
mid12_fio_ior = data.fio_mid12.pspkx1x2_mean;
mid12_fio_ior_std = data.fio_mid12.pspkx1x2_std;

pspkx1x2 =  mid12_fio_ior + 0.001;

[u, s, v] = svd(pspkx1x2);
svals = sum(s);
eigvals = svals .^ 2;
mid12_si = eigvals(1) / sum(eigvals+eps);


return;




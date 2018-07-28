function varargout = sm_fra_params_total_to_csv(varargin)
% sm_fra_params_total_to_csv FRA parameters struct array to CSV file
%    
%
%   params_total is obtained from sm_dir_get_fra_params.m
%
%   Reads params-v6.mat files in the current directory and saves the values
%   in each file to csv file.
%
%   Inputs to the function must be in keyword/value form:
%
%   Keyword         Value
%   ===============================================================
%   'outfolder'     Default = '.'. Change to alter output destination of csv file.
%   'params_total'  Required. struct array holding all squirrel monkey FRA params structs.
%   'process'       Default = 0. Set to 1 to overwrite the previously saved csv file.
%
%   data = sm_fra_params_total_to_csv('outfolder', '.', 'params_total', 'params_total');
%


library('csv');

nargoutchk(0,1);

narginchk(0,6);
options = struct(...
'outfolder', '.', ...
'process', 0, ...
'params_total', []);

options = input_options(options, varargin);
outfolder = options.outfolder;
params_total = options.params_total;


if isempty(params_total)
    error('Provide input params_total struct array.');
end

outfile = 'sm_fra_params.csv';
doutfile = dir(outfile);

if ( isempty(doutfile) || options.process )

    for i = 1:length(params_total)

        fprintf('Processing %.0f of %.0f\n', i, length(params_total));

        params = params_total(i);

        nspks = sum(params.spkcount);
        nreps = 3; %params.nreps;
        minfreq = min(params.freq);
        maxfreq = max(params.freq);
        minatten = min(params.atten);
        maxatten = max(params.atten);
        noct = log2(maxfreq/minfreq);
        center = minfreq * 2^(noct/2);

        if ~isempty(params.cf)
            cf = params.cf;
        else
            cf = -9999;
        end

        if ~isempty(params.threshold)
            threshold = params.threshold;
        else
            threshold = -9999;
        end

        if ~isempty(params.latency)
            latency = params.latency;
        else
            latency = -9999;
        end

        if (length(params.bw10) == 2 )
            bw10low = params.bw10(1);
            bw10hi = params.bw10(2);
        else
            bw10low = -9999;
            bw10hi = -9999;
        end

        if (length(params.bw20) == 2 )
            bw20low = params.bw20(1);
            bw20hi = params.bw20(2);
        else
            bw20low = -9999;
            bw20hi = -9999;
        end

        if (length(params.bw30) == 2 )
            bw30low = params.bw30(1);
            bw30hi = params.bw30(2);
        else
            bw30low = -9999;
            bw30hi = -9999;
        end

        if (length(params.bw40) == 2 )
            bw40low = params.bw40(1);
            bw40hi = params.bw40(2);
        else
            bw40low = -9999;
            bw40hi = -9999;
        end

        data.iskfile{i} = params.iskfile;
        data.nev_fra_file{i} = params.nev_fra_file;
        data.nev_long_file{i} = params.nev_long_file;
        data.nev_rep_file{i} = params.nev_rep_file;
        data.params_file{i} = params.params_file;

        data.Nspks{i} = nspks;
        data.Nreps{i} = nreps;
        data.MinFreq{i} = minfreq;
        data.MaxFreq{i} = maxfreq;
        data.MinAtten{i} = minatten;
        data.MaxAtten{i} = maxatten;
        data.Center{i} = center;
        data.Noct{i} = noct;
        data.CF{i} = cf;
        data.Threshold{i} = threshold;
        data.Latency{i} = latency;

        data.BW10low{i} = bw10low;
        data.BW10hi{i} = bw10hi;
        data.BW10oct{i} = log2(bw10hi/bw10low); 

        data.BW20low{i} = bw20low;
        data.BW20hi{i} = bw20hi;
        data.BW20oct{i} = log2(bw20hi/bw20low); 

        data.BW30low{i} = bw30low;
        data.BW30hi{i} = bw30hi;
        data.BW30oct{i} = log2(bw30hi/bw30low); 

        data.BW40low{i} = bw40low;
        data.BW40hi{i} = bw40hi;
        data.BW40oct{i} = log2(bw40hi/bw40low); 

    end % (for i)

    csv_struct2csv(data, outfile);
    fprintf('Data saved to: %s\n\n', outfile);
    varargout{1} = data;

else
    fprintf('%s already exists.\n', outfile);
end



return;




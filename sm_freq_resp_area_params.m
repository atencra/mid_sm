function params = sm_freq_resp_area_params(fra)
% sm_freq_resp_area_params CF, BW, etc from squirrel monkey FRA.
%
%   params = sm_freq_resp_area_params(fra)
%
%   fra is a struct array holding the tuning curve calculations
%   obtained using the function sm_fra_nev.m
%

fprintf('%s\n', mfilename);

%library('audiobox');
%
%assert(isfield(fra,'hp_atten'), 'hp_atten needs to be a field of fra.');
%assert(isfield(fra,'art_atten'), 'art_atten needs to be a field of fra.');
%
%calspl = 84;
%calhp = 30;
%calart = 11;
%maxamp = speakerspl(calspl, calhp, calart, fra(1).hp_atten, fra(1).art_atten);
%
%fprintf('Max amplitude = %.1f dB SPL\n', maxamp);

maxamp = -9999;

close all;


params = fra;

data_figure = figure;
ss = get(0, 'screensize');
set(data_figure, 'position', [0.5*ss(3) 0.4*ss(4) 0.4*ss(3) 0.5*ss(4)]);
%set(data_figure,'position', [1500 250 1000 800]);

for n = 1:length(fra)

    try

        fra_unit = fra(n);
        freq = fra_unit.freq / 1000;
        atten = -fra_unit.atten;

        uf = unique(freq);
        doct = log2(uf(2)/uf(1));
        fmin = min(uf) .* 2.^ (-doct);
        fmax = max(uf) .* 2.^ (doct);

        amin = min(atten);
        amax = max(atten);
        da = abs(atten(2) - atten(1));

        resp = fra_unit.spkcount;

        clf(data_figure);

        plot_tms_nev_fra(fra_unit);

        fprintf('Choose threshold, or click outside to skip.\n');
        [cf, thr] = ginput(1)

        if ( cf>fmin && cf<fmax && thr>(amin-da) && thr<amax )

            fprintf('Processing FRA.\n');

            fprintf('CF = %.2f kHz\n', cf);
            fprintf('Thr = %.2f dB\n', thr);
            fprintf('\n');

            [level, rate] = rate_level_curve(resp, freq, atten, cf);
            rlcurve = [level(:) rate(:)];


            plot([fmin fmax],[thr thr],'r--', 'linewidth', 2);
            plot([cf],[thr],'ro', 'markersize', 12);


        %if ( isempty(answer) )

            % get the latency data
            % -------------------------------------------------------------
    %         lat = [];
    %         for i = 1:length(fra(n).resp)
    %             trialspikes = fra(n).resp{i};
    %             index = find(trialspikes>0 && trialspikes<50);
    %             window_spikes = trialspikes(index);
    %             lat = [lat window_spikes(:)'];
    %         end % (for i)
    % 
    %         hist(lat,50); 
    %         [latency, dummay] = ginput(1);
    %         clf(data_figure);
    % 
    %         fprintf('Latency = %.2f ms\n', latency);

            latency = -9999;


            % plot tuning and extract cf, threshold, and bandwidths
            % -------------------------------------------------------------
            satisfied = 0;

            while ( ~satisfied )

                plot([fmin fmax],[thr thr],'r--', 'linewidth', 2);
                plot([cf],[thr],'ro', 'markersize', 12);

                dbabove = [10:10:40];
                bwmat = zeros(4,2);

                for j = 1:length(dbabove)

                    if ( (thr+dbabove(j)) <= (amax+da/2) )
                        plot([fmin fmax],[thr+dbabove(j) thr+dbabove(j)],'r--', 'linewidth', 2);
                        fprintf('Choose BW at %.0f dB above threshold or pick outside FRA to skip.\n', dbabove(j));
                        [x1,y1] = ginput(1);

                        if ( x1>fmin && x1<fmax && y1>amin && y1<amax )
                            plot(x1,thr+dbabove(j),'ro', 'markersize', 8, 'markerfacecolor', 'r');
                            [x2,y2] = ginput(1);
                            plot(x2,thr+dbabove(j),'ro', 'markersize', 8, 'markerfacecolor', 'r');
                            [bw, dummy] = sort([x1 x2]);
                            %plot([bw],[thr+dbabove(j) thr+dbabove(j)],'ro', ...
                            %    'markersize', 8, 'markerfacecolor', 'r');
                        else
                            bw = -9999*ones(1,2);
                        end
                     else
                        bw = -9999*ones(1,2);
                     end

                     bwmat(j,:) = bw;

                 end % (for j)

                fprintf('\nSatisfied? Click inside FRA, or click outside to redo.\n');
                [x,y] = ginput(1)

                if ( x>fmin && x<fmax && y>amin && y<amax )
                    satisfied = 1;
                    clf(data_figure);
                else
                    satisfied = 0;
                    clf(data_figure);
                    plot_tms_fra(fra_unit);
                    fprintf('Choose threshold.\n');
                    [cf, thr] = ginput(1);
                    fprintf('CF = %.2f kHz\n', cf);
                    fprintf('Thr = %.2f dB\n', thr);
                    fprintf('\n');
                end

            end % (while)

            params(n).maxamp = maxamp;
            params(n).cf = cf;
            params(n).threshold = thr;
            params(n).latency = latency;
            params(n).bw10 = bwmat(1,:);
            params(n).bw20 = bwmat(2,:);
            params(n).bw30 = bwmat(3,:);
            params(n).bw40 = bwmat(4,:);
            params(n).rlcurve = rlcurve;
            params(n).level = level;
            params(n).rate = rate;

            save('temp-fra-params', 'params');

        else
            params(n).maxamp = maxamp;
            params(n).cf = -9999;
            params(n).threshold = -9999;
            params(n).latency = -9999;
            params(n).bw10 = -9999*ones(1,2);
            params(n).bw20 = -9999*ones(1,2);
            params(n).bw30 = -9999*ones(1,2);
            params(n).bw40 = -9999*ones(1,2);
            params(n).rlcurve = -9999;
            params(n).level = -9999;
            params(n).rate = -9999;


        end % (if-else)

    catch
        fprintf('catch clause.\n');
        params(n).maxamp = maxamp;
        params(n).cf = -9999;
        params(n).threshold = -9999;
        params(n).latency = -9999;
        params(n).bw10 = -9999*ones(1,2);
        params(n).bw20 = -9999*ones(1,2);
        params(n).bw30 = -9999*ones(1,2);
        params(n).bw40 = -9999*ones(1,2);
        params(n).rlcurve = -9999;
        params(n).level = -9999;
        params(n).rate = -9999;

    end_try_catch

end % (for n)

close('all');


return;




function [level, rate] = rate_level_curve(spkcount, freq, amp, cf)

ua = unique(amp);
ua = ua(:)';

fmin = cf / 2.^ (1/2);
fmax = cf * 2.^ (1/2);

level = ua;
rate = zeros(size(level));
ntrials = length(freq);

for i = 1:length(level)

    for j = 1:ntrials
        if ( (amp(j)==level(i)) && (freq(j)>=fmin) && (freq(j)<=fmax) );
            nspks = spkcount(j);
            rate(i) = rate(i) + nspks;
        end
    end

end


return;













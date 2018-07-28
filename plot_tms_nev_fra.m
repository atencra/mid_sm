function plot_tms_nev_fra(fra, varargin)
%    plot_tms_fra Plot TMS style frequency response area
%    
%    plot_tms_fra(fra) 
%
%       fra : struct holding frequency response data.
%               Assumes that maximum SPL is 95.
%
%    plot_tms_fra(fra, 'maxaxmp', maxamp) 
%               Sets maximum SPL to maxamp.
%
%    plot_tms_fra(fra, 'xdf', xdf)
%       plot every xdf'th frequency value for xaxis tickmarks
%
%    plot_tms_fra(fra, 'ydf', ydf)
%       plot every ydf'th frequency value for yaxis tickmarks


fprintf('%s\n', mfilename);

graphics_toolkit('qt');

narginchk(1,7);

options = struct(...
'maxamp', 0, ...
'xdf', 7, ...
'ydf', 1);

options = input_options(options, varargin);

maxamp = options.maxamp;
xdf = options.xdf;
ydf = options.ydf;

freq = fra.freq;
atten = fra.atten;
if ( min(atten) < 0 )
    atten = fra.atten;
else
    atten = -1 * round(fra.atten);
end

spikecount = fra.spkcount;
f = freq;

a = atten + maxamp;

if ( max(f) > 1000 )
    f = f / 1000;
end

uf = unique(f);
uf = uf(:)';

ua = unique(a);
ua = ua(:)';
da = ua(2) - ua(1);

xtick = roundsd(uf(1:xdf:end),2);
doct = log2(uf(2)/uf(1));
fmin = min(f) .* 2.^ (-doct);
fmax = max(f) .* 2.^ (doct);

temp = fliplr(ua);
ytick = temp(1:ydf:end);
ytick = fliplr(ytick);

% Scale based on quantiles/percentiles???

q95 = quantile(spikecount,[0.95]);
q975 = quantile(spikecount,[0.975]);

if q975 == 0
    q975 = 1;
end


hold on;
%patch([fmin fmin fmax fmax], [min(ua)-da max(ua)+da max(ua)+da min(ua)-da], 'k');
for i = 1:length(f)
    nspks = spikecount(i);
    if ( nspks )
        if ( nspks > q975 )
            nspks = q975;
        end
        %plot([f(i) f(i)], [a(i)-(nspks/q975)*2.5 a(i)+(nspks/q975)*2.5], '-', 'color', 'y');
        plot([f(i) f(i)], [a(i)-(nspks/q975)*2.5 a(i)+(nspks/q975)*2.5], '-', 'color', 'k', 'linewidth', 1);
    end
end

set(gca, 'xtick', xtick, 'xticklabel', xtick);
set(gca,'xscale', 'log');
xlim([fmin fmax]);

set(gca, 'ytick', ytick, 'yticklabel', ytick);
ylim([min(ua)-da max(ua)+da]);


set(gca,'tickdir', 'out');
set(gca, 'ticklength', [0.025 0.025]);

return;

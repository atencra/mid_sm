function fioparams = sm_mid_cat_nonlinearity_params(fiopos, midpos)
% sm_mid_cat_nonlinearity_params  Asymmetry and separability of MID nonlinearities for cat data
%
%    fioparams = sm_mid_cat_nonlinearity_params(fiopos)
% 
%       fiopos : struct array holding cat MID results.
%
%       fioparams : struct holding nonlinearity parameters.
%    

graphics_toolkit('qt');

narginchk(2,2);

experiment = {};
site = {};
chan = {};
model = {};
depth = {};
position = {};
stim = {};
atten = {};
spl = {};
sm = {};
tm = {};
mdb = {};
sta_asi_total = {};
mid1_asi_total = {};
mid2_asi_total = {};
mid12_si_total = {};

for i = 1:length(fiopos)

    experiment{i} = fiopos(i).exp;
    site{i} = fiopos(i).site;
    chan{i} = fiopos(i).chan;
    model{i} = fiopos(i).model;
    depth{i} = fiopos(i).depth;
    position{i} = fiopos(i).position;
    stim{i} = fiopos(i).stim;
    atten{i} = fiopos(i).atten;
    spl{i} = fiopos(i).spl;
    sm{i} = 4;
    tm{i} = 40;
    mdb{i} = 40; 

    x = fiopos(i).sta.x;
    fx = fiopos(i).sta.fx; 

    if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
        index = find(x < 0);
        neg = fx(index);

        index = find(x > 0);
        pos = fx(index);

        sta_asi = (sum(pos) - sum(neg)) / (sum(pos) + sum(neg));
    else
        sta_asi = -9999;
    end

    x = fiopos(i).v1.x;
    fx = fiopos(i).v1.fx; 

    if ( ~isempty(x) && ~isempty(fx) && length(x)==length(fx) )
        index = find(x < 0);
        neg = fx(index);

        index = find(x > 0);
        pos = fx(index);

        mid1_asi = (sum(pos) - sum(neg)) / (sum(pos) + sum(neg));
    else
        mid1_asi = -9999;
    end

    x = fiopos(i).v2.x;
    fx = fiopos(i).v2.fx; 

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
    x12 = midpos(i).rpdx1x2px_pxt_2.x12;
    y12 = midpos(i).rpdx1x2px_pxt_2.y12;
    fx_v1v2 = midpos(i).rpdx1x2px_pxt_2.ior12_mean;
    pspkx1x2 = fx_v1v2 + 0.001;

    [u, s, v] = svd(pspkx1x2);
    svals = sum(s);
    eigvals = svals .^ 2;
    mid12_si = eigvals(1) / sum(eigvals+eps);

    sta_asi_total{i} = sta_asi;
    mid1_asi_total{i} = mid1_asi;
    mid2_asi_total{i} = mid2_asi;
    mid12_si_total{i} = mid12_si; 

end % (for i)


fioparams.experiment = experiment;
fioparams.site = site;
fioparams.chan = chan;
fioparams.model = model;
fioparams.depth = depth;
fioparams.position = position;
fioparams.stim = stim;
fioparams.atten = atten;
fioparams.spl = spl;
fioparams.sm = sm;
fioparams.tm = tm;
fioparams.mdb = mdb;
fioparams.sta_asi = sta_asi_total;
fioparams.mid1_asi = mid1_asi_total;
fioparams.mid2_asi = mid2_asi_total;
fioparams.mid12_si = mid12_si_total;


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




function [fio] = get_dat_sta_fio(files, coeff, varargin)
%function [mean_firing, x_mean, ior_mean, ior_std, px_mean, px_std] =
%get_dat_sta_fio(folder, location, cellnum, nv, nh, coeff, varargin)
%
%[mean_firing, x_mean, ior_mean, ior_std, px_mean, px_std] = ...
%     get_dat_sta_fio(folder, location, cellnum, coeff, Nparts, Nbins, Nbins_short, minpx)
%
% summary of changes made to accomodate ripple stimuli(May 31 2005):
% downsampling in ior2_mean is done by summing pxt within a larger bin, summing px within the 
% larger bin, and dividing the two numbers, also introduced dx, and probability distribution is now shown as a probability density
%
%
% The function assumes that you have files of the form:
%
%     rpx1pxpxt_sta_707_1_1x25x20_1_1.dat            
%     rpx1pxpxt_sta_707_1_1x25x20_1_2.dat            
%     rpx1pxpxt_sta_707_1_1x25x20_1_3.dat            
%     rpx1pxpxt_sta_707_1_1x25x20_1_4.dat     
%
% Parts of the file name are variable, such as 707, 25 , 20. These are specified by
% input arguments.
%
% folder : location of data. Example: 'C:\MATLABR2007b\work\data\MID_Inferior_Colliculus\';
%
% location : Tanya's site identifier. Examples: 707, 708, 709, etc.
%
% cellnum : Tanya's global cell identifier. Examples: 1, 2, 3, ...
%
% coeffs : coefficient vector which tells the polarity of the filters
%
% Npart = 4 : num of test reps in mid code. Should be 4.
%
% Nbins = 21 : num bins used to obtain projection values in mid code
%
% Nbins_short = 14 : num bins used to get nonlinearity values
%
%
% If you call get_data_sta_fio.m as
%
% [fio] = get_dat_sta_fio(folder, location, cellnum, nv, nh, coeff)
%
% then Nparts = 4, Nbins = 21, and Nbins_short = 14 by default.
%
% caa 2/17/09

% Parameters that Tatyana uses in her programs
% Nbins = 21; % used for input/output function but not RF
% Nbins_short = 14; % used for input/output function but not RF
% Nparts = 4; % used to identify files, not sure what the significance
%             % is, though



%     files{1} = rpx1pxpxt_sta_707_1_1x25x20_1_1.dat            
%     files{2} = rpx1pxpxt_sta_707_1_1x25x20_1_2.dat            
%     files{3} = rpx1pxpxt_sta_707_1_1x25x20_1_3.dat            
%     files{4} = rpx1pxpxt_sta_707_1_1x25x20_1_4.dat     


x_mtx = [];
px_mtx = [];
ior_mtx = [];
Nbins_short = 14;
mean_firing = 0;

% The default for Nparts below was originally 8 in Tanya's original code.
if isempty(varargin)
    Nparts = 4;
    Nbins = 21;
    minpx = 0;
elseif length(varargin)==1
    Nparts = 4;
    Nbins = varargin{1};
    minpx = 0;
elseif length(varargin)==2
    Nbins = varargin{1};
    Nparts = varargin{2};
    minpx = 0;
elseif length(varargin)==3
    Nbins = varargin{1};
    Nparts = varargin{2};
    Nbins_short = varargin{3};
    minpx = 0;
elseif length(varargin)==4
    Nbins = varargin{1};
    Nparts = varargin{2};
    Nbins_short = varargin{3};
    minpx = varargin{4};
end

if (length(coeff)~=Nparts) 
    length(coeff)
    coeff
    Nparts
    display('wrong length of coeff vector');
    return
end

if ( Nparts ~= 4 )
   error('For time being, Nparts must equal 4.');
end


pspk_mtx = [];
pxspk_mtx = [];
pspkx_mtx = [];

for i=1:Nparts

    %fname = sprintf('%s_%u.dat',fname_first,i);
    fp = fopen(files{i},'r');

    if (fp==-1)
        display('error opening file');
        display(files{i});
        pause
        return
    end


    x = fread(fp,Nbins,'double'); % projection value
    px = fread(fp,Nbins,'double'); % prob of a projection, p(x)

    ind0 = find( px < minpx );
    xm = sum( x.*px );
    x = x - xm; % center the projection values to 0

    pxt = fread(fp,Nbins,'double');
    pxt(ind0) = 0;

    pxspk_pspk = pxt; % p(x|spk) * p(spk)

    if (abs(sum(px)-1)>0.001) 
        display(sprintf('sum of px=%f',sum(px))); 
        fio.nbins = [];
        fio.nbins_short = [];
        fio.pspk_mtx = [];
        fio.pspk_mean = [];
        fio.x_mtx = [];
        fio.px_mtx = [];
        fio.pxspk_mtx = [];
        fio.pspkx_mtx = [];
        fio.ior_mtx = [];
        fio.x_mean = [];
        fio.ior_mean = [];
        fio.ior_std = [];
        fio.px_mean = [];
        fio.px_std = [];
        fio.info = [];
        return;
    end


    rbar = fread(fp, 1, 'double');
    pspk = rbar; % p(spk)
    pxspk = pxspk_pspk ./ pspk; % p(x|spk)

    mean_firing = mean_firing + rbar/Nparts;
    mean_pspk = mean_firing;

    Nrep_eff = fread(fp,1,'double');
    fclose(fp);

   x_r = x;

   if ( coeff(i)==1 )
      ior = pxt ./ (px+eps);
      pspkx = ior;
   else 
      for j = 1:Nbins
         ior(Nbins+1-j) = pxt(j) / (px(j)+eps);
      end
      pspkx = ior;
      x_r = -x;
   end

   x_r = reshape(x_r,Nbins,1); % projection value
   px = reshape(px,Nbins,1);
   ior = reshape(ior,Nbins,1); % p(spk|x)

   maxior = max(ior);
   minior = min(ior);

   ior_mtx = [ior_mtx ior]; % matrix of p(spk|x)
   x_mtx = [x_mtx x_r]; % projection matrix
   px_mtx = [px_mtx px];

   pxspk = reshape(pxspk, Nbins,1);
   pspkx = reshape(pspkx, Nbins,1);

   pspk_mtx = [pspk_mtx pspk];
   pxspk_mtx = [pxspk_mtx pxspk];
   pspkx_mtx = [pspkx_mtx pspkx];
    
files
coeff
pause

end


if (isempty(ior_mtx) )
    display('empty ior_mtx in plot_an_ior');
    return;
end


ior_mtx = reshape(ior_mtx,Nbins,Nparts);

x0 = min(min(x_mtx));
x1 = max(max(x_mtx));
maxmax = max([abs(x0) x1]);
edges = linspace(-maxmax, maxmax, Nbins_short); % make bounds equal

%edges=linspace(x0,x1,Nbins_short);

ior_rescaled = zeros(Nbins_short-1,Nparts);
px_rescaled = zeros(Nbins_short-1,Nparts);
npoints = zeros(Nbins_short-1,Nparts);

for i = 1:Nbins_short-1

    for j = 1:Nparts

        ind = find((x_mtx(:,j)>=edges(i))&(x_mtx(:,j)<edges(i+1)));

        if ( ~isempty(ind) )
            npoints(i,j) = npoints(i,j)+length(ind);
            px_rescaled(i,j) = px_rescaled(i,j)+sum(px_mtx(ind,j));
            ior_rescaled(i,j) = ior_rescaled(i,j)+sum(ior_mtx(ind,j).*px_mtx(ind,j));
        end

    end

    x_mean(i) = 0.5 * (edges(i)+edges(i+1));

end

ior_rescaled = ior_rescaled ./ (px_rescaled+eps);

px_mean = mean(px_rescaled');
ior_mean = mean(ior_rescaled');

ior_std = sqrt(var(ior_rescaled') / Nparts);
px_std = sqrt(var(px_rescaled') / Nparts);    

dx = (max(x_mean)-min(x_mean))/(Nbins_short-1);

px_mean = px_mean ./ dx;
px_std = px_std ./ dx;


% Calculate information values:
pxs1 = pxspk_mtx(:,1);
pxs2 = pxspk_mtx(:,2);
pxs3 = pxspk_mtx(:,3);
pxs4 = pxspk_mtx(:,4);

px1 = px_mtx(:,1);
px2 = px_mtx(:,2);
px3 = px_mtx(:,3);
px4 = px_mtx(:,4);

ind1 = find(pxs1>0 & px1>0);
ind2 = find(pxs2>0 & px2>0);
ind3 = find(pxs3>0 & px3>0);
ind4 = find(pxs4>0 & px4>0);

info1 = sum( pxs1(ind1) .* log2( pxs1(ind1) ./ px1(ind1) ) );
info2 = sum( pxs2(ind2) .* log2( pxs2(ind2) ./ px2(ind2) ) );
info3 = sum( pxs3(ind3) .* log2( pxs3(ind3) ./ px3(ind3) ) );
info4 = sum( pxs4(ind4) .* log2( pxs4(ind4) ./ px4(ind4) ) );

info = [info1 info2 info3 info4];


fio.nbins = Nbins;
fio.nbins_short = Nbins_short;
fio.pspk_mtx = pspk_mtx;
fio.pspk_mean = mean_pspk;
fio.x_mtx = x_mtx;
fio.px_mtx = px_mtx;
fio.pxspk_mtx = pxspk_mtx;
fio.pspkx_mtx = pspkx_mtx;
fio.ior_mtx = ior_mtx;
fio.x_mean = x_mean;
fio.ior_mean = ior_mean;
fio.ior_std = ior_std;
fio.px_mean = px_mean;
fio.px_std = px_std;
fio.info = info;

fio
pause

return;














for i=1:Nparts

end

if ( size(pspkx_mtx,2) ~= Nparts )
    error('empty pxspk_pspk');
end

% size(x_mtx)
% size(px_mtx)
% size(pxspk_mtx)
% size(pspkx_mtx)
% size(pspk_mtx)
% pause


% Calculate information values using a different technique:
pxs1 = pxspk_mtx(:,1);
pxs2 = pxspk_mtx(:,2);
pxs3 = pxspk_mtx(:,3);
pxs4 = pxspk_mtx(:,4);

px1 = px_mtx(:,1);
px2 = px_mtx(:,2);
px3 = px_mtx(:,3);
px4 = px_mtx(:,4);

ind1 = find(pxs1>0 & px1>0);
ind2 = find(pxs2>0 & px2>0);
ind3 = find(pxs3>0 & px3>0);
ind4 = find(pxs4>0 & px4>0);

info1 = sum( pxs1(ind1) .* log2( pxs1(ind1) ./ px1(ind1) ) );
info2 = sum( pxs2(ind2) .* log2( pxs2(ind2) ./ px2(ind2) ) );
info3 = sum( pxs3(ind3) .* log2( pxs3(ind3) ./ px3(ind3) ) );
info4 = sum( pxs4(ind4) .* log2( pxs4(ind4) ./ px4(ind4) ) );

information = [info1 info2 info3 info4];


% pspkx_mtx = reshape(pspkx_mtx,Nbins,Nparts);
% 
% xmin = min(min(x_mtx));
% xmax = max(max(x_mtx));
% maxmax = max([abs(xmin) xmax]);
% edges = linspace(-maxmax, maxmax, Nbins_short);
% 
% %edges=linspace(x0,x1,Nbins_short);
% 
% pspkx_rescaled = zeros(Nbins_short-1,Nparts);
% px_rescaled = zeros(Nbins_short-1,Nparts);
% pxspk_rescaled = zeros(Nbins_short-1,Nparts);
% npoints = zeros(Nbins_short-1,Nparts);
% 
% for i=1:Nbins_short-1
% 
%     for j=1:Nparts
% 
%         ind = find((x_mtx(:,j)>=edges(i))&(x_mtx(:,j)<edges(i+1)));
% 
%         if ~isempty(ind)
%             npoints(i,j) = npoints(i,j)+length(ind);
%             px_rescaled(i,j) = px_rescaled(i,j) + sum(px_mtx(ind,j));
%             pxspk_rescaled(i,j) = pxspk_rescaled(i,j) + sum(pxspk_mtx(ind,j));
%             pspkx_rescaled(i,j) = pspkx_rescaled(i,j) + sum(pspkx_mtx(ind,j).*px_mtx(ind,j));
%         end
% 
%     end
% 
%     x_mean(i)=0.5*(edges(i)+edges(i+1));
% 
% end
% 
% pspkx_rescaled = pspkx_rescaled ./ (px_rescaled+eps);
% 
% pspkx_mean = mean(pspkx_rescaled');
% pspkx_std = sqrt(var(pspkx_rescaled') / Nparts);
% 
% px_mean = mean(px_rescaled');
% px_std = sqrt(var(px_rescaled') / Nparts);    
% 
% dx = (max(x_mean)-min(x_mean))/(Nbins_short-1);
% 
% px_mean = px_mean ./ dx;
% px_std = px_std ./ dx;
% 
% 
% % The following code will also calculate the nonlinearity by 
% % using a loess procedure to find the appropriate shape
% % to the nonlinearity
% projection = -10:0.25:10;
% xmin = min(x_mtx(:))
% xmax = max(x_mtx(:))
% 
% ipos = find(projection < xmax);
% ineg = find(projection > xmin);
% 
% pmax = projection(max(ipos))
% pmin = projection(min(ineg))
% pause
% 
% 
% newx = pmin:0.25:pmax;
% alpha = .1; % minimal smoothing
% 
% lambda = 1; % linear local curve fitting
% newylin = loess(x_mtx(:), pspkx_mtx(:), newx, alpha, lambda);
% newylin(newylin<0) = 0;
% 
% 
% lambda = 2; % quadratic local curve fitting
% newyquad = loess(x_mtx(:), pspkx_mtx(:), newx, alpha, lambda);
% newyquad(newyquad<0) = 0;
% 
% % the linear local curve fitting approach is the best
% 
% figure;
% 
% subplot(2,1,1);
% hold on;
% plot(x_mtx(:,1), pspkx_mtx(:,1), 'ko');
% plot(x_mtx(:,2), pspkx_mtx(:,2), 'ko');
% plot(x_mtx(:,3), pspkx_mtx(:,3), 'ko');
% plot(x_mtx(:,4), pspkx_mtx(:,4), 'ko');
% plot(newx, newylin, 'r-', 'linewidth', 2);
% plot(newx, newyquad, 'g-', 'linewidth', 2);
% xlim([-6 6])
% 
% subplot(2,1,2);
% hold on;
% plot(newx, newylin, 'ro-', 'linewidth', 2);
% plot(newx, newyquad, 'go-', 'linewidth', 2);
% plot(x_mean, pspkx_mean, 'ko-');
% xlim([-6 6])
% 
% pause







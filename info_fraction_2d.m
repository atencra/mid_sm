function [ifrac] = info_fraction_2d(locator, x1, x2, x1binedges, x2binedges, frac)
%info_fraction_2d - filter information for different data fractions
%
% [ifrac] = info_fraction_2d(locator, x1, x2, x1binedges, x2binedges, frac)
% -------------------------------------------------------------------------
%
% locator : vector listing number of spikes at a given trial
%
% x1 : projection values onto the first MID
%
% x2 : projection values onto the second MID
%
% x1binedges, x2binedges : edges of bins at which projection probability 
%       distributions will be calculated. Vectors.
%
% fraction : vector of data fractions. Example: [80 85 90 92.5 95 97.5 100]
% 
% caa 3/10/09

frac = frac / 100;

nreps = 5;

ntrials = length(locator);

nfrac = round(frac * ntrials); % number of reduced trials

ifrac = zeros(1,nreps);

rand('state', 0);

for i = 1:nreps

   first = ceil( rand(1) * (ntrials-nfrac+1) );
   last = first + nfrac - 1;

   index_trials = first:last;

   locator_temp = locator( index_trials );

   % MID1 : Normalize projection values to mean, sd of prior
   x1temp = x1( index_trials );
   x1spktemp = x1temp( locator_temp > 0);

   x1mn = mean(x1temp);
   x1std = std(x1temp);

   x1temp = (x1temp - x1mn) ./ x1std;
   x1spktemp = (x1spktemp - x1mn) ./ x1std;


   % MID2 : Normalize projection values to mean, sd of prior
   x2temp = x2( index_trials );
   x2spktemp = x2temp( locator_temp > 0);

   x2mn = mean(x2temp);
   x2std = std(x2temp);

   x2temp = (x2temp - x2mn) ./ x2std;
   x2spktemp = (x2spktemp - x2mn) ./ x2std;


   % Combine the data into a matrix:
   x1x2 = [x1temp(:) x2temp(:)];
   x1x2spk = [x1spktemp(:) x2spktemp(:)];


   % Bin the projection values and obtain the probability
   % distributions:

   nx1x2 = hist2d(x1x2, x1binedges, x2binedges);
   px1x2 = nx1x2 ./ sum(sum(nx1x2)); % normalize

   nx1x2spk = hist2d(x1x2spk, x1binedges, x2binedges);
   px1x2spk = nx1x2spk ./ sum(sum(nx1x2spk)) + eps; % normalize


   % Now calculate the 2D information:

   iplugin = info_px_pxspk(px1x2, px1x2spk);

   ifrac(i) = iplugin;

end % (for i)


return;








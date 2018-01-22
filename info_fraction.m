function [infodata] = info_fraction(xbins, x, locator, fraction, x2bins, x2)
%info_fraction - filter information for different data fractions
%
% [infodata] = info_fraction(xbins, x, locator, fraction, x2bins, x2)
% -------------------------------------------------------------------
%
% xbins : center of bins at which projection probability distributions
% will be calculated
%
% x : projection values onto a filter. A vector.
%
% locator : vector listing number of spikes for a given trial
%
% frac : data fraction for which information will be estimated. A scalar, 
% usually something like 80 or 92.5
%
% infodata : data fraction information estimates. 1x5 vector. 5 estimates 
% 
% If 
%       [infodata] = info_fraction(xbins, x, locator, fraction, x2bins, x2)
%
% Then information for 2 filters is estimated, and x2bins is the bin centers
%       for the 2nd filter projection values, and x2 is similar to x1, but
%       for the 2nd filter.
%
%



narginchk(4,6);

if nargin ~=4 & nargin ~= 6
    error('Must have either 4 or 6 input arguments.');
end

if ( ~iscell(xbins) & ~iscell(locator) & ~iscell(x) )
    xbins = {xbins};
    locator = {locator};
    x = {x};
end

assert(length(x) == length(locator), ...
        'x and locator have different rep lengths.');
assert(length(x) == length(xbins), ...
        'x and xbins have different rep lengths.');

for i = 1:length(x)
    assert(length(x{i}) == length(locator{i}), ...
        'x and locator have different lengths.');
end


for i = 1:length(x)
    assert(length(x{i}) > length(xbins{i}), ...
        'xbins is longer than x.');
end


if nargin == 6

    if ( ~iscell(x2bins) & ~iscell(x2) )
        x2bins = {x2bins};
        x2 = {x2};
    end

    assert(length(x2) == length(locator), ...
            'x2 and locator have different rep lengths.');
    assert(length(x2) == length(x2bins), ...
            'x2 and x2bins have different rep lengths.');

    for i = 1:length(x2)
        assert(length(x2{i}) == length(locator{i}), ...
            'x2 and locator have different lengths.');
    end


    for i = 1:length(x2)
        assert(length(x2{i}) > length(x2bins{i}), ...
            'x2bins is longer than x2.');
    end

end



nreps = 5;

rand('state', 0);


if nargin == 4

    for i = 1:length(x)

        for j = 1:length(fraction)

            ntrials = length(locator{i});
            proportion = fraction(j) / 100;
            nfrac = round(proportion * ntrials); % number of reduced trials
            iplugin_reps = zeros(1,nreps);

            for k = 1:nreps

                first = ceil( rand(1) * (ntrials-nfrac+1) );
                last = first + nfrac - 1;

                index_trials = first:last;

                locator_temp = locator{i}( index_trials );
                xtemp = x{i}( index_trials );
                xspktemp = xtemp( locator_temp > 0);

                % Now normalize by the mean and std of the prior
                xmn = mean(xtemp);
                xstd = std(xtemp);

                xtemp = (xtemp - xmn) ./ xstd;
                xspktemp = (xspktemp - xmn) ./ xstd;


                % Form the probability distributions
                nx = hist(xtemp, xbins{i});
                px = nx ./ sum(nx); % p(x)
                px = px(:);

                nxspk = hist(xspktemp, xbins{i});
                pxspk = nxspk ./ sum( nxspk ); % p(x|spk)
                pxspk = pxspk(:);

                % Get and assign the information
                iplugin_reps(k) = info_px_pxspk(px, pxspk);

            end % (for i)

            ifrac(j).fraction = fraction(j);
            ifrac(j).nfrac = nfrac;
            ifrac(j).iplugin_reps = iplugin_reps;

        end % (for j)

        infodata(i).nreps = nreps;
        infodata(i).ntrials = ntrials;
        infodata(i).fraction = fraction;
        infodata(i).ifrac = ifrac;

        clear('ifrac');

    end % (for i)

else

    for i = 1:length(x)

        for j = 1:length(fraction)

            %[ifrac] = info_fraction( locator{i}, x{i}, xbins{i}, fraction(j) );

            ntrials = length(locator{i});
            proportion = fraction(j) / 100;
            nfrac = round(proportion * ntrials); % number of reduced trials
            iplugin_reps = zeros(1,nreps);

            for k = 1:nreps

                first = ceil( rand(1) * (ntrials-nfrac+1) );
                last = first + nfrac - 1;
                index_trials = first:last;

                locator_temp = locator{i}( index_trials );

                % RF1
                x1temp = x{i}( index_trials );
                x1spktemp = x1temp( locator_temp > 0);

                x1mn = mean(x1temp);
                x1std = std(x1temp);

                x1temp = (x1temp - x1mn) ./ x1std;
                x1spktemp = (x1spktemp - x1mn) ./ x1std;


                % RF2
                x2temp = x2{i}( index_trials );
                x2spktemp = x2temp( locator_temp > 0);

                x2mn = mean(x2temp);
                x2std = std(x2temp);

                x2temp = (x2temp - x2mn) ./ x2std;
                x2spktemp = (x2spktemp - x2mn) ./ x2std;


                % RF1 and RF2 combined
                x1x2 = [x1temp(:) x2temp(:)];
                x1x2spk = [x1spktemp(:) x2spktemp(:)];


                % Bin projection values, obtain the probability distributions:
                nx1x2 = hist2d(x1x2, center2edge(xbins{i}), center2edge(x2bins{i}));
                px1x2 = nx1x2 ./ sum(sum(nx1x2)); % normalize

                nx1x2spk = hist2d(x1x2spk,  center2edge(xbins{i}), center2edge(x2bins{i})); 
                px1x2spk = nx1x2spk ./ sum(sum(nx1x2spk)) + eps; % normalize

                iplugin_reps(k) = info_px_pxspk(px1x2, px1x2spk);

            end % (for i)

            ifrac(j).fraction = fraction(j);
            ifrac(j).nfrac = nfrac;
            ifrac(j).iplugin_reps = iplugin_reps;

        end % (for j)

        infodata(i).nreps = nreps;
        infodata(i).ntrials = ntrials;
        infodata(i).fraction = fraction;
        infodata(i).ifrac = ifrac;

        clear('ifrac');

    end % (for i)

end % (if nargin == 4)


return;















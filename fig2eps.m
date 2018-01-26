function fig2eps(filename,fh)
% fig2eps Save current figure as .eps file
% 
%     fig2eps(filename) saves the current figure as filename. If filename
%     does not end in .eps, the figure is saved as filename.eps
% 
%     fig2eps(filename,fh) saves the figure with handle 'fh'. If filename
%     does not end in .eps, the figure is saved as filename.eps
% 
%     The figure is saved with the font size set to 8 points, and the 
%     color scale set to RGB. Otherwise, the figure is saved as it appears.

narginchk(1,2);


% % Journal name for figure
% h = findobj('tag', 'jneurosci');
% valjneurosci = get(h, 'Value');
% 
% h = findobj('tag', 'jneurophys');
% valjneurophys = get(h, 'Value');
% 
% h = findobj('tag', 'neuron');
% valneuron = get(h, 'Value');
% 
% h = findobj('tag', 'natneurosci');
% valnatneurosci = get(h, 'Value');
% 
% 
% % Number of columns the figure should take up
% h = findobj('tag', 'column1');
% valcolumn1 = get(h, 'Value');
% 
% h = findobj('tag', 'column1pt5');
% valcolumn1pt5 = get(h, 'Value');
% 
% h = findobj('tag', 'column2');
% valcolumn2 = get(h, 'Value');
% 
% 
% % Set the figure width depending on the journal
% if ( valjneurosci )
%    if ( valcolumn1 )
%       width = 8.5;
%    elseif ( valcolumn1pt5 )
%       width = 11.6;
%    else
%       width = 17.6;
%    end
% end
% 
% if ( valjneurophys )
%    if ( valcolumn1 )
%       width = 8.9;
%    elseif ( valcolumn1pt5 )
%       width = 12.7;
%    else
%       width = 18;
%    end
% end
% 
% if ( valneuron )
%    if ( valcolumn1 )
%       width = 8.9;
%    elseif ( valcolumn1pt5 )
%       width = 12.7;
%    else
%       width = 18;
%    end
% end
% 
% if ( valnatneurosci )
%    if ( valcolumn1 )
%       width = 8.5;
%    elseif ( valcolumn1pt5 )
%       width = 11.6;
%    else
%       width = 17.6;
%    end
% end
% 
% 
% % Cerebral cortex values are:8.6 cm, 18 cm, 18 cm; there is no 1.5 column figure
% % PNAS lets you do whatever you want, so using Journal of Neuroscience
% % is probably safe
% 
% 
% % Color for the figure
% h = findobj('tag', 'figurecolor');
% val = get(h, 'Value');
% str = get(h, 'String');
% str_figurecolor = str{val};
% 
% if ( val == 1 )
%    str_figurecolor = '''bw''';
% elseif ( val == 2 )
%    str_figurecolor = '''gray''';
% elseif ( val == 3 )
%    str_figurecolor = '''rgb''';
% else
%    str_figurecolor = '''cmyk''';
% end


% % Font size from list box
% h = findobj('tag', 'figurefontsize');
% val = get(h, 'Value');
% str = get(h, 'String');
% str_figurefontsize = str{val};

str_figurecolor = '''rgb''';
str_figurefontsize = '8';

% Options struct for exportfig.m
% opts = eval(sprintf(' struct(''FontMode'', ''fixed'', ''FontSize'' , %s, ''width'', %.2f, ''color'', %s);', ...
% str_figurefontsize, width, str_figurecolor));
opts = eval(sprintf(' struct(''FontMode'', ''fixed'', ''FontSize'' , %s, ''color'', %s);', ...
str_figurefontsize, str_figurecolor));


% % Error check file name
% h = findobj('tag', 'filename');
% val = get(h, 'Value');
% str = get(h, 'String');
% 
% if ( strcmp(str, 'Save EPS file as ...') ) % no user filename was input
%    filename = 'temp.eps';
% else % see if the .eps extension was included
%    if ( findstr(lower(str), '.eps') )
%       filename = str;
%    else
%       filename = [str '.eps'];
%    end
% end


if ( isempty( findstr(lower(filename), '.eps') ) )
  filename = [filename '.eps'];
end


% Get figure handle to the figure that is to be exported
if nargin == 2
    figurechild = fh;
else
    children = get(0,'children'); % get the handle to the figure
    figurechild = gcf; %children(2); % children(1) is the handle to the gui
end

% Set Arial as the default exported font. Since this font, and helvetica, 
% are the only fonts that work for all journals
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')

exportfig(figurechild, filename, opts); % exports figure as an eps file
printeps(figurechild, filename);


return;



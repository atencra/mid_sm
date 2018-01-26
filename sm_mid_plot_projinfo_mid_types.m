function sm_mid_plot_projinfo_mid_types(projinfo, fio, varargin)
% mid_sm_plot_projinfo_mid_types Plots for different types of MID results
%
% sm_mid_plot_projinfo_mid_types(projinfo, fio)
% ---------------------------------------------------------------------------------
%
% Plots STA, MID1, MID2, MID12 information values contained in the struct
% arrays projinfo, and fio. 
%
% projinfo : struct array holding information estimates. These were estimates 
%   made after the MID analysis and will include training and test set information
%   calculations.
%
% fio : struct array holding filter and nonlinearity estimates. These were estimates 
%   made during the MID analysis and include training and mean filter/nonlinearity
%   calculations.
%
% projinfo and fio are obtained from mid_dir_sm_filter_to_fio_info.m, which in turn is
% which in turn is a fancy wrapper for mid_filter_to_fio_info.m
%
% For each type of MID, for each neuron, the filters and nonlinearities are plotted
% and then saved to eps files. The eps files are then converted to pdf files, and 
% the two pdf files are combined and saved.
% 


narginchk(2,8);

library('export_fig');

options = struct(...
'figpath', '.', ...
'gsdir', '.', ... 
'gsfile', 'gswin64c.exe', ...
'gspath', 'C:\Program Files\gs\');

options = input_options(options, varargin);



for i = 1:1 %length(projinfo)
   
    iskfile = projinfo(i).iskfile;
    
    filter_file_eps = strrep(iskfile, '.isk', '-filter.eps');
    filter_file_eps = fullfile(options.figpath, filter_file_eps);
    filter_file_pdf = strrep(filter_file_eps, 'eps', 'pdf');

    nonlinearity_file_eps = strrep(iskfile, '.isk', '-nonlinearity.eps');
    nonlinearity_file_eps = fullfile(options.figpath, nonlinearity_file_eps);
    nonlinearity_file_pdf = strrep(nonlinearity_file_eps, 'eps', 'pdf');

    combined_file_pdf = strrep(filter_file_pdf, '.pdf', '-nonlinearityr.pdf');


    info0_unit = projinfo(i).info0_extrap_test;
    info1_unit = projinfo(i).info1_extrap_test;
    info2_unit = projinfo(i).info2_extrap_test;
    info12_unit = projinfo(i).info12_extrap_test;

    index0 = find(info0_unit > 0 );
    index1 = find(info1_unit > 0 );
    index2 = find(info2_unit > 0 );
    index12 = find(info12_unit > 0 );

    if isempty(index0)
        info0 = 0;
    else
        info0 = mean(info0_unit(index0));
    end

    if isempty(index1)
        info1 = 0;
    else
        info1 = mean(info1_unit(index1));
    end

    if isempty(index2)
        info2 = 0;
    else
        info2 = mean(info2_unit(index2));
    end

    if isempty(index12)
        info12 = 0;
    else
        info12 = mean(info12_unit(index12));
    end

    contribution = 100 * info1 ./ (info12 + eps);
    synergy = 100 * info12 ./ (info1 + info2 + eps);

    [info0 info1 info2 info12]


    supstring = sprintf('I0=%.3f, I1=%.3f, I2=%.3f, I12=%.3f, Contribution=%.2f, Synergy=%.2f', ...
        info0, info1, info2, info12, ...
        contribution, synergy);


    sm_mid_plot_fio_filters(fio(i));
    suptitle(supstring);
    set(gcf,'position', [450 50 1200 500]);

    pause
    
    fig2eps(filter_file_eps);

    pause


    pause(0.5);
    crop = 0;
    append = 0;
    gray = 0;
    quality = 1000;
    eps2pdf(filter_file_eps, filter_file_pdf, crop, append, gray, quality);
    pause;
    %close all;

    fprintf('Figure saved in: %s\n\n', filter_file_pdf);



%     sm_mid_plot_fio_nonlinearities(fio(i));
% 
%     fig2eps(nonlinearity_file_eps);
%     pause(0.5);
%     crop = 1;
%     append = 0;
%     gray = 0;
%     quality = 1000;
%     eps2pdf(nonlinearity_file_eps, nonlinearity_file_pdf, crop, append, gray, quality);
%     pause(0.5)
%     close all;
%     fprintf('Figure saved in: %s\n\n', nonlinearity_file_pdf);
% 
% 
% 
%     append_pdfs(combined_file_pdf, filter_file_pdf);
%     append_pdfs(combined_file_pdf, nonlinearity_file_pdf);
%     fprintf('Figures combined and saved in: %s\n\n', combined_file_pdf);

end % (for i)


% pdf_file_site = sprintf('mid_filter_fio.pdf');
% pdf_file_site = fullfile(figpath, pdf_file_site);
% if exist(pdf_file_site, 'file')
%     delete(pdf_file_site);
% end
% 
% for j = 1:length(pdf_file_units)
%     file = pdf_file_units{j};
%     fprintf('Appending %s\n', file);
%     append_pdfs(pdf_file_site, file);
% end % (for j)
% 
%
%d = dir(pdf_file_dir);
%if isempty(d)
%    append_pdfs(pdf_file_dir, pdf_file_total); 
%end

return;










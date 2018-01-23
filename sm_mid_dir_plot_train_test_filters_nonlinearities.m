function sm_mid_dir_plot_train_test_filters_nonlinearities(batch)
%mid_dir_plot_train_test_filters_nonlinearities
%
%    mid_dir_plot_train_test_filters_nonlinearities(batch)
% 
%    mid_dir_pdf_plot_train_test_filters_nonlinearities(batch) goes through 
%    the folder datapath and searches for *-filter-fio-proj-info.mat files.
%    These files hold filter, nonlinearity, and information results for
%    the MID analysis.
%
%    It then plots the filters and nonlineaities within the folder,
%    converts the figures to pdf files, and saves the pdfs in the
%    folder figpath. The individual pdfs are appended, and then they
%    are deleted. Thus, there is one multiple figure pdf for each
%    neuron.
%
%    batch : if 1, then the function assumes it is outside the folders
%       holding the data. It then goes in to each folder, makes plots, and 
%       comes back out. Default = 0. 
% 
%    This function requires that the Ghostscript executable be installed.
%    It is assumed to have the name and path:
%       gsfile = 'gswin64c.exe';
%       gsdir = 'C:\Program Files\gs\gs9.20\bin';
%    


library('export_fig');


narginchk(0,1);

if nargin == 0
    batch = 0;
end

if isempty(batch)
    batch = 0;
end


figpath = '.';
datapath = '.';
gsdir = 'C:\Program Files\gs\gs9.20\bin';
gsfile = 'gswin64c.exe';
gspath = fullfile(gsdir, gsfile);



if ( batch )
    folders = get_directory_names;
else
    folders = {'.'};
end

startdir = pwd;

for ii = 1:length(folders)

    cd(folders{ii});

    dfilters = dir(fullfile(datapath, '*-filter-fio-proj-info.mat'));
    if isempty(dfilters)
        fprintf('\nNo *-filter-fio-proj-info.mat files in %s.\n\n', folders{ii});
    end

    matfiles = {dfilters.name};


    for i = 1:length(matfiles)
       
        fprintf('\nPlotting %s\n', matfiles{i});
        load(matfiles{i}, 'fio', 'projinfo');

        eps_file_filter = strrep(matfiles{i}, '.mat', '-filter.eps');
        pdf_file_filter = strrep(matfiles{i}, '.mat', '-filter.pdf');

        eps_file_fio = strrep(matfiles{i}, '.mat', '-fio.eps');
        pdf_file_fio = strrep(matfiles{i}, '.mat', '-fio.pdf');

        eps_file_info0 = strrep(matfiles{i}, '.mat', '-info0.eps');
        pdf_file_info0 = strrep(matfiles{i}, '.mat', '-info0.pdf');

        eps_file_info1 = strrep(matfiles{i}, '.mat', '-info1.eps');
        pdf_file_info1 = strrep(matfiles{i}, '.mat', '-info1.pdf');

        eps_file_info2 = strrep(matfiles{i}, '.mat', '-info2.eps');
        pdf_file_info2 = strrep(matfiles{i}, '.mat', '-info2.pdf');

        eps_file_info12 = strrep(matfiles{i}, '.mat', '-info12.eps');
        pdf_file_info12 = strrep(matfiles{i}, '.mat', '-info12.pdf');

        iskfile = strrep(fio.iskfile, '_', '-');

        crop = 1;
        append = 0;
        gray = 0;
        quality = 1000;


        sm_mid_plot_train_fio_1d_2d(fio);
        fig2eps(eps_file_fio);
        pause(0.5);
        %eps2pdf1(eps_file, gspath);
        eps2pdf(eps_file_fio, pdf_file_fio, crop, append, gray, quality);
        pause(0.5);
        close all;
        pause(1)


        sm_mid_plot_train_fio_filters(fio);
        fig2eps(eps_file_filter);
        pause(0.5);
        %eps2pdf1(eps_file, gspath);
        eps2pdf(eps_file_filter, pdf_file_filter, crop, append, gray, quality);
        pause(0.5);
        close all;
        pause(1)



        fraction = [90 92.5 95 97.5 100];

        sm_mid_plot_projinfo_train_test_information(fraction, projinfo.ifrac0_mtx_train, ...
           projinfo.ifrac0_mn_train, projinfo.ifrac0_std_train, ...
           projinfo.ifrac0_mtx_test, projinfo.ifrac0_mn_test, projinfo.ifrac0_std_test, ...
           'STA Info Analysis');
        fig2eps(eps_file_info0);
        pause(0.5);
        eps2pdf(eps_file_info0, pdf_file_info0, crop, append, gray, quality);
        pause(0.5);
        close all;
        pause(1)



        sm_mid_plot_projinfo_train_test_information(fraction, projinfo.ifrac1_mtx_train, ...
           projinfo.ifrac1_mn_train, projinfo.ifrac1_std_train, ...
           projinfo.ifrac1_mtx_test, projinfo.ifrac1_mn_test, projinfo.ifrac1_std_test, ...
           'MID1 Info Analysis');
        fig2eps(eps_file_info1);
        pause(0.5);
        eps2pdf(eps_file_info1, pdf_file_info1, crop, append, gray, quality);
        pause(0.5);
        close all;
        pause(1)



        sm_mid_plot_projinfo_train_test_information(fraction, projinfo.ifrac2_mtx_train, ...
           projinfo.ifrac2_mn_train, projinfo.ifrac2_std_train, ...
           projinfo.ifrac2_mtx_test, projinfo.ifrac2_mn_test, projinfo.ifrac2_std_test, ...
           'MID2 Info Analysis');
        fig2eps(eps_file_info2);
        pause(0.5);
        eps2pdf(eps_file_info2, pdf_file_info2, crop, append, gray, quality);
        pause(0.5);
        close all;
        pause(1)



        mid_plot_projinfo_train_test_information(fraction, projinfo.ifrac12_mtx_train, ...
           projinfo.ifrac12_mn_train, projinfo.ifrac12_std_train, ...
           projinfo.ifrac12_mtx_test, projinfo.ifrac12_mn_test, projinfo.ifrac12_std_test, ...
           'MID12 Info Analysis');
        fig2eps(eps_file_info12);
        pause(0.5);
        eps2pdf(eps_file_info12, pdf_file_info12, crop, append, gray, quality);
        pause(0.5);
        close all;
        pause(1)



        output_pdf = strrep(matfiles{i}, '.mat', '.pdf');
        delete(output_pdf);

        append_pdfs(output_pdf, ...
                    pdf_file_filter, ...
                    pdf_file_fio, ...
                    pdf_file_info0, ...
                    pdf_file_info1, ...
                    pdf_file_info2, ...
                    pdf_file_info12 ); 

        fprintf('\nCreated %s\n\n', output_pdf);

        delete(eps_file_filter);
        delete(pdf_file_filter);

        delete(eps_file_fio);
        delete(pdf_file_fio);

        delete(eps_file_info0);
        delete(pdf_file_info0);

        delete(eps_file_info1);
        delete(pdf_file_info1);

        delete(eps_file_info2);
        delete(pdf_file_info2);

        delete(eps_file_info12);
        delete(pdf_file_info12);

    end % (for i)

    cd(startdir)

end % (for ii)


return;






function mid_plot_train_fio_filters(fio)

numfbins = fio.nf_filter;
numtbins = fio.nt_filter;

sta{1} = reshape( fio.filter_matrix_sta(:,1), numfbins, numtbins );
sta{2} = reshape( fio.filter_matrix_sta(:,2), numfbins, numtbins );
sta{3} = reshape( fio.filter_matrix_sta(:,3), numfbins, numtbins );
sta{4} = reshape( fio.filter_matrix_sta(:,4), numfbins, numtbins );

mid1{1} = reshape( fio.filter_matrix_test2_v1(:,1), numfbins, numtbins );
mid1{2} = reshape( fio.filter_matrix_test2_v1(:,2), numfbins, numtbins );
mid1{3} = reshape( fio.filter_matrix_test2_v1(:,3), numfbins, numtbins );
mid1{4} = reshape( fio.filter_matrix_test2_v1(:,4), numfbins, numtbins );

mid2{1} = reshape( fio.filter_matrix_test2_v2(:,1), numfbins, numtbins );
mid2{2} = reshape( fio.filter_matrix_test2_v2(:,2), numfbins, numtbins );
mid2{3} = reshape( fio.filter_matrix_test2_v2(:,3), numfbins, numtbins );
mid2{4} = reshape( fio.filter_matrix_test2_v2(:,4), numfbins, numtbins );


% Plot the filters
% ----------------------------------------------------------

figure;

for i = 1:4
    subplot(3,4,i);
    imagesc( sta{i} );
    minmin = min(min(sta{i}));
    maxmax = max(max(sta{i}));
    boundary = max([abs(minmin) abs(maxmax)]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    cmap = brewmaps('rdbu',21);
    colormap(cmap);
    if i == 1
        ylabel('STA');
    end
    title(sprintf('Train Set %.0f',i));
end % (for i)




for i = 1:4
    subplot(3,4,i+4);
    imagesc( mid1{i} );
    minmin = min(min(mid1{i}));
    maxmax = max(max(mid1{i}));
    boundary = max([abs(minmin) abs(maxmax)]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    cmap = brewmaps('rdbu',21);
    colormap(cmap);
    if i == 1
        ylabel('MID1');
    end
end % (for i)


for i = 1:4
    subplot(3,4,i+8);
    imagesc( mid2{i} );
    minmin = min(min(mid2{i}));
    maxmax = max(max(mid2{i}));
    boundary = max([abs(minmin) abs(maxmax)]);
    set(gca,'tickdir', 'out', 'ticklength', [0.02 0.02]);
    set(gca, 'clim', [-1.05*boundary-eps 1.05*boundary+eps]);
    cmap = brewmaps('rdbu',21);
    colormap(cmap);
    if i == 1
        ylabel('MID2');
    end
end % (for i)

return;


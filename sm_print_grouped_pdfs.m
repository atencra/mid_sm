function smgroup = sm_print_grouped_pdfs(STTC_info)

smgroup = sm_group_neurons(STTC_info);

fn = fieldnames(smgroup);

for i = 1:length(fn)
    
    idx = smgroup.(fn{i});
    filenames = arrayfun(@(x) sprintf('temp%d.pdf',x), idx, 'UniformOutput', 0);
    
    outfile = sprintf('%s.pdf', fn{i});
    
    if exist(outfile, 'file')
        delete(outfile);
    end
    
    append_pdfs(outfile, filenames{:});

end


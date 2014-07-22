%% Process string with _ for legends showing.
% Chen Wang

function legends = processSrvNames(names)

    legends = {};
    
    for i = 1 : length(names)
        name = names{i};
        lgName = strrep(name, '_', '\_');
        legends = [legends; lgName];
    end

end
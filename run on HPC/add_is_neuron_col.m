function [table_of_clusters] = add_is_neuron_col(table_of_clusters,config)

    function [array_of_is_neuron] = add_neuron_or_not(table_of_clusters)
        array_of_is_neuron = nan(size(table_of_clusters,1),1);
        for i=1:size(table_of_clusters)
            current_grades = table_of_clusters{i,"grades"}{1};
            array_of_is_neuron(i)=current_grades{60};
        end
    end
    function [array_of_is_neuron] = add_neuron_or_not_in_parallel(table_of_clusters)
        sliced_table_of_clusters = slice_table_for_parallel_processing(table_of_clusters,[]);
        array_of_is_neuron = [];
        parfor i=1:size(sliced_table_of_clusters,1)
            current_data = sliced_table_of_clusters{i};
            current_grades = current_data{1,"grades"}{1};
            array_of_is_neuron = [array_of_is_neuron;current_grades{60}];
        end
    end
have_grades = check_for_required_cols(table_of_clusters,["grades"],"add_is_neuron_col.m","Esnure get_table_of_all_clusters_from_blind_pass.m ran correctly",0);
% table_of_clusters_wi = [];

if ~have_grades
    return;
end

if config.IS_PARALLEL_AVAILABLE && config.USE_PARALLEL
    is_neuron = add_neuron_or_not_in_parallel(table_of_clusters);
else
    is_neuron = add_neuron_or_not(table_of_clusters);
end
table_of_clusters.is_neuron=is_neuron;
end
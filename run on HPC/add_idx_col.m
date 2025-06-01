function [table_of_clusters_with_idx] = add_idx_col(table_of_clusters,config)

%get_table_of_all_clusters_from_blind_pass
%QUESTION: WHEN SHOULD I USE THIS FUNCTION?
%ANSWER: USE THIS FUNCTION TO GET THE IDX OF EACH CLUSTER in their corresponding aligned file
%QUESTION: WHERE CAN I GET table_of_clusters??
%ANSWER: Provided your blind pass has been run you can run get_table_of_all_clusters_from_blind_pass.m to get this table
%QUESTION: WHERE CAN I GET config?
%ANSWER: the config file is a struct that is created before you run your blind pass. A blank config file can be generated using blank_config.m
        %the spikesort_config file also has a config struct, but it must have all the filepaths changed to the relevant ones
    function [table_of_all_clusters] = add_idx_for_current_cluster(table_of_all_clusters)
        num_iters = size(table_of_all_clusters,1);
        for i=1:size(table_of_all_clusters,1)
            table_of_all_clusters{i} = add_idx(table_of_all_clusters{i});
            print_status_iter_message("add_idx_col",i,num_iters);
        end
    end
    function [table_of_all_clusters] = add_idx_for_current_cluster_parallel(table_of_all_clusters)
        num_iters = size(table_of_all_clusters,1);
        parfor i=1:num_iters
            table_of_all_clusters{i} = add_idx(table_of_all_clusters{i});
            print_status_iter_message("add_idx_col",i,num_iters);
        end
    end
table_of_clusters_with_idx = [];
has_required_cols = check_for_required_cols(table_of_clusters,["Tetrode","Z Score","dir_to_output"],"add_idx_col.m","ensure that get_table_of_all_clusters_from_blind_pass.m returned a table with column for Tetrode, Z Score, and dir_to_output",0);
if ~has_required_cols
    return
end
table_of_clusters = slice_table_for_parallel_processing(table_of_clusters,["Tetrode","Z Score"]);
if config.IS_PARALLEL_AVAILABLE && config.USE_PARALLEL
    table_of_clusters = add_idx_for_current_cluster_parallel(table_of_clusters);
else
    table_of_clusters = add_idx_for_current_cluster(table_of_clusters);
end
table_of_clusters_with_idx = vertcat(table_of_clusters{:});
end
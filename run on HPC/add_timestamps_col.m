function [table_of_clusters_with_timestamps] = add_timestamps_col(table_of_clusters,config)
%QUESTION: WHEN SHOULD I USE THIS FUNCTION???
%ANSWER: USE THIS AFTER YOU HAVE ALREADY RUN THE BLIND PASS AND GOTTEN base_table_of_all_clusters
%QUESTION: WHERE CAN I GET base_table_of_all_clusters???
%ANSWER: it is created by get_table_of_all_clusters_from_blind_pass.m
%        Please note that it doesn't run the blind pass, it just reads the results

    function [table_of_all_clusters] = add_ts_for_current_cluster(table_of_all_clusters)
        for i=1:size(table_of_all_clusters,1)
            table_of_all_clusters{i} = add_ts(table_of_all_clusters{i});
            print_status_iter_message("add_timestamps_col.m",i,size(table_of_all_clusters,1));
        end
    end
    function [table_of_clusters] = add_ts_for_current_cluster_parallel(table_of_clusters)
        num_iters = size(table_of_clusters,1);
        parfor i=1:size(table_of_clusters,1)
            table_of_clusters{i} = add_ts(table_of_clusters{i});
            print_status_iter_message("add_timestamp_col.m",i,num_iters);
        end
    end
table_of_clusters_with_timestamps = [];
has_necessary_cols = check_for_required_cols(table_of_clusters,["Z Score","Tetrode"],"add_timestamps_col.m","Ensure that get_table_of_all_clusters_from_blind_pass returned a table with Z Score and Tetrode Coumn",0);
if ~has_necessary_cols
    return;
end
table_of_clusters = slice_table_for_parallel_processing(table_of_clusters,["Z Score","Tetrode"]);
if config.IS_PARALLEL_AVAILABLE && config.USE_PARALLEL
   table_of_clusters = add_ts_for_current_cluster_parallel(table_of_clusters);
else
   table_of_clusters = add_ts_for_current_cluster(table_of_clusters);
end
table_of_clusters_with_timestamps = vertcat(table_of_clusters{:});
end
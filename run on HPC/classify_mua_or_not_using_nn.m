function [predictions] = classify_mua_or_not_using_nn(config,table_of_all_clusters,image_dir)
predictions = nan(1,size(table_of_all_clusters,1));
if config.ON_HPC
    mua_or_not_nn = importdata(config.FP_TO_MUA_OR_NOT_PREDICTING_NN_ON_HPC);
    mua_or_not_nn = mua_or_not_nn.net;
else
    mua_or_not_nn = importdata(config.FP_TO_MUA_OR_NOT_PREDICTING_NN);
    mua_or_not_nn = mua_or_not_nn.net;
end
for i=1:size(table_of_all_clusters,1)
    current_tetrode = table_of_all_clusters{i,"Tetrode"};
    current_z_score = table_of_all_clusters{i,"Z Score"};
    current_cluster = table_of_all_clusters{i,"Cluster"};
    current_grades = table_of_all_clusters{i,"grades"}{1};
    current_channels = current_grades{49};
    current_dimension_1 = current_channels(current_grades{42});
    current_dimension_2 = current_channels(current_grades{43});
    photo_string = "Z Score "+string(current_z_score)+" Tetrode "+current_tetrode+" Cluster "+string(current_cluster)+ " Channels"+string(current_dimension_1) +" and "+string(current_dimension_2)+".png";

    cluster_image = imread(fullfile(image_dir,photo_string));
    mua_or_not_pred = predict(mua_or_not_nn,single(cluster_image));
    [~,mua_or_not_pred] = max(mua_or_not_pred);
    predictions(i) = mua_or_not_pred-1;
    disp("classify_cluster_mua_or_not_using_nn.m Finished "+string(i)+"/"+string(size(table_of_all_clusters,1)));
end
end
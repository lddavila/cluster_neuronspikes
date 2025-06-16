function [table_of_clusters] =  add_prediction_cols(table_of_clusters,config)

if config.ON_HPC
    nn_pred_acc_cat_using_mean_waveform_nn_struct = importdata(config.FP_TO_PREDICT_ACC_CAT_USING_MEAN_WAVEFORM_NN_ON_HPC);
    nn_predi_acc_cat_using_grades_nn_struct = importdata(config.FP_TO_PREDICTING_ACCURACY_ON_GRADES_NN_ON_HPC);
else
    nn_pred_acc_cat_using_mean_waveform_nn_struct = importdata(config.FP_TO_PREDICT_ACC_CAT_USING_MEAN_WAVEFORM_NN);
    nn_predi_acc_cat_using_grades_nn_struct = importdata(config.FP_TO_PREDICTING_ACCURACY_ON_GRADES_NN);
end
nn_pred_acc_cat_using_mean_waveform = nn_pred_acc_cat_using_mean_waveform_nn_struct.net;
nn_predi_acc_cat_using_grades = nn_predi_acc_cat_using_grades_nn_struct.net;

mean_waveform_accuracy_prediction = nan(size(table_of_clusters,1),1);
grades_accuracy_prediction = nan(size(table_of_clusters,1),1);

for i=1:size(table_of_clusters,1)
    current_waveform = table_of_clusters{i,"Mean Waveform"}{1};
    mean_waveform_class_probabilities = predict(nn_pred_acc_cat_using_mean_waveform,current_waveform);
    [~,max_mean_wave_class] = max(mean_waveform_class_probabilities);
    max_mean_wave_class = max_mean_wave_class-1;

    current_grades = table_of_clusters{i,"grades"};
    [grade_names,all_grades] = flatten_grades_cell_array(current_grades,config);
    [indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
    ordered_grades_array =all_grades(:,indexes_of_grades_were_looking_for);
    grade_class_probabilities = predict(nn_predi_acc_cat_using_grades,ordered_grades_array);
    [~,max_grades_class] = max(grade_class_probabilities);
    max_grades_class = max_grades_class-1;

    mean_waveform_accuracy_prediction(i) = max_mean_wave_class;
    grades_accuracy_prediction(i) = max_grades_class;
    print_status_iter_message("add_prediction_cols.m",i,size(table_of_clusters,1));
end


table_of_clusters.mean_wave_pred = mean_waveform_accuracy_prediction;
table_of_clusters.grades_pred = grades_accuracy_prediction;

end
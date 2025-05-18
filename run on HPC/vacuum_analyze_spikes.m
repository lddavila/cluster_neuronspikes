function [] = vacuum_analyze_spikes(cell_array_of_vacuum_tests,config,which_string,num_stds_to_try,which_rows_to_use)
flattened_cell_array = vertcat(cell_array_of_vacuum_tests{:,:});
if class(which_rows_to_use) == "table"
    if which_rows_to_use=="all"
        array_of_idxs = 1:1:size(flattened_cell_array,1);
    else
        disp("invalid input. Terminating ...")
        return;
    end
else
    array_of_idxs = which_rows_to_use;
end
for i=1:size(num_stds_to_try,2)
    number_of_increases = 0;
    number_of_decreases = 0;
    magnitudes_of_decreases = nan(size(flattened_cell_array,1),1);
    magnitude_of_increases = nan(size(flattened_cell_array,1),1);
    for j=array_of_idxs
       
        original_accuracy = flattened_cell_array{j,1};
        if isempty(original_accuracy)
            continue;
        end
        accuracy_for_current_z_score = flattened_cell_array{j,i+3};
        difference_in_accuracy = accuracy_for_current_z_score - original_accuracy;
        if difference_in_accuracy > 0
            number_of_increases = number_of_increases+1;
            magnitude_of_increases(j) = difference_in_accuracy;
        else
            number_of_decreases = number_of_decreases+1;
            magnitudes_of_decreases(j) = difference_in_accuracy;
        end
    end
    magnitudes_of_decreases(isnan(magnitudes_of_decreases)) = [];
    magnitude_of_increases(isnan(magnitude_of_increases)) = [];

    figure;
    histogram(magnitudes_of_decreases,'Normalization','probability')
    title(which_string + " Num STDs absorbed: "+num_stds_to_try(i) +" Decreases")
    subtitle("Number Of Decreases:"+string(length(magnitudes_of_decreases)))
    figure;
    histogram(magnitude_of_increases,'Normalization','probability')
    title(which_string + " Num STDs absorbed: "+num_stds_to_try(i) +" Increases")
    subtitle("Number of Increases:"+string(length(magnitude_of_increases)));
    figure;
    x_labels_for_bar_plot = ["Increases","Decreases"];
    y_vals_for_bar_plot = [number_of_increases,number_of_decreases]./ sum([number_of_increases,number_of_decreases]);
    b =bar(x_labels_for_bar_plot,y_vals_for_bar_plot);
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    labels1 = string(b(1).YData);
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
end
end
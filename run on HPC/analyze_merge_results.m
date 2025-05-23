function [neural_network_training_data] = analyze_merge_results(new_accuracies_and_grades,table_of_clusters,increments_to_create_bins_by,exclude_diff_max_overlap_unit)
close all;
neural_network_training_data = {};
number_of_rows_required = 0;
for i=1:size(table_of_clusters,1)
    data_to_combine = new_accuracies_and_grades{table_of_clusters{i,"idx of its location in arrays"}};
    if ~isempty(data_to_combine)
        number_of_rows_required = number_of_rows_required + size(data_to_combine,1);
    end
end
flattened_array = cell(number_of_rows_required,4);
flattened_array_counter = 1;
for i=1:size(table_of_clusters,1)
    data_to_combine = new_accuracies_and_grades{table_of_clusters{i,"idx of its location in arrays"}};
    if ~isempty(data_to_combine)
        for j=1:size(data_to_combine,1)
            if exclude_diff_max_overlap_unit && contains(data_to_combine{j,1},"*")
                continue;
            end
            flattened_array{flattened_array_counter,1} = data_to_combine{j,1};
            flattened_array{flattened_array_counter,2} = data_to_combine{j,2} ;
            flattened_array{flattened_array_counter,3} = data_to_combine{j,3};
            flattened_array{flattened_array_counter,4} = data_to_combine{j,4};
            flattened_array_counter = flattened_array_counter+1;
        end
        disp("Finished flattening "+string(i)+"/"+string(size(table_of_clusters,1)))
    end
end


magnitude_of_increase = nan(flattened_array_counter,1);
inc_counter = 1;
magnitude_of_decrease = nan(flattened_array_counter,1);
dec_counter =1;
for i=1:size(flattened_array,1)
    before_merge_accuracy = flattened_array{i,3};
    after_merge_accuracy = flattened_array{i,4};

    difference_in_new_accuracy = after_merge_accuracy - before_merge_accuracy;

    if difference_in_new_accuracy>0
        magnitude_of_increase(inc_counter) = difference_in_new_accuracy ;
        inc_counter = inc_counter+1;
    else
        magnitude_of_decrease(dec_counter) =difference_in_new_accuracy;
        dec_counter = dec_counter+1;
    end

disp("Finished counting "+string(i)+"/"+string(size(table_of_clusters,1)))
end
x_labels_for_bar_plot = ["Decreases","Increases"];
increase_decrease_probability = [dec_counter,inc_counter]./sum([inc_counter,dec_counter])*100;
b = bar(x_labels_for_bar_plot,increase_decrease_probability);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
title("Decreases and Increases Probability");

magnitude_of_decrease(isnan(magnitude_of_decrease)) = [];
magnitude_of_increase(isnan(magnitude_of_increase)) = [];

bin_edges = 1:increments_to_create_bins_by:110;
figure
histogram(magnitude_of_increase,bin_edges,Normalization="probability");
title("Magnitude of Accuracy Increases")

bin_edges = -100:increments_to_create_bins_by:10;
figure;
histogram(magnitude_of_decrease,bin_edges,Normalization='probability')
title("Magnitude of Accuracy Decreases")
neural_network_training_data = cell(number_of_rows_required,4);
for i=1:size(flattened_array,1)
    string_of_combination = split(flattened_array{i,1},"|");
    primary_neuron =split(strrep(string( string_of_combination{1}),"Z Score:","")," ");
    secondary_neuron = split(strrep(string( string_of_combination{2}),"Z Score:","")," ");

    primary_neuron_z_score = str2double(string(primary_neuron{1}));
    primary_neuron_tetrode = string(primary_neuron{2});
    primary_neuron_cluster = str2double(string(primary_neuron{4}));
    
    secondary_neuron_z_score = str2double(string(secondary_neuron{1}));
    secondary_neuron_tetrode = string(secondary_neuron{2});
    secondary_neuron_cluster = str2double(string(secondary_neuron{4}));

    c1 = table_of_clusters{:,"Z Score"} == primary_neuron_z_score;
    c2 = table_of_clusters{:,"Tetrode"} == primary_neuron_tetrode;
    c3 = table_of_clusters{:,"Cluster"} == primary_neuron_cluster; 

    [row_for_prim,~] = find(c1 & c2 & c3);

   

    c4 = table_of_clusters{:,"Z Score"} == secondary_neuron_z_score;
    c5 = table_of_clusters{:,"Tetrode"} == secondary_neuron_tetrode;
    c6 = table_of_clusters{:,"Cluster"} == secondary_neuron_cluster; 

    [row_for_sec,~] = find(c4 & c5 & c6);

    neural_network_training_data{i,1} = table_of_clusters{row_for_prim,"grades"}{1};
    neural_network_training_data{i,2} = table_of_clusters{row_for_sec,"grades"}{1};
    neural_network_training_data{i,3} = flattened_array{i,2};
    neural_network_training_data{i,4} = flattened_array{i,4} - flattened_array{i,3};

    disp("Finished configuring grades "+string(i)+"/"+string(size(neural_network_training_data,1)))
end
end
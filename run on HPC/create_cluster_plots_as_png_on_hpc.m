function [] = create_cluster_plots_as_png_on_hpc()
cd("..");
addpath(genpath(pwd));
updated_table_of_overlap = importdata(fullfile("/home","lddavila","data_from_local_server","Timestamp and table","overlap_table.mat"));
disp("Finished loading the updated table of overlap")
sliced_updated_table_of_overlap = cell(1,size(updated_table_of_overlap,1));
dir_to_save_figures_to = "";
for i=1:size(updated_table_of_overlap,1)
    sliced_updated_table_of_overlap{i} = updated_table_of_overlap(i,:);
end

for i=1:length(sliced_updated_table_of_overlap)
    current_data = sliced_updated_table_of_overlap{i};
    current_tetrode = current_data{1,"Tetrode"};
    current_z_score = current_data{1,"Z Score"};
    current_cluster = current_data{1,"Cluster"};
end
end
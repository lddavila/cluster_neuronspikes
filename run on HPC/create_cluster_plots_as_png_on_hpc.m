function [] = create_cluster_plots_as_png_on_hpc()
%add necessary files to path
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config;
%set the directory where the pngs will be saved to
if config.ON_HPC
    dir_to_save_figures_to = config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO_ON_HPC;
    %import the data
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    disp("Finished loading the updated table of overlap")
else
    dir_to_save_figures_to = config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO;
    %import the data
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    disp("Finished loading the updated table of overlap")
end

%slice the data for parallel processing
subset_of_data = unique(updated_table_of_overlap(:,["Z Score","Tetrode"]),"rows","stable");
sliced_updated_table_of_overlap = cell(1,size(subset_of_data,1));
sliced_channels_per_tetrode = cell(1,size(subset_of_data,1));
dir_to_return_to = cd(dir_to_save_figures_to);
for i=1:size(subset_of_data,1)
    current_z_score =subset_of_data{i,"Z Score"} ;
    current_tetrode = subset_of_data{i,"Tetrode"};
    tetrode_number = str2double(strrep(current_tetrode,"t",""));
    c1 = updated_table_of_overlap{:,"Z Score"}==current_z_score;
    c2 = updated_table_of_overlap{:,"Tetrode"} ==current_tetrode;
    sliced_updated_table_of_overlap{i} = updated_table_of_overlap(c1 & c2,:);
    sliced_channels_per_tetrode{i} = config.ART_TETR_ARRAY(tetrode_number,:);
end
number_of_iterations = length(sliced_updated_table_of_overlap);
%create the figures
parfor i=1:length(sliced_updated_table_of_overlap)
    current_data = sliced_updated_table_of_overlap{i};
    %ensure that all data in the current set have the same z score and tetrode
    %if it doesn't then return
    if ~all(current_data{:,"Tetrode"} == current_data{1,"Tetrode"}) || ~all(current_data{:,"Z Score"} == current_data{1,"Z Score"})
        disp(current_data);
        error("every row of current_data doesn't have all have the same tetrode and z score");
    end
    current_tetrode = current_data{1,"Tetrode"};
    current_z_score = current_data{1,"Z Score"};
    if config.ON_HPC
        dir_with_grades = config.GENERIC_GRADES_DIR_ON_HPC+" "+string(current_z_score)+ " grades";
        dir_with_outputs = config.GENRIC_DIR_WITH_OUTPUTS_ON_HPC+string(current_z_score);
    else
        dir_with_grades = config.GENERIC_GRADES_DIR +" "+string(current_z_score)+" grades";
        dir_with_outputs = config.GENRIC_DIR_WITH_OUTPUTS +string(current_z_score);
    end
    [~,~,aligned,~,idx,failed_to_load] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,false);


    grades = current_data{:,"grades"};
    if failed_to_load
        disp("Failed To Load");
    end


    %now create the actual cluster plots
    % channels_of_curr_tetr = sliced_channels_per_tetrode{i};
    peaks= get_peaks(aligned, true)'; %get the peaks of the current data
    colors = distinguishable_colors(1); %will always use the same colors
    my_gray = [0.5 0.5 0.5];
    current_tetrode_channels = sliced_channels_per_tetrode{i};
    for j=1:size(grades,1)
        peaks_in_cluster = idx{j};
        if isempty(peaks_in_cluster)
            continue;
        end
        first_dimension = grades{j}{42};
        second_dimension = grades{j}{43};

        peaks_in_cluster(peaks_in_cluster > size(aligned,2)) = [];
        cluster = peaks(peaks_in_cluster, :);
        cluster_x = cluster(:, first_dimension);
        cluster_y = cluster(:, second_dimension);

        n = config.NUM_STDS_AROUND_CLUSTER; %number of standard deviations, theres no one right standard deviation, but this one seems to be good for my purposes

        cluster_x_mean = mean(cluster_x,'all');
        cluster_x_std = std(cluster_x);
        n_stds_right_of_cluster = cluster_x_mean+ (n*cluster_x_std);
        n_std_left_of_cluster = cluster_x_mean - (n*cluster_x_std);

        cluster_y_mean = mean(cluster_y,"all");
        cluster_y_std = std(cluster_y);
        n_stds_above_cluster = cluster_y_mean+ (n*cluster_y_std);
        n_std_below_cluster = cluster_y_mean - (n*cluster_y_std);


        c1 = peaks(:,first_dimension) < n_stds_right_of_cluster & peaks(:,first_dimension) > n_std_left_of_cluster;
        c2 = peaks(:,second_dimension) < n_stds_above_cluster & peaks(:,second_dimension) > n_std_below_cluster;

        if config.WHAT_KIND_OF_CLUSTER_PLOT_TO_MAKE=="all"
            data = peaks;
        elseif config.WHAT_KIND_OF_CLUSTER_PLOT_TO_MAKE=="limited"
            data = peaks(c1 & c2,:);
        else
            disp("Invalid value in config.WHAT_KIND_OF_CLUSTER_PLOT_TO_MAKE");
            disp("Produced by create_cluster_plots_as_png_on_hpc.m");
            error("thrown by create_cluster_plots_as_png_on_hpc.m");
        end
        hold on
        f = figure;
        scatter(data(:, first_dimension), data(:, second_dimension), 2,my_gray);



        hold on;
        scatter(cluster_x, cluster_y, 2,colors(1,:))
        axis equal;
        axis off;
        file_save_name = "Z Score "+ string(current_z_score)+ " Tetrode "+current_tetrode+" Cluster "+string(j)+" Channels"+string(current_tetrode_channels(first_dimension))+ " and "+string(current_tetrode_channels(second_dimension))+".png";
        saveas(f,file_save_name);
        close(f);
        RGB = imread(file_save_name);
        grayscaled_image =rgb2gray(RGB);
        resized_and_gray_scaled_image = imresize(grayscaled_image,[100,100]);
        delete(file_save_name);
        imshow(resized_and_gray_scaled_image)
        imwrite(resized_and_gray_scaled_image,file_save_name);


    end
    disp("Finished "+string(i)+"/"+string(number_of_iterations));

end
cd(dir_to_return_to);
end
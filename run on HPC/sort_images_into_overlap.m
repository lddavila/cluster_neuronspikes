function [] = sort_images_into_overlap(table_of_all_clusters,dir_with_images,dir_to_save_images_to,config)
for i=1:size(table_of_all_clusters,1)
    current_tetrode = table_of_all_clusters{i,"Tetrode"};
    current_z_score = table_of_all_clusters{i,"Z Score"};
    current_cluster = table_of_all_clusters{i,"Cluster"};
    current_grades = table_of_all_clusters{i,"grades"}{1};
    current_channels = current_grades{49};
    current_dimension_1 = current_channels(current_grades{42});
    current_dimension_2 = current_channels(current_grades{43});
    photo_string = "Z Score "+string(current_z_score)+" Tetrode "+current_tetrode+" Cluster "+string(current_cluster)+ " Channels"+string(current_dimension_1) +" and "+string(current_dimension_2)+".png";

    current_image = imread(fullfile(dir_with_images,photo_string));

    %cluster_image = imread(fullfile(image_dir,photo_string));
    overlap_data = table_of_all_clusters{i,"Other Appearence Info"}{1};

    other_appearence_z_score = overlap_data('Z score of other appearences');
    other_appearence_cluster = overlap_data('cluster number of other appearences');
    other_appearence_tetrode = overlap_data('tetrodes of other appearences');

    if ~isempty(other_appearence_z_score)
        other_image_patterns = strcat("Z Score ",other_appearence_z_score.'," Tetrode ",other_appearence_tetrode.'," Cluster "+other_appearence_cluster.', " Channels*.png");
        other_image_arrays = cell(1,size(other_appearence_tetrode,2));
        other_image_strings = repelem("",1,size(other_appearence_tetrode,2));
        for j=1:size(other_appearence_tetrode,2)
            other_image_strings(j) = ls(fullfile(dir_with_images,other_image_patterns(j)));
            other_image_arrays{j} = imread(other_image_strings(j));
        end

        %so we have determined previously that these clusters overlap
        %both in terms of their mean waveform being within a certain euclidean distance defined in the config file
        %and also having a certain timestamp overlap defined in the config file
        if config.DEBUG_DAVID
            number_of_cols = ceil(length(other_image_arrays)/4);
            figure;
            subplot(4,number_of_cols,1);
            imshow(current_image);
            [~,name,~] = fileparts(photo_string);
            title(name);
            for j = 1:length(other_image_arrays)
                subplot(4,number_of_cols,j+1)
                imshow(other_image_arrays{j})
                [~,name,~] = fileparts(other_image_strings(j));
                title(name);
            end
            close all;
        end
        %now we'll use a twin neural network to determine if they have similar classes based on their cluster pngs



    end


    disp("sort_images_into_overlap.m Finished "+string(i)+"/"+string(size(table_of_all_clusters,1)));
end
end
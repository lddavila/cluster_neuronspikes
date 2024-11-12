clc;
dir_with_nth_pass_grades="D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score2\";
dir_with_nth_pass_results = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score2\";

list_of_tetrodes = 1:286;
list_of_tetrodes = strcat("t",string(list_of_tetrodes));
art_tetr_array = build_artificial_tetrode();

for i=1:length(list_of_tetrodes)
    current_tetrode = list_of_tetrodes(i);
    relevant_grades = [];

    list_of_channels_in_current_tetrode = art_tetr_array(i,:);

    load(dir_with_nth_pass_grades+current_tetrode+".mat")
    output = importdata(dir_with_nth_pass_results+current_tetrode+" output.mat");
    aligned = importdata(dir_with_nth_pass_results+current_tetrode+" aligned.mat");
    idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
    for first_dimension = 1:length(list_of_channels_in_current_tetrode)
        for second_dimension = first_dimension+1:length(list_of_channels_in_current_tetrode)
            if size(grades(:,2),1) == 1
                return;
            end
            new_plot_proj_ver_3(idx,aligned,first_dimension,second_dimension,list_of_channels_in_current_tetrode,current_tetrode,1,grades(:,2),grades(:,8),grades(:,9),"");
        end
    end
end
function [] = plot_levels_of_SNR_starting_at_GT(ground_truth_unit_data,levels_beneath_highest_z_score_to_check,interval,tetrode_to_check_against,dir_of_precomputed,dir_of_raw_recordings,debug)
%first we must identify what the Ground truth looks like on the specified tetrode
art_tetr_array = build_artificial_tetrode();
tetrode_number = str2double(strrep(tetrode_to_check_against,"t",""));
channels_of_curr_tetr = art_tetr_array(tetrode_number,:);
array_of_channel_data = cell(1,length(channels_of_curr_tetr));
array_of_z_score_channel_data = cell(1,length(channels_of_curr_tetr));

%add 1 to all the ground truth unit data becomes there seems to be a small
%delta
ground_truth_unit_data = ground_truth_unit_data;
%import the channel and z score data
for channel_counter=1:length(channels_of_curr_tetr)
    array_of_channel_data{channel_counter} = importdata(dir_of_raw_recordings+"\c"+string(channels_of_curr_tetr(channel_counter))+".mat") *-1;
    array_of_z_score_channel_data{channel_counter} = importdata(dir_of_precomputed+"\z_score\c"+string(channels_of_curr_tetr(channel_counter))+".mat");
end

%import the peak data

%format the data into plotable format
ground_truth_peaks = nan(size(ground_truth_unit_data,2),length(channels_of_curr_tetr));
ground_truth_z_scores = nan(size(ground_truth_unit_data,2),length(channels_of_curr_tetr));
for channel_counter=1:length(channels_of_curr_tetr)
    ground_truth_peaks(:,channel_counter) = array_of_channel_data{channel_counter}(ground_truth_unit_data).';
    ground_truth_z_scores(:,channel_counter) = array_of_z_score_channel_data{channel_counter}(ground_truth_unit_data).';
end

%find which wire has the highest median z-score, this is the ranges that
%will be used
medians_by_wire = median(ground_truth_z_scores);
[~,wire_with_highest_median_z_score] = max(medians_by_wire);
highest_z_score = max(ground_truth_z_scores(:,wire_with_highest_median_z_score));

if debug
    figure
    histogram(ground_truth_z_scores(:,wire_with_highest_median_z_score));
    title(["Z Scores of Wire With Highest Median", "Channel "+ string(channels_of_curr_tetr(wire_with_highest_median_z_score))])

    figure();
    histogram(array_of_z_score_channel_data{wire_with_highest_median_z_score})
    title("Z Scores of the Wire with Highest Median Z Score")

    plot_ground_truth_peaks(ground_truth_unit_data,wire_with_highest_median_z_score,array_of_channel_data);
end

%now create a plot of the ground truth
figure;
plot_counter=1;
for first_dimension=1:4
    for second_dimension=first_dimension+1:4
        subplot(2,3,plot_counter);
        plot_ground_truth_of_neuron({1:size(ground_truth_peaks,1)},ground_truth_peaks,first_dimension,second_dimension,art_tetr_array(tetrode_number,:),tetrode_to_check_against,medians_by_wire(wire_with_highest_median_z_score),plot_counter,"Actual Neuron")
        plot_counter= plot_counter+1;
    end
end
sgtitle([tetrode_to_check_against, "Voltages Of Channels"]);

%create plots of all the peak locations of the ground truth


%now plot the same thing, but using the z scores instead
figure;
plot_counter=1;
for first_dimension=1:4
    for second_dimension=first_dimension+1:4
        subplot(2,3,plot_counter);
        plot_ground_truth_of_neuron({1:size(ground_truth_z_scores,1)},ground_truth_z_scores,first_dimension,second_dimension,art_tetr_array(tetrode_number,:),tetrode_to_check_against,medians_by_wire(wire_with_highest_median_z_score),plot_counter,"Actual Neuron")
        plot_counter= plot_counter+1;
    end
end
sgtitle([tetrode_to_check_against, "Z Scores Of Channels"]);

close all;
%now plot the peaks of the channel data
%staring with the highest z score
%and descending to the lowest z score to check against
%using the user defined interval to determine how many plots to create
for current_z_score=highest_z_score:-1*interval:levels_beneath_highest_z_score_to_check
    %get all the spikes on the channel with the higest median z score
    [peak_locations,peaks_of_wire_with_highest_median] = limited_spike_finder(array_of_channel_data{wire_with_highest_median_z_score},array_of_z_score_channel_data{wire_with_highest_median_z_score},current_z_score);

    %now cut the peak values at those location 
    peaks_of_current_z_score = nan(size(peaks_of_wire_with_highest_median,2),length(array_of_channel_data));
    for i=1:length(array_of_channel_data)
        peaks_of_current_z_score(:,i) = array_of_channel_data{i}(peak_locations);
    end
    figure;
    plot_counter=1;
    for first_dimension=1:4
        for second_dimension=first_dimension+1:4
            subplot(2,3,plot_counter);
            plot_ground_truth_of_neuron({1:size(peaks_of_current_z_score,1)},peaks_of_current_z_score,first_dimension,second_dimension,art_tetr_array(tetrode_number,:),tetrode_to_check_against,current_z_score,plot_counter,string(current_z_score))
            plot_counter= plot_counter+1;
        end
    end

    %calculate the SNR for this particular z-score
    %formula = (signal - noise) / (signal + noise)
    %signal in this case will be the voltages that exist in the ground truth
    %and in the wire
    %noise are voltages in the wire data but not the ground truth
    in_GT_and_wire = intersect(ground_truth_peaks(:,wire_with_highest_median_z_score),peaks_of_current_z_score(:,wire_with_highest_median_z_score));
    % disp("In Wire and Ground Truth")
    % disp(length(in_GT_and_wire));
    in_wire_but_not_GT = setdiff(peaks_of_current_z_score(:,wire_with_highest_median_z_score),ground_truth_peaks(:,wire_with_highest_median_z_score));
    in_GT_but_not_in_wire = setdiff(ground_truth_peaks(:,wire_with_highest_median_z_score),peaks_of_current_z_score(:,wire_with_highest_median_z_score));
    % disp("In Wire But Not GT")
    % disp(length(in_wire_but_not_GT));
    SNR = (length(in_GT_and_wire) - length(in_wire_but_not_GT))/ (length(in_GT_and_wire) + length(in_wire_but_not_GT));
    accuracy = (length(in_GT_and_wire) / (length(in_GT_and_wire)+length(in_GT_but_not_in_wire)+length(in_wire_but_not_GT))) * 100;
    sgtitle([tetrode_to_check_against, "Voltages Of Channels with Min Z Score of "+string(current_z_score),"SNR: "+ string(SNR),"Accuracy: "+string(accuracy)+"%"]);


end
end
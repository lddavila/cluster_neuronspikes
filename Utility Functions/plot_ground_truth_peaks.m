function [] = plot_ground_truth_peaks(ground_truth_unit_data,wire_with_highest_median_z_score,array_of_channel_data)

for i=1:length(ground_truth_unit_data)

    beginning_index = ground_truth_unit_data(i)-30;
    end_index = ground_truth_unit_data(i)+30;
    [~,m_i] = max(array_of_channel_data{wire_with_highest_median_z_score}(beginning_index:end_index));
    if m_i+beginning_index-1==ground_truth_unit_data(i)
        continue;
    end
    figure;
    if ground_truth_unit_data(i) - 30 <0
        beginning_index = 1;
    end
    if ground_truth_unit_data(i)+30 > length(array_of_channel_data{wire_with_highest_median_z_score})
        end_index = length(array_of_channel_data{wire_with_highest_median_z_score});
    end
    plot(beginning_index:end_index,array_of_channel_data{wire_with_highest_median_z_score}(beginning_index:end_index));

    hold on;
    xline(ground_truth_unit_data(i),'-',{string(ground_truth_unit_data(i))});


    %modify the m_i to account for the shift
    m_i = m_i+beginning_index-1;
    xline(m_i,'-',{"Actual Peak On Wire"})
    title(["Ground Truth index: "+string(ground_truth_unit_data(i))+ " Actual Max On Wire:"+string(m_i),"Difference"+string(ground_truth_unit_data(i) - m_i)]);
    %pause(5)
    close(gcf);
end
end
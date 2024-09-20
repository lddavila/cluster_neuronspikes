function [zeroed_out_recording] = zero_out_values_that_dont_meet_min_z_score(recording_matrix,z_score_matrix,min_z_score)
zeroed_out_recording = zeros(size(recording_matrix,1),size(recording_matrix,2));
for i=1:size(recording_matrix,2)
    current_vector_of_y_points_aka_voltages = recording_matrix(:,i);
    current_vector_of_z_scores = z_score_matrix(:,i);
    for j=1:size(current_vector_of_y_points_aka_voltages,1)
        current_value = current_vector_of_y_points_aka_voltages(j);
        current_z_score = current_vector_of_z_scores(j);
        if abs(current_z_score) >= min_z_score
            zeroed_out_recording(j,i) = current_value;
        end
    end
end
end
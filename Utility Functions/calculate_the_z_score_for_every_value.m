function [z_scores] = calculate_the_z_score_for_every_value(recording_matrix)
z_scores = zscore(recording_matrix,1,1);
end
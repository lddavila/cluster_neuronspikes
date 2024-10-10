function [channel_wise_mean,channel_wise_std,channel_wise_z_score] = calculate_the_mean_per_channel_ver_2(tall_array_of_recordings)
%tall_array_of_recordings: a matlab tall array full of structs
%every struct has only a single field:
    % "c+channel_number"
    %ex) c1, c2, c3, c4
%recall that when using tall arrays you don't evalue until you use the gather function
%and any errors that occur during the gather process will corrupt the tall array and you'll have to delete it and start over
%we use tall arrays because simulated recordings we are using have approximately 15,000,000 data points each and the real recordings will likely have even more. 
%see load_all_the_recordings_into_tall_array.m for how we actually load them.
lazy_eval_of_tall_array_size = size(tall_array_of_recordings,1);
number_of_channels = gather(lazy_eval_of_tall_array_size);
channel_wise_mean = zeros(1,number_of_channels);
channel_wise_std = zeros(1,number_of_channels);
channel_wise_z_score = zeros(1,number_of_channels);
for i=1:number_of_channels
    current_struct_unformatted = tall_array_of_recordings(i);
    current_struct_formatted = gather(current_struct_unformatted);
    channel_name_of_current_struct_formatted = fields(current_struct_formatted{1});
    channel_wise_mean(i) = mean(current_struct_formatted{1}.(channel_name_of_current_struct_formatted{1}));
    channel_wise_z_score(i) = zscore(current_struct_formatted{1}.(channel_name_of_current_struct_formatted{1}),0,'all');
    channel_wise_std(i) = std(current_struct_formatted{1}.(channel_name_of_current_struct_formatted{1}),0,'all');
    clear current_struct_formatted;
end
end
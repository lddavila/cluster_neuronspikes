function [] = custom_bubble_sort_test(array_of_mean_wave_forms)
for counter=1:size(array_of_mean_wave_forms,2)
    swapped=0;
    for current_wave_ind =1:size(array_of_mean_wave_forms,2)-counter
        wave_1 = array_of_mean_wave_forms(current_wave_ind);
        wave_2 = array_of_mean_wave_forms(current_wave_ind+1);
        is_wave_1_better = wave_1 > wave_2;
        if is_wave_1_better
            temp_row = wave_1;
            array_of_mean_wave_forms(current_wave_ind) = wave_2;
            array_of_mean_wave_forms(current_wave_ind+1) = temp_row;
            swapped=true;
        end
    end
    if ~swapped
        break;
    end
end
disp(array_of_mean_wave_forms);
end
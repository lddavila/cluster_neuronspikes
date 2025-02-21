function [] = plot_refined_tetrode_results(gen_dir_with_refined_tetrode_results,gen_dir_with_refined_tetrodes_grades,list_of_refined_tetrodes_to_plot,lists_of_min_amp)
for i=1:length(list_of_refined_tetrodes_to_plot)
    current_refined_tetrode = list_of_refined_tetrodes_to_plot(i);
    refined_grades_array = cell(1,length(lists_of_min_amp));
    refined_output_array =cell(1,length(lists_of_min_amp));
    refined_aligned_array= cell(1,length(lists_of_min_amp));
    refined_idx_array = cell(1,length(lists_of_min_amp));
    for j=1:length(lists_of_min_amp)
    [refined_grades_array{j},refined_output_array{j},refined_aligned_array{j},~,refined_idx_array{j}] = import_data(gen_dir_with_refined_tetrodes_grades+" "+string(lists_of_min_amp(j)) + " Channels grades",gen_dir_with_refined_tetrode_results+" "+string(lists_of_min_amp(j))+" Channels",current_refined_tetrode,true);
    end
    
    for j=1:length(lists_of_min_amp)
        figure;
        if size(refined_aligned_array{j},1)==2
            number_of_rows = 1;
            number_of_cols = 1;
        elseif size(refined_aligned_array{j},1)==3
            number_of_rows = 1;
            number_of_cols = 3;
        elseif size(refined_aligned_array{j},1)==4
            number_of_rows = 2;
            number_of_cols = 3;
        elseif size(refined_aligned_array{j},1)==5
            number_of_rows = 5;
            number_of_cols = 2;
        elseif size(refined_aligned_array{j},1)==6
            number_of_rows = 5;
            number_of_cols = 3;
        elseif size(refined_aligned_array{j},1) == 7
            number_of_rows = 7;
            number_of_cols = 3;
        end
        plot_counter=1;
        noncaring_channels = 1:size(refined_aligned_array{j},2);
        for first_dim=1:size(refined_aligned_array{j},1)
            for sec_dim=first_dim+1:size(refined_aligned_array{j},1)
                subplot(number_of_rows,number_of_cols,plot_counter)
          
                new_plot_proj_ver_5(refined_idx_array{j},refined_aligned_array{j},first_dim,sec_dim,noncaring_channels,current_refined_tetrode,0,plot_counter,repelem("",1,size(refined_grades_array{j},1)))
                plot_counter=plot_counter+1;
            end
        end
        first_title_string = "Refined Tetrode "+ current_refined_tetrode +" Top " + string(size(refined_aligned_array{j},1)) + " Channels ";
        second_title_string = "Min Amp "+string(lists_of_min_amp(j));
        sgtitle([first_title_string,second_title_string]);

    end
    close all;
end
end
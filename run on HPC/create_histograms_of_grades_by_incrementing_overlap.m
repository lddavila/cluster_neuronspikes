function [] = create_histograms_of_grades_by_incrementing_overlap(increment_to_go_by,grades_to_check,names_of_grades,contamination_table,save_figs,parent_dir_to_save_figs_to,close_all)

number_of_increments = 0:increment_to_go_by:100;
for i=1:length(grades_to_check)
    figure;
    % legend_string = repelem("",length(number_of_increments)-1);
    all_x_lims = zeros(length(number_of_increments)-1,2);
    all_y_lims = zeros(length(number_of_increments)-1,2);
    total_number_of_rows_in_cont_table = size(contamination_table,1);
    for j=1:length(number_of_increments)-1
        subplot(length(number_of_increments)-1,1,j)
        rows_of_cont_table_in_current_bucket = contamination_table(contamination_table{:,"Max Overlap % With Unit"} <= number_of_increments(j+1) & contamination_table{:,"Max Overlap % With Unit"} > number_of_increments(j),:);
        grades_of_clusters_in_current_bin = cell2mat(rows_of_cont_table_in_current_bucket{:,"grades"});
        grade_to_bin = grades_to_check(i);
        data_to_be_binned = grades_of_clusters_in_current_bin(:,grade_to_bin);
        if j==1
            h = histogram(data_to_be_binned);
            h = histogram('BinEdges',h.BinEdges,'BinCounts',(h.BinCounts ./ total_number_of_rows_in_cont_table )* 100);
        else
            p = histogram(data_to_be_binned,'BinEdges',h.BinEdges);
            histogram('BinEdges',h.BinEdges,'BinCounts',(p.BinCounts ./ total_number_of_rows_in_cont_table)*100);
        end
        % ylim([0,1])
        all_x_lims(j,:) = xlim;
        all_y_lims(j,:) = ylim;
        current_legend_item = "Overlap From "+string(number_of_increments(j))+" to "+string(number_of_increments(j+1));
        legend(current_legend_item)
        % legend_string(j) = current_legend_item;
        % hold on;
    end
    min_x_limit = min(all_x_lims(:,1));
    max_x_limit = max(all_x_lims(:,2));
    min_y_limit = min(all_y_lims(:,1));
    max_y_limit = max(all_y_lims(:,2));

    for j=1:length(number_of_increments)-1
        subplot(length(number_of_increments)-1,1,j)
        xlim([min_x_limit,max_x_limit]);
        ylim([min_y_limit,max_y_limit]);
    end
    sgtitle(names_of_grades(i)+ " "+string(i))
    % legend(legend_string);
    if save_figs
        home_dir = cd(parent_dir_to_save_figs_to);
        histograms_of_grades_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(parent_dir_to_save_figs_to,"Histograms of grades"));
        cd(histograms_of_grades_dir);
        save_name = names_of_grades(i);
        save_name = strrep(save_name,"/",".");
        save_name = strrep(save_name,"#","Number of ");
        save_name = strrep(save_name,"<","Less than");
        save_name = strrep(save_name,">","Greater than");
        savefig(gcf,"Grade "+string(i)+".fig");
        save("Grade "+string(i)+" Histogram.mat","h","min_x_limit","max_x_limit","min_y_limit","max_y_limit");
        cd(home_dir);
    end
    if close_all
        close all;
    end
end
end
                         
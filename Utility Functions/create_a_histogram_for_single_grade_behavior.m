function [] = create_a_histogram_for_single_grade_behavior(cont_table,conditions,grade_to_check,branch_level,increment_to_go_by,parent_dir_to_save_figs_to,save_figs)
close all;
% fig1 = openfig("E:\HPC Data\Histograms of grades\Grade "+string(grade_to_check));
% ylim([0,1])
load("E:\HPC Data\Histograms of grades\Grade "+string(grade_to_check)+" Histogram.mat","h","min_x_limit","max_x_limit","min_y_limit","max_y_limit");

% create_histograms_of_grades_by_incrementing_overlap(50,grade_to_check,[],cont_table(conditions,:),false,"E:\HPC Data",false);
number_of_increments = 0:increment_to_go_by:100;
legend_string = repelem("",length(number_of_increments)-1);
fig2=figure;
cont_table = cont_table(conditions,:);
all_x_lims = zeros(length(number_of_increments)-1,2);
all_y_lims = zeros(length(number_of_increments)-1,2);
number_of_rows_in_cont_table = size(cont_table,1);
for j=1:length(number_of_increments)-1
    subplot(length(number_of_increments)-1,1,j)
    rows_of_cont_table_in_current_bucket = cont_table(cont_table{:,"Max Overlap % With Unit"} <= number_of_increments(j+1) & cont_table{:,"Max Overlap % With Unit"} > number_of_increments(j),:);

    grades_of_clusters_in_current_bin = cell2mat(rows_of_cont_table_in_current_bucket{:,"grades"});
    if isempty(grades_of_clusters_in_current_bin)
        continue;
    end
    grade_to_bin = grade_to_check;
    data_to_be_binned = grades_of_clusters_in_current_bin(:,grade_to_bin);
    p = histogram(data_to_be_binned,'BinEdges',h.BinEdges,"Normalization","probability");
    histogram('BinEdges',h.BinEdges,'BinCounts',(p.BinCounts/number_of_rows_in_cont_table) * 100);
    all_x_lims(j,:) = xlim;
    all_y_lims(j,:) = ylim;
    current_legend_item = "Overlap From "+string(number_of_increments(j))+" to "+string(number_of_increments(j+1));
    legend(current_legend_item)
    xlabel("Grade Value");
    ylabel("Percentage")
    % legend_string(j) = current_legend_item;
    % ylim([0,1])
    hold on;
end

new_min_x_limit = min(all_x_lims(:,1));
new_max_x_limit = max(all_x_lims(:,2));
new_min_y_limit = min(all_y_lims(:,1));
new_max_y_limit = max(all_y_lims(:,2));

for j=1:length(number_of_increments)-1
    subplot(length(number_of_increments)-1,1,j)
    xlim([max(min_x_limit,new_min_x_limit),max(new_max_x_limit,max_x_limit)]);
    ylim([max(min_y_limit,new_min_y_limit),max(max_y_limit,new_max_y_limit)]);
end
sgtitle("Behavior of grade "+grade_to_check+" When branch"+string(branch_level)+" is reached")

% close(fig1);
fig1 = openfig("E:\HPC Data\Histograms of grades\Grade "+string(grade_to_check));
for j=1:length(number_of_increments)-1
    subplot(length(number_of_increments)-1,1,j)
    xlim([max(min_x_limit,new_min_x_limit),max(new_max_x_limit,max_x_limit)]);
    ylim([max(min_y_limit,new_min_y_limit),max(max_y_limit,new_max_y_limit)]);
end
set(fig1,'Position',[0 0 1000 2000])

% legend(legend_string);

if save_figs
    home_dir = cd(parent_dir_to_save_figs_to);
    histograms_of_grades_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(parent_dir_to_save_figs_to,"Histograms of grades"));
    cd(histograms_of_grades_dir);

    savefig(fig2,"Behavior of grade "+grade_to_check+" When branch"+string(branch_level)+" is reached"+".fig")
    cd(home_dir);
end
set(fig2,'Position',[1000 0 1000 2000]);
end
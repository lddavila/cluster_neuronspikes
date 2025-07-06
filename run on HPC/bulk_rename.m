function [] = bulk_rename(base_dir,file_to_save_renamed_files_to)

pieces_to_remove = ["accuracy score","num layers","num neurons per layer","complex_choose_better With Accuracy Differences Bound By","It Took","seconds"];
replace_with = ["a_s","n_l","n_n_p_l","c_c_b_acc_diff","",""];

all_files = struct2table(dir(fullfile(base_dir, '**', '*'))); % '**' searches subdirectories
only_directories = all_files(all_files{:,"isdir"},:);
only_directories = only_directories(~(string(only_directories{:,"name"})==".."),:);
only_directories = only_directories(~(string(only_directories{:,"name"})=="."),:);
all_files = all_files(~all_files{:,"isdir"},:); % Exclude directories

file_paths = fullfile(all_files{:,"folder"}, all_files{:,"name"});
% disp(filePaths);

%copy the file structure
for i=1:size(only_directories,1)
    create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(file_to_save_renamed_files_to,only_directories{i,"name"}{1}));
end


%copy the files
for i=1:size(file_paths,1)
%    'accuracy score 1 num layers 9 num neurons per layer5 complex_choose_better With Accuracy Differences Bound By 100 90 It Took 65.1167 seconds.mat'

    [filepath,name,ext] = fileparts(file_paths{i});
    original_name = string(name);
    for j=1:size(pieces_to_remove,2)
        name = strrep(name,pieces_to_remove(j),replace_with(j));
    end
    split_file_path = split(filepath,filesep);
    sub_dir = split_file_path{end};
    copyfile(fullfile(filepath,original_name+ext),fullfile(file_to_save_renamed_files_to,sub_dir,name+ext));
    

end

end
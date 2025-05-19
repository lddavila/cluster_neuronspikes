function [dir_to_save_test,dir_to_save_train] = split_images_into_training_and_testing(og_dir,dir_to_save_train,dir_to_save_test,how_much_training,data_ext)
rng(0);
if how_much_training >1 || how_much_training<0
    error("how_much_training should be a value between 0 and 1")
end
all_items = struct2table(dir(fullfile(og_dir,"*")));

if ~exist(dir_to_save_test,"dir")
    dir_to_save_test = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_test);
end

if ~exist(dir_to_save_train,"dir")
    dir_to_save_train = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_train);
end

for i=1:size(all_items,1)
    if ~all_items{i,"isdir"} ||string(all_items{i,"name"}) == "." || string(all_items{i,"name"}) == ".."
       continue;
    end

    file_path_to_read = fullfile(og_dir,string(all_items{i,"name"}));

    files_in_current_path = strtrim(string(ls(fullfile(file_path_to_read,"*"+data_ext))));

    number_of_training_files = round(how_much_training * size(files_in_current_path,1));
    number_of_test_files = size(files_in_current_path,1) - number_of_training_files;

    idxs_of_files = 1:size(files_in_current_path,1);

    training_file_idxs= randperm(length(idxs_of_files),number_of_training_files);
    test_file_idxs = setdiff(idxs_of_files,training_file_idxs);

    if number_of_test_files ~= length(test_file_idxs)
        error("mismatch in split_images_into_training_and_testing.m number of testing doesn't match expected")
    end

    if ~exist(fullfile(dir_to_save_train,string(all_items{i,"name"})),"dir")
        %disp();
        create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(dir_to_save_train,string(all_items{i,"name"})));
    end

    if ~exist(fullfile(dir_to_save_test,string(all_items{i,"name"})),"dir")
        create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(dir_to_save_test,string(all_items{i,"name"})));
    end

    for j=1:size(training_file_idxs,2)
        current_file_name = files_in_current_path(j);
        disp(fullfile(file_path_to_read,current_file_name))
        disp(fullfile(dir_to_save_train,string(all_items{i,"name"}),current_file_name))
        copyfile(fullfile(file_path_to_read,current_file_name),fullfile(dir_to_save_train,string(all_items{i,"name"}),string(training_file_idxs(j))))
        
    end

    for j=1:size(test_file_idxs,2)
        current_file_name = files_in_current_path(j);
        copyfile(fullfile(file_path_to_read,current_file_name),fullfile(dir_to_save_test,string(all_items{i,"name"}),string(test_file_idxs(j))))
    end

    
end
end
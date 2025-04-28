function [last_image_done] = manually_classify_images(dir_with_images,dir_to_save_sorted_figures_to,image_to_start_with)
all_files = strtrim(string(ls(dir_with_images+"\*.png")));
last_image_done =0;
for i=image_to_start_with:size(all_files,1)
    current_file = all_files(i);
    h = imshow(fullfile(dir_with_images,current_file));
    category = input("Enter a number based Classification (enter q to quit\n");
    if contains(string(category),'q')
        break;
    end
    dir_to_save_sorted_figures_to_final = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(dir_to_save_sorted_figures_to,string(category)));
    imwrite(h.CData,fullfile(dir_to_save_sorted_figures_to_final,current_file))
    last_image_done = last_image_done+1;
    disp("Finished"+string(i)+"/"+string(size(all_files,1)));
end
end
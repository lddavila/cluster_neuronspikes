function concatenate_many_plots_updated(directory_with_plots,pdf_file_name,pdf_directory_rel)
if ~exist(pdf_directory_rel,"dir")
    mkdir(pdf_directory_rel)
end
home_dir = cd(pdf_directory_rel);
pdf_directory_abs = cd(home_dir);
cd(directory_with_plots);
directory_with_plots_abs = cd(home_dir);
cd(directory_with_plots_abs);
list_of_all_plots = strtrim(string(ls(strcat(pwd,"\*.fig"))));
disp(list_of_all_plots)

for i=1:length(list_of_all_plots)
    openfig(list_of_all_plots(i),"reuse");
    ax = gcf;
    cd(pdf_directory_abs);
    exportgraphics(ax,pdf_file_name, "Append",true);
    close(gcf);
    cd(directory_with_plots_abs);
end
cd(home_dir)
end
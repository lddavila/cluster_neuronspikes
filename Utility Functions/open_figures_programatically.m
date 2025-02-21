function [] = open_figures_programatically(dir_with_figures,figure_file_name_struct,mode)
screens = get(0, 'MonitorPositions');

close all;
if mode == "single"
    left_figure_file_struct = figure_file_name_struct(1);
    left_figure_list_of_files = strtrim(string(ls(dir_with_figures+"\"+left_figure_file_struct)));
    for j=1:length(left_figure_list_of_files)
        try
            openfig(dir_with_figures+"\"+left_figure_list_of_files(j));
            input("Hit Enter to move to next setcontinue");
        catch
            disp(left_figure_list_of_files)
            disp("Couldn't be loaded")
        end
        
        close all;
    end
end
if mode=="split"
    left_figure_file_struct = figure_file_name_struct(1);
    right_figure_file_struct = figure_file_name_struct(2);

    left_figure_list_of_files = strtrim(string(ls(dir_with_figures+"\"+left_figure_file_struct)));
    right_figure_list_of_files = strtrim(string(ls(dir_with_figures+"\"+right_figure_file_struct)));

    for j=1:length(left_figure_list_of_files)
        fig1 = openfig(dir_with_figures+"\"+left_figure_list_of_files(j));
        pause(0.5)
        fig2 = openfig(dir_with_figures+"\"+right_figure_list_of_files(j));
        % pause(0.5)
        % 
        
        % 
        set(fig1,'Position',[0. 0 .7 1])
        set(fig2,'Position',[0.7 0 .3 1])
                
        input("Hit Enter to move to next setcontinue");
        close all;
    end

end

end
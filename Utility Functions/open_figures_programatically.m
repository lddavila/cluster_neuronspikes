function [] = open_figures_programatically(dir_with_figures,figure_file_name_struct,mode)
monitorPositions = get(0, 'MonitorPositions');

% Get screen size of the primary and secondary monitors
primaryMonitor = monitorPositions(1, :);  % First monitor (primary)
secondaryMonitor = monitorPositions(2, :); % Second monitor (secondary)
screenSize = get(0,'ScreenSize');
figWidth = primaryMonitor(3) / 2;  % Half the screen width
figHeight = primaryMonitor(4) * 0.7;  % 70% of the screen height
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
        fig_left = openFigure(dir_with_figures+"\"+left_figure_list_of_files(j));
        fig_right = openFigure(dir_with_figures+"\"+right_figure_list_of_files(j));
        % 
        left_pos  =  [0, (primaryMonitor(4) - figHeight) / 2, figWidth, figHeight];
        right_pos = [secondaryMonitor(1), (secondaryMonitor(4) - figHeight) / 2, figWidth, figHeight];

        % set(fig_left,'Position',left_pos);
        % set(fig_right,'Position',right_pos);
        input("Hit Enter to move to next setcontinue");
        close all;
    end

end

end
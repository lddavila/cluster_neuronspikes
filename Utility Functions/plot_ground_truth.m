function [] = plot_ground_truth(ground_truth,number_of_units_to_plot,timestamps)
figure;
y_coordinater = 2;
y_values = [1, 2];
for i=1:number_of_units_to_plot
    if i==1
        y_values = [y_values(1),y_values(2)];
    else
        y_values = [y_values(1)-y_coordinater,y_values(2)-y_coordinater];
    end
    x_values = sort([ground_truth{i},ground_truth{i}]);
    x_values = [timestamps(x_values)];
    x_values = [-1,-1, x_values];
    
   % line(x_values.',y_values(2:end-1).');
   y_counter = 4;
   current_y_values = y_values;
    for j=3:2:size(x_values,2)
        current_x_values = x_values(j:j+1);
        % disp([current_x_values.',current_y_values.']);
        line(current_x_values,current_y_values);
        hold on;
    end
    
    title("Neuron Ground Truth")
    xlabel("Time (in seconds)")
    
end
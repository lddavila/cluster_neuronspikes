function [] = create_graph_object_representing_probe()
array_of_channels = [1:96;97:192;193:288;289:384];
array_of_channels = array_of_channels.';
list_of_channels = 1:384;
adjacency_matrix = zeros(length(list_of_channels),length(list_of_channels));
for i=1:384
    valid_neighbors_of_i = find_valid_neighbors(i);
    indexes_of_valid_neighbors = find(ismember(list_of_channels,valid_neighbors_of_i));
    adjacency_matrix(i,indexes_of_valid_neighbors) = 1;
end
the_graph_of_neuron = graph(adjacency_matrix,'omitselfloops');
plot(the_graph_of_neuron,'XData',x,'YData',)
plot(the_graph_of_neuron,'Layout','force');
end
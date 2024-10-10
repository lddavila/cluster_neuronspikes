function [ordered_list_of_channels] = get_ordered_list_of_channel_names()
ordered_list_of_channels = [];
for i=1:384
    ordered_list_of_channels = [ordered_list_of_channels, "c"+ string(i)];
end
end
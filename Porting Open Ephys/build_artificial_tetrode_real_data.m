function [art_tetrode_array] = build_artificial_tetrode_real_data()
% disp("Missing Channel 384, fix later!!!!!!!!!!!!!")
art_tetrode_array = [];
%build the first set of art_tetrodes
for i=1:8:384
    current_tetrode = [i,i+2,i+4,i+6];
    art_tetrode_array = [art_tetrode_array;current_tetrode];
end
for i=2:8:384
    current_tetrode = [i,i+1,i+4,i+5];
    art_tetrode_array = [art_tetrode_array;current_tetrode];
end

for i=2:8:384
    current_tetrode = [i,i+2,i+4,i+6];
    art_tetrode_array = [art_tetrode_array;current_tetrode];
end
end
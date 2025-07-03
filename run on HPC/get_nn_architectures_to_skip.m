function [already_done_architectures] = get_nn_architectures_to_skip(dir_with_nn,pieces_to_remove)
a = struct2table(dir(dir_with_nn));
a = string(a.name(3:end));
disp(a);
already_done_architectures = regexprep(a, '\d+\.\d+', '');


for i=1:length(pieces_to_remove)
    already_done_architectures = strrep(already_done_architectures,pieces_to_remove(i),"");
end
already_done_architectures = split(already_done_architectures," ");
already_done_architectures = str2double(already_done_architectures);
disp(already_done_architectures)
end


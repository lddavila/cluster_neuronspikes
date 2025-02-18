function [current_cluster_category] = classify_clusters_based_on_grades(current_cluster_grades)

if current_cluster_grades(37) <1.1 
    current_cluster_category = "Probably Multi Unit Activity c2";
elseif current_cluster_grades(37) > 10
    current_cluster_category = "Probably a Neuron c3";
elseif current_cluster_grades(2) < 0.1 && current_cluster_grades(31) > 1 && current_cluster_grades(30) < 7 && current_cluster_grades(31) > 1
    current_cluster_category = "Probably A Neuron c4";
elseif current_cluster_grades(2) < 0.1  && current_cluster_grades(30) < 7 && current_cluster_grades(32) > 1
    current_cluster_category = "Probably A Neuron c5";
elseif current_cluster_grades(34) > 20 && (current_cluster_grades(33) == 2 || current_cluster_grades(33)==1) && ~isinf(current_cluster_grades(34))
    current_cluster_category =  "Probabaly A Neuron c6";
elseif current_cluster_grades(34)>12 && current_cluster_grades(33) == 2  && current_cluster_grades(32) >1
    current_cluster_category = "Probably A Neuron c7";
elseif current_cluster_grades(34)>12 && current_cluster_grades(33) ==2
    current_cluster_category = "Maybe a Neuron c8";
elseif current_cluster_grades(2) > 0.1&& current_cluster_grades(34)>4 && (current_cluster_grades(33) == 2 || current_cluster_grades(33) == 1)
    current_cluster_category = "Probably Multi Unit Activity c9";
elseif current_cluster_grades(34)>4 && (current_cluster_grades(33) == 2 || current_cluster_grades(33) == 1)
    current_cluster_category = "Maybe multi unit actvity c10";
elseif current_cluster_grades(34) > 4 && current_cluster_grades(33) ~=1
    current_cluster_category = "Might Be a Neuron c11";
elseif current_cluster_grades(33) == 1
    current_cluster_category = "Probably Multi Unit Activity c12";
elseif current_cluster_grades(33) == 2 && current_cluster_grades(31) ==1
    current_cluster_category = "Probably Multi Unit Activity c13";
elseif current_cluster_grades(33) == 2
    current_cluster_category = "Might Be Multi Unit Activity c14";
else
    current_cluster_category = "No category";
   
end


if current_cluster_grades(41) > 0.7
    current_cluster_category = current_cluster_category + " Hi Burst Ratio";
end



end

function [table_of_branch_ratios] = debug_mua_cases_after_first_tree(table_of_neurons_from_first_tree,mua_threshold)
mua_cases = table_of_neurons_from_first_tree(table_of_neurons_from_first_tree{:,"Max Overlap % With Unit"} < mua_threshold,:);

counts_of_mua_cases = groupcounts(mua_cases,"Classification");
counts_of_neurons = groupcounts(table_of_neurons_from_first_tree,"Classification");

united_table = join(counts_of_mua_cases,counts_of_neurons,'Keys',"Classification");

table_of_branch_ratios = table(united_table{:,"Classification"},united_table{:,"GroupCount_counts_of_mua_cases"},united_table{:,"GroupCount_counts_of_neurons"},united_table{:,"GroupCount_counts_of_mua_cases"}./united_table{:,"GroupCount_counts_of_neurons"},'VariableNames',["Branch","MUA Count","Total Case Count","Ratio of MUA to Classification"]);
disp(table_of_branch_ratios);
end